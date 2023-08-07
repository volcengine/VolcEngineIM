import { isFunction } from './tools';
import { noop, ElementType } from '../constant';

type changeFunc = (curRange?: Range, oldRange?: Range) => void;

/*
  https://zh.javascript.info/selection-range
*/
class Selection {
  domEditor?: HTMLElement;
  _currentRange?: Range;
  _onSelectionChange?: changeFunc;

  constructor(domEditor: HTMLElement, onChange?: changeFunc) {
    this.domEditor = domEditor;
    this._currentRange = null;
    this._onSelectionChange = isFunction(onChange) ? onChange : noop;
  }

  getRange() {
    return this._currentRange;
  }

  /** 保存选区 */
  saveRange(_range?: Range) {
    const oldRange = this._currentRange;

    if (_range && _range instanceof Range) {
      this._currentRange = _range;
      this._onSelectionChange(this._currentRange, oldRange);

      return;
    }

    const selection = window.getSelection();
    // 选择中的范围数，除 Firefox 外，其他浏览器最多为 1
    if (selection.rangeCount === 0) {
      return;
    }

    // 获取从 0 开始的第 i 个范围。在除 Firefox 之外的所有浏览器中，仅使用 0
    const curRange = selection.getRangeAt(0);

    // 判断选区内容是否在Editor
    const containerEle = this._getSelectionContainerElem(curRange);

    if (this.domEditor?.contains(containerEle)) {
      this._currentRange = curRange;
      this._onSelectionChange(this._currentRange, oldRange);
    }
  }

  /** 获取选区中的文字 */
  getSelectionText() {
    const range = this._currentRange;

    if (!range) {
      return '';
    }

    return range.toString();
  }

  /** 选区是否为空 */
  isSelectionEmpty() {
    const range = this._currentRange;

    if (!range || !range.startContainer) {
      return false;
    }

    if (
      range.startContainer === range.endContainer &&
      range.startOffset === range.endOffset
    ) {
      return true;
    }

    return false;
  }

  /** 恢复选区 */
  restoreSelection() {
    const range = this._currentRange;

    if (!range) {
      return;
    }

    const selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
  }

  restoreSelectionWithOutRemoveAll() {
    const selection = window.getSelection();
    selection.addRange(this._currentRange);
  }

  /** 获取选区容器元素 */
  _getSelectionContainerElem(range?: Range) {
    if (!range) return;

    // 在范围内的所有节点中最近的共同祖先节点
    const ele = range.commonAncestorContainer;
    return ele.nodeType === ElementType.ELEMENT_NODE ? ele : ele.parentNode;
  }
}

export default Selection;
