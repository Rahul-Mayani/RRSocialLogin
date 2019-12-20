# RRSocialLogin
Social (FB and Google) login by RxSwift


## Requirements

pod 'RxCocoa'

pod 'RxSwift'

pod 'FBSDKLoginKit'

pod 'GoogleSignIn'


## Installation

#### Manually
1. Download and drop ```RRFBLogin.swift, RRGoogleLogin.swift & SocialStruct.swift``` in your project.  
2. Congratulations!  

## Usage example
To run the example project, clone the repo, and run pod install from the Example directory first.


```swift

//Facebook button

fbButton.rx.tap.bind{ [weak self] _ in
    guard let strongSelf = self else {return}
    RRFBLogin.shared.fbLogin(viewController: strongSelf)
}.disposed(by: rxbag)

//Google Button

googleButton.rx.tap.bind{ [weak self] _ in
    guard let strongSelf = self else {return}
    RRGoogleLogin.shared.googleSignIn(viewController: strongSelf)
}.disposed(by: rxbag)

//Rx Observe:

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
    print(user.type) // Google or Facebook user
    print(user.name)
    print(user.email)
}

```

## Contribute

We would love you for the contribution to **RRSocialLogin**, check the ``LICENSE`` file for more info.


## License

RRSocialLogin is available under the MIT license. See the LICENSE file for more info.


