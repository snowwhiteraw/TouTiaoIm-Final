//
//  Database.swift
//  TouTiaoSK17.V2
//
//  Created by SeventeenK17 on 2021/7/6.
//

import Foundation
import SQLite

struct Database {

    var db: Connection!
    
    let userTable = Table("userTable") // 表名称
    let userName = Expression<String>("userName")
    let userText = Expression<String>("userText")
//    let time = Expression<>
    

    init() {
        connectDatabase()
    }

    // 与数据库建立连接
    mutating func connectDatabase(filePath: String = "/Documents") -> Void  {

        let sqlFilePath = NSHomeDirectory() + filePath + "/db.sqlite3"

        do { // 与数据库建立连接
            db = try Connection(sqlFilePath)
            print(sqlFilePath)
            print("与数据库建立连接 成功")
        } catch {
            print("与数据库建立连接 失败：\(error)")
        }

    }

        // 建表
        func createTable() -> Void  {
            do { // 创建表userTable
                try db.run(userTable.create { table in
                    table.column(userName)
                    table.column(userText)
                })
                print("创建表 userTable 成功")
            } catch {
                print("创建表 userTable 失败：\(error)")
            }
        }
    
    // 插入
    func insertItem(name: String ,text: String) -> Void {
            let insert = userTable.insert(userName <- name, userText <- text)
            do {
                let rowid = try db.run(insert)
                print("插入数据成功 id: \(rowid)")
            } catch {
                print("插入数据失败: \(error)")
            }
        }
    


        // 遍历
        func queryTable() -> Void {
            for item in (try! db.prepare(userTable)) {
                print("id：\(rowid)，用户名字：\(item[userName])，发表文章：\(item[userText])")

            }
        }

    //读取文章
    func readText() ->[String] {
        var text = [String]()
        for item in (try! db.prepare(userTable)) {
            text.append(item[userText])
            print("读取到--用户名字：\(item[userName])，发表文章：\(item[userText])")
        }
        text = text.reversed()
        return text
    }
    
        // 读取
        func readItem(name: String) -> Void {
            for item in try! db.prepare(userTable.filter(userName == name)) {
                print("用户名字：\(item[userName])，发表文章：\(item[userText])")
            }

        }
    
    //修改
    func updateItem(oldText:String,updateText:String){
        let item = userTable.filter(userText == oldText)
                do {
                    if try db.run(item.update(userText <- updateText)) > 0 {
                        print(" 更新成功")
                    } else {
                        print("没有发现条目")
                    }
                } catch {
                    print("更新失败：\(error)")
                }
        
    }

    
    //删除
    func deleteItem(text:String){
        let item = userTable.filter(userText == text)
                do {
                    if try db.run(item.delete()) > 0 {
                        print("删除成功")
                    } else {
                        print("没有发现条目")
                    }
                } catch {
                    print(" 删除失败：\(error)")
                }        
    }

    
}
