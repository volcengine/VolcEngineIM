import statvfs from "@ohos.file.statvfs";
const DATA_PATH = "/data";
export default class Storage {
    constructor() {
        this.inner_free_real = 0;
        this.inner_total_real = 0;
        this.inner_free_real = statvfs.getFreeSizeSync(DATA_PATH);
        this.inner_total_real = statvfs.getTotalSizeSync(DATA_PATH);
    }
}
