import Stack from './Stack';
export default class AllThread {
    constructor(d4) {
        this.thread_all_count = 0;
        this.thread_stacks = [];
        this.thread_all_count = d4.length;
        this.thread_stacks = this.stacksParser(d4);
    }
    stacksParser(y3) {
        let z3 = [];
        y3.forEach(b4 => {
            let c4 = b4.split('\n');
            z3.push(new Stack(c4[0], c4.slice(1)));
        });
        return z3;
    }
}
