import { build, clean } from './subtask/build';

(async(): Promise<void> => {
  await clean();
  await build();
})();
