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
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func paymentAction(_ sender: Any) {
         LetMeSentSdkController.shared.presentPayment()
    }
    
}

