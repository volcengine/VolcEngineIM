import http from '@ohos.net.http';
export class NetworkClient {
    static getDefault() {
        if (NetworkClient.default == undefined) {
            NetworkClient.default = new NetworkClient();
        }
        return NetworkClient.default;
    }
    static getNetworkClient() {
        if (NetworkClient.userNetworkClient == undefined) {
            return NetworkClient.getDefault();
        }
        else {
            return NetworkClient.userNetworkClient;
        }
    }
    static setNetworkClient(w14) {
        NetworkClient.userNetworkClient = w14;
    }
    post(s14, t14, u14, v14) {
        this.execute(s14, true, t14, u14, v14);
    }
    get(o14, p14, q14, r14) {
        this.execute(o14, false, p14, q14, r14);
    }
    execute(b14, c14, d14, e14, f14) {
        let g14 = http.createHttp();
        let h14 = {
            method: c14 ? http.RequestMethod.POST : http.RequestMethod.GET,
            header: e14,
            extraData: d14,
            usingProxy: true,
            expectDataType: d14 instanceof ArrayBuffer ? http.HttpDataType.ARRAY_BUFFER : http.HttpDataType.STRING
        };
        try {
            g14.request(b14, h14, (k14, l14) => {
                try {
                    f14(k14, l14);
                }
                catch (n14) {
                }
                finally {
                    try {
                        g14.destroy();
                    }
                    catch (m14) {
                    }
                }
            });
        }
        catch (i14) {
            f14(i14);
        }
    }
}
NetworkClient.default = undefined;
NetworkClient.userNetworkClient = undefined;
