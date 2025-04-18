import { useUnreadFriendApplyCount } from '../../../hooks';

function ApplyTitle() {
  const unreadApplyCount = useUnreadFriendApplyCount();

  return (
    <div>
      好友申请{' '}
      {unreadApplyCount ? (
        <span style={{ color: 'red' }}>({unreadApplyCount > 99 ? '99+' : unreadApplyCount})</span>
      ) : (
        ''
      )}
    </div>
  );
}

export const contactSublist = [
  {
    key: 'apply',
    title: '好友申请',
    menuRender: () => {
      return <ApplyTitle></ApplyTitle>;
    },
  },
  // {key: 'send', title: '发送的好友申请'},
  // {key: 'black', title: '黑名单'},
  {
    key: 'my',
    title: '我的好友',
    menuRender: () => {
      return '我的好友';
    },
  },
  {
    key: 'black',
    title: '黑名单',
    menuRender: () => {
      return '黑名单';
    },
  },
  {
    key: 'bot',
    title: '机器人列表',
    menuRender: () => {
      return '机器人列表';
    },
  },
] as const;
