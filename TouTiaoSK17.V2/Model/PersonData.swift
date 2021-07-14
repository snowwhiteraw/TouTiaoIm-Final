//
//  PersonData.swift
//  TouTiaoSK17.V2
//
//  Created by SeventeenK17 on 2021/7/5.
//

import Foundation
import UIKit
//import RealmSwift

let userData = UserMessageModel()
class PersonData : NSObject {
    @objc dynamic var text = ""

    
// 只需调整frame
//用户头像
    lazy var personImage : UIImageView = {
        let image = UIImageView()
        let url = URL(string: userData.userimageurl as String)!
        image.af.setImage(withURL: url)
        image.clipsToBounds = true
        return image
    }()
    
    
// 用户名字
    lazy var personName : UILabel = {
        let name = UILabel()
//        let name = UILabel(frame: CGRect(x: 120, y: 120, width: 150, height: 80))
        name.text = userData.username as String
        name.adjustsFontSizeToFitWidth = true
        name.font = UIFont.systemFont(ofSize: 20)
        return name
    }()
        
}

