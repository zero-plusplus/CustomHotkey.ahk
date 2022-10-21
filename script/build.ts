import * as path from 'path';
import { promises as fs } from 'fs';
// import { copySync } from 'fs-extra';
import * as del from 'del';
import * as mkdirp from 'mkdirp';
import { AhkVersion, IncludeInliner } from '@zero-plusplus/autohotkey-utilities';

(async() => {
  const libName = 'CustomHotkey'
  const srcDirPath = path.resolve(`${__dirname}`, '..', 'src')
  const buildDirPath = path.resolve(`${__dirname}`, '..', 'build')

  await del(buildDirPath)
  await mkdirp(buildDirPath)

  for await (const data of [ { version: '1.0', extension: 'ahk' }, /* { version: '2.0', extension: 'ahk2' } */ ]) {
    const inliner = new IncludeInliner(new AhkVersion(data.version));
    const source = inliner.exec(path.resolve(srcDirPath, `${libName}.${data.extension}`))

    const destPath = path.resolve(buildDirPath, `${libName}.${data.extension}`)
    await fs.writeFile(destPath, source, 'utf-8');
  }

  // copySync(`${srcDirPath}/addon`, `${buildDirPath}/addon`)
})()
