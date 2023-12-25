import { Badge, Tabs } from '@arco-design/web-react';

export default function ConversationTab({
  onChange,
  allUnreadCount,
  friendUnreadCount,
}: {
  onChange: (type: string) => void;
  allUnreadCount: number;
  friendUnreadCount: number;
}) {
  return (
    <Tabs defaultActiveTab="all" onChange={onChange} style={{ flexShrink: 0 }}>
      <Tabs.TabPane
        key="all"
        title={
          <>
            全部<Badge count={allUnreadCount}></Badge>
          </>
        }
      ></Tabs.TabPane>
      <Tabs.TabPane
        key="friend"
        title={
          <>
            好友<Badge count={friendUnreadCount}></Badge>
          </>
        }
      ></Tabs.TabPane>
    </Tabs>
  );
}
