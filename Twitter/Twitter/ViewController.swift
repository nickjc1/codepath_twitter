//
//  ViewController.swift
//  Twitter
//
//  Created by Chao Jiang on 2/20/22.
//

import UIKit

class ViewController: UIViewController {
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(loginButton)
        loginButtonConfiguration()
        
    }

}

//MARK: Extension for loginButton configure, tap Gesture, and animation
extension ViewController {
    private func loginButtonConfiguration() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.widthAnchor.constraint(equalTo: loginButton.heightAnchor, multiplier: 2)
        ])
    }
    
    @objc private func loginButtonTapped(_ sender: UIButton) {
        buttonTappedAnimation(sender)
        let twitter = TwitterViewController()
        let nc = UINavigationController(rootViewController: twitter)
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
    }
    
    @objc private func buttonTappedAnimation(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: {_ in
            UIButton.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
                sender.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
            
        })
    }
}

