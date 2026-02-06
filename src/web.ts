import { WebPlugin } from '@capacitor/core';
import type { CustomWebViewPlugin } from './definitions';

export class CustomWebViewWeb extends WebPlugin implements CustomWebViewPlugin {
  async open(options: { url: string }): Promise<void> {
    console.warn('[CustomWebView] open() is not supported on web', options);
  }

  async close(): Promise<void> {
    console.warn('[CustomWebView] close() is not supported on web');
  }
}
