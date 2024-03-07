

import UIKit
import WebKit
import UserNotifications
import AppTrackingTransparency
import AdSupport
import AppsFlyerLib
import StoreKit

class WebVC: UIViewController,  WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var request: URLRequest!
    var onReceiveURL: (URL) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = true
        webView.uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webView.load(self.request)
    }
}

extension WebVC {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
           if navigationAction.targetFrame == nil {
               webView.load(navigationAction.request)
           }
           return nil
       }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url {
            self.onReceiveURL(url)
        }
    }
}
