export default class Folder {
    static initHomeDir(k3: Context, l3: string): void;
    static getFileDir(i3: Context, j3: string): string;
    static getCacheDir(h3: Context): string;
    static getTempDir(g3: Context): string;
    static getCrashDir(c3: Context, d3: string, e3?: string): string;
    static getConfigDir(z2: Context, a3: string): string;
    static getSubDir(w2: string, x2: string): string;
}
