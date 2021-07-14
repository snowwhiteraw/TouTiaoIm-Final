//
//  PageManager.swift
//  TouTiaoSK17.V2
//
//  Created by SeventeenK17 on 2021/6/26.
//

import UIKit

class PageManager: NSObject {
    static let shared = PageManager()       //单例
    var lastConsetY: CGFloat = 0.0      //上一次的滑动位置
    var valueChanged: Bool = false      //发生改变
    
    override func copy() -> Any {
        return self
    }
    
    override func mutableCopy() -> Any {
        return self
    }
    
    func reset() {      //重置属性
        lastConsetY = 0.0
    }

}
