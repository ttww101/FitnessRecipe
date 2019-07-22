//
//  PersonalVC.swift
//  FitnessRecipe
//
//  Created by Apple on 5/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
//import LeanCloud

class PersonalVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var BMILabel: UILabel!
    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pushView: UIView!
    @IBOutlet weak var collectionView: UIView!
    
    @IBOutlet weak var loginView: UIView!
    
    var BLogin = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBodyValue()
        setViewLayer()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPersonalView()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        if userAccount.account == "" {
            customeAlert("提示", "登录后即可使用个人中心")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setPersonalView() {
        if userAccount.account != "" {
            loginView.isHidden = true
        }
    }
    
    func setBodyValue() {
        heightLabel.text = "\(FRData.height)"
        weightLabel.text = "\(FRData.weight)"
        let bmiH = FRData.height / 100
        let bmiW = FRData.weight
        let bmi = bmiW / (bmiH * bmiH)
        BMILabel.text = "\(String(format: "%.2f", bmi))"
    }
    
    func setViewLayer() {
        let topLayer = CALayer()
        topLayer.backgroundColor = UIColor.gray.cgColor
        topLayer.frame = CGRect(x: 0, y: -1, width: pushView.bounds.size.width, height: 1)
        collectionView.layer.addSublayer(topLayer)
        
        bgView.addGradual()
        shadowView.layer.roundCorners(radius: 15)
    }

    @IBAction func pushTapGestureRecongnizer(_ sender: UITapGestureRecognizer) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    @IBAction func collectionTapGestureRecongnizer(_ sender: UITapGestureRecognizer) {
        let collectionVC = CollectionVC()
        self.navigationController?.pushViewController(collectionVC, animated: true)
    }
    
    // MARK: - login
    @IBAction func loginClick(_ sender: UIButton) {
        self.navigationController?.pushViewController(LoginVC(), animated: true)
    }
    
    func customeAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        let action2 = UIAlertAction(title: "登录", style: .cancel) { (action) in
            self.navigationController?.pushViewController(LoginVC(), animated: true)
        }
        alert.addAction(action)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
}
