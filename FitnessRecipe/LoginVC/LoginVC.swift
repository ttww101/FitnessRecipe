//
//  LoginVC.swift
//  FitnessRecipe
//
//  Created by Apple on 6/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import LeanCloud
import LGButton
import SkyFloatingLabelTextField

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginImg: UIImageView!
    @IBOutlet weak var accountTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextFieldWithIcon!
    var rightBarBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登录"
        
        loginImg.layer.roundCorners(radius: loginImg.bounds.size.width / 2)
        rightBarBtn = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(toRegister(_:)))
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func goRegister() {
        self.navigationController?.pushViewController(RegisterVC(), animated: true)
    }
    
    // MARK: - barbuttonitem
    @objc func toRegister(_ sender: Any) {
        goRegister()
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 8
    }
    
    // MARK: - button action
    @IBAction func btnClick(_ sender: UIButton) {
        goRegister()
    }
    @IBAction func action(_ sender: LGButton) {
        sender.isLoading = true
        self.view.endEditing(true)
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                let strAccount = self.accountTF.text
                let strPassword = self.passwordTF.text
                if let account = strAccount, let password = strPassword, account != "", password != "" {
                    let query = LCQuery(className: "Account")
                    query.whereKey("account", .equalTo(account))
                    query.whereKey("password", .equalTo(password))
                    if query.getFirst().object != nil {
                        userAccount.account = account
                        self.customeAlert("成功", "登录成功！", { (action) in
                            self.popView()
                        })
                        sender.isLoading = false
                        self.popView()
                        //                setPersonalView()
                    } else {
                        self.customeAlert("错误", "帐号或密码错误")
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
