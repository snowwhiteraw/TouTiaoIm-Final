//
//  EmojiManager.swift
//  TouTiaoSK17.V2
//
//  Created by SeventeenK17 on 2021/6/27.
//

import UIKit

class EmojiManager: NSObject {

    static let shared: EmojiManager = EmojiManager()
    
    var emojiPackages = [EmojiPackage]()
    
    var deletePath: String?
    
    override init() {
        super.init()
        //加载Emoji
        guard let path = Bundle.main.path(forResource: "emojiPackage.plist", ofType: nil, inDirectory: "EmojiKeyBoard.bundle") else{
            return
        }
        guard let dict = NSDictionary(contentsOfFile: path) as? [String:Any] else{
            return
        }
        
        guard let array = dict["packages"] as? [[String:String]] else{
            return
        }
        
        for dict  in array {
           emojiPackages.append(EmojiPackage(dict: dict))
        }
        
        //删除键Path
        guard let deletePath = Bundle.main.path(forResource: "delete@3x.png", ofType: nil, inDirectory: "EmojiKeyBoard.bundle") else{
            return
        }
        self.deletePath = deletePath
    }
}
