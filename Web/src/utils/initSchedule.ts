export class InitSchedule {
  repeatTaskList: Array<() => Promise<unknown>>;
  onceTaskList: Array<() => Promise<unknown>>;

  constructor() {
    this.repeatTaskList = [];
    this.onceTaskList = [];
  }

  addRepeatTaskList(task: () => Promise<unknown>) {
    this.repeatTaskList.push(task);
  }

  addOnceTaskList(task: () => Promise<unknown>) {
    this.onceTaskList.push(task);
  }

  excute() {
    return new Promise(async (resolve, reject) => {
      try {
        if (this?.onceTaskList?.length) {
          await Promise.allSettled(this?.onceTaskList.map(item => item()));
          this.onceTaskList = [];
        }

        if (this?.repeatTaskList?.length) {
          const tempList = [];

          const results = await Promise.allSettled(
            this?.repeatTaskList.map(item => item()),
          );

          results.forEach((v, k) => {
            if (v.status === 'rejected') {
              tempList.push(this?.repeatTaskList[k]);
            }
          });

          this.repeatTaskList = tempList;
        }
      } catch (error) {
      } finally {
        resolve(true);
      }
    });
  }
}
