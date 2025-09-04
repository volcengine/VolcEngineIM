export declare class DBColumn {
    key: string;
    typeAndConstraint: string;
    constructor(key: string, typeAndConstraint: string);
}
export declare class DBFtsColumn {
    key: string;
    notIndex: boolean;
    constructor(key: string, notIndex: boolean);
}
