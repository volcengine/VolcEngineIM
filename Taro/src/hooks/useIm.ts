import { useDispatch } from 'react-redux';
import * as IMLib from '@volcengine/im-mp-sdk';

import { getToken } from '../utils/api';
import { APP_ID, IMCLOUD_CONFIG  } from '../constants';
import { clearAll, selectIm, setIm } from '../store/imReducers';
import { useAppSelector } from '../store/hooks';
import { selectUser } from '../store/userReducers';
import { useRecoilState } from 'recoil';
import { BytedIMInstance } from '../store';

const { BytedIM, MultimediaPlugin, LivePlugin, ContactPlugin } = IMLib;

export const useIm = () => {
  const user = useAppSelector(selectUser);
  const instance = useAppSelector(selectIm);
  const dispatch = useDispatch();
  const [_, set] = useRecoilState(BytedIMInstance);
  const init = env => {
    const option =  IMCLOUD_CONFIG;
    const imInstance = new BytedIM(
      {
        ...option,
        userId: user.id,
        deviceId: user.id,
        token: () => getToken(APP_ID, user.id, env),
        debug: true,
        injectContext: globalThis,
        // @ts-ignore
        _teaOptionLog: true,
        // @ts-ignore
        _teaOptionReportAll: true
      },
      [MultimediaPlugin, LivePlugin, ContactPlugin]
    );

    imInstance.init();

    dispatch(setIm(imInstance));
    set(imInstance);
  };

  const dispose = () => {
    instance.dispose();
    dispatch(clearAll());
  };

  return {
    init,
    dispose
  };
};
