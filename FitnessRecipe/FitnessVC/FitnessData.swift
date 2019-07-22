//
//  FitnessData.swift
//  iHealthS
//
//  Created by Apple on 2019/4/6.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

struct FitnessData {
    static var aerobicsTime = 480
    static var cellBgColor = UIColor(red: 213/255, green: 229/255, blue: 230/255, alpha: 1)
    static var actions: [String:Int] = ["a":5, "b":4, "c":3, "d":2, "e":2, "f":1, "g":2, "h":4, "i":2, "j":2, "k":4, "l":2, "m":2, "n":4, "o":2, "p":2, "q":2, "r":2]
    static var actionList: [String:[String]] =
        ["Aerobics":["a","g","j","h","c","i","f","g","j","g","j","n"]]
    static var actionName: [String:String] = ["a":"开合跳", "b":"站立脚踏车卷腹", "c":"爬山式", "d":"卷腹", "e":"仰卧交替脚跟接触", "f":"平板撑体", "g":"仰卧起坐", "h":"扭曲式", "i":"脚跟朝天式", "j":"双臂交叉紧缩式", "k":"曲腿转体", "l":"反向卷腹", "m":"V字卷腹", "n":"仰卧交替抬腿", "o":"X型卷腹", "p":"左侧卷腹", "q":"右侧卷腹", "r":"V型上举"]
    static var actionTime: [String:[Int]] =
        ["Aerobics":[20,20,20,20,20,20,20,20,20,20,20,20]]
}
