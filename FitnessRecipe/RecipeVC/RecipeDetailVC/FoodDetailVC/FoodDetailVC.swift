//
//  FoodDetailVC.swift
//  iFitnessMan
//
//  Created by Apple on 2019/4/11.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

class FoodDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var detailTable: UITableView!
    
    let userDefault = UserDefaults.standard
    var materialData = [String]()
    var contentData = [FoodDetailModel]()
    var parameter: [String:String]!
    var rightBarBtn: UIBarButtonItem!
    var rightBarBtn2: UIBarButtonItem!
    var collectSave = false
    var foodSave = false
    var dataControl: DataControl!
    var cal = 0
    
    var titleLabel: UILabel = {
       let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        label.textColor = UIColor(red: 0/255, green: 124/255, blue: 188/255, alpha: 1)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    init(_ parameter: [String:String]) {
        super.init(nibName: "FoodDetailVC", bundle: nil)
        self.parameter = parameter
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataControl = DataControl()
        
        detailTable.register(UINib(nibName: "MaterialDetailCell", bundle: nil), forCellReuseIdentifier: "MaterialDetailCell")
        detailTable.register(UINib(nibName: "CookingDetailCell", bundle: nil), forCellReuseIdentifier: "CookingDetailCell")
        
        setUI()
        getData()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        bgView.addGradual()
    }
    // MARK: - UI
    func setUI() {
        setLabel()
        setBarButton()
    }
    func setLabel() {
        titleView.addSubview(titleLabel)
        titleView.addViewLayout(titleLabel, 0, 0, 0, 0)
    }
    func setBarButton() {
        var btnImg = "heart.png"
        if FRData.collection.firstIndex(of: parameter["id"]!) != nil {
            btnImg = "fullheart.png"
            self.collectSave = true
        }
        
        var foodImg = "food.png"
        if FRData.userData[Date().getConvert()]!["recipe"]!.firstIndex(of: parameter["id"]!) != nil {
            foodImg = "fullfood.png"
            self.foodSave = true
        }
        
        rightBarBtn = UIBarButtonItem(image: UIImage(named: btnImg), style: .plain, target: self, action: #selector(collectionData(_:)))
        rightBarBtn2 = UIBarButtonItem(image: UIImage(named: foodImg), style: .plain, target: self, action: #selector(recipeEat(_:)))
        self.navigationItem.rightBarButtonItems = [rightBarBtn, rightBarBtn2]
    }
    
    // MARK: - Data
    func getData() {
        APIManager.shared.getData(url: FRData.url, parameter: parameter, completion: { (json) in
            let status: String = json["status"] as! String
            if status == "1" {
                self.organizeData(json["data"] as! AnyObject)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func organizeData(_ data: AnyObject) {
        let foodCal = data["calories"] as! String
        cal += Int(foodCal)!
        titleLabel.text = data["title"] as! String
        let img: String = data["title_image"] as! String
        foodImage.downloadedFrom(imageurl: img)
        self.materialData = data["material"] as! [String]
        let content = data["content"] as! [AnyObject]
        let contentImage = data["image"] as! [AnyObject]
        for i in 0...content.count - 1 {
            contentData.append(FoodDetailModel.init(content: content[i] as! String, contentImage: contentImage[i] as! String))
        }
        detailTable.reloadData()
    }
    @objc func collectionData(_ sender: Any) {
        self.collectSave = !self.collectSave
        if self.collectSave {
            self.rightBarBtn.image = UIImage(named: "fullheart.png")
            FRData.collection.append(self.parameter["id"]!)
        } else {
            if let idx = FRData.collection.firstIndex(of: self.parameter["id"]!) {
                FRData.collection.remove(at: idx)
                self.rightBarBtn.image = UIImage(named: "heart.png")
            }
        }
        self.userDefault.set(FRData.collection, forKey: "Recipe")
        self.userDefault.synchronize()
    }
    @objc func recipeEat(_ sender: Any) {
        self.foodSave = !self.foodSave
        if self.foodSave {
            self.rightBarBtn2.image = UIImage(named: "fullfood.png")
        } else {
            if FRData.userData[Date().getConvert()]!["recipe"]!.firstIndex(of: parameter["id"]!) != nil {
                self.rightBarBtn2.image = UIImage(named: "food.png")
            }
        }
        dataControl.setRecipe(self.parameter["id"]!, cal)
    }
    
    // MARK: - tableview data source
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "材料"
        case 1:
            return "做法"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//            return 44
//        case 1:
//            return 160
//        default:
//            return 0
//        }
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            var origCount = self.materialData.count
            var count = self.materialData.count / 2
            if (origCount - (count * 2)) == 1 {
                count += 1
            }
            return count
        case 1:
            return self.contentData.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 44))
        headerView.backgroundColor = .white
        let view = UIView(frame: CGRect(x: 10, y: 12, width: 5, height: 20))
        view.backgroundColor = UIColor(red: 76/255, green: 104/255, blue: 234/255, alpha: 1)
        let label = UILabel(frame: CGRect(x: 30, y: 0, width: tableView.bounds.size.width - 30, height: 44))
        label.textColor = UIColor(red: 76/255, green: 104/255, blue: 234/255, alpha: 1)
        switch section {
        case 0:
            label.text = "材料"
        case 1:
            label.text = "做法"
        default:
            label.text = ""
        }
        headerView.addSubview(view)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let row = indexPath.row * 2
            let cellData = self.materialData[row]
            let cell = detailTable.dequeueReusableCell(withIdentifier: "MaterialDetailCell", for: indexPath) as! MaterialDetailCell
            cell.materialLabel1.text = cellData
            cell.materialLabel1.adjustsFontSizeToFitWidth = true
            if (row + 1) < self.materialData.count {
                cell.materialLabel2.text = self.materialData[row + 1]
                cell.materialLabel2.adjustsFontSizeToFitWidth = true
            } 
            return cell
        } else {
            let cellData = self.contentData[indexPath.row]
            let cell = detailTable.dequeueReusableCell(withIdentifier: "CookingDetailCell", for: indexPath) as! CookingDetailCell
            cell.foodImage.downloadedFrom(imageurl: cellData.contentImage)
            cell.stepLabel.text = "步骤\(indexPath.row + 1)"
            cell.contentLabel.text = cellData.content
            cell.contentLabel.adjustsFontSizeToFitWidth = true
            return cell
        }
        
    }

}
