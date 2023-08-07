export function sendCode(params: { mobile: string }) {
  return Promise.resolve({});
}
export function smsLogin(params: { mobile: string; code: string }) {
  return Promise.resolve({ user_id_str: params.mobile });
}
