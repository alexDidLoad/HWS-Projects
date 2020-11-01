//
//  ViewController.swift
//  Project4
//
//  Created by Alexander Ha on 9/21/20.
//  Copyright © 2020 Alexander Ha. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var selectedWebsites: String!
//    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        //url request
        let url = URL(string: "https://" + selectedWebsites)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        //nav bar bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        //setting up progressView
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        //setting up the spacer for the toolbar and having a refresh button
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "BACK", style: .done, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "FORWARD", style: .done, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [back, progressButton, spacer, refresh, forward]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page", message: nil, preferredStyle: .actionSheet)
        
        for website in selectedWebsites {
            ac.addAction(UIAlertAction(title: "\(website)", style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView?.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var allowed = true
        let url = navigationAction.request.url
        if let host = url?.host {
            for website in selectedWebsites {
                if host.contains(website) {
                    allowed = true
                    decisionHandler(.allow)
                    return
                } else {
                    allowed = false
                }
            }
        }
        decisionHandler(.cancel)
        if allowed == false {
            let ac = UIAlertController(title: "Blocked", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
}



