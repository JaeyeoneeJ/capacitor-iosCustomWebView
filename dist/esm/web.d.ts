import { WebPlugin } from '@capacitor/core';
import type { CustomWebViewPlugin } from './definitions';
export declare class CustomWebViewWeb extends WebPlugin implements CustomWebViewPlugin {
    open(options: {
        url: string;
    }): Promise<void>;
    close(): Promise<void>;
}
