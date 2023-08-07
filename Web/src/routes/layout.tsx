import { Outlet, useLocation } from '@modern-js/runtime/router';
import { RecoilRoot } from 'recoil';
import { Spin, Message } from '@arco-design/web-react';

import { PageLoading, AppLayout } from './Style';
import { AppNavbar } from '../components';
import { useImSdK } from '../hooks';
import { useEffect } from 'react';

const Layout = () => {
  const { loading } = useImSdK();

  if (loading) {
    return (
      <PageLoading>
        <Spin dot />
      </PageLoading>
    );
  }

  return (
    <AppLayout>
      <AppNavbar />

      <Outlet></Outlet>
    </AppLayout>
  );
};

export default () => {
  const { pathname } = useLocation();

  

  return <RecoilRoot>{pathname === '/login' ? <Outlet></Outlet> : <Layout />}</RecoilRoot>;
};
