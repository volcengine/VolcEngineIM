declare namespace HomeScssNamespace {
  export interface IHomeScss {
    card: string;
    code: string;
    container: string;
    description: string;
    grid: string;
    logo: string;
    styles: string;
    title: string;
  }
}

declare const HomeScssModule: HomeScssNamespace.IHomeScss & {
  /** WARNING: Only available when `css-loader` is used without `style-loader` or `mini-css-extract-plugin` */
  locals: HomeScssNamespace.IHomeScss;
};

export = HomeScssModule;
