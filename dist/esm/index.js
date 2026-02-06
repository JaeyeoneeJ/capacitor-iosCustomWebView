import { registerPlugin } from '@capacitor/core';
const CustomWebView = registerPlugin('CustomWebView', {
    web: () => import('./web').then((m) => new m.CustomWebViewWeb()),
});
export * from './definitions';
export { CustomWebView };
//# sourceMappingURL=index.js.map