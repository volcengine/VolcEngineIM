import zlib from '@ohos.zlib';
export default class ZipUtils {
    static zip(m12, n12, o12) {
        let p12 = {
            level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION,
            memLevel: zlib.MemLevel.MEM_LEVEL_DEFAULT,
            strategy: zlib.CompressStrategy.COMPRESS_STRATEGY_DEFAULT_STRATEGY
        };
        try {
            zlib.compressFile(m12, n12, p12, (s12) => {
                if (s12 !== null) {
                    o12(false);
                }
                else {
                    o12(true);
                }
            });
        }
        catch (q12) {
            o12(false);
        }
    }
}
