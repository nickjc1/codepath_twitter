//
//  TwitterHomeViewController.swift
//  Twitter
//
//  Created by Chao Jiang on 2/22/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit


class TwitterHomeViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
        setupNavigationBarApperance()
        setupNavigationBarLeftLogoutButton()
    
    }

}
//MARK: - logout functionality
extension TwitterHomeViewController {
    @objc func logoutTapped(_ sender: UIBarButtonItem) {
        TwitterAPICaller.client?.logout()
        UserLoggedInStatus.isLogginedIn = false
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - navigationBar and navigationBar button set up
extension TwitterHomeViewController {
    
    func setupNavigationBarLeftLogoutButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    func setupNavigationBarApperance() {
        if #available(iOS 13.0, *) {
            let standardApperance = UINavigationBarAppearance()
//            standardApperance.configureWithOpaqueBackground()
            standardApperance.backgroundColor = .twitterBlue()
            standardApperance.titleTextAttributes = [.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.standardAppearance = standardApperance
            self.navigationController?.navigationBar.scrollEdgeAppearance = standardApperance
            self.navigationController?.navigationBar.compactAppearance = standardApperance
        } else {
            // Fallback on earlier versions
            self.navigationController?.navigationBar.backgroundColor = .white
            self.navigationItem.titleView?.tintColor = .black
            self.navigationItem.leftBarButtonItem?.tintColor = .black 
        }
    }
}
