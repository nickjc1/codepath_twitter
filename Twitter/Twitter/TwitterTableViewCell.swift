//
//  TwitterTableViewCell.swift
//  Twitter
//
//  Created by Chao Jiang on 2/23/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

protocol TwitterTableViewCellDelegate {
    func refreshTweets()
}

class TwitterTableViewCell: UITableViewCell {
    
    var delegate: TwitterTableViewCellDelegate?

//MARK: - boolean variables for favoriteButton and retweetButton
    private var favorited: Bool?
    //use this compute variable to initialize the favouriteButton image when the cell appear
    var isFavourite: Bool? {
        get {
            return favorited
        }
        set {
            if(newValue!) {
                self.favouriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
            } else {
                favouriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
            }
            self.favorited = newValue
        }
    }
    
    private var retweeted: Bool?
    var isRetweeted: Bool? {
        get {
            return retweeted
        }
        set {
            retweeted = newValue
            if(newValue!) {
                self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
                retweetButton.isEnabled = false
            } else {
                self.retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
                retweetButton.isEnabled = true
            }
        }
    }
    
    var tweetId: Int = -1
    
//MARK: - Cell contents
    let userImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .twitterBlue()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let userNameLable:UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.font = .boldSystemFont(ofSize: 20)
        lb.textAlignment = .left
        lb.textColor = .black
        lb.text = "Chao Jiang"
        return lb
    }()
    
    let twitterContentTextview:UITextView = {
        let tv = UITextView()
        tv.textAlignment = .left
        tv.font = .systemFont(ofSize: 18)
        tv.textColor = .black
        tv.isUserInteractionEnabled = false
        tv.isScrollEnabled = false
        tv.text = "Chao Jiang is a good person! Good luck bro!!!"
        return tv
    }()
    
    let favouriteButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favor-icon"), for: .normal)
//        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(favouriteButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    let favouriteNumber:UILabel = {
        let lb = UILabel()
        lb.text = String(0)
        lb.textColor = .systemGray
        lb.font = .systemFont(ofSize: 15)
        return lb
    }()
    
    let retweetButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "retweet-icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(retweetButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    let retweetNumber:UILabel = {
        let lb = UILabel()
        lb.text = String(0)
        lb.textColor = .systemGray
        lb.font = .systemFont(ofSize: 15)
        return lb
    }()
//MARK: - initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //use this line to let user be able to access the content(e.g: button inside cell) inside the cell(THE MAGIC CODE!!!)
        self.contentView.isUserInteractionEnabled = true
        
        configurateCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - userImageView, userNameLable, userTwitterContent layout configuration
extension TwitterTableViewCell {
    
    func configurateCellLayout() {
        userImageViewConfiguration()
        userNameLableConfiguration()
        twitterContentTextViewConfiguration()
        
        favouriteLayoutConfiguration()
        retweetLayoutConfiguration()
    }
    
    func userImageViewConfiguration() {
        self.addSubview(userImageView)
        self.userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor),
            userImageView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    func userNameLableConfiguration() {
        self.addSubview(userNameLable)
        self.userNameLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameLable.topAnchor.constraint(equalTo: self.userImageView.topAnchor),
            userNameLable.leadingAnchor.constraint(equalTo: self.userImageView.trailingAnchor, constant: 10),
            userNameLable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            userNameLable.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func twitterContentTextViewConfiguration() {
        self.addSubview(twitterContentTextview)
        self.twitterContentTextview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            twitterContentTextview.topAnchor.constraint(equalTo: userNameLable.bottomAnchor, constant: 10),
            twitterContentTextview.leadingAnchor.constraint(equalTo: userNameLable.leadingAnchor),
            twitterContentTextview.trailingAnchor.constraint(equalTo: userNameLable.trailingAnchor),
            twitterContentTextview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50)
        ])
    }
}

//MARK: - favourite button, retweet button layout configuration
extension TwitterTableViewCell {

    func favouriteLayoutConfiguration() {
        self.addSubview(favouriteButton)
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(favouriteNumber)
        favouriteNumber.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favouriteNumber.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            favouriteNumber.heightAnchor.constraint(equalToConstant: 25),
            favouriteNumber.widthAnchor.constraint(equalTo: favouriteNumber.heightAnchor, multiplier: 1.7),
            favouriteNumber.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            favouriteButton.trailingAnchor.constraint(equalTo: favouriteNumber.leadingAnchor),
            favouriteButton.centerYAnchor.constraint(equalTo: favouriteNumber.centerYAnchor),
//            favouriteButton.bottomAnchor.constraint(equalTo: favouriteNumber.bottomAnchor),
            favouriteButton.heightAnchor.constraint(equalTo: favouriteNumber.heightAnchor),
            favouriteButton.widthAnchor.constraint(equalTo: favouriteButton.heightAnchor)
        ])
    }
    
    func retweetLayoutConfiguration() {
        self.addSubview(retweetButton)
        retweetButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(retweetNumber)
        retweetNumber.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            retweetNumber.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor),
            retweetNumber.bottomAnchor.constraint(equalTo: favouriteButton.bottomAnchor),
            retweetNumber.heightAnchor.constraint(equalTo: favouriteNumber.heightAnchor),
            retweetNumber.widthAnchor.constraint(equalTo: retweetNumber.heightAnchor, multiplier: 1.5),
            
            retweetButton.trailingAnchor.constraint(equalTo: retweetNumber.leadingAnchor),
            retweetButton.bottomAnchor.constraint(equalTo: retweetNumber.bottomAnchor),
            retweetButton.heightAnchor.constraint(equalTo: favouriteButton.heightAnchor),
            retweetButton.widthAnchor.constraint(equalTo: retweetButton.heightAnchor)
        ])
    }
}

//MARK: - Cell button functionality
extension TwitterTableViewCell{
    @objc func favouriteButtonTapped(_ sender: Any?) {
        guard let isFavor = self.favorited else {return}
        let urlStr = isFavor ? "https://api.twitter.com/1.1/favorites/destroy.json" : "https://api.twitter.com/1.1/favorites/create.json"
        TwitterAPICaller.client?.post(urlStr, parameters: ["id": self.tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            self.isFavourite = !isFavor
            self.delegate?.refreshTweets()
        }, failure: { (task, error) in
            print("post favourite failed with error: \(error)")
        })
    }
    
    @objc func retweetButtonTapped(_ sender: Any?) {
//        guard let isRetwed = self.retweeted else {return}
        let urlStr = "https://api.twitter.com/1.1/statuses/retweet/\(self.tweetId).json"
        TwitterAPICaller.client?.post(urlStr, parameters: ["id": self.tweetId], progress: nil, success: {
            (task, response)in
            self.isRetweeted = true
            self.delegate?.refreshTweets()
        }, failure: {
            (task, error) in
            print("Encounter retweet error: \(error)")
        })
    }
}


