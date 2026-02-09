import Foundation
import Capacitor

@objc(CustomWebViewPlugin)
public class CustomWebViewPlugin: CAPPlugin, CAPBridgedPlugin {

    public let identifier = "CustomWebViewPlugin"
    public let jsName = "CustomWebView"

    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "open", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "close", returnType: CAPPluginReturnNone)
    ]

    private var webVC: CustomWebViewController?

    @objc func open(_ call: CAPPluginCall) {
        let urlString = call.getString("url") ?? ""
        let closeButtonText = call.getString("closeButtonText") ?? ""
        guard let url = URL(string: urlString) else {
            call.reject("Invalid URL")
            return
        }
        

        DispatchQueue.main.async {
            let vc = CustomWebViewController(url: url, closeButtonText: closeButtonText)
            vc.modalPresentationStyle = .fullScreen
            self.bridge?.viewController?.present(vc, animated: true)
            self.webVC = vc
        }

        call.resolve()
    }

    @objc func close(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.webVC?.dismiss(animated: true)
            self.webVC = nil
        }
        call.resolve()
    }
}
