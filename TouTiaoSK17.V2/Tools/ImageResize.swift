//
//  ImageResize.swift
//  TouTiaoSK17.V2
//
//  Created by SeventeenK17 on 2021/6/28.
//

import Foundation
import UIKit

class ImageResize: UIImage {
////重置大小
//    func reSizeImage(reSize:CGSize)->UIImage {
//        //UIGraphicsBeginImageContext(reSize);
//        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
//        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
//        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
//        UIGraphicsEndImageContext();
//        return reSizeImage;
//    }
//
////等比例缩放
//    func scaleImage(scaleSize:CGFloat)->UIImage {
//        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
//        return reSizeImage(reSize: reSize)
//    }
    func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
            let size = CGSize(width: width, height:
                image.size.height * width / image.size.width)
            let renderer = UIGraphicsImageRenderer(size: size)
            let newImage = renderer.image { (context) in
                image.draw(in: renderer.format.bounds)
            }
            return newImage
    }
}
