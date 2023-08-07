interface StorageModel {
  date: number;
  content: object | string;
  expire: number;
}

export class Storage {
  static get(key: string): StorageModel {
    const raw = localStorage.getItem(key);
    if (!raw) {
      return { date: 0, expire: 0, content: '' };
    }
    const res: StorageModel = JSON.parse(raw);
    const { date, expire, content } = res;
    let contentValue;
    if (expire === 0 || date + expire >= Date.now()) {
      try {
        contentValue = JSON.parse(content as string);
      } catch (err) {
        contentValue = content;
      }
    } else {
      contentValue = '';
    }

    return {
      date: res.date,
      expire: res.expire,
      content: contentValue,
    };
  }

  static set(key: string, content: object | string, expire = 0): void {
    const date = Date.now();
    try {
      content = JSON.stringify(content);
    } catch (err) {
      content = '';
    }
    const res = {
      date,
      expire,
      content,
    };
    localStorage.setItem(key, JSON.stringify(res));
  }
}
