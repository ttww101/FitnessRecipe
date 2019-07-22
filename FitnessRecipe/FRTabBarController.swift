//
//  FRTabBarController.swift
//  FitnessRecipe
//
//  Created by Apple on 5/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class FRTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let userDefault = UserDefaults.standard
    var rightBarBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        self.title = "首页"
        self.delegate = self
        let mainVC = MainVC()
        mainVC.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "tab_01_25"), tag: 0)
        
        let fitnessVC = FitnessVC()
        fitnessVC.tabBarItem = UITabBarItem(title: "锻炼", image: UIImage(named: "tab_03_25"), tag: 1)
        
        let recipeVC = RecipeVC()
        self.addChild(recipeVC)
        recipeVC.tabBarItem = UITabBarItem(title: "食谱", image: UIImage(named: "tab_02_25"), tag: 2)
        
        let informationVC = InfomationVC()
        informationVC.tabBarItem = UITabBarItem(title: "资讯", image: UIImage(named: "tab_05_25"), tag: 3)
        
        let personalVC = PersonalVC()
        self.addChild(personalVC)
        personalVC.tabBarItem = UITabBarItem(title: "个人", image: UIImage(named: "tab_04_25"), tag: 4)
        let tabbarList = [mainVC, fitnessVC, recipeVC, informationVC, personalVC]
        self.viewControllers = tabbarList
        
        rightBarBtn = UIBarButtonItem(image: UIImage(named: "collectionstar.png"), style: .plain, target: self, action: #selector(toCollection(_:)))
    }
    
    @objc func toCollection(_ sender: Any) {
        if userAccount.account != "" {
            let collectionVC = CollectionVC()
            self.navigationController?.pushViewController(collectionVC, animated: true)
        } else {
            customeAlert("提示", "登录后即可使用")
        }
    }
    
    func setting() {
        getUserBody()
        getRecipe()
        getFitness()
        getUserData()
    }
    func getUserBody() {
        FRData.height = self.userDefault.double(forKey: "BodyHeight")
        FRData.weight = self.userDefault.double(forKey: "BodyWeight")
    }
    func getRecipe() {
        if let collection = self.userDefault.array(forKey: "Recipe") {
            FRData.collection = collection as! [String]
        }
    }
    func getFitness() {
        if let fitness = self.userDefault.array(forKey: "Fitness") {
            FRData.fitness = fitness as! [String]
        }
    }
    func getUserData() {
        if let data = self.userDefault.dictionary(forKey: "FRData") {
            FRData.userData = data as! [String:[String:[String]]]
        }
//        FRData.userData = ["2019/06/20":["weight":["84"],
//                                       "fitness":["a","c","k","n","b","d","g","i"],
//                                       "recipe":["252044","256630","248391"],
//                                       "getCal":["738"],
//                                       "loseCal":["374"],
//                                       "Hblood":["120"],
//                                       "Lblood":["61"],
//                                       "heartbeat":["117"]],
//                           "2019/06/21":["weight":["83"],
//                                       "fitness":["o","r","h","b","a","f","k","m"],
//                                       "recipe":["250060","251993","252339"],
//                                       "getCal":["839"],
//                                       "loseCal":["354"],
//                                       "Hblood":["127"],
//                                       "Lblood":["66"],
//                                       "heartbeat":["105"]],
//                           "2019/06/22":["weight":["85"],
//                                       "fitness":["n","g","a","d","p","q","o","n"],
//                                       "recipe":["256630","261519","83095"],
//                                       "getCal":["653"],
//                                       "loseCal":["437"],
//                                       "Hblood":["123"],
//                                       "Lblood":["69"],
//                                       "heartbeat":["113"]],
//                           "2019/06/23":["weight":["82"],
//                                       "fitness":["h","f","q","r","l","k","e","g"],
//                                       "recipe":["266256","263976","258905"],
//                                       "getCal":["712"],
//                                       "loseCal":["393"],
//                                       "Hblood":["123"],
//                                       "Lblood":["69"],
//                                       "heartbeat":["113"]],
//                           "2019/06/24":["weight":["81"],
//                                       "fitness":["a","b","i","r","q","h","e","c"],
//                                       "recipe":["255934","279011","247996"],
//                                       "getCal":["747"],
//                                       "loseCal":["359"],
//                                       "Hblood":["119"],
//                                       "Lblood":["59"],
//                                       "heartbeat":["120"]],
//                           "2019/06/25":["weight":["81"],
//                                       "fitness":["d","r","o","f","n","p","e","j"],
//                                       "recipe":["250475","265131","260014"],
//                                       "getCal":["696"],
//                                       "loseCal":["383"],
//                                       "Hblood":["129"],
//                                       "Lblood":["71"],
//                                       "heartbeat":["131"]],
//                           "2019/06/26":["weight":["80"],
//                                       "fitness":["n","j","a","o","q","e","f","i"],
//                                       "recipe":["264718","266372","259150"],
//                                       "getCal":["683"],
//                                       "loseCal":["327"],
//                                       "Hblood":["126"],
//                                       "Lblood":["63"],
//                                       "heartbeat":["117"]]
//                            ]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        self.title = item.title
        if item.tag == 2 {
            self.navigationItem.rightBarButtonItem = rightBarBtn
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
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
