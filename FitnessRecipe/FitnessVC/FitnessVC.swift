//
//  FitnessVC.swift
//  iFitnessMan
//
//  Created by Apple on 2019/4/10.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

@objc class FitnessVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var clockView: UIView!
    @IBOutlet weak var aerobicsTabel: UITableView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var hCalLab: UILabel!
    @IBOutlet weak var tCalLab: UILabel!
    @IBOutlet weak var sCalLab: UILabel!
    
    var listData = [FitnessModel]()
    var aerobicsTime = 0
    var recordTime = 0
    var reduceCal = 0
    var timer: Timer?
    var isPlay = false
    var dataControl: DataControl!
    var clockControl: XLFoldClock!
    var calarray = [3,3,4,3,3,4,3,3,4,3,3,4,3,3,4,3,3,4,3,4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataControl = DataControl()
        self.aerobicsTime = FitnessData.aerobicsTime
        
        clockControl = XLFoldClock()
        clockControl.frame = clockView.bounds
        aerobicsTime = FRData.fitness.count * 40
        changeTimeLabel()
        clockView.addSubview(clockControl)
        clockView.addViewLayout(clockControl, 0, 0, 0, 0)
        
        let nib = UINib(nibName: "FitnessCell", bundle: nil)
        aerobicsTabel.register(nib, forCellReuseIdentifier: "Cell")
        setFootView()
        
        self.getData()
        aerobicsTabel.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if FRData.fitness.count != 0 {
            stopView()
        }
    }
    override func viewDidLayoutSubviews() {
        bgView.addGradual()
        let corners: UIRectCorner = [.topLeft, .topRight]
        playView.corner(byRoundingCorners: corners, radii: 15)
        clockControl.frame = clockView.bounds
    }
    
    // MARK: - set table view
    func setFootView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 30, height: 60))
        customView.backgroundColor = UIColor.white
        let button = UIButton(frame: CGRect(x: 24, y: 8, width: UIScreen.main.bounds.size.width - 78, height: 44))
        button.backgroundColor = UIColor(red: 81/255, green: 139/255, blue: 245/255, alpha: 1)
        button.layer.roundCorners(radius: 17)
        button.setTitle("编辑课程", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(lessonClick(_:)), for: .touchUpInside)
        customView.addSubview(button)
        aerobicsTabel.tableFooterView = customView
    }
    
    // MARK - get aerobics data
    func getData() {
        listData = [FitnessModel]()
        let actions = FitnessData.actions
        let actionName = FitnessData.actionName
        let actionList = FRData.fitness
        let actionTime = 20
        if actionList.count > 0 {
            for i in 0...actionList.count - 1 {
                let imgsCount = actions[actionList[i]]!
                let imgs = getImgsName(actionList[i], imgsCount)
                listData.append(FitnessModel.init(title: actionName[actionList[i]]!, time: actionTime, imgs: imgs))
            }
        }
    }
    func getImgsName(_ action: String, _ count: Int) -> [String] {
        var imgs = [String]()
        for i in 1...count {
            imgs.append("\(action)0\(i).png")
        }
        return imgs
    }
    
    // MARK: - button click
    @IBAction func fitnessPlayClick(_ sender: UIButton) {
        if FRData.fitness.count != 0 {
            if !isPlay {
                aerobicsTabel.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                playBtn.setTitle("暂停", for: .normal)
                isPlay = true
                aerobicsTabel.isScrollEnabled = false
                registerTimer()
            } else {
                stopView()
            }
        }
    }
    @objc func lessonClick(_ sender: UIButton) {
        let lessonVC = LessonVC()
        lessonVC.lessonChange = {[weak self] in
            self?.aerobicsTime = FRData.fitness.count * 40
            self?.changeTimeLabel()
            self?.recordTime = 0
            self?.reduceCal = 0
            self?.getData()
            self?.aerobicsTabel.reloadData()
        }
        self.navigationController?.pushViewController(lessonVC, animated: true)
    }
    
    // MARK: - timer
    func registerTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runAerobics(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func runAerobics(_ timer: Timer) -> Void {
        let row = Int(recordTime / 40)
        let indexPath = IndexPath(row: row, section: 0)
        let comparTime = (recordTime - (Int(recordTime / 40) * 40))
        if comparTime > 19 {
            let num = comparTime - 20
            reduceCal += calarray[num]
            changeCalLabel()
        }
        if comparTime == 0 {
            if row != 0 {
                let actionList = FRData.fitness
                dataControl.setFitness(row - 1, value: actionList[row - 1])
                let subCell = aerobicsTabel.cellForRow(at: IndexPath(row: row - 1, section: 0)) as! FitnessCell
                subCell.stopImg()
            }
            if aerobicsTime == 0 {
                resetView()
                aerobicsTabel.isScrollEnabled = true
                return
            }
            let cell = aerobicsTabel.cellForRow(at: indexPath) as! FitnessCell
            aerobicsTabel.scrollToRow(at: indexPath, at: .top, animated: true)
            cell.heightAnchor.constraint(equalToConstant: 120)
            cell.playRest()
        }
        if comparTime == 20 {
            let cell = aerobicsTabel.cellForRow(at: indexPath) as! FitnessCell
            cell.playAction()
        }
        
        recordTime += 1
        aerobicsTime -= 1
        self.changeTimeLabel()
    }
    
    // MARK: - set time label
    func changeTimeLabel() {
        let timeString = aerobicsTime.toTimeString()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        let date = dateFormatter.date(from: timeString)
        clockControl.date = date
    }
    func changeCalLabel() {
        var v = reduceCal
        hCalLab.text = Int(v/100).description
        v -= Int(v/100) * 100
        tCalLab.text = Int(v/10).description
        v -= Int(v/10) * 10
        sCalLab.text = v.description
    }
    
    // MARK: - reset View
    func resetView() {
        timer?.invalidate()
        timer = nil
        aerobicsTime = FRData.fitness.count * 40
        changeTimeLabel()
        recordTime = 0
        reduceCal = 0
        playBtn.setTitle("开始", for: .normal)
        isPlay = false
    }
    func stopView() {
        timer?.invalidate()
        timer = nil
        let row = Int(recordTime / 40)
        let indexPath = IndexPath(row: row, section: 0)
        let remaind = Int(recordTime % 40)
        recordTime -= remaind
        aerobicsTime += remaind
        aerobicsTabel.reloadRows(at: [indexPath], with: .none)
        aerobicsTabel.isScrollEnabled = true
        self.changeTimeLabel()
        playBtn.setTitle("开始", for: .normal)
        isPlay = false
    }

    // MARK: - table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = listData[indexPath.row]
        let cell = aerobicsTabel.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FitnessCell
        cell.titleLabel.text = cellData.title
        cell.timeLabel.text = cellData.time.toTimeString()
        cell.time = cellData.time
        cell.imgArray = cellData.imgs
        cell.setImg()
        
        return cell
    }
}
