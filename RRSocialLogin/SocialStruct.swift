//
//  SocialStruct.swift
//  RRSocialLogin
//
//  Created by Rahul Mayani on 20/12/19.
//  Copyright © 2019 RR. All rights reserved.
//

import Foundation

public struct SocialUserDetails {
    var userId: String = ""
    var type: SocialLoginType = .google
    var name: String = ""
    var email: String = ""
    var profilePic: String = ""
}

enum SocialLoginType: String {
    case google = "google"
    case facebook = "facebook"
}
