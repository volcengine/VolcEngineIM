export default class StringUtils {
    static getStringBetween(g12, h12, i12, j12 = false) {
        if (g12 == null)
            return "";
        const k12 = g12.indexOf(h12);
        if (k12 == -1) {
            return "";
        }
        g12 = g12.substring(k12 + (j12 ? 0 : h12.length));
        const l12 = g12.indexOf(i12);
        if (l12 >= 0) {
            return g12.substring(0, l12);
        }
        else {
            return g12;
        }
    }
    static splitString(b12, c12) {
        const d12 = b12.split(c12);
        d12.shift();
        return d12.map(f12 => c12 + f12.trim());
    }
}
