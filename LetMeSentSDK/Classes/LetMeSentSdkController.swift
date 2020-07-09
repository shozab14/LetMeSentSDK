//
//  LetMeSentSdkController.swift
//  LetMeSentSDK
//
//  Created by Shozab Haider macbook on 6/10/20.
//

import Foundation


public class LetMeSentSdkController{
    public init(){}
    public static let shared = LetMeSentSdkController()
    public weak var delegate : UIViewController?
    public var clientID :String?
    public var clientSecret:String?
    var activityView: UIActivityIndicatorView?
    private var withdrawInfo:WithdrawInfo?{
        didSet{
            
            transactionParams.updateValue(withdrawInfo?.payer ?? "", forKey: "payer")
            transactionParams.updateValue(withdrawInfo?.amount?.description ?? "" , forKey: "amount")
            transactionParams.updateValue(withdrawInfo?.currency ?? "", forKey: "currency")
            transactionParams.updateValue(withdrawInfo?.successUrl ?? "", forKey: "successUrl")
            transactionParams.updateValue(withdrawInfo?.cancelUrl ?? "", forKey: "cancelUrl")
        }
    }
   var headers :Dictionary<String,Any> = [:]
   var transactionParams :Dictionary<String,Any> = [:]
    
    
    private struct WithdrawInfo{
        let payer :String?
        let amount :Double?
        let currency :String?
        let successUrl :String?
        let cancelUrl :String?
    }
    
    
    
    public func setupWithdrawInfo( payer :String,amount :Double,currency :String,successUrl :String,cancelUrl :String){
        self.withdrawInfo = WithdrawInfo(payer: payer,amount: amount, currency: currency, successUrl: successUrl, cancelUrl: cancelUrl)
    }
    
    func showActivityIndicator() {

        activityView = UIActivityIndicatorView(style: .whiteLarge)
        guard let center =  self.delegate?.view.center else {return}
        activityView?.center = center
        self.delegate?.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
    
    
}

