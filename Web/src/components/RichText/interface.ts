export enum richTextTag {
  UNKNOWN = 0,
  TEXT = 1,
  IMG = 2,
  P = 3,
  FIGURE = 4,
  AT = 5,
  A = 6,
  B = 7,
  I = 8,
  U = 9,
  EMOTION = 10,
  BUTTON = 11,
  SELECT = 12,
  PROGRESSSELECT = 13,
  DIV = 14,
  TEXTABLEAREA = 15,
  TIME = 16,
  LINK = 17,
  MEDIA = 18,
  SELECTMENU = 19,
  OVERFLOWMENU = 20,
  DATEPICKER = 21,
  DOCS = 22,
  H1 = 23,
  H2 = 24,
  H3 = 25,
  UL = 26,
  OL = 27,
  LI = 28,
  QUOTE = 29,
  CODE = 30,
  CODE_BLOCK = 31,
  HR = 32,
  TIMEPICKER = 33,
  DATETIMEPICKER = 34,
  REACTION = 35,
  MENTION = 36,
}

export interface IRichTextElement {
  childIds?: string[];
  property: any;
  tag: richTextTag;
  style: Record<string, any>;
  styleKeys?: string[];
  wideStyle?: object;
}

export interface IRichTextElements {
  [id: string]: IRichTextElement;
}

export interface IRichText {
  elementIds: string[];
  elements: IRichTextElements;
  imageIds: string[];
  atIds: string[];
  anchorIds: string[];
  mediaIds?: string[];
  docsIds?: string[];
  innerText: string;
}
