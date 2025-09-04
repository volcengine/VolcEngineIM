export interface IMultipartUtility {
    getHeader: () => Object;
    getBoundary: () => string;
}
