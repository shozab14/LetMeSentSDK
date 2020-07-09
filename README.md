# LetMeSentSDK

[![CI Status](https://img.shields.io/travis/shozab14/LetMeSentSDK.svg?style=flat)](https://travis-ci.org/shozab14/LetMeSentSDK)
[![Version](https://img.shields.io/cocoapods/v/LetMeSentSDK.svg?style=flat)](https://cocoapods.org/pods/LetMeSentSDK)
[![License](https://img.shields.io/cocoapods/l/LetMeSentSDK.svg?style=flat)](https://cocoapods.org/pods/LetMeSentSDK)
[![Platform](https://img.shields.io/cocoapods/p/LetMeSentSDK.svg?style=flat)](https://cocoapods.org/pods/LetMeSentSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

import LetMeSentSDK

override func viewDidLoad() {
    super.viewDidLoad()
    LetMeSentSdkController.shared.delegate = self
    LetMeSentSdkController.shared.clientID = "ClientID "
    LetMeSentSdkController.shared.clientSecret = "ClientSecret"
   
}

@IBAction func paymentAction(_ sender: Any) {
      LetMeSentSdkController.shared.setupWithdrawInfo(payer: "letmesent", amount: 100, currency: "USD", successUrl: "http://localhost/ecommerce/example-success", cancelUrl: "http://localhost/ecommerce/public/")
       LetMeSentSdkController.shared.presentPayment()
  }
  
## Requirements
Swift Language Version = 5.0
Deployment Target = ios 11.0
## Installation

LetMeSentSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LetMeSentSDK'
```
## Author

shozab14, shozabhiader14@gmail.com

## License

LetMeSentSDK is available under the MIT license. See the LICENSE file for more info.
# LetMeSentSDK
