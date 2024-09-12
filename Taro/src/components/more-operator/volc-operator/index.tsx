import { View, Image } from '@tarojs/components';

import VolcSvg from '../../../assets/svg/Volcano.svg';

interface OperatorProps {
  onClick: () => void;
}

const Operator: React.FC<OperatorProps> = ({ onClick }) => {
  return (
    <View className="operator-wrapper" onClick={onClick}>
      <View className="icon-wrapper">
        <Image className="icon" src={VolcSvg}></Image>
      </View>
      <View className="operator-desc">欢迎语(自定义消息)</View>
    </View>
  );
};

export default Operator;
