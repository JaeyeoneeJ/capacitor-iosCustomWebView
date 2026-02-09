import UIKit
import WebKit

final class CustomWebViewController: UIViewController, WKNavigationDelegate {

    private let url: URL
    private let closeButtonText: String?
    private let closeWarningText: String
    private let webView = WKWebView()
    private var backButton: UIButton!
    private let toolbarPosition: ToolbarPosition
    private let toolbarHeight: CGFloat = 48

    // gradient view
    private let gradientView = UIView()

    init(url: URL, closeButtonText: String? = nil, closeWarningText: String? = nil, toolbarPosition: ToolbarPosition = .top) {
        self.url = url
        self.closeButtonText = closeButtonText
        self.closeWarningText = closeWarningText ?? "Tap again to close the WebView."
        self.toolbarPosition = toolbarPosition
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
        setupGradient()
        load()
    }

    // MARK: - Header

    private let header = UIView()

    private func setupHeader() {
        header.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)

        let back = UIButton(type: .system)
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        back.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(back)
        self.backButton = back

        let close = UIButton(type: .system)
        if let text = closeButtonText, !text.isEmpty {
            close.setTitle(text, for: .normal)
        } else {
            close.setImage(UIImage(systemName: "xmark"), for: .normal)
        }
        close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        close.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(close)

        NSLayoutConstraint.activate([
            back.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 8),
            back.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),

            close.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -8),
            close.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            close.widthAnchor.constraint(equalToConstant: 44),
            close.heightAnchor.constraint(equalToConstant: 44)
        ])

        if toolbarPosition == .top {
            NSLayoutConstraint.activate([
                header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                header.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
            ])
        }

        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: toolbarHeight)
        ])
    }

    // MARK: - WebView

    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        view.addSubview(webView)

        if toolbarPosition == .top {
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: header.bottomAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: view.topAnchor),
                webView.bottomAnchor.constraint(equalTo: header.topAnchor)
            ])
        }

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Gradient Shadow
    private func setupGradient() {
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientView)

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.05).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.cornerRadius = 0

        let gradientHeight: CGFloat = 6

        if toolbarPosition == .top {
            gradientView.layer.addSublayer(gradientLayer)
            NSLayoutConstraint.activate([
                gradientView.topAnchor.constraint(equalTo: header.bottomAnchor),
                gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                gradientView.heightAnchor.constraint(equalToConstant: gradientHeight)
            ])
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        } else {
            gradientView.layer.addSublayer(gradientLayer)
            NSLayoutConstraint.activate([
                gradientView.bottomAnchor.constraint(equalTo: header.topAnchor),
                gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                gradientView.heightAnchor.constraint(equalToConstant: gradientHeight)
            ])
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        }

        gradientView.layoutIfNeeded()
        gradientLayer.frame = gradientView.bounds
    }

    // MARK: - Load URL
    private func load() {
        webView.load(URLRequest(url: url))
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    // MARK: - Toast
    private var toastView: UIView?
    private var lastBackPressedAt: Date?

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
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
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

    // MARK: - Back button
    @objc private func backTapped() {
        if webView.canGoBack {
            webView.goBack()
            return
        }

        let now = Date()
        if let last = lastBackPressedAt, now.timeIntervalSince(last) < 2 {
            dismiss(animated: true)
        } else {
            lastBackPressedAt = now
            showToast(closeWarningText)
        }
    }
}
