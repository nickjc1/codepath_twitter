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

    let tweetCharCountLable:UILabel = {
        let lb = UILabel()
        lb.isEnabled = false
        lb.font = .boldSystemFont(ofSize: 20)
        lb.textColor = .systemGray
        lb.text = "0"
        return lb
    }()
    
//MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        tweetTextView.delegate = self
//        self.navigationItem.title = "Tweet"
//        self.navigationItem.setHidesBackButton(true, animated: false)
        
        setupNavigationBarRightBarButton()
        setupTweetTextViewCfonfiguration()
        setupTweetCharCountConfiguration()
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


//MARK: - Setup layout
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
    
    func setupTweetCharCountConfiguration() {
        self.view.addSubview(tweetCharCountLable)
        tweetCharCountLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tweetCharCountLable.topAnchor.constraint(equalTo: self.tweetTextView.bottomAnchor, constant: 5),
            tweetCharCountLable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tweetCharCountLable.heightAnchor.constraint(equalToConstant: 25),
            tweetCharCountLable.widthAnchor.constraint(equalTo: self.tweetCharCountLable.heightAnchor, multiplier: 2)
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

extension TweetPostViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""
        self.tweetCharCountLable.text = String(currentText.count + 1)

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 16 characters
        return updatedText.count <= 279
    }
}
