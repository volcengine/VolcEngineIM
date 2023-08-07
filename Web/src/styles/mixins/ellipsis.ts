import { css } from 'styled-components';

export const ellipsis = css`
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
`;

export const multiEllipsis = function(lines: number) {
  return css`
    display: -webkit-box;
    overflow: hidden;
    text-overflow: ellipsis;
    -webkit-line-clamp: ${lines};
    -webkit-box-orient: vertical;
  `;
};
