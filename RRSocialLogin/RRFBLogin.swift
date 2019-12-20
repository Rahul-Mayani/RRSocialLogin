//
//  RRFBLogin.swift
//  RRSocialLogin
//
//  Created by Rahul Mayani on 20/12/19.
//  Copyright © 2019 RR. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import RxSwift

class RRFBLogin {
    
    // MARK: - Variable -
    static let shared = RRFBLogin()
    
    open var fbUserDetails: PublishSubject<SocialUserDetails> = PublishSubject()
    
    // MARK: - Others -
    func fbLogin(viewController: UIViewController) {
        LoginManager().logIn(permissions: ["public_profile", "email"], from: viewController) { [weak self] (result, error) in
            guard let strongSelf = self else {return}
            if let error = error {
                strongSelf.fbUserDetails.onError(error)
            } else if result?.isCancelled ?? false {
                // User Cancelled
            } else {
                if let _ = AccessToken.current {
                    strongSelf.getProfileFromFB()
                }
            }
        }
    }

    private func getProfileFromFB() {
        //AppLoader.startLoaderToAnimating()
        GraphRequest.init(graphPath: "me", parameters: ["fields":"id, name, email, picture.width(200).height(200)"])
          .start { [weak self] (connection, result, error) in
                //AppLoader.stopLoaderToAnimating()
                guard let strongSelf = self else {return}
                if let error = error {
                    strongSelf.fbUserDetails.onError(error)
                } else {
                    guard let user = result as? [String: Any] else { return }
                    let name = (user["name"] as? String) ?? ""
                    let email = (user["email"] as? String) ?? ""
                    let userId = (user["id"] as? String) ?? ""
                    //strongSelf.getProfileFromFB(email: (user["email"] as? String) ?? "")
                    var imageURL: String = ""
                    if let profilePictureObj = user["picture"] as? [String: Any],
                        let data = profilePictureObj["data"] as? [String: Any],
                        let pictureUrlString  = data["url"] as? String,
                        let pictureUrl = NSURL(string: pictureUrlString) {
                        imageURL = pictureUrl.absoluteString ?? ""
                    }
                    let userSocial = SocialUserDetails.init(userId: userId, type: .facebook, name: name, email: email, profilePic: imageURL)
                    strongSelf.fbUserDetails.onNext(userSocial)
                }
           }
    }
    /*
    private func getProfileFromFB(email: String = "") {
        
        Profile.loadCurrentProfile { [weak self] (profile, error) in
            AppLoader.stopLoaderToAnimating()
            guard let strongSelf = self else {return}
            if let error = error {
                strongSelf.fbUserDetails.onError(error)
            } else {
                var imageURL: String = ""
                if let profilePic = profile?.imageURL(forMode: .square, size: CGSize(width: 200, height: 200)) {
                    imageURL = profilePic.absoluteString
                }
                let user = SocialUserDetails.init(userId: profile?.userID ?? "", token: AccessToken.current?.tokenString ?? "", name: profile?.name ?? "", email: email, profilePic: imageURL)
                strongSelf.fbUserDetails.onNext(user)
            }
        }
    }
    */
    static func fbLogOut() {
        LoginManager().logOut()
    }
}
