//
//  LessonVC.swift
//  FitnessRecipe
//
//  Created by Apple on 6/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class LessonVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var lessonTable: UITableView!
    
    var listData = [LessonModel]()
    var lessonFitness = [String]()
    let userDefault = UserDefaults.standard
    var rightBarBtn: UIBarButtonItem!
    
    var lessonChange: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lessonFitness = FRData.fitness
        self.title = "编辑课程"
        
        rightBarBtn = UIBarButtonItem(title: "儲存", style: .plain, target: self, action: #selector(fitnessData(_:)))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        let nib = UINib(nibName: "LessonCell", bundle: nil)
        lessonTable.register(nib, forCellReuseIdentifier: "LessonCell")
        
        self.getData()
        lessonTable.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func getData() {
        let data = FitnessData.actionName
        for (key, value) in data {
            listData.append(LessonModel(title: value, img: "\(key)01.png", id: key))
        }
    }
    
    @objc func fitnessData(_ sender: Any) {
        FRData.fitness = lessonFitness
        self.userDefault.set(FRData.fitness, forKey: "Fitness")
        self.userDefault.synchronize()
        lessonChange?()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = listData[indexPath.row]
        let cell = lessonTable.dequeueReusableCell(withIdentifier: "LessonCell", for: indexPath) as! LessonCell
        cell.lessonImg.image = UIImage(named: cellData.img)
        cell.lessonTitle.text = cellData.title
        if let idx = lessonFitness.firstIndex(of: cellData.id) {
            cell.sortLabel.text = "\(idx + 1)"
            cell.sortView.isHidden = false
        }
        
        return cell
    }
    // MARK: - table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lessonTable.deselectRow(at: indexPath, animated: true)
        let cellData = listData[indexPath.row]
        if let idx = lessonFitness.firstIndex(of: cellData.id) {
            lessonFitness.remove(at: idx)
            self.lessonTable.reloadData()
        } else {
            lessonFitness.append(cellData.id)
            self.lessonTable.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }

}
