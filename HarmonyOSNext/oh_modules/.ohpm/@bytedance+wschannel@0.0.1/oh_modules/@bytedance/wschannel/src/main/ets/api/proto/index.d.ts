import * as $protobuf from "protobufjs";
import Long = require("long");
/** Namespace ws_proto. */
export namespace ws_proto {
    /** Properties of a Frame. */
    interface IFrame {
        /** Frame seqid */
        seqid: Long;
        /** Frame logid */
        logid: Long;
        /** Frame service */
        service: number;
        /** Frame method */
        method: number;
        /** Frame headers */
        headers?: (ws_proto.Frame.IExtendedEntry[] | null);
        /** Frame payload_encoding */
        payload_encoding?: (string | null);
        /** Frame payload_type */
        payload_type?: (string | null);
        /** Frame payload */
        payload?: (Uint8Array | null);
    }
    /** Represents a Frame. */
    class Frame implements IFrame {
        /**
         * Constructs a new Frame.
         * @param [properties] Properties to set
         */
        constructor(p13?: ws_proto.IFrame);
        /** Frame seqid. */
        public seqid: Long;
        /** Frame logid. */
        public logid: Long;
        /** Frame service. */
        public service: number;
        /** Frame method. */
        public method: number;
        /** Frame headers. */
        public headers: ws_proto.Frame.IExtendedEntry[];
        /** Frame payload_encoding. */
        public payload_encoding: string;
        /** Frame payload_type. */
        public payload_type: string;
        /** Frame payload. */
        public payload: Uint8Array;
        /**
         * Creates a new Frame instance using the specified properties.
         * @param [properties] Properties to set
         * @returns Frame instance
         */
        public static create(o13?: ws_proto.IFrame): ws_proto.Frame;
        /**
         * Encodes the specified Frame message. Does not implicitly {@link ws_proto.Frame.verify|verify} messages.
         * @param message Frame message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(m13: ws_proto.IFrame, n13?: $protobuf.Writer): $protobuf.Writer;
        /**
         * Encodes the specified Frame message, length delimited. Does not implicitly {@link ws_proto.Frame.verify|verify} messages.
         * @param message Frame message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(k13: ws_proto.IFrame, l13?: $protobuf.Writer): $protobuf.Writer;
        /**
         * Decodes a Frame message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns Frame
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(i13: ($protobuf.Reader | Uint8Array), j13?: number): ws_proto.Frame;
        /**
         * Decodes a Frame message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns Frame
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(h13: ($protobuf.Reader | Uint8Array)): ws_proto.Frame;
        /**
         * Verifies a Frame message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(g13: {
            [k: string]: any;
        }): (string | null);
        /**
         * Creates a Frame message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns Frame
         */
        public static fromObject(f13: {
            [k: string]: any;
        }): ws_proto.Frame;
        /**
         * Creates a plain object from a Frame message. Also converts values to other types if specified.
         * @param message Frame
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(d13: ws_proto.Frame, e13?: $protobuf.IConversionOptions): {
            [k: string]: any;
        };
        /**
         * Converts this Frame to JSON.
         * @returns JSON object
         */
        public toJSON(): {
            [k: string]: any;
        };
        /**
         * Gets the default type url for Frame
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(c13?: string): string;
    }
    namespace Frame {
        /** Properties of an ExtendedEntry. */
        interface IExtendedEntry {
            /** ExtendedEntry key */
            key: string;
            /** ExtendedEntry value */
            value: string;
        }
        /** Represents an ExtendedEntry. */
        class ExtendedEntry implements IExtendedEntry {
            /**
             * Constructs a new ExtendedEntry.
             * @param [properties] Properties to set
             */
            constructor(b13?: ws_proto.Frame.IExtendedEntry);
            /** ExtendedEntry key. */
            public key: string;
            /** ExtendedEntry value. */
            public value: string;
            /**
             * Creates a new ExtendedEntry instance using the specified properties.
             * @param [properties] Properties to set
             * @returns ExtendedEntry instance
             */
            public static create(a13?: ws_proto.Frame.IExtendedEntry): ws_proto.Frame.ExtendedEntry;
            /**
             * Encodes the specified ExtendedEntry message. Does not implicitly {@link ws_proto.Frame.ExtendedEntry.verify|verify} messages.
             * @param message ExtendedEntry message or plain object to encode
             * @param [writer] Writer to encode to
             * @returns Writer
             */
            public static encode(y12: ws_proto.Frame.IExtendedEntry, z12?: $protobuf.Writer): $protobuf.Writer;
            /**
             * Encodes the specified ExtendedEntry message, length delimited. Does not implicitly {@link ws_proto.Frame.ExtendedEntry.verify|verify} messages.
             * @param message ExtendedEntry message or plain object to encode
             * @param [writer] Writer to encode to
             * @returns Writer
             */
            public static encodeDelimited(w12: ws_proto.Frame.IExtendedEntry, x12?: $protobuf.Writer): $protobuf.Writer;
            /**
             * Decodes an ExtendedEntry message from the specified reader or buffer.
             * @param reader Reader or buffer to decode from
             * @param [length] Message length if known beforehand
             * @returns ExtendedEntry
             * @throws {Error} If the payload is not a reader or valid buffer
             * @throws {$protobuf.util.ProtocolError} If required fields are missing
             */
            public static decode(u12: ($protobuf.Reader | Uint8Array), v12?: number): ws_proto.Frame.ExtendedEntry;
            /**
             * Decodes an ExtendedEntry message from the specified reader or buffer, length delimited.
             * @param reader Reader or buffer to decode from
             * @returns ExtendedEntry
             * @throws {Error} If the payload is not a reader or valid buffer
             * @throws {$protobuf.util.ProtocolError} If required fields are missing
             */
            public static decodeDelimited(t12: ($protobuf.Reader | Uint8Array)): ws_proto.Frame.ExtendedEntry;
            /**
             * Verifies an ExtendedEntry message.
             * @param message Plain object to verify
             * @returns `null` if valid, otherwise the reason why it is not
             */
            public static verify(s12: {
                [k: string]: any;
            }): (string | null);
            /**
             * Creates an ExtendedEntry message from a plain object. Also converts values to their respective internal types.
             * @param object Plain object
             * @returns ExtendedEntry
             */
            public static fromObject(r12: {
                [k: string]: any;
            }): ws_proto.Frame.ExtendedEntry;
            /**
             * Creates a plain object from an ExtendedEntry message. Also converts values to other types if specified.
             * @param message ExtendedEntry
             * @param [options] Conversion options
             * @returns Plain object
             */
            public static toObject(p12: ws_proto.Frame.ExtendedEntry, q12?: $protobuf.IConversionOptions): {
                [k: string]: any;
            };
            /**
             * Converts this ExtendedEntry to JSON.
             * @returns JSON object
             */
            public toJSON(): {
                [k: string]: any;
            };
            /**
             * Gets the default type url for ExtendedEntry
             * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
             * @returns The default type url
             */
            public static getTypeUrl(o12?: string): string;
        }
    }
}
