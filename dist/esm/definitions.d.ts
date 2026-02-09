export interface CustomWebViewPlugin {
    open(options: {
        url: string;
        closeButtonText?: string;
        closeWarningText?: string;
        toolbarPosition?: 'top' | 'bottom';
    }): Promise<void>;
    close(): Promise<void>;
}
