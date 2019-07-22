//
//  RecipeDetailVC.swift
//  FitnessRecipe
//
//  Created by Apple on 5/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

enum RecipeDetailType {
    case Elementary, Intermediate, Advanced
    
    var identifier: String {
        switch self {
        case .Elementary:
            return "初阶食谱"
        case .Intermediate:
            return "中阶食谱"
        case .Advanced:
            return "高阶食谱"
        }
    }
}

class RecipeDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let userDefault = UserDefaults.standard
    var recipeTable: UITableView!
    var listData = [RecipeMode]()
    var type: RecipeDetailType!
    var dataControl: DataControl!
    
    init(_ start: Int, _ end: Int, _ data: [RecipeMode], _ type: RecipeDetailType) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
        listData.removeAll()
        for i in start...end {
            listData.append(data[i])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGradual()
        self.title = type.identifier
        dataControl = DataControl()
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipeTable.reloadData()
    }
    // MARK: - UI
    func setUI() {
        recipeTable = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        recipeTable.register(UINib(nibName: "RecipeTableCell", bundle: nil), forCellReuseIdentifier: "RecipeTableCell")
        recipeTable.backgroundColor = UIColor(red: 238/255, green: 237/255, blue: 232/255, alpha: 1)
        recipeTable.separatorStyle = .none
        recipeTable.dataSource = self
        recipeTable.delegate = self
        recipeTable.backgroundColor = .clear
        self.view.addSubview(recipeTable)
        self.view.addViewLayout(recipeTable, 15, 0, 5, 5)
    }
    
    // MARK: - tableview data souce
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = listData[indexPath.row]
        let cell = recipeTable.dequeueReusableCell(withIdentifier: "RecipeTableCell", for: indexPath) as! RecipeTableCell
        cell.titleLabel.text = cellData.title
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.contentLabel.text = cellData.content
        cell.contentLabel.lineBreakMode = .byCharWrapping
        cell.contentLabel.numberOfLines = 3
        cell.foodImage.downloadedFrom(imageurl: cellData.image)
        if FRData.collection.firstIndex(of: cellData.id) != nil {
            cell.collectionBtn.setImage(UIImage(named: "fullheart.png"), for: .normal)
        } else {
            cell.collectionBtn.setImage(UIImage(named: "heart.png"), for: .normal)
        }
        if FRData.userData[Date().getConvert()]!["recipe"]!.firstIndex(of: cellData.id) != nil {
            cell.eatBtn.setImage(UIImage(named: "fullfood.png"), for: .normal)
        } else {
            cell.eatBtn.setImage(UIImage(named: "food.png"), for: .normal)
        }
        cell.heartClosure = {
            if let idx = FRData.collection.firstIndex(of: cellData.id) {
                FRData.collection.remove(at: idx)
                cell.collectionBtn.setImage(UIImage(named: "heart.png"), for: .normal)
            } else {
                FRData.collection.append(cellData.id)
                cell.collectionBtn.setImage(UIImage(named: "fullheart.png"), for: .normal)
            }
            self.userDefault.set(FRData.collection, forKey: "Recipe")
            self.userDefault.synchronize()
        }
        cell.eatClosure = { [weak self] in
            if FRData.userData[Date().getConvert()]!["recipe"]!.firstIndex(of: cellData.id) != nil {
                cell.eatBtn.setImage(UIImage(named: "food.png"), for: .normal)
            } else {
                cell.eatBtn.setImage(UIImage(named: "fullfood.png"), for: .normal)
            }
            self?.dataControl.setRecipe(cellData.id, Int(cellData.cal)!)
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.recipeTable.deselectRow(at: indexPath, animated: true)
        let data = listData[indexPath.row]
        var param = [String:String]()
        param["type"] = "content"
        param["id"] = data.id
        let foodDetailVC = FoodDetailVC(param)
        self.navigationController?.pushViewController(foodDetailVC, animated: true)
    }
}
