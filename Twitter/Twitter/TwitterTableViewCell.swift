//
//  TwitterTableViewCell.swift
//  Twitter
//
//  Created by Chao Jiang on 2/23/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TwitterTableViewCell: UITableViewCell {
    
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
//        lb.text = "Chao Jiang"
        return lb
    }()
    
    let twitterContentTextview:UITextView = {
        let tv = UITextView()
        tv.textAlignment = .left
        tv.font = .systemFont(ofSize: 18)
        tv.textColor = .black
        tv.isUserInteractionEnabled = false
        tv.isScrollEnabled = false
//        tv.text = "Chao Jiang is a good person! Good luck bro!!!"
        return tv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurateCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - userImageView, userNameLable, userTwitterContent layout configuration
extension TwitterTableViewCell {
    
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
            twitterContentTextview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    func configurateCellLayout() {
        userImageViewConfiguration()
        userNameLableConfiguration()
        twitterContentTextViewConfiguration()
    }
    
}
