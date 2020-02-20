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
    
    var select_btn = NSButton()
    var return_btn = NSButton()
    var delete_btn = NSButton()
    
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
        
        select_btn = NSButton(title: "決定", target: self, action: #selector(select_theme))
        select_btn.frame = CGRect(x: 375, y: 30 , width: 75, height: 50)
        select_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(select_btn)
        
        delete_btn = NSButton(title: "削除", target: self, action: #selector(delete_db))
        delete_btn.frame = CGRect(x: 300, y: 30 , width: 75, height: 50)
        delete_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(delete_btn)
        return_btn = NSButton(title: "戻る", target: self, action: #selector(return_disp))
        return_btn.frame = CGRect(x: 25, y: 30 , width: 75, height: 50)
        return_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(return_btn)
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return unique_stocks.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return unique_stocks[row]
    }
    @objc func onItemClicked() {
        print("tableview.clickedRow")
        print(tableview.clickedRow)
        print("unique_stocks.count")
        print(unique_stocks.count)
        if tableview.clickedRow > -1{
            select_stock = unique_stocks[tableview.clickedRow]
            print(select_stock)
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
                print("キャンセル")
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
}
