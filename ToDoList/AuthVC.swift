import Foundation
import UIKit
import WebKit

final class AuthViewController: UIViewController {
    
    // MARK: - Properties
    
    private let clientID = "0d0970774e284fa8ba9ff70b6b06479a"
    
    // MARK: - Subviews
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    lazy var skipButton: UIButton = {
        let skipButton = UIButton()
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.backgroundColor = UIColor.Editor.backSecondary
        skipButton.setTitleColor(UIColor.Editor.labelPrimary, for: .normal)
        skipButton.layer.cornerRadius = 16
        skipButton.setTitle("Без авторизации", for: .normal)
        skipButton.addTarget(self, action: #selector(skipButtonTouched), for: .touchUpInside)
        return skipButton
    }()
    
    lazy var yandexButton: UIButton = {
        let yandexButton = UIButton()
        yandexButton.translatesAutoresizingMaskIntoConstraints = false
        yandexButton.backgroundColor = UIColor.Editor.backSecondary
        yandexButton.setTitleColor(UIColor.Editor.labelPrimary, for: .normal)
        yandexButton.layer.cornerRadius = 16
        yandexButton.setTitle("Войти через Яндекс", for: .normal)
        yandexButton.addTarget(self, action: #selector(yandexButtonTouched), for: .touchUpInside)
        return yandexButton
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        view.addSubview(webView)
        view.addSubview(yandexButton)
        view.addSubview(skipButton)
        view.backgroundColor = UIColor.Editor.backPrimary
        webView.navigationDelegate = self
        setConstraints()
        //        getToken()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadToken()
    }
    
    // MARK: - Private
    
    private func getToken() {
        guard let authUrl = URL(string: "https://oauth.yandex.ru/authorize?response_type=token&client_id=" + clientID) else {
            return
        }
        let authRequest = URLRequest(url: authUrl)
        webView.load(authRequest)
    }
    
    private func setConstraints() {
        yandexButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        yandexButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -72).isActive = true
        yandexButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        yandexButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        skipButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        skipButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func makeToDoListVC(token: String = "Bearer DataOnCentaurs") -> UINavigationController {
        let toDoListVC = ToDoListViewController(token: token)
        let navVC = UINavigationController(rootViewController: toDoListVC)
        navVC.navigationBar.prefersLargeTitles = true
        let style = NSMutableParagraphStyle()
        let scale = UIScreen.main.scale
        style.firstLineHeadIndent = 30 / scale
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.paragraphStyle: style]
        navVC.modalPresentationStyle = .fullScreen
        return navVC
    }
    
    private func loadToken() {
        guard let data = KeyChainHelper.standard.read(service: "access-token", account: "yandex") else {
            return
        }
        if let accessToken = String(data: data, encoding: .utf8) {
            self.present(makeToDoListVC(token: accessToken), animated: true, completion: nil)
        }
    }
    
    @objc func skipButtonTouched() {
        self.present(makeToDoListVC(), animated: true, completion: nil)
    }
    
    @objc func yandexButtonTouched() {
        view.addSubview(webView)
        yandexButton.removeFromSuperview()
        
        webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        
        getToken()
    }
}

// MARK: - <WKNavigatoinDelegate>

extension AuthViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy
        ) -> Void) {
        guard let string = webView.url?.absoluteString.replacingOccurrences(of: "#", with: "?") else { return }
        let components = URLComponents(string: string)
        let token = components?.queryItems?.first(where: { $0.name == "access_token"})?.value
        if let token = token {
            let authToken = "OAuth " + token
            if KeyChainHelper.standard.read(service: "access-token", account: "yandex") != nil {
                self.present(makeToDoListVC(token: authToken), animated: true, completion: nil)
            } else {
                let data = Data(authToken.utf8)
                KeyChainHelper.standard.save(data, service: "access-token", account: "yandex")
                self.present(makeToDoListVC(token: authToken), animated: true, completion: nil)
            }
        }
        decisionHandler(.allow)
    }
    
}
