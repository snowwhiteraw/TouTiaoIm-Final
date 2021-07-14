//
//  PersonHomeViewController.swift
//  TouTiaoSK17.V2
//
//  Created by SeventeenK17 on 2021/6/26.
//

import UIKit
import MJRefresh
//import SQLite
//import RealmSwift


class PersonHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let userData = UserMessageModel()
    let personData = PersonData()
    var personImageInit = UIImage(systemName: "person.circle")
    var personNameInit = "用户名字"
    var database = Database()
    var text = [String]()
    var pageVC: PageViewController?

    
    //tableView设置
    lazy var table1 = configTable(tableName: 1)
    lazy var table2 = configTable(tableName: 2)
    lazy var table3 = configTable(tableName: 3)
    lazy var table4 = configTable(tableName: 4)
    lazy var table5 = configTable(tableName: 5)
    lazy var table6 = configTable(tableName: 6)
    
    func configTable(tableName:Int) -> UITableView {
        let tableName = UITableView()
        tableName.delegate = self
        tableName.dataSource = self
//        tableName.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableName.register(PersonHomeCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableName.tableFooterView = UIView.init()
        tableName.estimatedRowHeight = 200
        tableName.rowHeight = UITableView.automaticDimension
        if #available(iOS 13.0, *) {
            tableName.automaticallyAdjustsScrollIndicatorInsets = false
        }
        return tableName
    }
    
    
    lazy var headerView: UIView = {
        //背景图
        let tmpView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 230))
        tmpView.backgroundColor = UIColor.white
        let bgurl = URL(string: userData.userbackimageurl as String)!
        var imgView = UIImageView.init(image: UIImage.init(named: "TTBackground"))
        imgView.af.setImage(withURL: bgurl)
        imgView.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 230)
        imgView.contentMode = UIView.ContentMode.top
//        imgView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        imgView.alpha = 0.5
        tmpView.addSubview(imgView)
        imgView.center = tmpView.center
        tmpView.clipsToBounds = true
        
        //用户头像
        let personImage = personData.personImage
        personImage.frame = CGRect(x: 20, y: 140, width: 80, height: 80)
        tmpView.addSubview(personImage)
//
//        let personImage = UIImageView()
//        let url = URL(string: userData.userimageurl as String)!
//        personImage.af.setImage(withURL: url)
        personImage.layer.masksToBounds = true
        personImage.layer.cornerRadius = personImage.frame.width/2
        
        //用户名字
        let personName = personData.personName
        personName.frame = CGRect(x: 120, y: 120, width: 150, height: 80)

        
        tmpView.addSubview(personData.personName)
        
        //用户数据
        
        database.createTable()
        text = database.readText()
        let count = text.count
//        tmpView.addSubview(personData(Data: "头条：" + (userData.toutiaonum as String) , x: 120, y: 155))
        tmpView.addSubview(personData(Data: "头条：" + "\(count)" , x: 120, y: 155))
        tmpView.addSubview(personData(Data: "获赞：" + (userData.beingagreenum as String), x: 260, y: 155))
        tmpView.addSubview(personData(Data: "粉丝：" + (userData.fansnum as String), x: 120, y: 180))
        tmpView.addSubview(personData(Data: "关注：" + (userData.follownum as String), x: 260, y: 180))
        
        
        return tmpView
    }()
    
    func personData(Data:String,x:CGFloat,y:CGFloat) -> UILabel {
        let personData = UILabel(frame: CGRect(x: x, y: y, width: 80, height: 60))
        personData.text = Data
        personData.textColor = .darkGray
        personData.adjustsFontSizeToFitWidth = true
        personData.font = UIFont.systemFont(ofSize: 14)
        return personData
    }
    
    lazy var segmentItem: PageBar = {
        let tmpSeg = PageBar.init(frame: CGRect.init(x: 0, y: 230, width: UIScreen.main.bounds.width, height: 44))
        tmpSeg.backgroundColor = UIColor.white
        return tmpSeg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view, typically from a nib.
        title = "个人中心"
        navigationController?.navigationBar.isTranslucent = false
        //加入分页VC，可直接使用，也可继承。
        pageVC = PageViewController.init(headView: headerView, hoverView: segmentItem, subViewCount:6)        //1
        if let pVC = pageVC {
            addChild(pVC)
            view.addSubview(pVC.view)
            pVC.configTableView(subViews: [table1,table2,table3,table4,table5,table6], selectIndex: 0)
        }
    
        //headerView，segment置前
        //加入headerView
        self.view.addSubview(headerView)
        //加入segment
        let titles = ["头条","粉丝","关注","收藏","评论","点赞"]
        segmentItem.selectedItemIndex = 0
        segmentItem.setTitles(titles)
        self.view.addSubview(segmentItem)
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
//        database = Database()
        database.createTable()
        text = database.readText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        table1.reloadData()
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if table1 == tableView{
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell",for: indexPath) as! PersonHomeCell
        cell.textData.text = text[indexPath.row]
            return cell
        }
        let cell = UITableViewCell()
        return cell

    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return text.count
//        return text?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if table1 == tableView{
        let alertController = UIAlertController(title: "提示", message: "编辑或删除数据？", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let editAction = UIAlertAction(title: "编辑", style: .default, handler: {action in
            let vc = FabuViewController()
            vc.isEditText = true
            vc.textView.text = self.text[indexPath.row]
            self.navigationController?.pushViewController(vc,animated: true)
        })
        let deleteAction = UIAlertAction(title: "删除", style: .destructive, handler: {action in
            let ac = UIAlertController(title: "确定删除？", message:"删除后不能恢复数据" , preferredStyle: .alert)
            let deleteAC = UIAlertAction(title: "删除", style: .destructive, handler: {action in
                
                self.database.deleteItem(text: self.text[indexPath.row])
                self.text = self.database.readText()
                self.table1.reloadData()
                                
            })
            ac.addAction(cancelAction)
            ac.addAction(deleteAC)
            
            self.present(ac, animated: true, completion: nil)
            
        })
        
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
        print("点击成功")
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let didScroll = pageVC?.didScroll else { return }
        didScroll(scrollView)
    }

    //修改用户名
    @objc func changeName(){
        let alertController = UIAlertController(title: "修改用户名字", message: nil, preferredStyle:.alert)
        alertController.addTextField(configurationHandler: {(textField : UITextField!) in
                textField.placeholder = "请输入用户名字"
            // 添加监听代码，监听文本框变化时要做的操作
            NotificationCenter.default.addObserver(self, selector: #selector(self.alertTextFieldDidChange), name: UITextField.textDidChangeNotification, object: textField)
        })
    
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "确认", style: .default , handler: { action in
            let newName = (alertController.textFields?.first)! as UITextField
            let name = newName.text
//            self.userData.username = NSMutableString(string:name!)
//            print(self.userData.username)
            
//            print(name)
            NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
                })
        okAction.isEnabled = false
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

        
    }
/// 监听文字改变
    @objc func alertTextFieldDidChange(){
        let alertController = self.presentedViewController as! UIAlertController?
        if (alertController != nil) {
            let login = (alertController!.textFields?.first)! as UITextField
            let okAction = alertController!.actions.last! as UIAlertAction
            if (!(login.text?.isEmpty)!) {
                    okAction.isEnabled = true
            } else {
                okAction.isEnabled = false
                }
            }
    }

}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


