//
//  RecipeVC.swift
//  FitnessRecipe
//
//  Created by Apple on 5/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class RecipeVC: UIViewController {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    
    var listData = [RecipeMode]()
    var rightBarBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setView()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLayoutSubviews() {
        bgView.addGradual()
    }
    
    func setView() {
        if userAccount.account != "" {
            twoBtn.setImage(UIImage(named: "two"), for: .normal)
            threeBtn.setImage(UIImage(named: "three"), for: .normal)
        } else {
            twoBtn.setImage(UIImage(named: "twolock"), for: .normal)
            threeBtn.setImage(UIImage(named: "threelock"), for: .normal)
        }
    }

    // MARK: - Data
    func getData() {
        APIManager.shared.getData(url: FRData.url, parameter: ["type":"title"], completion: { (json) in
            let status: String = json["status"] as! String
            if status == "1" {
                self.organizeData(json["data"] as! [AnyObject])
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func organizeData(_ data: [AnyObject]) {
        listData.removeAll()
        for i in 0...data.count - 1 {
            listData.append(RecipeMode.init(id: data[i]["id"] as! String, title: data[i]["title"] as! String, image: data[i]["title_image"] as! String, content: data[i]["title_introduction"] as! String, cal: data[i]["calories"] as! String))
        }
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        let start = sender.tag
        let end = ((start + 19) > listData.count - 1) ? listData.count - 1 : start + 19
        var type: RecipeDetailType = .Elementary
        switch sender.tag {
        case 0:
            type = .Elementary
        case 20:
            if userAccount.account == "" {
                self.navigationController?.pushViewController(LoginVC(), animated: true)
                return
            }
            type = .Intermediate
        case 40:
            if userAccount.account == "" {
                self.navigationController?.pushViewController(LoginVC(), animated: true)
                return
            }
            type = .Advanced
        default:
            type = .Elementary
        }
        let recipeDetailVC = RecipeDetailVC(start, end, listData, type)
        self.navigationController?.pushViewController(recipeDetailVC, animated: true)
    }
    
}
