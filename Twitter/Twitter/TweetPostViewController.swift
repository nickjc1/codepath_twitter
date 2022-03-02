//
//  TweetPostViewController.swift
//  Twitter
//
//  Created by Chao Jiang on 2/28/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetPostViewController: UIViewController {
    
    let tweetTextView:UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .white
        tv.keyboardAppearance = .default
        tv.font = .systemFont(ofSize: 18)
        tv.becomeFirstResponder()
        return tv
    }()

    
//MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
//        self.navigationItem.title = "Tweet"
//        self.navigationItem.setHidesBackButton(true, animated: false)
        
        setupNavigationBarRightBarButton()
        setupTweetTextViewCfonfiguration()
    }
    
}




//MARK: - Set up navtiongation bar right button
extension TweetPostViewController {
    
    @objc func postTweet(_ sender: UIBarButtonItem) {
        if(!self.tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweet: tweetTextView.text, success: {
                print("succeed")
                self.navigationController?.popViewController(animated: true)
            }, failure: { error in
                print("encounter posting tweet error: \(error)")
            })
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupNavigationBarRightBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: .plain, target: self, action: #selector(postTweet(_:)))
    }
}


//MARK: - Setup tweetTextView layout
extension TweetPostViewController {
    func setupTweetTextViewCfonfiguration() {
        self.view.addSubview(tweetTextView)
        self.tweetTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tweetTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tweetTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tweetTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tweetTextView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -10)
        ])
        
    }
}

//MARK: - Add postTweet function into TwitterAPICaller class
extension TwitterAPICaller {
    func postTweet(tweet: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let url: String = "https://api.twitter.com/1.1/statuses/update.json"
        TwitterAPICaller.client?.post(url, parameters: ["status": tweet], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
}
