package com.test.lgsubscribenative.webview;

import com.getcapacitor.Logger;

public class CustomWebView {

    public String echo(String value) {
        Logger.info("Echo", value);
        return value;
    }
}
