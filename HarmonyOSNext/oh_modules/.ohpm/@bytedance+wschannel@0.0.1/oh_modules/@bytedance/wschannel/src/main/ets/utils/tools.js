import Long from 'long';
export function long2Bigint(f12) {
    if (f12) {
        try {
            return BigInt(f12.toString());
        }
        catch (g12) {
            return BigInt(-1);
        }
    }
    else {
        return BigInt(-1);
    }
}
export function bigint2Long(d12) {
    if (d12) {
        try {
            return Long.fromValue(d12.toString());
        }
        catch (e12) {
            return Long.UONE;
        }
    }
    else {
        return Long.UONE;
    }
}
export function convertMap(y11) {
    let z11 = {};
    y11.forEach((b12, c12) => {
        z11[c12] = b12;
    });
    return z11;
}
