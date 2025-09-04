export declare class BIMFileUtils {
    static copyFileToTemp(uri: string): Promise<string>;
    static getAudioDuration(uri: string): Promise<number>;
    static genVideoCoverPixMap(uri: string, width: number, height: number): Promise<Nullable<PixelMap>>;
    static savePixMap(name: string, pixMap: PixelMap): Promise<string>;
    static genCoverAndSave(uri: string, width: number, height: number): Promise<string>;
}
