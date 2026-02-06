import { registerPlugin } from '@capacitor/core';

import type { CustomWebViewPlugin } from './definitions';

const CustomWebView = registerPlugin<CustomWebViewPlugin>('CustomWebView', {
  web: () => import('./web').then((m) => new m.CustomWebViewWeb()),
});

export * from './definitions';
export { CustomWebView };
