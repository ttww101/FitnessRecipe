//
//  InfomationVC.swift
//  FitnessRecipe
//
//  Created by Apple on 6/19/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

struct infoModel {
    var title: String
    var img: String
    var id: Int
}

class InfomationVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var infoTable: UITableView!
    @IBOutlet weak var loginView: UIView!
    
    var listData = [infoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTable.register(UINib(nibName: "InfomationCell", bundle: nil), forCellReuseIdentifier: "InfomationCell")
        
        getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        if userAccount.account == "" {
            customeAlert("提示", "登录后即可观看资讯文章")
        } else {
            loginView.isHidden = true
        }
    }
    override func viewDidLayoutSubviews() {
        bgView.addGradual()
    }
    
    // MARK: - Data
    func getData() {
        APIManager.shared.getData(url: "http://wp.asopeixun.com:5000/get_post_from_category_id", parameter: ["category_id":"153"], completion: { (json) in
            let list = json["list"] as! [AnyObject]
            let apiData = list[0]["list"] as! [AnyObject]
            self.organizeData(apiData)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func organizeData(_ data: [AnyObject]) {
        listData.removeAll()
        for i in 0...data.count - 1 {
            listData.append(infoModel(title: data[i]["title"] as! String, img: data[i]["thumb"] as! String, id: data[i]["ID"] as! Int))
        }
        infoTable.reloadData()
    }
    
    // MARK: - tableview data souce
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = listData[indexPath.row]
        let cell = infoTable.dequeueReusableCell(withIdentifier: "InfomationCell", for: indexPath) as! InfomationCell
        cell.infoTitle.text = cellData.title
        cell.infoImg.downloadedFrom(imageurl: cellData.img)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.infoTable.deselectRow(at: indexPath, animated: true)
        let data = listData[indexPath.row]
        let id = data.id
        let infoDetailVC = InfoDetailVC(id)
        self.navigationController?.pushViewController(infoDetailVC, animated: true)
    }
    
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
