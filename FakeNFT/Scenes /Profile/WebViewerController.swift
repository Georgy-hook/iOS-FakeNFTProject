//  WebViewerController.swift
//  Profile
//  Created by Adam West on 03.11.2023.

import Foundation

import UIKit
import WebKit

final class WebViewerController: UIViewController {
    // MARK: Private properties
    private let webView = WKWebView()
    private let urlString: String
    
    // MARK: Initialisation
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadRequest()
    }
    
    // MARK: Selectors
    @objc func didTapDone() {
        dismiss(animated: true)
    }
    
    // MARK: Methods
    private func loadRequest() {
        guard let url = URL(string: urlString) else {
            dismiss(animated: true)
            return
        }
        webView.load(URLRequest(url: url))
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
