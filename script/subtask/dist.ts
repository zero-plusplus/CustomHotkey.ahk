import * as fs from 'fs';
import * as path from 'path';
import * as del from 'del';
import * as mkdirp from 'mkdirp';
import { build } from './build';
import * as archiver from 'archiver';

const { stat } = fs.promises;

const rootDir = path.join(__dirname, '../../');
const distDirPath = path.resolve(rootDir, 'dist');

const archive = archiver('zip', {
  zlib: { level: 9 },
});
const zip = async(srcDir: string, destDir: string, additionalFiles: string[] = []): Promise<void> => {
  await mkdirp(destDir);

  const zipName = `${path.basename(destDir)}.zip`;
  const destPath = path.resolve(destDir, zipName);

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
export const distForV1 = async(): Promise<void> => {
  await zip(
    path.resolve(rootDir, 'build'),
    path.resolve(distDirPath, 'CustomHotkey'),
    [
      path.resolve(path.resolve(rootDir, 'image')),
      path.resolve(rootDir, 'README.md'),
      path.resolve(rootDir, 'README.ja.md'),
    ],
  );
};
export const distOnly = async(): Promise<void> => {
  await build();
  await Promise.all([ distForV1() ]);
};
export const dist = async(): Promise<void> => {
  await clean();
  await mkdirp(distDirPath);
  await distOnly();
};
