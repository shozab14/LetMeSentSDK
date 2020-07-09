//
//  LetMeSentSdkControllerExt.swift
//  LetMeSentSDK
//
//  Created by Shozab Haider macbook on 7/9/20.
//

import Foundation

//MARK:-  LetMeSentSdkController Extention
extension LetMeSentSdkController{
    
    
    //MARK:-  loginApiCall
    private func loginApiCall(email:String,password:String,completion: @escaping ((_ response:SDKLoginResponse?,_ error:String?) -> Void)){
        guard let url = URL(string: "https://letmesent.com/api/login") else {
            print("Invalid URL")
            return
        }
    
        let parameters = [
            
            "email":email,
            "password" :password
            ] as [String : Any]
        
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpMethod = "POST"
        request.httpBody = httpBody
        self.showActivityIndicator()
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(SDKLoginBase.self, from: data) {
                    
                    if let token =  decodedResponse.response?.token {
                        self.headers.updateValue(token, forKey: "Authorization-Token")
                        self.verification { (response, error) in
                            
                        }
                        completion(decodedResponse.response,nil)
                        
                    }else{
                        DispatchQueue.main.async {
                          self.hideActivityIndicator()
                        }
                        completion(nil,decodedResponse.response?.message)
                    }
                    
                    return
                }
            }
            DispatchQueue.main.async {
              self.hideActivityIndicator()
            }
            completion(nil,error?.localizedDescription)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
     //MARK:- verification
    
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
                    
                    if let accessToken =  decodedResponse.data?.access_token{
                        self.headers.updateValue("Bearer" + " " + accessToken, forKey: "Authorization")
                        
                        self.transactionInfo { (response, error) in
                            
                        }
                        completion(decodedResponse,nil)
                        
                    }else{
                        DispatchQueue.main.async {
                          self.hideActivityIndicator()
                        }
                        completion(nil,decodedResponse.message)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
              self.hideActivityIndicator()
            }
            completion(nil,error?.localizedDescription)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
     //MARK:- transactionInfo
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
                    
                    if let approvedUrl =  decodedResponse.data?.approvedUrl{
                        
                        if let startIndex  = approvedUrl.range(of: "grant_id=")?.upperBound , let endIndex = approvedUrl.range(of: "&")?.lowerBound {
                            let grant_id = approvedUrl[startIndex..<endIndex].description
                            if let startIndex  = approvedUrl.range(of: "token=")?.upperBound{
                                let token = approvedUrl[startIndex...].description
                                print(token)
                                self.payment(grant_id: grant_id, paymentToken: token) { (response, message) in
                                    DispatchQueue.main.async {
                                      self.hideActivityIndicator()
                                    }
                                }
                                
                            }
                        }
                        completion(decodedResponse,nil)
                        
                    }else{
                        DispatchQueue.main.async {
                          self.hideActivityIndicator()
                        }
                        completion(nil,decodedResponse.message)
                    }
                    return
                }
            }
            DispatchQueue.main.async {
              self.hideActivityIndicator()
            }
            completion(nil,error?.localizedDescription)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
     //MARK:- payment
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
                    
               
                    if let response =  decodedResponse.success,response.message == "Success"{
                        self.controllerAlert(msg: "Payment Completed")
                        completion(decodedResponse,nil)
                        
                    }else{
                        DispatchQueue.main.async {
                          self.hideActivityIndicator()
                        }
                        self.controllerAlert(msg: decodedResponse.success?.message ?? "")
                        completion(nil,decodedResponse.success?.message)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
              self.hideActivityIndicator()
            }
            completion(nil,error?.localizedDescription)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    
    private func controllerAlert(msg:String){
        DispatchQueue.main.async {[weak self] in
            let alert = UIAlertController(title: "LetMeSent", message: msg, preferredStyle: .alert)
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
    
    //MARK:- presentPayment
    public func presentPayment(){
        guard let vc = self.delegate  else {
            self.controllerAlert(msg: "Please set your view controller as delegate of LetMeSentSdkController")
            return}
        let alert = UIAlertController(title: "Let Me Sent",
                                      message: "Insert email & password.",
                                      preferredStyle: .alert)
        
        // Login button
        let loginAction = UIAlertAction(title: "Login", style: .default, handler: { (action) -> Void in
            
            //   Get TextFields text
            guard let emailTxt = alert.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
            guard let passwordTxt = alert.textFields![1].text else {return}
            
            if !self.isValidEmail(email: emailTxt) || emailTxt.count < 1{
                self.controllerAlert(msg: "Email seems empty or invalid.")
            }else if passwordTxt.count < 1{
                self.controllerAlert(msg: "Password seems empty.")
                
            }else{
                
                self.loginApiCall(email: emailTxt, password: passwordTxt) {(response, error) in
                    if let err = error{
                        self.hideActivityIndicator()
                        self.controllerAlert(msg: err)
                        return
                    }
                }
            }
            
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
