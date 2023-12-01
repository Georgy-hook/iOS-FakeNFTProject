//  WebViewerController.swift
//  FakeNFT
//  Created by Adam West on 03.11.2023.

import Foundation

import UIKit
import WebKit

final class WebViewerController: UIViewController {
    // MARK: Private properties
    private let webView: WKWebView
    private let activity: UIActivityIndicatorView

    // MARK: Initialisation
    init() {
        self.webView = WKWebView()
        self.activity = UIActivityIndicatorView(style: .medium)
        super.init(nibName: nil, bundle: nil)
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActivityIndicator()
    }
    
    // MARK: Selectors
    @objc func didTapDone() {
        dismiss(animated: true)
    }
    
    // MARK: Methods
    func loadRequest(with urlString: String) {
        guard let url = URL(string: urlString) else {
            dismiss(animated: true)
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    private func setupActivityIndicator() {
        webView.addSubview(activity)
        activity.center = self.view.center
        activity.hidesWhenStopped = true
    }
    
    private func showActivityIndicator(show: Bool) {
        show ? activity.startAnimating():
        activity.stopAnimating()
    }
}


// MARK: - WKNavigationDelegate & WKUIDelegate
extension WebViewerController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
}

// MARK: - Setup views, constraints
private extension WebViewerController {
    func setupUI() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        view.addSubviews(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
