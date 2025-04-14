export const isBotConversion = (conversionId: string) => {
  const result = /^\d:1:(999880|999881):.+$|^\d:1:.+:(999880|999881)$/.test(conversionId);
  return result;
};

export const isSpecialBotConversion = (conversionId: string) => {
  // 特殊机器人会话 999880
  const result = /^\d:1:999880:.+$|^\d:1:.+:999880$/.test(conversionId);
  return result;
};
