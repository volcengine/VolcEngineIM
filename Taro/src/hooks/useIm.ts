import { useDispatch } from 'react-redux';
import * as IMLib from '@volcengine/im-mp-sdk';

import { getToken } from '../utils/api';
import { APP_ID, IMCLOUD_CONFIG  } from '../constants';
import { clearAll, selectIm, setIm } from '../store/imReducers';
import { useAppSelector } from '../store/hooks';
import { selectUser } from '../store/userReducers';

const { BytedIM, MultimediaPlugin, LivePlugin } = IMLib;

export const useIm = () => {
  const user = useAppSelector(selectUser);
  const instance = useAppSelector(selectIm);
  const dispatch = useDispatch();

  const init = env => {
    const option = IMCLOUD_CONFIG;
    const imInstance = new BytedIM(
      {
        ...option,
        userId: user.id,
        deviceId: user.id,
        token: () => getToken(APP_ID, user.id, env),
        injectContext: globalThis
      },
      [MultimediaPlugin, LivePlugin]
    );

    imInstance.init();

    dispatch(setIm(imInstance));
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
