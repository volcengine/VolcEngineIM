import { css } from 'styled-components';

export const safeAreaInsetBottom = css`
  padding-bottom: constant(safe-area-inset-bottom);
  padding-bottom: env(safe-area-inset-bottom);
`;
