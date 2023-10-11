import { Component, PropsWithChildren } from 'react';
import { Provider } from 'react-redux';
import 'ossaui/dist/style/index.scss';

import './app.scss';
import { store } from './store';

class App extends Component<PropsWithChildren> {
  taroGlobalData = {
    globalData: {},
  };

  render() {
    return <Provider store={store}>{this.props.children}</Provider>;
  }
}

export default App;
