//
//  LoginViewController.swift
//  Twitter
//
//  Created by Chao Jiang on 2/21/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let logo:UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "TwitterLogoBlue")
        logo.contentMode = .scaleAspectFill
        return logo
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        button.backgroundColor = UIColor.twitterBlue()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitle("  Login  ", for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(logo)
        logoConfiguration()
        self.view.addSubview(loginButton)
        loginButtonConfiguration()
    
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(UserLoggedInStatus.isLogginedIn) {
            pushToTwitterHomeViewController()
        }
    }
}


//MARK: - Autolayout for logo and button, Loginbutton functionality
extension LoginViewController {
    func logoConfiguration() {
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            logo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 150),
            logo.heightAnchor.constraint(equalTo: logo.widthAnchor)
        ])
    }
    
    func loginButtonConfiguration() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50),
            loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        TwitterAPICaller.client?.login(url: "https://api.twitter.com/oauth/request_token", success: {
            self.pushToTwitterHomeViewController()
            UserLoggedInStatus.isLogginedIn = true
        }, failure: { error in
            print("Could not log in with error: \(error)")
        })
    }
    
    func pushToTwitterHomeViewController() {
        let twitter = TwitterHomeViewController()
        let nc = UINavigationController(rootViewController: twitter)
        nc.modalPresentationStyle = .fullScreen
//        nc.navigationBar.prefersLargeTitles = true
        self.present(nc, animated: true, completion: nil)
    }
}


//MARK: - twitterBlue() to return twitter's blue UIColor
extension UIColor {
    static func twitterBlue() -> UIColor {
        return UIColor(red: 77.0/255, green: 159.0/255, blue: 235.0/255, alpha: 1)
    }
}
