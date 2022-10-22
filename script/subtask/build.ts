import * as pkginfo from 'pkginfo';
import * as path from 'path';
import { promises as fs } from 'fs';
import * as del from 'del';
// import { copySync } from 'fs-extra';
import * as mkdirp from 'mkdirp';
import { AhkVersion, IncludeInliner } from '@zero-plusplus/autohotkey-utilities';

pkginfo(module, 'version');
const version = module.exports.version;

const libName = 'CustomHotkey';
const srcDirPath = path.resolve(`${__dirname}`, '../..', 'src');
export const buildDirPath = path.resolve(`${__dirname}`, '../..', 'build');

export const clean = async(): Promise<void> => {
  await del(buildDirPath);
};
export const buildOnly = async(): Promise<void> => {
  await mkdirp(buildDirPath);

  for await (const data of [ { version: '1.0', extension: 'ahk' } /* { version: '2.0', extension: 'ahk2' } */ ]) {
    const inliner = new IncludeInliner(new AhkVersion(data.version));
    const source = inliner.exec(path.resolve(srcDirPath, `${libName}.${data.extension}`))
      .replace(
        /static version := "90C242F3-2AA0-2EAF-A73D-E5B4F7592E73"[^\r\n]*/u,
        `static version := "${String(version)}"`,
      );

    const destPath = path.resolve(buildDirPath, `${libName}.${data.extension}`);
    await fs.writeFile(destPath, source, 'utf-8');
  }

  // copySync(`${srcDirPath}/addon`, `${buildDirPath}/addon`)
};
export const build = async(): Promise<void> => {
  await clean();
  await buildOnly();
};
