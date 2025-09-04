import * as $protobuf from "protobufjs/minimal";
const $Reader = $protobuf.Reader, $Writer = $protobuf.Writer, $util = $protobuf.util;
const $root = $protobuf.roots["default"] || ($protobuf.roots["default"] = {});
export const ws_proto = $root.ws_proto = (() => {
    const r1 = {};
    r1.Frame = (function () {
        function t1(k4) {
            this.headers = [];
            if (k4)
                for (let l4 = Object.keys(k4), m4 = 0; m4 < l4.length; ++m4)
                    if (k4[l4[m4]] != null)
                        this[l4[m4]] = k4[l4[m4]];
        }
        t1.prototype.seqid = $util.Long ? $util.Long.fromBits(0, 0, true) : 0;
        t1.prototype.logid = $util.Long ? $util.Long.fromBits(0, 0, true) : 0;
        t1.prototype.service = 0;
        t1.prototype.method = 0;
        t1.prototype.headers = $util.emptyArray;
        t1.prototype.payload_encoding = "";
        t1.prototype.payload_type = "";
        t1.prototype.payload = $util.newBuffer([]);
        t1.create = function u1(j4) {
            return new t1(j4);
        };
        t1.encode = function v1(g4, h4) {
            if (!h4)
                h4 = $Writer.create();
            h4.uint32(8).uint64(g4.seqid);
            h4.uint32(16).uint64(g4.logid);
            h4.uint32(24).int32(g4.service);
            h4.uint32(32).int32(g4.method);
            if (g4.headers != null && g4.headers.length)
                for (let i4 = 0; i4 < g4.headers.length; ++i4)
                    $root.ws_proto.Frame.ExtendedEntry.encode(g4.headers[i4], h4.uint32(42).fork()).ldelim();
            if (g4.payload_encoding != null && Object.hasOwnProperty.call(g4, "payload_encoding"))
                h4.uint32(50).string(g4.payload_encoding);
            if (g4.payload_type != null && Object.hasOwnProperty.call(g4, "payload_type"))
                h4.uint32(58).string(g4.payload_type);
            if (g4.payload != null && Object.hasOwnProperty.call(g4, "payload"))
                h4.uint32(66).bytes(g4.payload);
            return h4;
        };
        t1.encodeDelimited = function w1(e4, f4) {
            return this.encode(e4, f4).ldelim();
        };
        t1.decode = function x1(z3, a4) {
            if (!(z3 instanceof $Reader))
                z3 = $Reader.create(z3);
            let b4 = a4 === undefined ? z3.len : z3.pos + a4, c4 = new $root.ws_proto.Frame();
            while (z3.pos < b4) {
                let d4 = z3.uint32();
                switch (d4 >>> 3) {
                    case 1: {
                        c4.seqid = z3.uint64();
                        break;
                    }
                    case 2: {
                        c4.logid = z3.uint64();
                        break;
                    }
                    case 3: {
                        c4.service = z3.int32();
                        break;
                    }
                    case 4: {
                        c4.method = z3.int32();
                        break;
                    }
                    case 5: {
                        if (!(c4.headers && c4.headers.length))
                            c4.headers = [];
                        c4.headers.push($root.ws_proto.Frame.ExtendedEntry.decode(z3, z3.uint32()));
                        break;
                    }
                    case 6: {
                        c4.payload_encoding = z3.string();
                        break;
                    }
                    case 7: {
                        c4.payload_type = z3.string();
                        break;
                    }
                    case 8: {
                        c4.payload = z3.bytes();
                        break;
                    }
                    default:
                        z3.skipType(d4 & 7);
                        break;
                }
            }
            if (!c4.hasOwnProperty("seqid"))
                throw $util.ProtocolError("missing required 'seqid'", { instance: c4 });
            if (!c4.hasOwnProperty("logid"))
                throw $util.ProtocolError("missing required 'logid'", { instance: c4 });
            if (!c4.hasOwnProperty("service"))
                throw $util.ProtocolError("missing required 'service'", { instance: c4 });
            if (!c4.hasOwnProperty("method"))
                throw $util.ProtocolError("missing required 'method'", { instance: c4 });
            return c4;
        };
        t1.decodeDelimited = function y1(y3) {
            if (!(y3 instanceof $Reader))
                y3 = new $Reader(y3);
            return this.decode(y3, y3.uint32());
        };
        t1.verify = function z1(v3) {
            if (typeof v3 !== "object" || v3 === null)
                return "object expected";
            if (!$util.isInteger(v3.seqid) && !(v3.seqid && $util.isInteger(v3.seqid.low) && $util.isInteger(v3.seqid.high)))
                return "seqid: integer|Long expected";
            if (!$util.isInteger(v3.logid) && !(v3.logid && $util.isInteger(v3.logid.low) && $util.isInteger(v3.logid.high)))
                return "logid: integer|Long expected";
            if (!$util.isInteger(v3.service))
                return "service: integer expected";
            if (!$util.isInteger(v3.method))
                return "method: integer expected";
            if (v3.headers != null && v3.hasOwnProperty("headers")) {
                if (!Array.isArray(v3.headers))
                    return "headers: array expected";
                for (let w3 = 0; w3 < v3.headers.length; ++w3) {
                    let x3 = $root.ws_proto.Frame.ExtendedEntry.verify(v3.headers[w3]);
                    if (x3)
                        return "headers." + x3;
                }
            }
            if (v3.payload_encoding != null && v3.hasOwnProperty("payload_encoding"))
                if (!$util.isString(v3.payload_encoding))
                    return "payload_encoding: string expected";
            if (v3.payload_type != null && v3.hasOwnProperty("payload_type"))
                if (!$util.isString(v3.payload_type))
                    return "payload_type: string expected";
            if (v3.payload != null && v3.hasOwnProperty("payload"))
                if (!(v3.payload && typeof v3.payload.length === "number" || $util.isString(v3.payload)))
                    return "payload: buffer expected";
            return null;
        };
        t1.fromObject = function a2(s3) {
            if (s3 instanceof $root.ws_proto.Frame)
                return s3;
            let t3 = new $root.ws_proto.Frame();
            if (s3.seqid != null)
                if ($util.Long)
                    (t3.seqid = $util.Long.fromValue(s3.seqid)).unsigned = true;
                else if (typeof s3.seqid === "string")
                    t3.seqid = parseInt(s3.seqid, 10);
                else if (typeof s3.seqid === "number")
                    t3.seqid = s3.seqid;
                else if (typeof s3.seqid === "object")
                    t3.seqid = new $util.LongBits(s3.seqid.low >>> 0, s3.seqid.high >>> 0).toNumber(true);
            if (s3.logid != null)
                if ($util.Long)
                    (t3.logid = $util.Long.fromValue(s3.logid)).unsigned = true;
                else if (typeof s3.logid === "string")
                    t3.logid = parseInt(s3.logid, 10);
                else if (typeof s3.logid === "number")
                    t3.logid = s3.logid;
                else if (typeof s3.logid === "object")
                    t3.logid = new $util.LongBits(s3.logid.low >>> 0, s3.logid.high >>> 0).toNumber(true);
            if (s3.service != null)
                t3.service = s3.service | 0;
            if (s3.method != null)
                t3.method = s3.method | 0;
            if (s3.headers) {
                if (!Array.isArray(s3.headers))
                    throw TypeError(".ws_proto.Frame.headers: array expected");
                t3.headers = [];
                for (let u3 = 0; u3 < s3.headers.length; ++u3) {
                    if (typeof s3.headers[u3] !== "object")
                        throw TypeError(".ws_proto.Frame.headers: object expected");
                    t3.headers[u3] = $root.ws_proto.Frame.ExtendedEntry.fromObject(s3.headers[u3]);
                }
            }
            if (s3.payload_encoding != null)
                t3.payload_encoding = String(s3.payload_encoding);
            if (s3.payload_type != null)
                t3.payload_type = String(s3.payload_type);
            if (s3.payload != null)
                if (typeof s3.payload === "string")
                    $util.base64.decode(s3.payload, t3.payload = $util.newBuffer($util.base64.length(s3.payload)), 0);
                else if (s3.payload.length >= 0)
                    t3.payload = s3.payload;
            return t3;
        };
        t1.toObject = function b2(m3, n3) {
            if (!n3)
                n3 = {};
            let o3 = {};
            if (n3.arrays || n3.defaults)
                o3.headers = [];
            if (n3.defaults) {
                if ($util.Long) {
                    let r3 = new $util.Long(0, 0, true);
                    o3.seqid = n3.longs === String ? r3.toString() : n3.longs === Number ? r3.toNumber() : r3;
                }
                else
                    o3.seqid = n3.longs === String ? "0" : 0;
                if ($util.Long) {
                    let q3 = new $util.Long(0, 0, true);
                    o3.logid = n3.longs === String ? q3.toString() : n3.longs === Number ? q3.toNumber() : q3;
                }
                else
                    o3.logid = n3.longs === String ? "0" : 0;
                o3.service = 0;
                o3.method = 0;
                o3.payload_encoding = "";
                o3.payload_type = "";
                if (n3.bytes === String)
                    o3.payload = "";
                else {
                    o3.payload = [];
                    if (n3.bytes !== Array)
                        o3.payload = $util.newBuffer(o3.payload);
                }
            }
            if (m3.seqid != null && m3.hasOwnProperty("seqid"))
                if (typeof m3.seqid === "number")
                    o3.seqid = n3.longs === String ? String(m3.seqid) : m3.seqid;
                else
                    o3.seqid = n3.longs === String ? $util.Long.prototype.toString.call(m3.seqid) : n3.longs === Number ? new $util.LongBits(m3.seqid.low >>> 0, m3.seqid.high >>> 0).toNumber(true) : m3.seqid;
            if (m3.logid != null && m3.hasOwnProperty("logid"))
                if (typeof m3.logid === "number")
                    o3.logid = n3.longs === String ? String(m3.logid) : m3.logid;
                else
                    o3.logid = n3.longs === String ? $util.Long.prototype.toString.call(m3.logid) : n3.longs === Number ? new $util.LongBits(m3.logid.low >>> 0, m3.logid.high >>> 0).toNumber(true) : m3.logid;
            if (m3.service != null && m3.hasOwnProperty("service"))
                o3.service = m3.service;
            if (m3.method != null && m3.hasOwnProperty("method"))
                o3.method = m3.method;
            if (m3.headers && m3.headers.length) {
                o3.headers = [];
                for (let p3 = 0; p3 < m3.headers.length; ++p3)
                    o3.headers[p3] = $root.ws_proto.Frame.ExtendedEntry.toObject(m3.headers[p3], n3);
            }
            if (m3.payload_encoding != null && m3.hasOwnProperty("payload_encoding"))
                o3.payload_encoding = m3.payload_encoding;
            if (m3.payload_type != null && m3.hasOwnProperty("payload_type"))
                o3.payload_type = m3.payload_type;
            if (m3.payload != null && m3.hasOwnProperty("payload"))
                o3.payload = n3.bytes === String ? $util.base64.encode(m3.payload, 0, m3.payload.length) : n3.bytes === Array ? Array.prototype.slice.call(m3.payload) : m3.payload;
            return o3;
        };
        t1.prototype.toJSON = function c2() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };
        t1.getTypeUrl = function d2(l3) {
            if (l3 === undefined) {
                l3 = "type.googleapis.com";
            }
            return l3 + "/ws_proto.Frame";
        };
        t1.ExtendedEntry = (function () {
            function f2(i3) {
                if (i3)
                    for (let j3 = Object.keys(i3), k3 = 0; k3 < j3.length; ++k3)
                        if (i3[j3[k3]] != null)
                            this[j3[k3]] = i3[j3[k3]];
            }
            f2.prototype.key = "";
            f2.prototype.value = "";
            f2.create = function g2(h3) {
                return new f2(h3);
            };
            f2.encode = function h2(f3, g3) {
                if (!g3)
                    g3 = $Writer.create();
                g3.uint32(10).string(f3.key);
                g3.uint32(18).string(f3.value);
                return g3;
            };
            f2.encodeDelimited = function i2(d3, e3) {
                return this.encode(d3, e3).ldelim();
            };
            f2.decode = function j2(y2, z2) {
                if (!(y2 instanceof $Reader))
                    y2 = $Reader.create(y2);
                let a3 = z2 === undefined ? y2.len : y2.pos + z2, b3 = new $root.ws_proto.Frame.ExtendedEntry();
                while (y2.pos < a3) {
                    let c3 = y2.uint32();
                    switch (c3 >>> 3) {
                        case 1: {
                            b3.key = y2.string();
                            break;
                        }
                        case 2: {
                            b3.value = y2.string();
                            break;
                        }
                        default:
                            y2.skipType(c3 & 7);
                            break;
                    }
                }
                if (!b3.hasOwnProperty("key"))
                    throw $util.ProtocolError("missing required 'key'", { instance: b3 });
                if (!b3.hasOwnProperty("value"))
                    throw $util.ProtocolError("missing required 'value'", { instance: b3 });
                return b3;
            };
            f2.decodeDelimited = function k2(x2) {
                if (!(x2 instanceof $Reader))
                    x2 = new $Reader(x2);
                return this.decode(x2, x2.uint32());
            };
            f2.verify = function l2(w2) {
                if (typeof w2 !== "object" || w2 === null)
                    return "object expected";
                if (!$util.isString(w2.key))
                    return "key: string expected";
                if (!$util.isString(w2.value))
                    return "value: string expected";
                return null;
            };
            f2.fromObject = function m2(u2) {
                if (u2 instanceof $root.ws_proto.Frame.ExtendedEntry)
                    return u2;
                let v2 = new $root.ws_proto.Frame.ExtendedEntry();
                if (u2.key != null)
                    v2.key = String(u2.key);
                if (u2.value != null)
                    v2.value = String(u2.value);
                return v2;
            };
            f2.toObject = function n2(r2, s2) {
                if (!s2)
                    s2 = {};
                let t2 = {};
                if (s2.defaults) {
                    t2.key = "";
                    t2.value = "";
                }
                if (r2.key != null && r2.hasOwnProperty("key"))
                    t2.key = r2.key;
                if (r2.value != null && r2.hasOwnProperty("value"))
                    t2.value = r2.value;
                return t2;
            };
            f2.prototype.toJSON = function o2() {
                return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
            };
            f2.getTypeUrl = function p2(q2) {
                if (q2 === undefined) {
                    q2 = "type.googleapis.com";
                }
                return q2 + "/ws_proto.Frame.ExtendedEntry";
            };
            return f2;
        })();
        return t1;
    })();
    return r1;
})();
export { $root as default };
