import { clean as cleanBuild } from './subtask/build';
import { clean as cleanDist } from './subtask/dist';

(async(): Promise<void> => {
  await cleanBuild();
  await cleanDist();
})();
