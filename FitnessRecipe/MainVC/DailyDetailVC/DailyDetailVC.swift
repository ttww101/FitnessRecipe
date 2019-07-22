//
//  DailyDetailVC.swift
//  FitnessRecipe
//
//  Created by Apple on 5/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class DailyDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var dailyTable: UITableView!
    @IBOutlet weak var weightBtn: UIButton!
    
    var weight = ""
    var fitness = [String]()
    var recipe = [String]()
    var recipeData = [RecipeMode]()
    var fitnessData = [FitnessModel]()
    var getCal = 0
    var loseCal = 0
    
    init(_ weight: String, _ fitness: [String], _ recipe: [String]) {
        super.init(nibName: "DailyDetailVC", bundle: nil)
        self.weight = weight
        self.fitness = fitness
        self.recipe = recipe
        if self.fitness.count > 0 { getFitnessData() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightBtn.setTitle(weight, for: .normal)
        if recipe.count > 0 { getRecipeData() }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Data
    func getFitnessData() {
        fitnessData.removeAll()
        let actionName = FitnessData.actionName
        let actionTime: [Int] = FitnessData.actionTime["Aerobics"]!
        for i in 0...fitness.count - 1 {
            let imgs = ["\(fitness[i])0\(1).png"]
            fitnessData.append(FitnessModel.init(title: actionName[fitness[i]]!, time: actionTime[i], imgs: imgs))
        }
        loseCal = fitness.count * 67
    }
    func getRecipeData() {
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
        recipeData.removeAll()
        for i in 0...data.count - 1 {
            let id = data[i]["id"] as! String
            let cal = data[i]["calories"] as! String
            let listEveryData = RecipeMode.init(id: id, title: data[i]["title"] as! String, image: data[i]["title_image"] as! String, content: data[i]["title_introduction"] as! String, cal: data[i]["calories"] as! String)
            for j in 0..<recipe.count {
                if id == recipe[j] {
                    getCal += Int(cal)!
                    recipeData.append(listEveryData)
                }
            }
        }
        dailyTable.reloadData()
    }
    
    // MARK: - tableview data source
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "锻炼"
        case 1:
            return "进食"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = .white
        let view = UIView(frame: CGRect(x: 10, y: 5, width: 5, height: 20))
        view.backgroundColor = UIColor(red: 76/255, green: 104/255, blue: 234/255, alpha: 1)
        let label = UILabel(frame: CGRect(x: 30, y: 0, width: tableView.bounds.size.width - 30, height: 30))
        label.textColor = UIColor(red: 76/255, green: 104/255, blue: 234/255, alpha: 1)
        let label2 = UILabel(frame: CGRect(x: 90, y: 0, width: tableView.bounds.size.width - 30, height: 30))
        label2.textColor = .orange
        switch section {
        case 0:
            label.text = "锻炼 -"
            label2.text = "\(loseCal)卡"
        case 1:
            label.text = "进食 -"
            label2.text = "\(getCal)卡"
        default:
            label.text = ""
        }
        headerView.addSubview(view)
        headerView.addSubview(label)
        headerView.addSubview(label2)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.fitnessData.count
        case 1:
            return self.recipeData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cellData = fitnessData[indexPath.row]
            let cellID = "DailyDetailCell"
            let cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
            cell.textLabel?.text = cellData.title
            cell.imageView!.image = UIImage(named: cellData.imgs[0])
            return cell
        } else {
            let cellData = recipeData[indexPath.row]
            let cellID = "DailyDetailCell"
            let cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
            cell.textLabel?.text = cellData.title
            let url = URL(string: cellData.image)
            let data = try? Data(contentsOf: url!)
            cell.imageView?.image = UIImage(data: data!)
            return cell
        }
        
    }

    @IBAction func viewTap(_ sender: UITapGestureRecognizer) {
        self.view.removeFromSuperview()
    }
}
