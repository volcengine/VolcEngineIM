import { useCallback, useState } from 'react';
import { View, Image, Text, Progress } from '@tarojs/components';

import { getFileMsgContent } from '../../../utils/message-preview';
import { useAudioContext } from '../../../hooks/useMedia';

import PlaySvg from '../../../assets/svg/play.svg';
import PauseSvg from '../../../assets/svg/pause.svg';

import './index.scss';

interface ItemProps {
  message: any;
}

const Item: React.FC<ItemProps> = ({ message }) => {
  const url = getFileMsgContent(message);
  const [isPlay, setPlay] = useState(false);
  const handlePlayEnd = useCallback(() => {
    setPlay(false);
  }, []);
  const { duration, currentTime, playAudio, pauseAudio } = useAudioContext({
    url,
    onEnded: handlePlayEnd,
  });

  const percent = duration > 0 ? (currentTime / duration) * 100 : 0;

  const handlePlay = useCallback(() => {
    setPlay(true);
    playAudio();
  }, [playAudio]);

  const handlePause = useCallback(() => {
    setPlay(false);
    pauseAudio();
  }, [pauseAudio]);

  if (!url) {
    return <Text>音频获取失败</Text>;
  }

  return (
    <View className='audio-item-wrapper'>
      {isPlay ? (
        <View onClick={handlePause} className='icon-wrapper'>
          <Image className='icon' src={PauseSvg}></Image>
        </View>
      ) : (
        <View onClick={handlePlay} className='icon-wrapper'>
          <Image className='icon' src={PlaySvg}></Image>
        </View>
      )}
      <View className='progress-wrapper'>
        <Progress percent={percent} activeColor='#DD1A21' strokeWidth={2} />
      </View>
      {duration > 0 && <Text className='text'>{Math.round(duration)}s</Text>}
    </View>
  );
};

export default Item;
