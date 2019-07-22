//
//  RegisterVC.swift
//  FitnessRecipe
//
//  Created by Apple on 6/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import LeanCloud
import LGButton
import SkyFloatingLabelTextField

class RegisterVC: UIViewController {
    
    @IBOutlet weak var loginImg: UIImageView!
    @IBOutlet weak var accountTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var checkTF: SkyFloatingLabelTextFieldWithIcon!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册"
        
        loginImg.layer.roundCorners(radius: loginImg.bounds.size.width / 2)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 8
    }
    
    // MARK: - button action
    @IBAction func action(_ sender: LGButton) {
        sender.isLoading = true
        self.view.endEditing(true)
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                let strAccount = self.accountTF.text
                let strPassword = self.passwordTF.text
                let strCheck = self.checkTF.text
                if let account = strAccount, let password = strPassword, let check = strCheck, account != "", password != "", check != "" {
                    if password == check {
                        let query = LCQuery(className: "Account")
                        query.whereKey("account", .equalTo(account))
                        if query.getFirst().object != nil {
                            self.customeAlert("错误", "帐号重复")
                            sender.isLoading = false
                        } else {
                            do {
                                let todo = LCObject(className: "Account")
                                try todo.set("account", value: account)
                                try todo.set("password", value: password)
                                let _ = todo.save {[weak self] (result) in
                                    switch result {
                                    case .success:
                                        // handle object
                                        self?.customeAlert("成功", "注册成功", { (action) in
                                            self?.popView()
                                        })
                                        sender.isLoading = false
                                        break
                                    case .failure(let error):
                                        self?.customeAlert("错误", "帐号重复")
                                        sender.isLoading = false
                                        break
                                    }
                                }
                            } catch {
                                // handle error
                            }
                        }
                    } else {
                        self.customeAlert("错误", "密码不相同")
                        sender.isLoading = false
                    }
                } else {
                    self.customeAlert("错误", "帐号或密码不可留白")
                    sender.isLoading = false
                }
            }
        }
    }
    
    func customeAlert(_ title: String, _ message: String, _ alertAction: ((_ a: UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "好", style: .default, handler: alertAction)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}
