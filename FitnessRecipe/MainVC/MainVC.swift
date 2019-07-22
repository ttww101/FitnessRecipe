//
//  MainVC.swift
//  FitnessRecipe
//
//  Created by Apple on 5/27/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FSCalendar
import Charts

enum ViewType {
    case weight, fitness, blood, heartbeat
    
    var onclick: String {
        switch self {
        case .weight:
            return "weight0.png"
        case .fitness:
            return "fitness0.png"
        case .blood:
            return "blood0.png"
        case .heartbeat:
            return "heartbeat0.png"
        }
    }
    var offclick: String {
        switch self {
        case .weight:
            return "weight1.png"
        case .fitness:
            return "fitness1.png"
        case .blood:
            return "blood1.png"
        case .heartbeat:
            return "heartbeat1.png"
        }
    }
    var dataKey: String {
        switch self {
        case .weight:
            return "weight"
        case .fitness:
            return "loseCal"
        case .blood:
            return "Hblood"
        case .heartbeat:
            return "heartbeat"
        }
    }
    var dataUnit: String {
        switch self {
        case .weight:
            return "kg"
        case .fitness:
            return "cal"
        case .blood:
            return "mmHg"
        case .heartbeat:
            return "dpm"
        }
    }
    var chartTitle: String {
        switch self {
        case .weight:
            return "体重"
        case .fitness:
            return "热量"
        case .blood:
            return "血压"
        case .heartbeat:
            return "心率"
        }
    }
}

struct chartModel {
    var dataValue: [Double]
    var title: String
    var color: NSUIColor
}

class MainVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var weightBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var weightShaView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var weightModeBtn: UIButton!
    @IBOutlet weak var bloodModeBtn: UIButton!
    @IBOutlet weak var fitnessModeBtn: UIButton!
    @IBOutlet weak var heartbeatModeBtn: UIButton!
    @IBOutlet weak var chartTitle: UILabel!
    
    var dataControl: DataControl!
    var dailyDetailVC: DailyDetailVC!
    var viewType: ViewType!
    var viewBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.frame.size.height = 1000
        dataControl = DataControl()
        viewType = .weight
        viewBtn = weightModeBtn
        setting()
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        calendar.reloadData()
        chartSet()
    }
    override func viewDidLayoutSubviews() {
        bgView.addGradual()
    }
    
    func viewModeChange(_ type: ViewType, _ btn: UIButton) {
        if viewType != type {
            viewBtn.setImage(UIImage(named: viewType.offclick), for: .normal)
            btn.setImage(UIImage(named: type.onclick), for: .normal)
            viewBtn = btn
            viewType = type
            bodyInfoChange()
            startChart()
        }
    }
    
    func bodyInfoChange() {
        var btnTitle = ""
        if viewType! == .blood {
            btnTitle = "\(dataControl.getData(viewType.dataKey))/\(dataControl.getData("Lblood")) \(viewType.dataUnit)"
        } else {
            btnTitle = "\(dataControl.getData(viewType.dataKey)) \(viewType.dataUnit)"
        }
        weightBtn.setTitle(btnTitle, for: .normal)
        weightBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        chartTitle.text = "(一周\(self.viewType.chartTitle)变化)"
    }
    
    func setting() {
        weightShaView.layer.addShadow()
        weightView.layer.roundCorners(radius: 5)
        calendarSet()
    }
    func calendarSet() {
        let locale = NSLocale.init(localeIdentifier: "zh_CN")
        calendar.locale = locale as Locale
    }
    func chartSet() {
        if FRData.weight == 0 || FRData.height == 0 {
            let fsVC = FirstSettingVC("", "", .weight)
//            fsVC.finishClosure = {[weak self] in
//                self?.bodyInfoChange()
//                self?.startChart()
//            }
            self.present(fsVC, animated: true, completion: nil)
        } else {
            dataControl.setWeight(FRData.weight)
            bodyInfoChange()
            startChart()
        }
    }
    func startChart() {
        let dateArray = getWeekDate()
        var chartData = [chartModel]()
        switch viewType! {
        case .weight:
            let weightData = getWeightData(dateArray.0)
            chartData.append(chartModel(dataValue: weightData, title: "体重(kg)", color: .init(red: 240/255, green: 161/255, blue: 82/255, alpha: 1)))
        case .fitness:
            let gCalData = getUserData(dateArray.0, "getCal")
            let loseCalData = getUserData(dateArray.0, "loseCal")
            chartData.append(chartModel(dataValue: gCalData, title: "摄取卡路里", color: .init(red: 35/255, green: 93/255, blue: 172/255, alpha: 1)))
            chartData.append(chartModel(dataValue: loseCalData, title: "消耗卡路里", color: .init(red: 100/255, green: 163/255, blue: 247/255, alpha: 1)))
        case .blood:
            let HBlood = getUserData(dateArray.0, "Hblood")
            let LBlood = getUserData(dateArray.0, "Lblood")
            chartData.append(chartModel(dataValue: HBlood, title: "收缩压", color: .init(red: 128/255, green: 211/255, blue: 157/255, alpha: 1)))
            chartData.append(chartModel(dataValue: LBlood, title: "舒张压", color: .init(red: 68/255, green: 163/255, blue: 101/255, alpha: 1)))
        case .heartbeat:
            let heartbeat = getUserData(dateArray.0, "heartbeat")
            chartData.append(chartModel(dataValue: heartbeat, title: "心率", color: .init(red: 237/255, green: 112/255, blue: 108/255, alpha: 1)))
        }
        setLineData(dateArray.1, chartData)
    }
    
    // MARK: - button click
    @IBAction func modeBtnClick(_ sender: UIButton) {
        var nextType: ViewType = .weight
        var nextBtn: UIButton = weightModeBtn
        switch sender.tag {
        case 0:
            nextType = .weight
            nextBtn = weightModeBtn
        case 1:
            nextType = .blood
            nextBtn = bloodModeBtn
        case 2:
            nextType = .fitness
            nextBtn = fitnessModeBtn
        case 3:
            nextType = .heartbeat
            nextBtn = heartbeatModeBtn
        default:
            return
        }
        viewModeChange(nextType, nextBtn)
    }
    
    // MARK: - FSCalendarDataSource
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var dots = 0
        if let getDateData = FRData.userData[date.getConvert()] {
            if let getDayFitness = getDateData["fitness"] {
                if getDayFitness.count > 0 { dots = 2 }
            }
            if let getDayRecipe = getDateData["recipe"] {
                if getDayRecipe.count > 0 { dots = 2 }
            }
        }
        return dots
    }
    // MARK: - FSCalendarDelegateAppearance
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        var colors = [UIColor]()
        if FRData.userData[date.getConvert()]?["fitness"]?.count ?? 0 > 0 {
            colors.append(.blue)
        } else {
            colors.append(.gray)
        }
        if FRData.userData[date.getConvert()]?["recipe"]?.count ?? 0 > 0 {
            colors.append(.orange)
        } else {
            colors.append(.gray)
        }
        return colors
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        var colors = [UIColor]()
        if FRData.userData[date.getConvert()]?["fitness"]?.count ?? 0 > 0 {
            colors.append(.blue)
        } else {
            colors.append(.gray)
        }
        if FRData.userData[date.getConvert()]?["recipe"]?.count ?? 0 > 0 {
            colors.append(.orange)
        } else {
            colors.append(.gray)
        }
        return colors
    }
    
    // MARK: - FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        var open = false
        var fitnessArray = [String]()
        var recipeArray = [String]()
        if let getDateData = FRData.userData[date.getConvert()] {
            if let getDayFitness = getDateData["fitness"] {
                if getDayFitness.count > 0 { open = true; fitnessArray = getDayFitness }
            }
            if let getDayRecipe = getDateData["recipe"] {
                if getDayRecipe.count > 0 { open = true; recipeArray = getDayRecipe }
            }
        }
        if open {
            dailyDetailVC = DailyDetailVC("\(FRData.weight)", fitnessArray, recipeArray)
            self.addChild(dailyDetailVC)
            self.view.addSubview(dailyDetailVC.view)
            self.view.addViewLayout(dailyDetailVC.view, 0, 0, 0, 0)
        }
    }
    
    // MARK: - Charts
    func setLineData(_ dataPoints: [String], _ data: [chartModel]) {
        let lineChartData = LineChartData()
        
        for i in 0..<data.count {
            let dataArray = data[i].dataValue
            var dataEntries: [ChartDataEntry] = []
            for j in 0..<dataArray.count {
                let dataEntry = ChartDataEntry(x: Double(j), y: dataArray[j])
                dataEntries.append(dataEntry)
            }
            let dataSet = LineChartDataSet(entries: dataEntries, label: data[i].title)
            dataSet.setColors(data[i].color)
            dataSet.setCircleColor(data[i].color)
            lineChartData.addDataSet(dataSet)
        }
        setChart(dataPoints: dataPoints, lineChartData: lineChartData)
    }
    
    func setChart(dataPoints: [String], lineChartData: LineChartData) {
        lineChart.data = lineChartData
        lineChart.minOffset = 30
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        lineChart.xAxis.granularity = 1.0
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.drawAxisLineEnabled = false
        lineChart.rightAxis.enabled = false
        lineChart.scaleXEnabled = false
        lineChart.scaleYEnabled = false
    }
    
    // charts X
    func getWeekDate() -> ([String],[String]) {
        var weekDate = [String]()
        var yDate = [String]()
        let date = Date()
        let lastTime: TimeInterval = -(24*60*60)
        for i in 0...5 {
            let j = 6 - i
            let lastDate = date.addingTimeInterval(Double(j) * lastTime)
            weekDate.append(lastDate.getConvert())
            yDate.append(lastDate.getConvert2())
        }
        weekDate.append(date.getConvert())
        yDate.append(date.getConvert2())
        return (weekDate, yDate)
    }
    // charts Y
    func getWeightData(_ dataKey: [String]) -> [Double] {
        var weightArray = [Double]()
        for i in 0..<dataKey.count {
            var b = true
            if let getDateData = FRData.userData[dataKey[i]] {
                if let getDayWeight = getDateData["weight"] {
                    if getDayWeight.count > 0 {
                        b = false
                        weightArray.append(Double(getDayWeight[0])!)
                    }
                }
            }
            if b { weightArray.append(FRData.weight) }
        }
        return weightArray
    }
    func getUserData(_ dataKey: [String], _ mainKey: String) -> [Double] {
        var calArray = [Double]()
        for i in 0..<dataKey.count {
            var b = true
            if let getDateData = FRData.userData[dataKey[i]] {
                if let getDayData = getDateData[mainKey] {
                    if getDayData.count > 0 {
                        b = false
                        calArray.append(Double(getDayData[0])!)
                    }
                }
            }
            if b { calArray.append(0) }
        }
        return calArray
    }
    @IBAction func fixWeight(_ sender: UIButton) {
        var param1 = ""
        var param2 = ""
        switch self.viewType! {
        case .weight:
            param1 = "\(FRData.height)"
            param2 = "\(FRData.weight)"
        case .fitness:
            return
        case .blood:
            param1 = dataControl.getData("Hblood")
            param2 = dataControl.getData("Lblood")
        case .heartbeat:
            param1 = dataControl.getData("heartbeat")
            param2 = "0"
        }
        let fsVC = FirstSettingVC(param1, param2, self.viewType)
//        fsVC.finishClosure = {[weak self] in
//            self?.bodyInfoChange()
//            self?.startChart()
//        }
        self.present(fsVC, animated: true, completion: nil)
    }
}
