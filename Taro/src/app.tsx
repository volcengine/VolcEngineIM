import { Component, PropsWithChildren } from 'react';
import { Provider } from 'react-redux';
import 'ossaui/dist/style/index.scss';
import 'taro-ui/dist/style/index.scss';

import './app.scss';
import { AccountsInfoVersion, store } from './store';
import { RecoilRoot, useRecoilState } from 'recoil';
import { useAccountsInfo, useProfileUpdater } from './hooks/useProfileUpdater';
import { useImEvent } from './hooks/useImEvent';

function NewComponent(props: { children: React.ReactNode }) {
  useProfileUpdater();
  useImEvent();
  const [accountsInfo, setAccountsInfo] = useRecoilState(AccountsInfoVersion);

  return <>{props.children}</>;
}

class App extends Component<PropsWithChildren> {
  taroGlobalData = {
    globalData: {}
  };

  render() {
    return (
      <Provider store={store}>
        {/*@ts-ignore*/}
        <RecoilRoot>
          <NewComponent children={this.props.children} />
        </RecoilRoot>
      </Provider>
    );
  }
}

export default App;
