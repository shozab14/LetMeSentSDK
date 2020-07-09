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
    private var withdrawInfo:WithdrawInfo?{
        didSet{
            
            transactionParams.updateValue(withdrawInfo?.payer ?? "", forKey: "payer")
            transactionParams.updateValue(withdrawInfo?.amount?.description ?? "" , forKey: "amount")
            transactionParams.updateValue(withdrawInfo?.currency ?? "", forKey: "currency")
            transactionParams.updateValue(withdrawInfo?.successUrl ?? "", forKey: "successUrl")
            transactionParams.updateValue(withdrawInfo?.cancelUrl ?? "", forKey: "cancelUrl")
        }
    }
    private var headers :Dictionary<String,Any> = [:]
    private var transactionParams :Dictionary<String,Any> = [:]
    
    
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
    
    
}





//MARK:-  LetMeSentSdkController Extention
extension LetMeSentSdkController{
    
    private func loginApiCall(completion: @escaping ((_ response:SDKLoginResponse?,_ error:String?) -> Void)){
        guard let url = URL(string: "https://letmesent.com/api/login") else {
            print("Invalid URL")
            return
        }
        let parameters = [
            
            "email":"abdur.techvill@gmail.com",
            "password" : "123456"
            ] as [String : Any]
        
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpMethod = "POST"
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(SDKLoginBase.self, from: data) {
                    // we have good data – go back to the main thread
                    //                    DispatchQueue.main.async {
                    //
                    //                        // update our UI
                    //                       // self.results = decodedResponse.results
                    //                    }
                    if let token =  decodedResponse.response?.token {
                        self.headers.updateValue(token, forKey: "Authorization-Token")
                        self.verification { (response, error) in
                            
                        }
                        //  completion(decodedResponse.response,nil)
                        
                    }else{
                        completion(nil,decodedResponse.response?.message)
                    }
                    
                    print("response: \(decodedResponse.response)")
                    // everything is good, so we can exit
                    return
                }
            }
            
            // if we're still here it means there was a problem
            completion(nil,error?.localizedDescription)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    private func verification(completion: @escaping ((_ response:VerifyBase?,_ error:String?) -> Void)){
        guard let url = URL(string: "https://letmesent.com/merchant/api/verify") else {
            print("Invalid URL")
            return
        }
        
        guard let clientID = self.clientID,let clientSecret = self.clientSecret else{
            controllerAlert(msg: "Please provide client secret & client id")
            return
        }
        let parameters = [
            
            "client_id":clientID,
            "client_secret" : clientSecret
            ] as [String : Any]
        
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpMethod = "POST"
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(VerifyBase.self, from: data) {
                    // we have good data – go back to the main thread
                    //                    DispatchQueue.main.async {
                    //
                    //                        // update our UI
                    //                       // self.results = decodedResponse.results
                    //                    }
                    if let accessToken =  decodedResponse.data?.access_token{
                        self.headers.updateValue("Bearer" + " " + accessToken, forKey: "Authorization")
                        
                        print("api verification \(accessToken)")
                        
                        self.transactionInfo { (response, error) in
                            
                        }
                        // completion(decodedResponse,nil)
                        
                    }else{
                        completion(nil,decodedResponse.message)
                    }
                    return
                }
            }
            
