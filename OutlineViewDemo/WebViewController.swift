//
//  WebViewController.swift
//  OutlineViewDemo
//
//  Created by 褚尉卿 on 2020/2/14.
//  Copyright © 2020 cwq. All rights reserved.
//

import Cocoa
import WebKit

class WebViewController: NSViewController, WKUIDelegate, WKNavigationDelegate {
    var myWebView: WKWebView!
    
    func currentTime() -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "H:m:s"
        return dateformat.string(from: Date())
    }
    
    func log(_ msg: String) {
        print("\(currentTime()) \(msg)")
    }
    
    func webView(_ myWebView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        log("1. The web content is loaded in the WebView.")
    }
    
    func webView(_ myWebView: WKWebView, didCommit navigation: WKNavigation!) {
        log("2. The WebView begins to receive web content.")
    }
    
    func webView(_ myWebView: WKWebView, didFinish navigation: WKNavigation!) {
        log("3. The navigating to url \(myWebView.url!) finished")
    }
    
    func webViewWebContentProcessDidTerminate(_ myWebView: WKWebView) {
        log("The Web Content Process is finished")
    }
    
    func webView(_ myWebView: WKWebView, didFail navigation: WKNavigation!, withError: Error) {
        log("An error didFail occured")
    }
    
    func webView(_ myWebView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError: Error) {
        log("An error didFailProvisionalNavigation occured.")
    }
    
    func webView(_ myWebView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        log("The WebView received a server redirect")
    }
    
    // the following function handles target="_blank" links by opening them in the same view
    func webView(_ myWebView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        log("New Navigation")
        if navigationAction.targetFrame == nil {
            log("Trial to open a blank window")
            log("navigationAction : " + String(describing: navigationAction))
            let newLink = navigationAction.request
            log("The new navigationAction is : " + String(describing: navigationAction))
            log("The new URL is : " + String(describing: newLink.url!))
            openSafari(link: newLink.url!)
        }
        return nil
    }
    
    func openSafari(link: URL) {
        let checkURL = link
        if NSWorkspace.shared.open(checkURL as URL) {
            log("URL Successfully Opened in Safari")
        } else {
            log("Invalid URL in Safari")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        log("0. WebViewController View loaded")
        let configuration = WKWebViewConfiguration()
        myWebView = WKWebView(frame: .zero, configuration: configuration)
        myWebView.translatesAutoresizingMaskIntoConstraints = false
        myWebView.navigationDelegate = self
        myWebView.uiDelegate = self
        view.addSubview(myWebView)
        // topAnchor only available in version 10.11
        [myWebView.topAnchor.constraint(equalTo: view.topAnchor),
         myWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         myWebView.leftAnchor.constraint(equalTo: view.leftAnchor),
         myWebView.rightAnchor.constraint(equalTo: view.rightAnchor)].forEach {
            anchor in
            anchor.isActive = true
        }
        let myURL = URL(string: "http://www.google.com")
        let myRequest = URLRequest(url: myURL!)
        myWebView.load(myRequest)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(load(_:)),
                                               name: NSNotification.Name(rawValue: notifyKey),
                                               object: nil)
    }
    
    @objc func load(_ notification: Notification) {
        if let data = notification.userInfo as? [String: String] {
            let myURL = URL(string: data["feedItemUrl"]!)
            let myRequest = URLRequest(url: myURL!)
            myWebView.load(myRequest)
        }
    }
}
