export function isFunction(val) {
  return typeof val === 'function';
}

export function isString(val): val is string {
  return typeof val === 'string';
}

export function isHTMLElement(val: any) {
  if (!val || typeof val !== 'object') return false;
  return val instanceof HTMLElement;
}

export function _getRange() {
  const sel = window.getSelection();
  if (sel.rangeCount > 0) {
    return sel.getRangeAt(0);
  }
  return null;
}

export function _clearRange(range) {
  if (!range) range = _getRange();
  const sel = window.getSelection();
  sel.removeAllRanges();
  return sel.addRange(range);
}

export function _setRange(
  position: 'after' | 'before',
  node: Node,
  range: Range,
) {
  if (!range) range = _getRange();
  if (!range || !node) return range;
  if (position === 'after') {
    range.setEndAfter(node);
    range.setStartAfter(node);
  } else if (position === 'before') {
    range.setEndBefore(node);
    range.setStartBefore(node);
  }
  range.collapse(false);
  return _clearRange(range);
}
