//
//  ViewController.swift
//  Project4
//
//  Created by Eddie Jung on 8/3/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites: [String]?
    var websitesDisabled: [String]?
    var selectedURL: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let goBack = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [goBack, spacer, progressButton, spacer, refresh, spacer, goForward]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        guard let selectedURLTitle = selectedURL else { return }
        
        let url = URL(string: "https://" + selectedURLTitle)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open", message: nil, preferredStyle: .actionSheet)
        
        guard let websitesApproved = websites else { return }
        guard let websitesUnApproved = websitesDisabled else { return }
        
        for website in websitesApproved {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
    
        for websiteNotAllowed in websitesUnApproved {
            ac.addAction(UIAlertAction(title: websiteNotAllowed, style: .default, handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            guard let websitesApproved = websites else { return }
            guard let websitesUnApproved = websitesDisabled else { return }
            
            for website in websitesApproved {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
            
            for websiteNotAllowed in websitesUnApproved {
                if host.contains(websiteNotAllowed) {
                    print("Blocked: \(websiteNotAllowed)")
                    decisionHandler(.cancel)
                    blockAlert()
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
    }
    
    func blockAlert() {
        let ac = UIAlertController(title: "The requested website is blocked.", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

}

