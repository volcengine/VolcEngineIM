import { hilog } from '@kit.PerformanceAnalysisKit';

class VEIMAppLog {
  prefix: string;
  domain: number;

  constructor(prefix: string, domain: number) {
    this.prefix = prefix;
    this.domain = domain;
  }

  debug(tag: string, content: string) {
    hilog.debug(this.domain, `${this.prefix} [${tag}]`, content)
  }

  info(tag: string, content: string) {
    hilog.info(this.domain, `${this.prefix} [${tag}]`, content)
  }

  warn(tag: string, content: string) {
    hilog.warn(this.domain, `${this.prefix} [${tag}]`, content)
  }

  error(tag: string, content: string) {
    hilog.error(this.domain, `${this.prefix} [${tag}]`, content)
  }

  fatal(tag: string, content: string) {
    hilog.fatal(this.domain, `${this.prefix} [${tag}]`, content)
  }
}

export default new VEIMAppLog("[ve_im_app]", 0xFF00)