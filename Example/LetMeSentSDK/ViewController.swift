//
//  ViewController.swift
//  LetMeSentSDK
//
//  Created by shozab14 on 06/06/2020.
//  Copyright (c) 2020 shozab14. All rights reserved.
//

import UIKit
import LetMeSentSDK
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        LetMeSentSdkController.shared.delegate = self
        LetMeSentSdkController.shared.clientID = "TrH51u26rtvXOPJPsYOfNV5TMdUZqY"
        LetMeSentSdkController.shared.clientSecret = "KqGwBKtiEVyQfWyJv59HYF1EqdM13pkM0yyNKcgSAcOWTw4C4ipI25NsXkGWfZrq20ZJDdOanH693tRbtC0g5khZIpwokno0IBEj"
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func paymentAction(_ sender: Any) {
        LetMeSentSdkController.shared.setupWithdrawInfo(payer: "letmesent", amount: 100, currency: "USD", successUrl: "http://localhost/ecommerce/example-success", cancelUrl: "http://localhost/ecommerce/public/")
         LetMeSentSdkController.shared.presentPayment()
    }
    
}

