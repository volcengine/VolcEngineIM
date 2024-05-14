import React, { FC, useState, CSSProperties } from 'react';
import { Tooltip } from '@arco-design/web-react';

import Portal from '../../Portal';
import { IconEmoji } from '../../Icon';
import EmojiList from './EmojiList';
import IconButtonMask from '../../IconButtonMask';
import { useRecoilValue } from 'recoil';
import { BytedIMInstance, CurrentConversation } from '../../../store';
import { im_proto } from '@volcengine/im-web-sdk';

interface EmojiButtonProps {
  sendStickerMessage?: (sticker: any, from?) => void;
  isSimple: boolean;
  isCryptoChat: boolean;
  alignContainer?: () => HTMLElement;
  onEmojiPanelTrigger?: (showEmoji: boolean) => void;
  list?: any[];
  editor?: HTMLTextAreaElement;
}

const EmojiButton: FC<EmojiButtonProps> = props => {
  const { list, editor } = props;

  const [visible, setVisible] = useState(false);
  const [panelStyle, setPanelStyle] = useState<CSSProperties>({});

  const toggleEmoji = () => {
    setVisible(p => !p);
  };

  const handleEmojiOpen = (event: React.MouseEvent<any>) => {
    const targetEle = event.target as HTMLDivElement;

    const rect = targetEle.getBoundingClientRect();

    const { x, y } = rect;

    setPanelStyle({
      left: x - 13,
      top: y - 208,
    });
    setVisible(true);
  };

  const addEmoji = (value: any) => {
    if (!editor) return;
    editor.value += value;
    editor.focus();
  };
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const currentConversation = useRecoilValue(CurrentConversation);

  const handleSelectEmoji = (value: any = {}) => {
    const { name } = value;
    addEmoji(name);
    setVisible(false);
    if (currentConversation.type === im_proto.ConversationType.ONE_TO_ONE_CHAT) {
      bytedIMInstance.sendP2PMessage({
        conversation: currentConversation,
        sendType: im_proto.SendType.BY_CONVERSATION,
        msgType: im_proto.MessageType.MESSAGE_TYPE_CUSTOM_P2P,
        content: JSON.stringify({
          type: 1000,
          ext: '',
          message_type: im_proto.MessageType.MESSAGE_TYPE_TEXT,
        }),
      });
    }
  };

  return (
    <>
      {visible && (
        <Portal>
          <EmojiList style={panelStyle} list={list} onSelectEmoji={handleSelectEmoji} onMaskClick={toggleEmoji} />
        </Portal>
      )}
      <Tooltip position="top" content="表情">
        <div className="toolbar-item" onClick={handleEmojiOpen}>
          <IconButtonMask>
            <IconEmoji />
          </IconButtonMask>
        </div>
      </Tooltip>
    </>
  );
};

export default EmojiButton;
