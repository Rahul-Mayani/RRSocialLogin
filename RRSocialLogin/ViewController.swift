//
//  ViewController.swift
//  SocialLogin
//
//  Created by Rahul Mayani on 20/12/19.
//  Copyright © 2019 RR. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    // MARK: - IBOutlet -
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!

    // MARK: - Variable -
    let rxbag = DisposeBag()
    
    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        googleLogin()
        facebookLogin()
        
        fbButton.rx.tap.bind{ [weak self] _ in
            guard let strongSelf = self else {return}
            RRFBLogin.shared.fbLogin(viewController: strongSelf)
        }.disposed(by: rxbag)
        
        googleButton.rx.tap.bind{ [weak self] _ in
            guard let strongSelf = self else {return}
            RRGoogleLogin.shared.googleSignIn(viewController: strongSelf)
        }.disposed(by: rxbag)
    }
}

// MARK: - Social Login -
extension ViewController{
    
    private func googleLogin() {
        RRGoogleLogin.shared.googleUserDetails.asObservable()
        .subscribe(onNext: { [weak self] (userDetails) in
            guard let strongSelf = self else {return}
            strongSelf.socialLogin(user: userDetails)
        }, onError: { [weak self] (error) in
            guard let strongSelf = self else {return}
            strongSelf.showAlert(title: nil, message: error.localizedDescription)
        }).disposed(by: rxbag)
    }
    
    private func facebookLogin() {
        RRFBLogin.shared.fbUserDetails.asObservable()
        .subscribe(onNext: { [weak self] (userDetails) in
            guard let strongSelf = self else {return}
            strongSelf.socialLogin(user: userDetails)
        }, onError: { [weak self] (error) in
            guard let strongSelf = self else {return}
            strongSelf.showAlert(title: nil, message: error.localizedDescription)
        }).disposed(by: rxbag)
    }
    
    fileprivate func socialLogin(user :SocialUserDetails) {
        //print(user.type)
        print(user.name)
        print(user.email)
    }
    
    func showAlert(title : String?, message : String?, handler: ((UIAlertController) -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            handler?(alertController)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
