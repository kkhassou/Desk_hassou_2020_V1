//
//  View_2_Controller.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/01/03.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class View_2_Controller: NSViewController, NSTableViewDelegate, NSTableViewDataSource{
    
    let realm = try! Realm()
    var unique_stocks:[String] = []
    
    var return_btn = NSButton()
    var detail_disp_btn = NSButton()
    var select_btn = NSButton()
    var delete_btn = NSButton()
    var nine_x_nine_btn = NSButton()
    var enlarge_btn = NSButton()
    var select_stock = ""
    
    @IBOutlet weak var tableview: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        tableview.action = #selector(onItemClicked)
        
        return_btn = NSButton(title: "戻る", target: self, action: #selector(return_disp))
        return_btn.frame = CGRect(x: 25, y: 30 , width: 75, height: 50)
        return_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(return_btn)

        nine_x_nine_btn = NSButton(title: "9x9へ", target: self, action: #selector(select_nine_x_nine))
        nine_x_nine_btn.frame = CGRect(x: 25, y: 0 , width: 100, height: 50)
        nine_x_nine_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(nine_x_nine_btn)

        enlarge_btn = NSButton(title: "アイデア増幅", target: self, action: #selector(select_enlarge))
        enlarge_btn.frame = CGRect(x: 150, y: 0 , width: 200, height: 50)
        enlarge_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(enlarge_btn)
        
        select_btn = NSButton(title: "そのアイデアを見る", target: self, action: #selector(detail_disp))
        select_btn.frame = CGRect(x: 100, y: 30 , width: 200, height: 50)
        select_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(select_btn)
        
        delete_btn = NSButton(title: "削除", target: self, action: #selector(delete_db))
        delete_btn.frame = CGRect(x: 300, y: 30 , width: 75, height: 50)
        delete_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(delete_btn)
        
        select_btn = NSButton(title: "決定", target: self, action: #selector(select_theme))
        select_btn.frame = CGRect(x: 375, y: 30 , width: 75, height: 50)
        select_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(select_btn)
        
        let stocks = realm.objects(Idea_Stock.self)
        var temp :[String] = []
        for one in stocks{
            temp.append(one.theme)
        }
        let orderedSet = NSOrderedSet(array: temp)
        unique_stocks = orderedSet.array as! [String]
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
        }
    }
    @objc func return_disp(){
        self.dismiss(nil)
        let next = storyboard?.instantiateController(withIdentifier: "first")
        self.presentAsModalWindow(next! as! NSViewController)
    }
    @objc func detail_disp(){
        if select_stock != ""{
            UserDefaults.standard.set(select_stock, forKey: "theme")
            UserDefaults.standard.synchronize()
            self.dismiss(nil)
            let next = storyboard?.instantiateController(withIdentifier: "third")
            self.presentAsModalWindow(next! as! NSViewController)
        }else{
            let alert = NSAlert()
            alert.messageText = "テーマを選択してください"
            alert.addButton(withTitle: "OK")
            let response = alert.runModal()
        }

    }
    @objc func select_theme(){
        if select_stock != ""{
            UserDefaults.standard.set(select_stock, forKey: "theme")
            UserDefaults.standard.synchronize()
            self.dismiss(nil)
            let next = storyboard?.instantiateController(withIdentifier: "first")
            self.presentAsModalWindow(next! as! NSViewController)
        }else{
            let alert = NSAlert()
            alert.messageText = "テーマを選択してください"
            alert.addButton(withTitle: "OK")
            let response = alert.runModal()
        }
    }
    @objc func select_nine_x_nine(){
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
    @objc func select_enlarge(){
        if select_stock != ""{
            UserDefaults.standard.set(select_stock, forKey: "theme")
            UserDefaults.standard.synchronize()
            self.dismiss(nil)
            let next = storyboard?.instantiateController(withIdentifier: "Enlerge")
            self.presentAsModalWindow(next! as! NSViewController)
        }else{
            let alert = NSAlert()
            alert.messageText = "テーマを選択してください"
            alert.addButton(withTitle: "OK")
            let response = alert.runModal()
        }
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
                let stocks = realm.objects(Idea_Stock.self).filter("theme == %@",select_stock)
                try! realm.write {
                    realm.delete(stocks)
                }
                let deleted = realm.objects(Idea_Stock.self)
                var temp :[String] = []
                for one in deleted{
                    temp.append(one.theme)
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
