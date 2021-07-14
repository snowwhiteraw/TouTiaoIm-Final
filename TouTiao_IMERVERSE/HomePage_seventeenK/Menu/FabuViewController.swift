//
//  FabuViewController.swift
//  TouTiaoSK17.V2
//
//  Created by SeventeenK17 on 2021/6/27.
//

import UIKit
import KMPlaceholderTextView
import SnapKit


class FabuViewController: UIViewController, UITextViewDelegate{
    
    var dataBase = Database()

    let emojiViewHeight: CGFloat = 250
    
    let textView = UITextView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
    let rightBarButton = UIBarButtonItem(title: "发布", style: .plain, target: self, action: nil)
    let buttomView = UIView(frame: CGRect(x: 0, y:UIScreen.main.bounds.height-40 , width: UIScreen.main.bounds.width, height: 40))
    
    var oldText = ""
    var isEditText = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        rightBarButton.tintColor = .gray
        self.navigationItem.rightBarButtonItem = rightBarButton
        configTextView()
        setupBtmView()
        
        self.textView.inputView = emojiView
        
        oldText = textView.text

    }

    //配置TextView
    func configTextView(){
        textView.delegate = self
        self.view.addSubview(textView)
        //字体颜色
        textView.textColor = UIColor.black
        //内容部分链接样式
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange,
                                       NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        //边框
//        textView.layer.borderColor = UIColor.red.cgColor
//        textView.layer.borderWidth = 1.5
        //字体大小
        textView.font = UIFont.systemFont(ofSize: 16)
        //内容可编辑
        textView.isEditable = true
        //内容可选
//        textView.isSelectable = true
        //边框圆角设置
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 5.0
        //自适应高度
        textView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        //对齐方式
        textView.textAlignment = .left
        //返回键的类型
        textView.returnKeyType = .done
        //键盘类型
        textView.keyboardType = UIKeyboardType.default
        //是否可以滚动
        textView.isScrollEnabled = true
        //给文字中的网址和电话号码自动加上链接
        textView.dataDetectorTypes = .all  //电话和网址都加
        
        textView.becomeFirstResponder()
        

    }
    

    
    //设置工具栏
    func setupBtmView()  {
        self.buttomView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha:1)
        self.textView.inputAccessoryView = buttomView
        buttomView.addSubview(emojiButton)
        emojiButton.snp.makeConstraints{(make)in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
                                
        }
        
    }
    
    //emoji按钮
     var emojiButton: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.setImage(UIImage(systemName: "face.smiling")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
//        btn.imageView?.frame = btn.frame
//        btn.isHidden = false
        btn.setImage(UIImage(systemName: "keyboard")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .selected)
        btn.addTarget(self, action: #selector(keyboardExchange(_:)), for: .touchUpInside)
        return btn
    }()
        
    
    //emoji键盘
     lazy var emojiView: EmojiView = {
        let size = UIScreen.main.bounds.size
        let view = EmojiView(frame: CGRect(x: 0, y: 0, width: size.width, height: emojiViewHeight)){ [weak self] model in
            self?.showEmojiText(emojModel: model)
        }
        view.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha:1)
        
        return view
    }()
    
    
    //MARK:- 表情键盘输入解析
     func showEmojiText(emojModel: EmojiModel){
        //删除键
        if emojModel.isDelete{
            self.textView.deleteBackward()
            return
        }
        //空格键
        if emojModel.isSpace{
            return
        }
        //获取emoji并显示UITextView上
        if emojModel.emojiCode != nil {
            //找到光标的位置
            let textRange = textView.selectedTextRange
            textView.replace(textRange!, withText: emojModel.emojiCode!)
            return
        }
        // 本地图片
        let font = textView.font!
        let range = textView.selectedRange
        if emojModel.pngPath != nil {
            let attr = NSMutableAttributedString(attributedString: textView.attributedText)
            let attach = EmojiAttachment()
            attach.chs = emojModel.chs
            attach.image = UIImage(contentsOfFile: emojModel.pngPath!)
            attach.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            //在光标所在位置插入表情
            attr.replaceCharacters(in: range, with: NSAttributedString(attachment: attach))
            textView.attributedText = attr
        }
        //重新设置字体大小
        textView.font = font
        
        //让选中的rang+1
        textView.selectedRange = NSRange(location: range.location+1, length: 0)
                
        //主动调用textDidChange方法
//        textViewDidChange(textView)
    }
    

        
    //MARK:- 表情键盘按钮点击
        @objc private func keyboardExchange(_ btn: UIButton){
////            textView.resignFirstResponder()
//
            btn.isSelected = !btn.isSelected
            textView.inputView = btn.isSelected ? emojiView : nil
            textView.reloadInputViews()

        }

    
    @objc func clickCamera(){
        
    }
    

    //发布按钮
    func fabuButton() -> UIBarButtonItem  {
        
        if textView.text.isEmpty  {
            let rightBarButton = UIBarButtonItem(title: "发布", style: .plain, target: self, action: nil)
            rightBarButton.tintColor = .gray
            return rightBarButton

        }else{
            let rightBarButton = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(fabu))
            return rightBarButton

        }
    }
    

    
    @objc func fabu(){
        if isEditText{
            dataBase.updateItem(oldText: oldText, updateText: textView.text)
            print("修改")
        }
        else{
            let userData = UserMessageModel()
            dataBase.insertItem(name: userData.username as String, text: textView.text)
            dataBase.queryTable()
            print("增加")
            
        }

        let ac = UIAlertController(title: "发布成功！", message: nil, preferredStyle: .alert)
        let alert = UIAlertAction(title: "确定", style: .default, handler: {action in
            self.navigationController?.popToRootViewController(animated: true)
//            self.navigationController?.pushViewController(PersonHomeViewController(), animated: true)
        }
        )
        ac.addAction(alert)
        self.present(ac, animated: true, completion: nil)

        
    }
    
//
    func textViewDidChange(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem = fabuButton()
        
    }

    }
    

