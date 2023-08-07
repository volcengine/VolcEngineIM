import React, { useEffect, useState } from 'react';
import {
  Layout,
  Typography,
  PageHeader,
  Grid,
  Select,
  Button,
  Message,
  Checkbox,
  Link,
  Input,
  Form,
} from '@arco-design/web-react';
import { useRecoilValue, useSetRecoilState } from 'recoil';
import { useNavigate } from '@modern-js/runtime/router';

import styles from './index.module.scss';
import { BUSINESS_BACKEND_TOKEN_ENABLE, IM_TOKEN_KEY, SMS_ENABLE, USER_ID_KEY } from '../../constant';
import { Storage } from '../../utils/storage';
import { DefaultUserIds, UserId } from '../../store';

const { Content } = Layout;
const { Row, Col } = Grid;
const { Option } = Select;
import LogoSvg from './logo_huoshanyinqin.svg';

import { useCountDown, useRequest } from 'ahooks';
import classNames from 'classnames'; // 单站点登录Web接口
import { sendCode, smsLogin } from './account';

const Login = () => {
  const setUserId = useSetRecoilState(UserId);
  const navigate = useNavigate();

  const [targetDate, setTargetDate] = useState<number>();

  const [countdown] = useCountDown({
    targetDate,
    onEnd: () => {},
  });

  const { run: handleLogin, loading: loginLoading } = useRequest(
    async () => {
      try {
        await form.validate();
      } catch {
        return;
      }

      if (!SMS_ENABLE) {
        const userIdStr = form.getFieldValue('userId');
        Storage.set(USER_ID_KEY, userIdStr, Date.now() + 7 * 24 * 60 * 60 * 1000);
        if (!BUSINESS_BACKEND_TOKEN_ENABLE) Storage.set(IM_TOKEN_KEY, form.getFieldValue('userToken'));
        setUserId(userIdStr);
        navigate('/');
        return;
      }

      try {
        let loginResult = await smsLogin({
          mobile: form.getFieldValue('phone'),
          code: form.getFieldValue('code'),
        });
        Message.success('登录成功');
        console.log('loginResult', loginResult);

        let userIdStr = loginResult.user_id_str;
        Storage.set(USER_ID_KEY, userIdStr, Date.now() + 7 * 24 * 60 * 60 * 1000);
        setUserId(userIdStr);
        navigate('/');
      } catch (error) {
        console.log(error);
        if (error.code === 'ERR_NETWORK') {
          return Message.error('请先连接网络');
        }
        return Message.error(error.description || '登录错误');
      }
    },
    { manual: true }
  );

  const [form] = Form.useForm<{
    phone: string;
    code: string;
    userId: string;
    userToken: string;
  }>();

  const { run: getSmsCode, loading: smsCodeLoading } = useRequest(
    async () => {
      try {
        await form.validate(['phone']);
      } catch (e) {
        return;
      }
      try {
        const resp = await sendCode({
          mobile: `+86 ${form.getFieldValue('phone')}`,
        });
        Message.success('验证码已发送');
        setTargetDate(Date.now() + 1000 * 60);
      } catch (error) {
        if (error.error_code) {
          Message.error(error.description || '获取验证码错误');
        } else if (error.code === 'ERR_NETWORK') {
          Message.error('请先连接网络');
        }
      }
    },
    { manual: true }
  );

  return (
    <Form form={form} wrapperCol={{ span: 24 }}>
      <div className={styles.layout}>
        <div className={styles['formWrapper']}>
          <div className={styles['logoTitleWrapper']}>
            <img src={LogoSvg} alt={'volcengine logo'}></img>
            <span>火山引擎即时通讯</span>
          </div>

          {SMS_ENABLE ? (
            <div className={styles['input-wrapper']}>
              <Form.Item
                field="phone"
                normalize={v => {
                  return v?.toString().replace(/\D/g, '').slice(0, 11) ?? v;
                }}
                rules={[
                  {
                    validator(value, cb) {
                      if (!value || value?.length !== 11) {
                        return cb('请输入11位手机号');
                      }
                      if (value[0] !== '1') {
                        return cb('+86 手机号必须以1开头');
                      }
                      return cb();
                    },
                  },
                ]}
                validateTrigger={'onBlur'}
              >
                <Input addBefore="+86" placeholder="请输入手机号" />
              </Form.Item>
              <Form.Item
                field="code"
                validateTrigger={'onBlur'}
                normalize={v => {
                  return v?.toString().replace(/\D/g, '').slice(0, 6) ?? v;
                }}
                rules={[
                  {
                    validator(value, cb) {
                      if (!value || !/^\d{4,6}$/.test(value)) {
                        cb('请输入验证码');
                      }
                      return cb();
                    },
                  },
                ]}
              >
                <Input
                  className={classNames('arco-input-search', styles['code-input'])}
                  placeholder="请输入验证码"
                  addAfter={
                    <Button
                      loading={smsCodeLoading}
                      type={'primary'}
                      onClick={() => {
                        getSmsCode();
                      }}
                      disabled={countdown !== 0}
                    >
                      {countdown === 0
                        ? smsCodeLoading
                          ? '正在获取'
                          : '获取验证码'
                        : `${Math.round(countdown / 1000)} 秒`}
                    </Button>
                  }
                  autoComplete={'off'}
                />
              </Form.Item>
              <Form.Item
                field="allow"
                rules={[
                  {
                    validator(value, cb) {
                      if (!value) {
                        cb('请先同意协议');
                      }
                      return cb();
                    },
                  },
                ]}
              >
                <Checkbox className={styles['agreement-box']}>
                  我已阅读并同意
                  <Link href="https://www.volcengine.com/docs/6348/975891" target="_blank" icon>
                    用户协议
                  </Link>
                  和
                  <Link href="https://www.volcengine.com/docs/6348/975890" target="_blank" icon>
                    隐私政策
                  </Link>
                </Checkbox>
              </Form.Item>
            </div>
          ) : (
            <div className={styles['input-wrapper']}>
              <Form.Item
                field="userId"
                normalize={v => {
                  return v?.toString().replace(/\D/g, '').slice(0, 18) ?? v;
                }}
                rules={[
                  {
                    validator(value, cb) {
                      if (!value) {
                        return cb('请输入登录用户 ID');
                      }
                      return cb();
                    },
                  },
                ]}
                validateTrigger={'onBlur'}
              >
                <Input placeholder="请输入登录用户 ID" />
              </Form.Item>
              {!BUSINESS_BACKEND_TOKEN_ENABLE && (
                <Form.Item
                  field="userToken"
                  rules={[
                    {
                      validator(value, cb) {
                        if (!value) {
                          return cb('请输入用户 Token');
                        }
                        return cb();
                      },
                    },
                  ]}
                  validateTrigger={'onBlur'}
                  extra={
                    <>
                      临时 Token 可在{' '}
                      <a href={'https://console.volcengine.com/rtc/im/appManage'} target={'_blank'}>
                        控制台
                      </a>{' '}
                      生成
                    </>
                  }
                >
                  <Input placeholder="请输入用户 Token" autoComplete={'off'} />
                </Form.Item>
              )}
            </div>
          )}
          <div className={styles['button-wrapper']}>
            <div className={styles.button}>
              <Button type="primary" long onClick={handleLogin} loading={loginLoading}>
                登录
              </Button>
            </div>
          </div>
        </div>
      </div>
    </Form>
  );
};

export default Login;