            // if we're still here it means there was a problem
            completion(nil,error?.localizedDescription)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    private func transactionInfo(completion: @escaping ((_ response:TransactionInfoBase?,_ error:String?) -> Void)){
        guard let url = URL(string: "https://letmesent.com/merchant/api/transaction-info") else {
            print("Invalid URL")
            return
        }
        
        
        let parameters = transactionParams
        
        var request = URLRequest(url: url)
        print("api trans param \(parameters)")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.allHTTPHeaderFields =  headers as? [String : String]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpMethod = "POST"
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(TransactionInfoBase.self, from: data) {
                    // we have good data – go back to the main thread
                    //                    DispatchQueue.main.async {
                    //
                    //                        // update our UI
                    //                       // self.results = decodedResponse.results
                    //                    }
                    if let approvedUrl =  decodedResponse.data?.approvedUrl{
                        print("api transc \(approvedUrl)")
                        if let startIndex  = approvedUrl.range(of: "grant_id=")?.upperBound , let endIndex = approvedUrl.range(of: "&")?.lowerBound {
                            let grant_id = approvedUrl[startIndex..<endIndex].description
                            if let startIndex  = approvedUrl.range(of: "token=")?.upperBound{
                                let token = approvedUrl[startIndex...].description
                                print(token)
                                self.payment(grant_id: grant_id, paymentToken: token) { (response, message) in
                                    
                                }
                                
                            }
                        }
                        
                        
                        
                        
                        completion(decodedResponse,nil)
                        
                    }else{
                        completion(nil,decodedResponse.message)
                    }
                    return
                }
            }
            
            // if we're still here it means there was a problem
            completion(nil,error?.localizedDescription)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    private func payment(grant_id:String, paymentToken:String, completion: @escaping ((_ response:PaymentBase?,_ error:String?) -> Void)){
        guard let url = URL(string: "https://letmesent.com/api/merchant/payment") else {
            print("Invalid URL")
            return
        }
        
        
        let parameters = ["grant_id":grant_id,"token":paymentToken]
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.allHTTPHeaderFields =  headers as? [String : String]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpMethod = "POST"
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(PaymentBase.self, from: data) {
                    // we have good data – go back to the main thread
                    //                    DispatchQueue.main.async {
                    //
                    //                        // update our UI
                    //                       // self.results = decodedResponse.results
                    //                    }
                    if let response =  decodedResponse.success,response.status == 200{
                        self.controllerAlert(msg: "Payment Completed")
                        completion(decodedResponse,nil)
                        
                    }else{
                        self.controllerAlert(msg: "Payment error try again!")
                        completion(nil,decodedResponse.success?.message)
                    }
                    return
                }
            }
            
            // if we're still here it means there was a problem
            completion(nil,error?.localizedDescription)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    
    private func controllerAlert(msg:String){
        DispatchQueue.main.async {[weak self] in
            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self?.delegate?.present(alert, animated: true, completion: nil)
        }
        
    }
    private func isValidEmail(email:String) -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
    
    public func presentPayment(){
        guard let vc = self.delegate  else {return}
        let alert = UIAlertController(title: "Let Me Sent",
                                      message: "Insert email & password.",
                                      preferredStyle: .alert)
        
        // Login button
        let loginAction = UIAlertAction(title: "Login", style: .default, handler: { (action) -> Void in
            self.loginApiCall { (response, error) in
                if let resp = response{
                    self.controllerAlert(msg: String(describing: resp))
                    return
                }
                if let err = error{
                    self.controllerAlert(msg: err)
                    return
                }
            }
            // Get TextFields text
            //            guard let emailTxt = alert.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
            //             guard let passwordTxt = alert.textFields![1].text else {return}
            //
            //            if !self.isValidEmail(email: emailTxt) || emailTxt.count < 1{
            //                self.errorAlert(msg: "Email seems empty or invalid.")
            //            }else if passwordTxt.count < 1{
            //                self.errorAlert(msg: "Password seems empty.")
            //
            //            }else{
            //                self.loginApiCall()
            //                 print("EMAIL: \(emailTxt)\n Password: \(passwordTxt)")
            //            }
            
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        // Add 1 textField (for username)
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .emailAddress
            textField.placeholder = "Type your email"
            textField.textColor = .darkText
        }
        
        // Add 2nd textField (for password)
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.placeholder = "Type your password"
            textField.isSecureTextEntry = true
            textField.textColor = .darkText
        }
        
        // Add action buttons and present the Alert
        alert.addAction(loginAction)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
        
    }
}


