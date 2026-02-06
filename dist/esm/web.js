import { WebPlugin } from '@capacitor/core';
export class CustomWebViewWeb extends WebPlugin {
    async open(options) {
        console.warn('[CustomWebView] open() is not supported on web', options);
    }
    async close() {
        console.warn('[CustomWebView] close() is not supported on web');
    }
}
//# sourceMappingURL=web.js.map