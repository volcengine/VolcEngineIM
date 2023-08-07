import React from 'react';

import EmptyList from '@/assets/image/empty-list.png';
import NoMessageWrap from './Styles';

interface NoPermissionProps {
  [props: string]: any;
}

const NoPermission: React.FC<NoPermissionProps> = props => {
  return <NoMessageWrap></NoMessageWrap>;
};

export default NoPermission;
