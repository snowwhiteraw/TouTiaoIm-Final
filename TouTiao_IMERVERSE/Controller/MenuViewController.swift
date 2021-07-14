//
//  MenuViewController.swift
//  TouTiaoSK17.V2
//
//  Created by SeventeenK17 on 2021/6/25.
//

import UIKit

class MenuViewController: UIViewController {
    let menuIcon = ["square.and.pencil","message","star","qrcode.viewfinder","gearshape"]
    let menuLable = ["发布","消息","收藏","扫描","设置"]
    var personImageInit = UIImage(systemName: "person.circle")
    var personNameInit = "用户名字"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //用户头像
        let personImage = UIImageView(image: personImageInit)
        personImage.frame = CGRect(x: 20, y: 60, width: 80, height: 80)
        self.view.addSubview(personImage)
        
        //用户名字
        let personName = UILabel(frame: CGRect(x: 120, y: 60, width: 150, height: 80))
        personName.text = personNameInit
        personName.adjustsFontSizeToFitWidth = true
        personName.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(personName)
        
        //菜单
        let tableView = UITableView(frame: CGRect(x: 0, y: 160, width: view.bounds.width, height: view.bounds.height-160), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)

        // Do any additional setup after loading the view.
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
    extension MenuViewController: UITableViewDelegate,UITableViewDataSource{

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return menuLable.count


        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
            cell.accessoryType = .none
            cell.textLabel?.text =  menuLable[indexPath.row]
    //        cell.imageView?.image = UIImage(named: menuIcon[indexPath.row])
            cell.imageView?.image = UIImage(systemName: menuIcon[indexPath.row])?.withTintColor(.red,renderingMode: .alwaysOriginal)
            return cell
            
        }
    }


