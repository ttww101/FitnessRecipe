//
//  CollectionVC.swift
//  FitnessRecipe
//
//  Created by Apple on 5/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var bgView: UIView!
    var opView: UIView!
    var mainView: UIView!
    var collectionTable: UITableView!
    var listData = [RecipeMode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        setUI()
        getData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: - UI
    func setUI() {
        setViews()
        setImage()
        setTableView()
    }
    func setViews() {
        bgView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)))
        bgView.addGradual()
        self.view.addSubview(bgView)
        
        opView = UIView()
        opView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        opView.layer.roundCorners(radius: 15)
        self.view.addSubview(opView)
        self.view.addViewLayout(opView, 15, 15, 15, 15)
        
        mainView = UIView()
        mainView.backgroundColor = UIColor.white
        mainView.layer.roundCorners(radius: 10)
        self.opView.addSubview(mainView)
        self.opView.addViewLayout(mainView, 5, 5, 5, 5)
    }
    // image
    func setImage() {
        self.mainView.addBackground(UIImageView(image: UIImage(named: "collection.png")), .scaleAspectFit)
    }
    // tableview
    func setTableView() {
//        collectionTable = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        collectionTable.rowHeight = 80
//        collectionTable.separatorStyle = .none
//        collectionTable.dataSource = self
//        collectionTable.delegate = self
//        self.mainView.addSubview(collectionTable)
//        self.mainView.addViewLayout(collectionTable, 0, 0, 0, 0)
        collectionTable = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        collectionTable.register(UINib(nibName: "RecipeTableCell", bundle: nil), forCellReuseIdentifier: "RecipeTableCell")
        collectionTable.backgroundColor = UIColor(red: 238/255, green: 237/255, blue: 232/255, alpha: 1)
        collectionTable.separatorStyle = .none
        collectionTable.dataSource = self
        collectionTable.delegate = self
        collectionTable.backgroundColor = .clear
        self.view.addSubview(collectionTable)
        self.view.addViewLayout(collectionTable, 15, 15, 15, 15)
        if FRData.collection.count == 0 {
            collectionTable.isHidden = true
        }else{
            opView.isHidden = true
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
            let id = data[i]["id"] as! String
            let listEveryData = RecipeMode.init(id: id, title: data[i]["title"] as! String, image: data[i]["title_image"] as! String, content: data[i]["title_introduction"] as! String, cal: data[i]["calories"] as! String)
            for j in 0..<FRData.collection.count {
                if id == FRData.collection[j] {
                    listData.append(listEveryData)
                }
            }
        }
        collectionTable.reloadData()
    }
    
//    // MARK: - UITableViewDataSource
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return listData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellData = listData[indexPath.row]
//        let cellID = "CollectionFoodCell"
//        let cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
//        cell.textLabel?.text = cellData.title
//        let url = URL(string: cellData.image)
//        let data = try? Data(contentsOf: url!)
//        cell.imageView?.image = UIImage(data: data!)
//        cell.accessoryType = .disclosureIndicator
//
//        return cell
//    }
//    // MARK: - UITableViewDelegate
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.collectionTable.deselectRow(at: indexPath, animated: true)
//        let data = listData[indexPath.row]
//        var param = [String:String]()
//        param["type"] = "content"
//        param["id"] = data.id
//        let foodDetailVC = FoodDetailVC(param)
//        self.navigationController?.pushViewController(foodDetailVC, animated: true)
//    }
    // MARK: - tableview data souce
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = listData[indexPath.row]
        let cell = collectionTable.dequeueReusableCell(withIdentifier: "RecipeTableCell", for: indexPath) as! RecipeTableCell
        cell.titleLabel.text = cellData.title
        cell.titleLabel.lineBreakMode = .byCharWrapping
        cell.titleLabel.numberOfLines = 0
        cell.contentLabel.text = cellData.content
        cell.contentLabel.lineBreakMode = .byCharWrapping
        cell.contentLabel.numberOfLines = 0
        cell.foodImage.downloadedFrom(imageurl: cellData.image)
        cell.collectionBtn.isHidden = true
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.collectionTable.deselectRow(at: indexPath, animated: true)
        let data = listData[indexPath.row]
        var param = [String:String]()
        param["type"] = "content"
        param["id"] = data.id
        let foodDetailVC = FoodDetailVC(param)
        self.navigationController?.pushViewController(foodDetailVC, animated: true)
    }
}
