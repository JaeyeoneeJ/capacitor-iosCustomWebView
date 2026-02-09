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

    private func load() {
        webView.load(URLRequest(url: url))
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }

    private var toastView: UIView?

    private func showToast(_ message: String) {
        toastView?.removeFromSuperview()

        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textAlignment = .center
        label.numberOfLines = 0

        let container = UIView()
        container.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        container.layer.cornerRadius = 10
        container.clipsToBounds = true
        container.alpha = 0

        label.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)
        view.addSubview(container)
        toastView = container

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),

            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            ),
            container.widthAnchor.constraint(lessThanOrEqualToConstant: 320)
        ])

        UIView.animate(withDuration: 0.25) {
            container.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            UIView.animate(withDuration: 0.25, animations: {
                container.alpha = 0
            }) { _ in
                container.removeFromSuperview()
            }
        }
    }
    
    private var lastBackPressedAt: Date?
    
    @objc private func backTapped() {
        if webView.canGoBack {
        webView.goBack()
        return
        }
        
        let now = Date()
        
        if let last = lastBackPressedAt,
           now.timeIntervalSince(last) < 2 {
            dismiss(animated: true)
        } else {
            lastBackPressedAt = now
            showToast("한 번 더 누르면 웹뷰가 종료됩니다.")
        }
    }
}
