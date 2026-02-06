import UIKit
import WebKit

final class CustomWebViewController: UIViewController, UIGestureRecognizerDelegate {

    private let url: URL
    private let webView = WKWebView()

    init(url: URL) {
        self.url = url
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
        setupGesture()
        load()
    }

    private func setupHeader() {
        let header = UIView()
        header.backgroundColor = .white
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)

        let close = UIButton(type: .system)
        close.setTitle("X", for: .normal)
        close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        close.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(close)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 48),

            close.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            close.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
    }

    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupGesture() {
        let edge = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(handleEdgeSwipe)
        )
        edge.edges = .left
        edge.delegate = self
        view.addGestureRecognizer(edge)
    }

    private func load() {
        webView.load(URLRequest(url: url))
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    // 👉 여기 핵심
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 웹뷰 히스토리가 없을 때만 제스처 시작
        return webView.canGoBack == false
    }

    @objc private func handleEdgeSwipe(_ g: UIScreenEdgePanGestureRecognizer) {
        if g.state == .ended {
            if webView.canGoBack {
                webView.goBack()
            } else {
                dismiss(animated: true)
            }
        }
    }
}
