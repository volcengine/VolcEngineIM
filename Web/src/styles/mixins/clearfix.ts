import { css } from 'styled-components';

export const clearfix = css`
  &::after {
    display: table;
    clear: both;
    content: '';
  }
`;
