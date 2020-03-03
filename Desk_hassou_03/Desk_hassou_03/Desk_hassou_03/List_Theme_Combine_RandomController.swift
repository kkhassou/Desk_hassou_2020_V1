//
//  List_Theme_Combine_RandomController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/02/22.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//
import Cocoa
import Realm
import RealmSwift

class List_Theme_Combine_RandomController: NSViewController, NSTableViewDelegate, NSTableViewDataSource{
    
    
    let realm = try! Realm()
    var unique_stocks:[String] = []
    
    var return_btn = NSButton()
    var select_btn = NSButton()
    var nine_x_nine_btn = NSButton()
    var delete_btn = NSButton()
    
    @IBOutlet weak var tableView: NSTableView!
    
    var select_stock = ""
    var mtheme = ""
    
    var m_hint_theme_num = -999
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.action = #selector(onItemClicked)
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        let stocks = realm.objects(Hint_Db.self)
        var temp :[String] = []
        for one in stocks{
            temp.append(one.theme)
        }
        let orderedSet = NSOrderedSet(array: temp)
        unique_stocks = orderedSet.array as! [String]
        
        var return_btn_p = Param(st_ :"戻る",x_:25,y_:30,width_:75,height_:50,fontSize_:22)
        U().button_generate(param_:return_btn_p,viewCon_:self,view_:self.view,action: #selector(return_disp))

        var select_btn_p = Param(st_ :"決定",x_:375,y_:30,width_:75,height_:50,fontSize_:22)
        U().button_generate(param_:select_btn_p,viewCon_:self,view_:self.view,action: #selector(select_theme))
        
        var delete_btn_p = Param(st_ :"削除",x_:300,y_:30,width_:75,height_:50,fontSize_:22)
        U().button_generate(param_:delete_btn_p,viewCon_:self,view_:self.view,action: #selector(delete_db))
        
        m_hint_theme_num = UserDefaults.standard.object(forKey: "hint_theme_num") as! Int
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return unique_stocks.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return unique_stocks[row]
    }
    @objc func return_disp(){
        self.dismiss(nil)
        let next = storyboard?.instantiateController(withIdentifier: "Combine_Random")
        self.presentAsModalWindow(next! as! NSViewController)
    }
    @objc func select_theme(){
        if select_stock != ""{
        
            UserDefaults.standard.set(select_stock, forKey: "hint_theme")
            UserDefaults.standard.set(m_hint_theme_num, forKey: "hint_theme_num")
            UserDefaults.standard.set(true, forKey: "return_from_List_Theme_Combine_Random")
            UserDefaults.standard.synchronize()
            
            self.dismiss(nil)
            let next = storyboard?.instantiateController(withIdentifier: "Combine_Random")
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
                let stocks = realm.objects(Hint_Db.self).filter("theme == %@",select_stock)
                try! realm.write {
                    realm.delete(stocks)
                }
                let deleted = realm.objects(Hint_Db.self)
                var temp :[String] = []
                for one in deleted{
                    temp.append(one.theme)
                }
                let orderedSet = NSOrderedSet(array: temp)
                unique_stocks = orderedSet.array as! [String]
                tableView.reloadData()
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
    @objc func onItemClicked() {
        if tableView.clickedRow > -1{
            select_stock = unique_stocks[tableView.clickedRow]
        }
    }
}
