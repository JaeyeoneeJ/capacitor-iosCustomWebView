import UIKit
import WebKit

final class CustomWebViewController: UIViewController, UIGestureRecognizerDelegate, WKNavigationDelegate {

    private let url: URL
    private let closeButtonText: String
    private let webView = WKWebView()
    private var backButton: UIButton!

    init(url: URL, closeButtonText: String? = nil) {
        self.url = url
        self.closeButtonText = closeButtonText ?? "Close"
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupHeader()
        setupWebView()
        // setupGesture()
        load()
    }

    private func setupHeader() {
        let header = UIView()
        header.backgroundColor = .white
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)

        let back = UIButton(type: .system)
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        back.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(back)
        self.backButton = back

        let close = UIButton(type: .system)
        close.setTitle(closeButtonText, for: .normal)
        close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        close.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(close)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 48),

            back.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 8),
            back.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),

            close.leadingAnchor.constraint(equalTo: back.trailingAnchor, constant: 4),
            close.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])

        updateBackButton()
    }


    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // private func setupGesture() {
    //     let edge = UIScreenEdgePanGestureRecognizer(
    //         target: self,
    //         action: #selector(handleEdgeSwipe)
    //     )
    //     edge.edges = .left
    //     edge.delegate = self
    //     view.addGestureRecognizer(edge)
    // }

    private func load() {
        webView.load(URLRequest(url: url))
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    // func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    //     // 웹뷰 히스토리가 없을 때만 제스처 시작
    //     return webView.canGoBack == false
    // }

    // @objc private func handleEdgeSwipe(_ g: UIScreenEdgePanGestureRecognizer) {
    //     if g.state == .ended {
    //         if webView.canGoBack {
    //             webView.goBack()
    //         } else {
    //             dismiss(animated: true)
    //         }
    //     }
    // }

    private func updateBackButton() {
        backButton.isEnabled = webView.canGoBack
        backButton.alpha = webView.canGoBack ? 1.0 : 0.3
    }

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateBackButton()
    }

    @objc private func backTapped() {
        guard webView.canGoBack else { return }
        webView.goBack()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.updateBackButton()
        }
    }
}
