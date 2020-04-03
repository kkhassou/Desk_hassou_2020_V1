//
//  View_3_Controller.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/01/03.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class View_3_Controller: NSViewController, NSTableViewDelegate, NSTableViewDataSource{
    
    let realm = try! Realm()
    
    var unique_stocks:[String] = []
    
    var return_btn_p = Param(st_ :"戻る",x_:25,y_:30,width_:75,height_:50,fontSize_:22)
    var more_idea_btn_p = Param(st_ :"1つ1つ再度アイデア",x_:110,y_:30,width_:250,height_:50,fontSize_:22)
    var select_btn_p = Param(st_ :"決定",x_:375,y_:30,width_:75,height_:50,fontSize_:22)
    var delete_btn_p = Param(st_ :"削除",x_:460,y_:30,width_:75,height_:50,fontSize_:22)
    var deep_enlarge_btn_p = Param(st_ :"深層増幅",x_:550,y_:30,width_:150,height_:50,fontSize_:22)
    var nine_x_nine_btn_p = Param(st_ :"9x9へ",x_:25,y_:0,width_:100,height_:50,fontSize_:22)
    var group_btn_p = Param(st_ :"グループ分け＆コメント",x_:150,y_:0,width_:250,height_:50,fontSize_:22)
    var index_group_btn_p = Param(st_ :"一覧からグループ分け",x_:425,y_:0,width_:225,height_:50,fontSize_:22)


    @IBOutlet weak var tableView: NSTableView!

    var m_select_stock = ""
    var m_theme = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.action = #selector(onItemClicked)
        
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        let stocks = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme)
        var temp :[String] = []
        for one in stocks{
            temp.append(one.idea)
        }
        let orderedSet = NSOrderedSet(array: temp)
        unique_stocks = orderedSet.array as! [String]
    
        U().button_generate(param_:return_btn_p,viewCon_:self,view_:self.view,action: #selector(return_disp))
    
        U().button_generate(param_:more_idea_btn_p,viewCon_:self,view_:self.view,action: #selector(more_idea))
        
        U().button_generate(param_:select_btn_p,viewCon_:self,view_:self.view,action: #selector(select_theme))
    
        U().button_generate(param_:nine_x_nine_btn_p,viewCon_:self,view_:self.view,action: #selector(select_nine_x_nine))
    
        U().button_generate(param_:group_btn_p,viewCon_:self,view_:self.view,action: #selector(group_divide))
        
        U().button_generate(param_:index_group_btn_p,viewCon_:self,view_:self.view,action: #selector(index_group_divide))
        
        U().button_generate(param_:delete_btn_p,viewCon_:self,view_:self.view,action: #selector(delete_db))

        U().button_generate(param_:deep_enlarge_btn_p,viewCon_:self,view_:self.view,action: #selector(deep_enlarge))
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return unique_stocks.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return unique_stocks[row]
    }
    @objc func return_disp(){
        U().screen_next(viewCon : self ,id:"second" , storyboard:storyboard!)
    }
    
    @objc func more_idea(){
        U().screen_next(viewCon : self ,id:"More_Idea" , storyboard:storyboard!)
    }
    @objc func deep_enlarge(){
        UserDefaults.standard.set("Deep_Enlarge_Pre", forKey: "to_page")
        UserDefaults.standard.synchronize()
        let next = storyboard?.instantiateController(withIdentifier: "List")
        self.presentAsModalWindow(next! as! NSViewController)
        self.dismiss(nil)
    }
    @objc func select_theme(){
        if m_select_stock != ""{
            UserDefaults.standard.set(m_select_stock, forKey: "theme")
            UserDefaults.standard.synchronize()
            U().screen_next(viewCon : self ,id:"first" , storyboard:storyboard!)
        }else{
            let alert = NSAlert()
            alert.messageText = "テーマを選択してください"
            alert.addButton(withTitle: "OK")
            let response = alert.runModal()
        }
    }
    @objc func select_nine_x_nine(){
        if m_select_stock != ""{
            UserDefaults.standard.set(m_select_stock, forKey: "theme")
            UserDefaults.standard.synchronize()
            U().screen_next(viewCon : self ,id:"Nine_x_Nine" , storyboard:storyboard!)
        }else{
            let alert = NSAlert()
            alert.messageText = "テーマを選択してください"
            alert.addButton(withTitle: "OK")
            let response = alert.runModal()
        }
    }
    @objc func group_divide(){
        U().screen_next(viewCon : self ,id:"Group_Divide" , storyboard:storyboard!)
    }
    @objc func index_group_divide(){
        U().screen_next(viewCon : self ,id:"Index_Group_Divide" , storyboard:storyboard!)
    }
    @objc func delete_db(){
        if m_select_stock != ""{
            let alert = NSAlert()
            alert.messageText = "本当に、" + m_select_stock + "を削除して良いですか？"
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "キャンセル")
            let response = alert.runModal()
            switch response {
            case .alertFirstButtonReturn:
                let stocks = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme).filter("idea == %@",m_select_stock)
                try! realm.write {
                    realm.delete(stocks)
                }
                let deleted = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme)
                var temp :[String] = []
                for one in deleted{
                    temp.append(one.idea)
                }
                let orderedSet = NSOrderedSet(array: temp)
                unique_stocks = orderedSet.array as! [String]
                tableView.reloadData()
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
    @objc func onItemClicked() {
        if tableView.clickedRow > -1{
            m_select_stock = unique_stocks[tableView.clickedRow]
        }
    }
}
