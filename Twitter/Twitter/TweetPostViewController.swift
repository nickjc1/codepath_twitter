//
//  TweetPostViewController.swift
//  Twitter
//
//  Created by Chao Jiang on 2/28/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetPostViewController: UIViewController {

    
//MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.twitterBlue()
//        self.navigationItem.title = "Tweet"
        
        
        setupNavigationBarRightBarButton()
    }

//MARK: - viewWillDisappear()
    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
}




//MARK: - Set up navtiongation bar right button
extension TweetPostViewController {
    
    @objc func postTweet(_ sender: UIBarButtonItem) {
        print("Button tapped")
    }
    
    func setupNavigationBarRightBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: .plain, target: self, action: #selector(postTweet(_:)))
    }
}
