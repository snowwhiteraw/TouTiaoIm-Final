//
//  ScanViewController.swift
//  TouTiaoSK17.V2
//
//  Created by SeventeenK17 on 2021/6/29.
//

import UIKit

class ScanViewController: LBXScanViewController {

   //   扫码区域上方提示文字
        var topTitle: UILabel?

    //闪关灯开启状态
    var isOpenedFlash: Bool = false

// 底部几个功能：开启闪光灯、相册、我的二维码

    //底部显示的功能项
    var bottomItemsView: UIView?

    //相册
    var btnPhoto: UIButton = UIButton()

    //闪光灯
    var btnFlash: UIButton = UIButton()
    
    var style = LBXScanViewStyle()


    override func viewDidLoad() {
        super.viewDidLoad()

        //需要识别后的图像
        setNeedCodeImage(needCodeImg: true)

        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10        
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
        self.scanStyle = style


        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        drawBottomItems()
    }

    override func handleCodeResult(arrayResult: [LBXScanResult]) {

        for result: LBXScanResult in arrayResult {
            if let str = result.strScanned {
                print(str)
            }
        }

        let result: LBXScanResult = arrayResult[0]

        let vc = ScanResultController()
        vc.codeResult = result
        navigationController?.pushViewController(vc, animated: true)
    }

    func drawBottomItems() {
        if (bottomItemsView != nil) {

            return
        }

        let yMax = self.view.frame.maxY - self.view.frame.minY

        bottomItemsView = UIView(frame: CGRect(x: 0.0, y: yMax-100, width: self.view.frame.size.width, height: 100 ) )

        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)

        self.view .addSubview(bottomItemsView!)

        let size = CGSize(width: 65, height: 87)

        self.btnFlash = UIButton()
        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width/3, y: bottomItemsView!.frame.height/2)

        btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)
        btnFlash.addTarget(self, action: #selector(ScanViewController.openOrCloseFlash), for: UIControl.Event.touchUpInside)
        

        self.btnPhoto = UIButton()
        btnPhoto.bounds = btnFlash.bounds
        btnPhoto.center = CGPoint(x: bottomItemsView!.frame.width * 2/3, y: bottomItemsView!.frame.height/2)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_nor"), for: UIControl.State.normal)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_down"), for: UIControl.State.highlighted)

        btnPhoto.addTarget(self, action: #selector(openPhotoAlbum), for: UIControl.Event.touchUpInside)
        
//        self.btnMyQR = UIButton()
//        btnMyQR.bounds = btnFlash.bounds;
//        btnMyQR.center = CGPoint(x: bottomItemsView!.frame.width * 3/4, y: bottomItemsView!.frame.height/2);
//        btnMyQR.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"), for: UIControl.State.normal)
//        btnMyQR.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_down"), for: UIControl.State.highlighted)
//        btnMyQR.addTarget(self, action: #selector(myCode), for: UIControl.Event.touchUpInside)
        

        bottomItemsView?.addSubview(btnFlash)
        bottomItemsView?.addSubview(btnPhoto)
//        bottomItemsView?.addSubview(btnMyQR)

        view.addSubview(bottomItemsView!)
    }
    
    //开关闪光灯
    @objc func openOrCloseFlash() {
        scanObj?.changeTorch()

        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_down"), for:UIControl.State.normal)
        }
        else
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)

        }
    }

    //自定义颜色线
    func createImageWithColor(color: UIColor) -> UIImage {
        let rect=CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage!
    }

}
