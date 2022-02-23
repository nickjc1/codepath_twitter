//
//  UserLoginStatus.swift
//  Twitter
//
//  Created by Chao Jiang on 2/23/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

struct UserLoggedInStatus {
    static var isLogginedIn:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "loginStatus")
        }
        get {
            UserDefaults.standard.bool(forKey: "loginStatus")
        }
    }
}
