//
//  One_BrainstormingController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/05/01.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class One_BrainstormingController: NSViewController, NSTableViewDelegate, NSTableViewDataSource{

    let realm = try! Realm()
    
    @IBOutlet weak var tableView: NSTableView!
    
    var m_theme = ""
    var m_hint = ""
    var m_hint_category = ""
    var m_ran_int = -99
    var db_stocks:[String] = []
    var select_stock = ""

    var hint_content = NSTextField()
    var hint_content_p = Param(st_ :"",x_:650,y_:300,width_:500,height_:80,fontSize_:20)
    
    var idea_input = NSTextField()

    var hint_category_select_btn = NSButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if false{
            let dummy = realm.objects(Hint_Db_ver2.self).filter("theme == %@","業界一覧")
            try! realm.write {
                realm.delete(dummy)
            }
            let dummy2 = realm.objects(Hint_Db_ver2.self).filter("theme == %@","興味深い事_1")
            try! realm.write {
                realm.delete(dummy2)
            }
        }
        if false{
            let dummy = realm.objects(Hint_Db_ver2.self)
            try! realm.write {
                realm.delete(dummy)
            }
            let simple_s = ["➕",
            "➖",
            "✖️",
            "➗",
            "逆",
            "分岐"]
            for one in simple_s {
                try! realm.write() {
                    var hint_Db = Hint_Db_ver2()
                    hint_Db.theme  = "シンプル_1"
                    hint_Db.content = one
                    realm.add(hint_Db)
                }
            }
            for one in not_related_hint_2 {
                try! realm.write() {
                    var hint_Db = Hint_Db_ver2()
                    hint_Db.theme  = "関係ない_1"
                    hint_Db.content = one
                    realm.add(hint_Db)
                }
            }
            for one in osborneChecklist_1 {
                try! realm.write() {
                    var hint_Db = Hint_Db_ver2()
                    hint_Db.theme  = "オズボーンのチェックリスト"
                    hint_Db.content = one
                    realm.add(hint_Db)
                }
            }
            let sdgs_s = realm.objects(Hint_Db.self).filter("theme == %@","SDGs169の具体的な目標").value(forKey: "content") as! [String]
            for one in sdgs_s {
                try! realm.write() {
                    var hint_Db = Hint_Db_ver2()
                    hint_Db.theme  = "SDGs169の具体的な目標"
                    hint_Db.content = one
                    realm.add(hint_Db)
                }
            }
        }
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor

        m_theme = UserDefaults.standard.object(forKey: "one_brainstorming_theme") as! String
        
        m_hint_category = UserDefaults.standard.object(forKey: "m_hint_category") as! String

        var theme_title = NSTextField()
        var theme_title_p = Param(st_ :"テーマ",x_:650,y_:550,width_:100,height_:50,fontSize_:20)
        U().text_generate(param_:theme_title_p,nsText_:theme_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        var theme_content = NSTextField()
        var theme_content_p = Param(st_ :m_theme,x_:650,y_:450,width_:500,height_:80,fontSize_:20)
        U().text_generate(param_:theme_content_p,nsText_:theme_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        var hint_title = NSTextField()
        var hint_title_p = Param(st_ :"ヒント",x_:650,y_:370,width_:80,height_:50,fontSize_:20)
        U().text_generate(param_:hint_title_p,nsText_:hint_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        hint_category_select_btn = NSButton(title: "ヒントカテゴリ選択", target: self, action: #selector(hint_category_select_click))
        hint_category_select_btn.frame = CGRect(x: 750, y: 400 , width: 200, height: 30)
        hint_category_select_btn.font = NSFont.systemFont(ofSize: 20)
        view.self.addSubview(hint_category_select_btn)
        
        var hint_add_btn = NSButton(title: "ヒントを追加", target: self, action: #selector(hint_add_click))
        hint_add_btn.frame = CGRect(x: 950, y: 400 , width: 200, height: 30)
        hint_add_btn.font = NSFont.systemFont(ofSize: 20)
        view.self.addSubview(hint_add_btn)
        
        m_ran_int = U().random_hint_disp_ver2(param_:hint_content_p,hint_key_:m_hint_category,ns_content_ : hint_content,view_ : self.view, realm_: realm,befor_num_: m_ran_int)
        
        var idea_title = NSTextField()
        var idea_title_p = Param(st_ :"アイデア",x_:650,y_:190,width_:125,height_:50,fontSize_:20)
        U().text_generate(param_:idea_title_p,nsText_:idea_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)


        var idea_input_p = Param(st_ :"",x_:650,y_:90,width_:500,height_:100,fontSize_:15)
         U().text_generate(param_:idea_input_p,nsText_:idea_input,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
        
        var ramdom_store_btn_p = Param(st_ :"ランダム&保存",x_:1000,y_:20,width_:180,height_:50,fontSize_:20)
        U().button_generate(param_:ramdom_store_btn_p,viewCon_:self,view_:self.view,action: #selector(randam_store_click))
        
        var text_disp_btn_p = Param(st_ :"テキスト表示",x_:620,y_:20,width_:180,height_:50,fontSize_:20)
        U().button_generate(param_:text_disp_btn_p,viewCon_:self,view_:self.view,action: #selector(text_disp_click))
        
        let stocks = realm.objects(Idea_Stock_ver2.self).filter("theme == %@",m_theme).value(forKey: "idea") as! [String]
        let orderedSet = NSOrderedSet(array: stocks)
        db_stocks = orderedSet.array as! [String]
        tableView.scroll(NSPoint(x: 0, y: 30 * db_stocks.count))

        tableView.action = #selector(onItemClicked)
    }
    @objc func randam_store_click(_ sender: NSButton) {
        if idea_input.stringValue != ""{
            let exitstIt = realm.objects(Idea_Stock_ver2.self).filter("theme == %@",m_theme).filter("idea == %@",idea_input.stringValue)
            if exitstIt.count == 0{
                let idea_Stock_ver2 = Idea_Stock_ver2()
                idea_Stock_ver2.theme  = m_theme
                idea_Stock_ver2.hint = hint_content.stringValue
                idea_Stock_ver2.idea = idea_input.stringValue
                try! realm.write() {
                    realm.add(idea_Stock_ver2)
                }
                m_ran_int = U().random_hint_disp_ver2(param_:hint_content_p,hint_key_:m_hint_category,ns_content_ : hint_content,view_ : self.view, realm_: realm,befor_num_: m_ran_int)

                // リストの更新
                db_stocks.append(idea_input.stringValue)
                tableView.reloadData()
                tableView.scroll(NSPoint(x: 0, y: 30 * db_stocks.count))
                idea_input.stringValue = ""
            }else{
                let alert = NSAlert()
                alert.messageText = "重複したアイデアは登録出来ません。"
                alert.addButton(withTitle: "OK")
                let response = alert.runModal()
            }
        }else{
            m_ran_int = U().random_hint_disp_ver2(param_:hint_content_p,hint_key_:m_hint_category,ns_content_ : hint_content,view_ : self.view, realm_: realm,befor_num_: m_ran_int)
        }
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return db_stocks.count
    }
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return db_stocks[row]
    }
    @objc func onItemClicked() {
        if tableView.clickedRow > -1{
            select_stock = db_stocks[tableView.clickedRow]
        }else{
            print("配列の範囲外")
        }
    }
    @objc func hint_category_select_click(_ sender: NSButton) {
            UserDefaults.standard.set("Hint_Category_List_ver2", forKey: "to_page")
            UserDefaults.standard.synchronize()
            let next = storyboard?.instantiateController(withIdentifier: "List")
            self.presentAsModalWindow(next! as! NSViewController)
            self.dismiss(nil)
    }
    @objc func text_disp_click(_ sender: CustomNSButton){
        UserDefaults.standard.set("One_Brainstorming", forKey: "from_page")
        UserDefaults.standard.synchronize()
        let next = storyboard?.instantiateController(withIdentifier: "Txt_Disp")
        self.presentAsModalWindow(next! as! NSViewController)
    }
    @objc func hint_add_click(_ sender: NSButton) {
        UserDefaults.standard.set("One_Brainstorming_Hint_Add", forKey: "from_page")
        UserDefaults.standard.synchronize()
        self.dismiss(nil)
        let next = storyboard?.instantiateController(withIdentifier: "Txt_Disp")
        self.presentAsModalWindow(next! as! NSViewController)
    }
}
