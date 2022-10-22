import * as fs from 'fs';
import * as path from 'path';
import * as del from 'del';
import * as mkdirp from 'mkdirp';
import { build, buildDirPath } from './build';
import * as archiver from 'archiver';

const { stat, copyFile } = fs.promises;

const rootDir = path.join(__dirname, '../../');
const distDirPath = path.resolve(rootDir, 'dist');

const archive = archiver('zip', {
  zlib: { level: 9 },
});
const zip = async(srcDir: string, dest: string, additionalFiles: string[] = []): Promise<void> => {
  const zipName = `${path.basename(dest)}.zip`;
  const destDir = path.dirname(dest);
  const destPath = path.resolve(destDir, zipName);
  await mkdirp(destDir);

  const output = fs.createWriteStream(destPath);
  archive.pipe(output);

  archive.glob('*.*', { cwd: srcDir });
  for await (const file of additionalFiles) {
    if ((await stat(file)).isDirectory()) {
      const name = path.basename(file);
      archive.directory(file, name);
      continue;
    }

    const fileName = path.basename(file);
    const dir = path.dirname(file);
    archive.glob(fileName, { cwd: dir });
  }
  await archive.finalize();
};

export const clean = async(): Promise<void> => {
  await del(distDirPath);
};
export const createDistDir = async(): Promise<void> => {
  await mkdirp(distDirPath);
};
export const distForV1 = async(): Promise<void> => {
  await createDistDir();
  const fileName = 'CustomHotkey.ahk';
  await copyFile(path.resolve(buildDirPath, fileName), path.resolve(distDirPath, fileName));
};
export const distPackForV1 = async(): Promise<void> => {
  await createDistDir();
  await zip(
    path.resolve(rootDir, 'build'),
    path.resolve(distDirPath, 'CustomHotkey+README'),
    [
      path.resolve(path.resolve(rootDir, 'image')),
      path.resolve(rootDir, 'README.md'),
      path.resolve(rootDir, 'README.ja.md'),
    ],
  );
};
export const distOnly = async(): Promise<void> => {
  await build();
  await distForV1();
  await distPackForV1();
};
export const dist = async(): Promise<void> => {
  await clean();
  await createDistDir();
  await distOnly();
};
