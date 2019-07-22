//
//  FirstSettingVC.swift
//  FitnessRecipe
//
//  Created by Apple on 5/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class FirstSettingVC: UIViewController {
    @IBOutlet weak var bgColorView: UIView!
    @IBOutlet weak var settingView: UIView!
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTitle: UILabel!
    @IBOutlet weak var weightTitle: UILabel!
    
    let userDefault = UserDefaults.standard
    var finishClosure: (() -> Void)?
    var heightStr = ""
    var weightStr = ""
    var dataControl: DataControl!
    var type: ViewType!
    
    init(_ height: String, _ weight: String, _ type: ViewType) {
        super.init(nibName: nil, bundle: nil)
        self.heightStr = (height == "-") ? "" : height
        self.weightStr = (weight == "-") ? "" : weight
        self.type = type
        dataControl = DataControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let corners: UIRectCorner = [.topLeft, .topRight]
        settingView.corner(byRoundingCorners: corners, radii: 15)
        
        viewSetting()
        
        heightTextField.text = heightStr
        weightTextField.text = weightStr
    }
    override func viewDidLayoutSubviews() {
        bgColorView.addGradual()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func viewSetting() {
        switch self.type! {
        case .weight:
            return
        case .fitness:
            return
        case .blood:
            heightTitle.text = "收缩压(mmHg)："
            weightTitle.text = "舒张压(mmHg)："
        case .heartbeat:
            heightTitle.text = "心率(dpm)："
            weightTitle.isHidden = true
            weightTextField.isHidden = true
        }
    }
    
    @IBAction func finishClick(_ sender: UIButton) {
        let height = heightTextField.text
        let weight = weightTextField.text
        if let h = height, let w = weight, h != "", w != "" {
            let douH = Double(h)!
            let douW = Double(w)!
            switch self.type! {
            case .weight:
                FRData.height = Double(round(10*douH)/10)
                FRData.weight = Double(round(10*douW)/10)
                self.userDefault.set(FRData.height, forKey: "BodyHeight")
                self.userDefault.set(FRData.weight, forKey: "BodyWeight")
                self.userDefault.synchronize()
                dataControl.setWeight(FRData.weight)
            case .fitness:
                return
            case .blood:
                dataControl.setBlood(Int(douH), Int(douW))
            case .heartbeat:
                dataControl.setHeartbeat(Int(douH))
            }
            finishClosure?()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
