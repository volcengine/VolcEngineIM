import appTools, { defineConfig } from '@modern-js/app-tools';

// https://modernjs.dev/configure/app/usage
export default defineConfig({
  plugins: [appTools()],
  dev: {
    port: 5000,
    startUrl: 'http://localhost:<port>/rtc/solution/im',
  },
  tools: {
    sass: {
      sourceMap: true,
    },
  },
  runtime: {
    router: {
      basename: '/rtc/solution/im',
    },
  },
  html: {
    title: '火山引擎即时通讯 Demo',
  },
  source: {
    globalVars: {
      'process.env.BUILD_TYPE':  'online',
    },
  },
});
