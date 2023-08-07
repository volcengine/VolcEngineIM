class QueryArrManager {
  arr?: any[];

  constructor() {
    this.arr = [];
  }

  push(query: string) {
    if (query) {
      this.arr.push(query);
    }
  }

  includes(query: string) {
    return this.arr.includes(query);
  }

  clear() {
    this.arr.length = 0;
  }

  reset(query: string) {
    const index = this.arr.indexOf(query);
    if (index === -1) return;
    this.arr.splice(0, index + 1);
  }
}

export default QueryArrManager;
