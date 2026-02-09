export interface CustomWebViewPlugin {
  open(options: { url: string, closeButtonText?: string }): Promise<void>;

  close(): Promise<void>;
}
