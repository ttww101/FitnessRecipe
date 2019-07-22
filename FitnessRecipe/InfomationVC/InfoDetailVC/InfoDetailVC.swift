//
//  InfoDetailVC.swift
//  FitnessRecipe
//
//  Created by Apple on 6/19/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import WebKit

class InfoDetailVC: UIViewController,WKUIDelegate,WKNavigationDelegate {

    var webView:WKWebView!
    var id: Int!
    
    init(_ id: Int) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://wp.asopeixun.com/?p=\(id!)");
        webView.load(URLRequest(url: url!))
        self.title = "文章"
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("webview:\(webView) decidePolicyFornavigationAction:\(navigationAction) decisionHandler:\(decisionHandler)")
        //判斷點擊觸發事件
        switch navigationAction.navigationType {
        case .linkActivated://點擊事件
            if navigationAction.targetFrame == nil{
                self.webView.load(navigationAction.request)
            }
            let url = navigationAction.request.url
            let str:String = (url?.scheme!)!
            switch str {//判斷點擊到的事件是什麼要幹嘛
            case "mailto"://信箱
                print("mail")
                let subject = "UIWebViewDome"//主旨
                let body = "這是UIWebView運用於點擊事件是發送mail時"//信件內文
                let coded = "\(navigationAction.request)?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                //開啟信箱
                //（因為openURL前方有帶入字串"mailto:"所以系統會自動判斷開啟信箱而非safari)
                if let emailURL = URL(string: coded!){
                    if UIApplication.shared.canOpenURL(emailURL){
                        UIApplication.shared.openURL(emailURL)
                    }
                }
                
                decisionHandler(.cancel)
                return
            case "tel"://電話
                //一般來講網頁端如果有做好就不用做下面的動作，做了其實是多餘的。除非網頁端只有提供一般電話號碼的字串並沒有帶tel:那樣的話就需要自己在做url並作下面的動作
                //但是！wkWebView是不管怎樣都必須要告知你要做的動作所以下面動作必須要做！
                print("tel")
                let number:String = (url?.absoluteString)!
                //因為apple一般會要求開發者在用戶做某些特定動作時必須要有提醒（例如取用相機之類的），所以在這做了一個AlertController來提醒用戶撥出通話。
                let alertController = UIAlertController(title: nil, message: "\(number.replacingOccurrences(of: "tel:", with: ""))", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: nil));
                alertController.addAction(UIAlertAction(title: "通話", style: .default, handler: { (action:UIAlertAction) in
                    if UIApplication.shared.canOpenURL(navigationAction.request.url!){
                        UIApplication.shared.openURL(navigationAction.request.url!)
                    }
                }));
                
                
                self.present(alertController, animated: true, completion: nil)
                
            default:
                break
            }
        default:
            break
        }
        
        decisionHandler(.allow)
        
    }
}
