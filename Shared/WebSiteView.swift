//
//  WebSiteView.swift
//  Scrumdinger (iOS)
//
//  Created by ozgur.atak on 21.03.2023.
//

import SwiftUI
import WebKit

struct WebSiteView: UIViewRepresentable {
    
    var url: URL
    @State private var webView: WKWebView?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let webView = webView else {
            let request = URLRequest(url: url)
            uiView.load(request)
            self.webView = uiView
            return
        }
        
        if webView != uiView {
            uiView.load(URLRequest(url: url))
            self.webView = uiView
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject {
        var parent: WebSiteView
        
        init(_ parent: WebSiteView) {
            self.parent = parent
            super.init()
        }
        
        deinit {
            self.parent.webView?.stopLoading()
            self.parent.webView?.configuration.userContentController.removeScriptMessageHandler(forName: "callbackHandler")
        }
        
        func close() {
            self.parent.webView?.stopLoading()
            self.parent.webView?.removeFromSuperview()
        }
    }
    
    func close() {
        self.makeCoordinator().close()
    }
}
