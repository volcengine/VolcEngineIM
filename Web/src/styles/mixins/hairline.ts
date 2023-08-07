import { css } from 'styled-components';

export const hairlineCommon = function() {
  return css`
    content: '';
    position: absolute;
    display: block;
    transform-origin: 0 0;
  `;
};

export const hairlineTop = function(color?: string) {
  return css`
    position: relative;

    &::before {
      ${hairlineCommon()}
      border-top: 1PX solid ${color};
      left: 0;
      top: 0;
      width: 100%;
      transform-origin: 0 top;

      @media (min-resolution: 2dppx) {
        width: 200%;
        transform: scale(.5);
      }

      @media (min-resolution: 3dppx) {
        width: 300%;
        transform: scaleX(0.333);
      }
    }
  `;
};

export const hairlineRight = function(color?: string) {
  return css`
    position: relative;

    &::before {
      ${hairlineCommon()}
      border-right: 1PX solid ${color};
      right: 0;
      top: 0;
      height: 100%;
      transform-origin: right 0;

      @media (min-resolution: 2dppx) {
        width: 200%;
        transform: scale(.5);
      }

      @media (min-resolution: 3dppx) {
        width: 300%;
        transform: scaleX(0.333);
      }
    }
  `;
};

export const hairlineBottom = function(color?: string) {
  return css`
    position: relative;

    &::before {
      ${hairlineCommon()}
      border-bottom: 1PX solid ${color};
      left: 0;
      bottom: 0;
      width: 100%;
      transform-origin: 0 bottom;

      @media (min-resolution: 2dppx) {
        width: 200%;
        transform: scale(.5);
      }

      @media (min-resolution: 3dppx) {
        width: 300%;
        transform: scaleX(0.333);
      }
    }
  `;
};

export const hairlineLeft = function(color?: string) {
  return css`
    position: relative;

    &::before {
      ${hairlineCommon()}
      border-left: 1PX solid ${color};
      left: 0;
      top: 0;
      height: 100%;
      transform-origin: left 0;

      @media (min-resolution: 2dppx) {
        width: 200%;
        transform: scale(.5);
      }

      @media (min-resolution: 3dppx) {
        width: 300%;
        transform: scaleX(0.333);
      }
    }
  `;
};

export const hairlineAll = function(
  color = '#ccc',
  radius: string | number = '2PX',
  style = 'solid',
) {
  return css`
    position: relative;

    &::after {
      content: '';
      pointer-events: none;
      display: block;
      position: absolute;
      left: 0;
      top: 0;
      transform-origin: 0 0;
      border: 1px ${style} ${color};
      border-radius: ${radius};
      box-sizing: border-box;
      width: 100%;
      height: 100%;

      @media (min-resolution: 2dppx) {
        width: 200%;
        height: 200%;
        border-radius: ${radius} * 2;
        transform: scale(0.5);
      }

      @media (min-resolution: 3dppx) {
        width: 300%;
        height: 300%;
        border-radius: $radius * 3;
        transform: scale(0.333);
      }
    }
  `;
};
