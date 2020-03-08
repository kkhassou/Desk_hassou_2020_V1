//
//  List_Nine_x_NineController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/02/17.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class List_Nine_x_NineController: NSViewController, NSTableViewDelegate, NSTableViewDataSource{

    @IBOutlet weak var tableview: NSTableView!
    
    var unique_stocks:[String] = []

    var select_stock = ""
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stocks = realm.objects(Nine_x_Nine_Stock.self)
        var temp :[String] = []
        for one in stocks{
            temp.append(one.y4_x4)
        }
        let orderedSet = NSOrderedSet(array: temp)
        unique_stocks = orderedSet.array as! [String]
        tableview.action = #selector(onItemClicked)
        
        var return_btn_p = Param(st_ :"戻る",x_:25,y_:30,width_:75,height_:50,fontSize_:22)
        U().button_generate(param_:return_btn_p,viewCon_:self,view_:self.view,action: #selector(return_disp))

        var select_btn_p = Param(st_ :"決定",x_:375,y_:30,width_:75,height_:50,fontSize_:22)
        U().button_generate(param_:select_btn_p,viewCon_:self,view_:self.view,action: #selector(select_theme))
        
        var delete_btn_p = Param(st_ :"削除",x_:300,y_:30,width_:75,height_:50,fontSize_:22)
        U().button_generate(param_:delete_btn_p,viewCon_:self,view_:self.view,action: #selector(delete_db))
        
        var new_btn_p = Param(st_ :"新規作成",x_:130,y_:30,width_:150,height_:50,fontSize_:22)
        U().button_generate(param_:new_btn_p,viewCon_:self,view_:self.view,action: #selector(new_db))

    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return unique_stocks.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return unique_stocks[row]
    }
    @objc func onItemClicked() {
        if tableview.clickedRow > -1{
            select_stock = unique_stocks[tableview.clickedRow]
        }else{
            print("配列の範囲外")
        }
    }
    
    @objc func select_theme(){
        if select_stock != ""{
            UserDefaults.standard.set(select_stock, forKey: "theme")
            UserDefaults.standard.synchronize()
            self.dismiss(nil)
            let next = storyboard?.instantiateController(withIdentifier: "Nine_x_Nine")
            self.presentAsModalWindow(next! as! NSViewController)
        }else{
            let alert = NSAlert()
            alert.messageText = "テーマを選択してください"
            alert.addButton(withTitle: "OK")
            let response = alert.runModal()
        }
    }
    @objc func return_disp(){
        self.dismiss(nil)
    }
    @objc func delete_db(){
        if select_stock != ""{
            let alert = NSAlert()
            alert.messageText = "本当に、" + select_stock + "を削除して良いですか？"
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "キャンセル")
            let response = alert.runModal()
            switch response {
            case .alertFirstButtonReturn:
                let stocks = realm.objects(Nine_x_Nine_Stock.self).filter("y4_x4 == %@",select_stock)
                try! realm.write {
                    realm.delete(stocks)
                }
                let deleted = realm.objects(Nine_x_Nine_Stock.self)
                var temp :[String] = []
                for one in deleted{
                    temp.append(one.y4_x4)
                }
                let orderedSet = NSOrderedSet(array: temp)
                unique_stocks = orderedSet.array as! [String]
                tableview.reloadData()
                break
            case .alertSecondButtonReturn:
                break
            default:
                break
            }
        }else{
            let alert = NSAlert()
            alert.messageText = "テーマを選択してください"
            alert.addButton(withTitle: "OK")
            let response = alert.runModal()
        }
    }
    @objc func new_db(){
        UserDefaults.standard.set("", forKey: "theme")
        UserDefaults.standard.synchronize()
        self.dismiss(nil)
        let next = storyboard?.instantiateController(withIdentifier: "Nine_x_Nine")
        self.presentAsModalWindow(next! as! NSViewController)
    }
}
