//
//  WkWebviewController.swift
//  haptik_sdk
//
//  Created by Arun Singh on 19/05/22.
//

import UIKit
import WebKit

class WkWebviewController: UIViewController, WKUIDelegate {
 
    // MARK: - Lifecycle Methods
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavItem()
        if let myURL = URL(string: url) {
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        }
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
 
    // MARK: - Actions
  
    @objc func backAction() {
        print("backAction")
        self.dismiss(animated: true, completion: nil)
    }
 
    // MARK: - Properties
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
 
 
}
 
extension WkWebviewController {
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            webView.rightAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
 
    func setupNavItem() {
        let backBarItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = backBarItem
    }
 
    func setupNavBar() {
        self.navigationController?.navigationBar
            .barTintColor = .systemBlue
        self.navigationController?.navigationBar
            .tintColor = .white
    }
}
