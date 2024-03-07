

import UIKit
import WebKit
import UserNotifications
import AppTrackingTransparency
import AdSupport
import AppsFlyerLib
import StoreKit

class WebVC: UIViewController,  WKNavigationDelegate, WKUIDelegate {

    var webView: WKWebView!
    
    var request: URLRequest!
    var onReceiveURL: (URL) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ініціалізація WKWebView з конфігурацією
        webView = WKWebView(frame: .zero, configuration: self.configureWebView())
        
        // Додаємо WKWebView на представлення та налаштовуємо констрейнти
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = true
        webView.uiDelegate = self
        
        // Додаємо жести назад і вперед
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        swipeRight.direction = .right
        webView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goForward))
        swipeLeft.direction = .left
        webView.addGestureRecognizer(swipeLeft)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webView.load(self.request)
    }
    
    func configureWebView() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        
        // Встановлюємо користувацький user-agent
        configuration.applicationNameForUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
        
        return configuration
    }
    
    // Функція для переходу назад
    @objc func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    // Функція для переходу вперед
    @objc func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
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
