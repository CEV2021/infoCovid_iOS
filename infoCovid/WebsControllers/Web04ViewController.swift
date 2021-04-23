

import UIKit
import WebKit
class Web04ViewController: UIViewController, WKNavigationDelegate {

        
    
    var webView: WKWebView!

override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.isToolbarHidden = true
}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("ya estoy")
        let url = URL(string: "https://www.pokemongolive.com")!
        self.webView.load(URLRequest(url: url))
        
    }
    
    override func loadView() {
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.view = self.webView
        print("ahora")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = self.webView.title
    }

    @IBAction func reloadButton(_ sender: Any) {
        self.webView.reload()
    }
}
