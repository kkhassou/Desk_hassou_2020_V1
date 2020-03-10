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
    
    var select_stock = ""
    
    @IBOutlet weak var tableview: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        tableview.action = #selector(onItemClicked)
  
        var return_btn_p = Param(st_ :"戻る",x_:25,y_:30,width_:75,height_:50,fontSize_:22)
        U().button_generate(param_:return_btn_p,viewCon_:self,view_:self.view,action: #selector(return_disp))
        var nine_x_nine_btn_p = Param(st_ :"9x9へ",x_:25,y_:0,width_:100,height_:50,fontSize_:22)
        U().button_generate(param_:nine_x_nine_btn_p,viewCon_:self,view_:self.view,action: #selector(select_nine_x_nine))
        var hierarchy_theme_btn_p = Param(st_ :"テーマの階層表示へ",x_:290,y_:0,width_:220,height_:50,fontSize_:22)
        U().button_generate(param_:hierarchy_theme_btn_p,viewCon_:self,view_:self.view,action: #selector(hierarchy_theme))
        var enlarge_btn_p = Param(st_ :"アイデア増幅",x_:120,y_:0,width_:160,height_:50,fontSize_:22)
        U().button_generate(param_:enlarge_btn_p,viewCon_:self,view_:self.view,action: #selector(select_enlarge))
        var detail_disp_btn_p = Param(st_ :"そのアイデアを見る",x_:100,y_:30,width_:200,height_:50,fontSize_:22)
        U().button_generate(param_:detail_disp_btn_p,viewCon_:self,view_:self.view,action: #selector(detail_disp))
        var delete_btn_p = Param(st_ :"削除",x_:300,y_:30,width_:75,height_:50,fontSize_:22)
        U().button_generate(param_:delete_btn_p,viewCon_:self,view_:self.view,action: #selector(delete_db))
        var select_btn_p = Param(st_ :"決定",x_:375,y_:30,width_:75,height_:50,fontSize_:22)
        U().button_generate(param_:select_btn_p,viewCon_:self,view_:self.view,action: #selector(select_theme))
        
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
    
    @objc func hierarchy_theme(){
        if select_stock != ""{
            UserDefaults.standard.set(select_stock, forKey: "theme")
            UserDefaults.standard.synchronize()
            self.dismiss(nil)
            let next = storyboard?.instantiateController(withIdentifier: "Hierarchy_Theme")
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
