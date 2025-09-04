const ERROR_MESSAGE = 'Error message:';
const SOURCE_CODE = 'SourceCode:';
const STACK_TRACE = 'Stacktrace:';
const FORMAT_ERROR = 'format error';
export class JsCrash {
    constructor(g6) {
        this.error_message = FORMAT_ERROR;
        this.source_code = FORMAT_ERROR;
        this.stack_trace = FORMAT_ERROR;
        try {
            let o6 = g6.indexOf(STACK_TRACE) + STACK_TRACE.length;
            let p6 = g6.length - 1;
            if (o6 < p6) {
                this.stack_trace = g6.substring(o6, p6);
            }
        }
        catch (n6) {
        }
        try {
            let l6 = g6.indexOf(ERROR_MESSAGE) + ERROR_MESSAGE.length;
            let m6 = g6.indexOf(SOURCE_CODE);
            if (m6 < 0) {
                m6 = g6.indexOf(STACK_TRACE);
            }
            m6 -= 1;
            if (l6 < m6) {
                this.error_message = g6.substring(l6, m6);
            }
        }
        catch (k6) {
        }
        try {
            let i6 = g6.indexOf(SOURCE_CODE);
            if (i6 < 0) {
                this.source_code = '';
            }
            else {
                i6 += SOURCE_CODE.length;
                let j6 = g6.indexOf(STACK_TRACE);
                if (i6 < j6) {
                    this.source_code = g6.substring(i6, j6);
                }
            }
        }
        catch (h6) {
        }
    }
    toJsonString() {
        return JSON.stringify(this);
    }
}
