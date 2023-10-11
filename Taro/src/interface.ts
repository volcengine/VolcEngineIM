export interface User {
  id: string;
  name: string;
}

export interface UserInfo extends User {
  isLogin?: boolean;
}
