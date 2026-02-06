export interface CustomWebViewPlugin {
  open(options: { url: string }): Promise<void>;

  close(): Promise<void>;
}
