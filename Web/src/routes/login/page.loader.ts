import { redirect } from '@modern-js/runtime/router';
import { fetchUserId } from '../../apis/app';

export default async () => {
  const cacheUserId = await fetchUserId();

  if (cacheUserId) {
    return redirect('/');
  }

  return null;
};
