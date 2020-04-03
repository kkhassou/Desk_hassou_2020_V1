//
//  ListController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/29.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class ListController: NSViewController, NSTableViewDelegate, NSTableViewDataSource{
    var db_stocks:[String] = []
    var select_stock = ""
    let realm = try! Realm()
    var m_to_page = ""
    @IBOutlet weak var tableview: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_to_page = UserDefaults.standard.object(forKey: "to_page") as! String
        UserDefaults.standard.set("", forKey: "to_page")
        UserDefaults.standard.synchronize()
        if m_to_page == "Proposal_List"{
            let stocks = realm.objects(Proposal_Seed.self)
            var temp :[String] = []
            for one in stocks{
                temp.append(one.seed)
            }
            let orderedSet = NSOrderedSet(array: temp)
            db_stocks = orderedSet.array as! [String]
            var select_btn_p = Param(st_ :"決定",x_:10,y_:30,width_:75,height_:50,fontSize_:22)
            U().button_generate(param_:select_btn_p,viewCon_:self,view_:self.view,action: #selector(select_theme))
        }else if m_to_page == "Concurrent_List"{
            let stocks = realm.objects(Concurrent_db.self)
            var temp :[String] = []
            for one in stocks{
                temp.append(one.theme)
            }
            let orderedSet = NSOrderedSet(array: temp)
            db_stocks = orderedSet.array as! [String]
            var select_btn_p = Param(st_ :"決定",x_:10,y_:30,width_:75,height_:50,fontSize_:22)
            U().button_generate(param_:select_btn_p,viewCon_:self,view_:self.view,action: #selector(select_theme))
            
            var new_btn_p = Param(st_ :"新規作成",x_:85,y_:30,width_:100,height_:50,fontSize_:22)
            U().button_generate(param_:new_btn_p,viewCon_:self,view_:self.view,action: #selector(new_theme))
        }else if m_to_page == "Hint_Category_List"{
            let stocks = realm.objects(Hint_Db.self)
            var temp :[String] = []
            for one in stocks{
                temp.append(one.theme)
            }
            let orderedSet = NSOrderedSet(array: temp)
            db_stocks = orderedSet.array as! [String]
            var select_btn_p = Param(st_ :"決定",x_:10,y_:30,width_:75,height_:50,fontSize_:22)
            U().button_generate(param_:select_btn_p,viewCon_:self,view_:self.view,action: #selector(select_theme))
        }
        tableview.action = #selector(onItemClicked)
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return db_stocks.count
    }
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return db_stocks[row]
    }
    @objc func onItemClicked() {
        if tableview.clickedRow > -1{
            select_stock = db_stocks[tableview.clickedRow]
        }else{
            print("配列の範囲外")
        }
    }
    @objc func new_theme(){
        let alert = NSAlert()
        alert.messageText = "新規テーマで作成"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "キャンセル")
        let new_theme_input = NSTextField(frame: NSRect(x: 0, y: 80, width: 500, height: 24))
        let stackViewer = NSStackView(frame: NSRect(x: 0, y: 0, width: 500, height: 150))
        stackViewer.addSubview(new_theme_input)
        alert.accessoryView = stackViewer

        let response = alert.runModal()
        switch response {
        case .alertFirstButtonReturn:
            if new_theme_input.stringValue != ""{
                var exitstIt = realm.objects(Concurrent_db.self).filter("theme == %@",new_theme_input.stringValue)
                if exitstIt.count == 0{
                    let new_Db = Concurrent_db()
                    new_Db.theme  = new_theme_input.stringValue
                    try! realm.write() {
                        realm.add(new_Db)
                    }
                    UserDefaults.standard.set(new_theme_input.stringValue, forKey: "concurrent_theme")
                    UserDefaults.standard.synchronize()
                    self.dismiss(nil)
                    let next = storyboard?.instantiateController(withIdentifier: "Concurrent")
                    self.presentAsModalWindow(next! as! NSViewController)
                }else{
                    let alert = NSAlert()
                    alert.messageText = "重複したアイデアは登録出来ません。"
                    let response = alert.runModal()
                }
            }else{
                let alert = NSAlert()
                alert.messageText = "テーマを入力してください。。"
                alert.addButton(withTitle: "OK")
                let response = alert.runModal()
            }

            break
        case .alertSecondButtonReturn:
            break
        default:
            break
        }
    }
    @objc func select_theme(){
        if select_stock != ""{
            if m_to_page == "Proposal_List"{
                UserDefaults.standard.set(select_stock, forKey: "trigger_idea")
                UserDefaults.standard.synchronize()
                self.dismiss(nil)
                let next = storyboard?.instantiateController(withIdentifier: "Proposal")
                self.presentAsModalWindow(next! as! NSViewController)
            }else if m_to_page == "Concurrent_List"{
                UserDefaults.standard.set(select_stock, forKey: "concurrent_theme")
                UserDefaults.standard.synchronize()
                self.dismiss(nil)
                let next = storyboard?.instantiateController(withIdentifier: "Concurrent")
                self.presentAsModalWindow(next! as! NSViewController)
            }else if m_to_page == "Hint_Category_List"{
                UserDefaults.standard.set(select_stock, forKey: "mHintCategory")
                UserDefaults.standard.synchronize()
                self.dismiss(nil)
                let next = storyboard?.instantiateController(withIdentifier: "More_Idea")
                self.presentAsModalWindow(next! as! NSViewController)
            }
        }else{
            let alert = NSAlert()
            alert.messageText = "テーマを選択してください"
            alert.addButton(withTitle: "OK")
            let response = alert.runModal()
        }
    }
}
