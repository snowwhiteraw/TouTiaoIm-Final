//
//  FabuViewController.swift
//  TouTiaoSK17.V2
//
//  Created by SeventeenK17 on 2021/6/25.
//

import UIKit

class FabuViewController: UIViewController {
    let fabuIcon = ["doc.text","doc.richtext","questionmark.square","video"]
    let fabuLable = ["微头条","文章","问答","视频"]
    var personImageInit = UIImage(systemName: "person.circle")
    var personNameInit = "用户名字"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1, alpha: 1)
        
        configBackbotton()
        configNC()


        //用户头像
        let personImage = UIImageView(image: personImageInit)
        personImage.frame = CGRect(x: 20, y: 80, width: 80, height: 80)
        self.view.addSubview(personImage)
        
        //用户名字
        let personName = UILabel(frame: CGRect(x: 120, y: 80, width: 150, height: 80))
        personName.text = personNameInit
        personName.adjustsFontSizeToFitWidth = true
        personName.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(personName)
        
        //菜单
        let tableView = UITableView(frame: CGRect(x: 0, y: 180, width: view.bounds.width, height: view.bounds.height-180), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)

        // Do any additional setup after loading the view.
    }
    
    //视图将要显示
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
          
         //设置导航栏背景透明
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                                     for: .default)
         self.navigationController?.navigationBar.shadowImage = UIImage()
     }
      
     //视图将要消失
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
          
         //重置导航栏背景
         self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
         self.navigationController?.navigationBar.shadowImage = nil
        
     }
 
    
    //返回按钮
    func configBackbotton()  {
        let backButton = UIButton(type: .system)
        let buttonImage = UIImage(systemName: "arrow.backward")?.withTintColor(.red, renderingMode:.alwaysOriginal)
        backButton.frame =  CGRect(x: 3, y: 55, width: 60, height: 25)
        backButton.setImage(buttonImage, for: .normal)
        backButton.addTarget(self, action: #selector(pageReturn), for: .touchDown)
        self.view.addSubview(backButton)

    }
    
    @objc func pageReturn(){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //导航栏【返回键】
    func configNC(){
        self.navigationController?.navigationBar.tintColor = UIColor.red
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
    }

    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
    extension FabuViewController: UITableViewDelegate,UITableViewDataSource{

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return fabuLable.count


        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
            cell.accessoryType = .none
            cell.textLabel?.text = fabuLable[indexPath.row]
    //        cell.imageView?.image = UIImage(named: menuIcon[indexPath.row])
            cell.imageView?.image = UIImage(systemName: fabuIcon[indexPath.row])?.withTintColor(.red,renderingMode: .alwaysOriginal)
            //背景色
            cell.selectedBackgroundView = UIView()
            cell.selectedBackgroundView?.backgroundColor = .red
            return cell
            
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            if indexPath.row == 0{
//                self.navigationController?.pushViewController(FabuTTViewController(), animated:true )
//            }
            
            //取消底色
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

