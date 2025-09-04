export class CrashLib {
    constructor(p5, q5) {
        this.lib_name = '';
        this.lib_uuid = '';
        this.lib_name = p5;
        this.lib_uuid = this.compatibleBuildID(q5);
    }
    compatibleBuildID(n5) {
        let o5 = '';
        if (n5.length < 16) {
            o5 = n5;
        }
        else {
            o5 += n5.charAt(6);
            o5 += n5.charAt(7);
            o5 += n5.charAt(4);
            o5 += n5.charAt(5);
            o5 += n5.charAt(2);
            o5 += n5.charAt(3);
            o5 += n5.charAt(0);
            o5 += n5.charAt(1);
            o5 += n5.charAt(10);
            o5 += n5.charAt(11);
            o5 += n5.charAt(8);
            o5 += n5.charAt(9);
            o5 += n5.charAt(14);
            o5 += n5.charAt(15);
            o5 += n5.charAt(12);
            o5 += n5.charAt(13);
            if (n5.length >= 32) {
                o5 += n5.substring(16, 32);
                o5 += '0';
            }
        }
        return o5.toUpperCase();
    }
}
