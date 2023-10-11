export default {
  pages: [
    'pages/login/index',
    'pages/chat/index',
    'pages/live-chat/index',
    'pages/home/index',
    'pages/live/index',
    'pages/me/index'
  ],
  tabBar: {
    color: '#000000',
    selectedColor: '#000000',
    list: [
      {
        pagePath: 'pages/home/index',
        iconPath: 'assets/chat.png',
        selectedIconPath: 'assets/chat-active.png',
        text: '消息'
      },
      {
        pagePath: 'pages/live/index',
        iconPath: 'assets/chat.png',
        selectedIconPath: 'assets/chat-active.png',
        text: '直播'
      },
      {
        pagePath: 'pages/me/index',
        iconPath: 'assets/me.png',
        selectedIconPath: 'assets/me-active.png',
        text: '我'
      }
    ]
  },
  window: {
    backgroundTextStyle: 'light',
    navigationBarBackgroundColor: '#fff',
    navigationBarTitleText: 'WeChat',
    navigationBarTextStyle: 'black'
  }
};
