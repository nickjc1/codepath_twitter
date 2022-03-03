//
//  TwitterHomeViewController.swift
//  Twitter
//
//  Created by Chao Jiang on 2/22/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class TwitterHomeViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numOfTweet = Int()
    
    var test:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
        //set up the navigationbar backbutton title in the next view of the navigation stack
        self.navigationItem.backButtonTitle = "Cancel"
        //set up the navigationbar all button color
        self.navigationController?.navigationBar.tintColor = .white
        
        setupNavigationBarApperance()
        setupNavigationBarLeftLogoutButton()
        setupNavgationBarRightButton()
        
        self.tableView.register(TwitterTableViewCell.self, forCellReuseIdentifier: "TwitterCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.allowsSelection = false
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        
        loadTweets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
}

//MARK: - TableView Cell functionality
extension TwitterHomeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
//        return 15
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterCell") as? TwitterTableViewCell {
            cell.delegate = self
            let tweet = tweetArray[indexPath.row]

            guard let tweetText = tweet["text"] as? String else {return cell}
            cell.twitterContentTextview.text = tweetText

            guard let user = tweet["user"] as? NSDictionary else {return cell}
            guard let name = user["name"] as? String else {return cell}
            cell.userNameLable.text = name

            guard let imageUrlStr = user["profile_image_url_https"] as? String else {return cell}
            if let url = URL.init(string: imageUrlStr) {
                cell.userImageView.af_setImage(withURL: url)
            }
            
            guard let tweetId = tweet["id"] as? Int else {return cell}
            cell.tweetId = tweetId
            
            guard let favorited = tweet["favorited"] as? Bool else {return cell}
            cell.isFavourite = favorited
            guard let favoritedCount = tweet["favorite_count"] as? Int else {return cell}
            cell.favouriteNumber.text = String(favoritedCount)
            
            guard let retweeted = tweet["retweeted"] as? Bool else {return cell}
            cell.isRetweeted = retweeted
            guard let retweetedCount = tweet["retweet_count"] as? Int else {return cell}
            cell.retweetNumber.text = String(retweetedCount)
            
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row + 1 == self.numOfTweet) {
            loadMoreTweets()
        }
    }
}

//MARK: - Fetch twitter data
extension TwitterHomeViewController {
    @objc func loadTweets() {
        self.numOfTweet = 15
        fetchData()
    }
    
    func loadMoreTweets() {
        self.numOfTweet += 10
        fetchData()
    }
    
    func fetchData() {
        let getTwitterTimeURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let parameters = ["count": numOfTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: getTwitterTimeURL, parameters: parameters, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
}

//MARK: - NavigationBarButton Functionality
extension TwitterHomeViewController {
    @objc func logoutTapped(_ sender: UIBarButtonItem) {
        TwitterAPICaller.client?.logout()
        UserLoggedInStatus.isLogginedIn = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tweetTapped(_ sender: UIBarButtonItem) {
        let tweetPostViewController = TweetPostViewController()
        self.navigationController?.pushViewController(tweetPostViewController, animated: true)
    }
}

//MARK: - navigationBar and navigationBar button set up
extension TwitterHomeViewController {
    
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
            self.navigationController?.navigationBar.tintColor = .black
        }
    }
    
    func setupNavigationBarLeftLogoutButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped(_:)))
//        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    func setupNavgationBarRightButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: .plain, target: self, action: #selector(tweetTapped(_:)))
//        self.navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
}

extension TwitterHomeViewController: TwitterTableViewCellDelegate {
    func refreshTweets() {
        fetchData()
    }
}

