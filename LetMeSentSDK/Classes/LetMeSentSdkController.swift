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
    public var delegate : UIViewController?
  
      
}











//MARK:-  LetMeSentSdkController Extention
extension LetMeSentSdkController{
    private func errorAlert(msg:String){
              let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                 }))
              delegate?.present(alert, animated: true, completion: nil)
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
            // Get TextFields text
            guard let emailTxt = alert.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
             guard let passwordTxt = alert.textFields![1].text else {return}

            if !self.isValidEmail(email: emailTxt) || emailTxt.count < 1{
                self.errorAlert(msg: "Email seems empty or invalid.")
            }else if passwordTxt.count < 1{
                self.errorAlert(msg: "Password seems empty.")

            }else{
                 print("EMAIL: \(emailTxt)\n Password: \(passwordTxt)")
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
