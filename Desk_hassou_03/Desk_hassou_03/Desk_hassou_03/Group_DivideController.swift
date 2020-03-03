//
//  Group_DivideController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/02/24.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Group_DivideController: NSViewController, NSComboBoxDataSource{

    let realm = try! Realm()

    var m_unique_stocks:[String] = []
    var m_dataArray:[String] = []

    let SELF_X = 10
    let SELF_Y = 10
    let SELF_WIDTH = 500
    let SELF_HEITHT = 675
    
    var theme_title = NSTextField()
    var theme_title_p = Param(st_ :"テーマ",x_:10,y_:615,width_:55,height_:20,fontSize_:15)
    let THEME_TITLE_ST = "テーマ"
    
    var theme_content = NSTextField()
    var theme_content_p = Param(st_ :"",x_:10,y_:540,width_:480,height_:60,fontSize_:0)
    
    var idea_title = NSTextField()
    var idea_title_p = Param(st_ :"アイデア",x_:10,y_:485,width_:70,height_:20,fontSize_:15)

    
    var idea_content = NSTextField()
    var idea_content_p = Param(st_ :"",x_:10,y_:405,width_:480,height_:60,fontSize_:15)
    
    var group_title = NSTextField()
    var group_title_p = Param(st_ :"グループ分け",x_:10,y_:345,width_:90,height_:20,fontSize_:15)
    
    var group_content = NSTextField()
    var group_content_p = Param(st_ :"",x_:10,y_:315,width_:480,height_:20,fontSize_:13)
    
    var group_input = NSTextField()
    var group_input_p = Param(st_ :"",x_:10,y_:235,width_:480,height_:20,fontSize_:13)
    
    var comment_title = NSTextField()
    var comment_title_p = Param(st_ :"コメント",x_:10,y_:185,width_:70,height_:20,fontSize_:13)

    var comment_input = NSTextField()
    var comment_input_p = Param(st_ :"コメント",x_:10,y_:85,width_:480,height_:80,fontSize_:13)
    
    var comboBox = NSComboBox()
    
    var group_input_btn_p  =   Param(st_:"リストにセット",x_:380,y_:205,width_:120,height_:30,fontSize_:10)
    var next_idea_btn_p  = Param(st_ :"次へ",x_:135,y_:0,width_:100,height_:50,fontSize_:22)
    var return_idea_btn_p  = Param(st_ :"前へ",x_:25,y_:0,width_:100,height_:50,fontSize_:22)
    
    var m_stock_num = 0
    var m_theme = ""
    var m_idea = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = CGRect(x:SELF_X, y:SELF_Y , width:SELF_WIDTH, height:SELF_HEITHT);
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
   
    U().text_generate(param_:theme_title_p,nsText_:theme_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
        
        theme_content_p.st = m_theme
    U().text_generate(param_:theme_content_p,nsText_:theme_content,view_:self.view,input_flag_:false,ajust_flag_:true,border_flag_:false)
    U().text_generate(param_:idea_title_p,nsText_:idea_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
    U().text_generate(param_:group_title_p,nsText_:group_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
    U().text_generate(param_:comment_title_p,nsText_:comment_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
    U().text_generate(param_:group_input_p,nsText_:group_input,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
        
        let stocks = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme)
        var temp :[String] = []
        for one in stocks{
            temp.append(one.idea)
        }
        let orderedSet = NSOrderedSet(array: temp)
        m_unique_stocks = orderedSet.array as! [String]
        m_idea = m_unique_stocks[m_stock_num]
        idea_content_p.st = m_idea
    U().text_generate(param_:idea_content_p,nsText_:idea_content,view_:self.view,input_flag_:false,ajust_flag_:true,border_flag_:false)
        
        let group_label_s = realm.objects(Group_Label_Db.self)
        var temp_2 :[String] = []
        for one in group_label_s{
            temp_2.append(one.gourp_label)
        }
        let orderedSet_2 = NSOrderedSet(array: temp_2)
        m_dataArray = orderedSet_2.array as! [String]
        
        comboBox.usesDataSource = true
        comboBox.dataSource = self
        comboBox.frame = CGRect(x: 10, y: 265 , width: 480, height: 50)
        comboBox.isEditable = false
        comboBox.stringValue = ""
        self.view.addSubview(comboBox)
        
        // 値があれば、上書きする
        db_select_and_disp()
        
        U().button_generate(param_:group_input_btn_p,viewCon_:self,view_:self.view,action:
            #selector(group_input_click))
        
        U().button_generate(param_:next_idea_btn_p,viewCon_:self,view_:self.view,action: #selector(next_idea_click))
        
        U().button_generate(param_:return_idea_btn_p,viewCon_:self,view_:self.view,action: #selector(return_idea_click))

    }
    func db_select_and_disp(){
        idea_content_p.st = m_idea
    U().text_generate(param_:idea_content_p,nsText_:idea_content,view_:self.view,input_flag_:false,ajust_flag_:true,border_flag_:false)
        
        var temp =
            realm.objects(Group_Divide_Db.self).filter(" theme == %@",m_theme).filter(" idea == %@",m_idea).last
        if temp != nil{
            group_content_p.st = temp!.gourp_label
            U().text_generate(param_:group_content_p,nsText_:group_content,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:false)
            
            comment_input_p.st = temp!.comment
            U().text_generate(param_:comment_input_p,nsText_:comment_input,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
        }else{

            group_content_p.st = ""
            U().text_generate(param_:group_content_p,nsText_:group_content,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:false)
        
            comment_input_p.st = ""
            U().text_generate(param_:comment_input_p,nsText_:comment_input,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)

        }
    }
    func db_insert(){
        let delets = realm.objects(Group_Divide_Db.self).filter("theme == %@",m_theme).filter("idea == %@",m_idea)
        try! realm.write {
            realm.delete(delets)
        }
        let group_Divide_Db = Group_Divide_Db()
        group_Divide_Db.theme = m_theme
        group_Divide_Db.idea = m_idea
        group_Divide_Db.gourp_label = group_content.stringValue
        group_Divide_Db.comment = comment_input.stringValue
        try! realm.write() {
            realm.add(group_Divide_Db)
        }
    }
    @objc func next_idea_click(){
        db_insert()
        var idea_content = NSTextField()
        idea_content.frame = CGRect(x:10, y:405 , width:480, height:60);
        if m_stock_num <= m_unique_stocks.count - 1 {
            m_stock_num = m_stock_num + 1
        }
        idea_content.stringValue = m_unique_stocks[m_stock_num]
        m_idea = m_unique_stocks[m_stock_num]
        
        if group_content.stringValue != ""{
            let group_Label_Db = Group_Label_Db()
            group_Label_Db.gourp_label  = group_content.stringValue
            try! realm.write() {
                realm.add(group_Label_Db)
            }
        }
        db_select_and_disp()
    }
    @objc func return_idea_click(){
        var idea_content = NSTextField()
        idea_content.frame = CGRect(x:10, y:405 , width:480, height:60);
        if m_stock_num >= 1 {
            m_stock_num = m_stock_num - 1
        }
        idea_content.stringValue = m_unique_stocks[m_stock_num]
        m_idea = m_unique_stocks[m_stock_num]
        
        db_select_and_disp()
    }
    @objc func group_input_click(){        
        group_content_p.st = group_input.stringValue
        U().text_generate(param_:group_content_p,nsText_:group_content,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:false)
        let group_Label_Db = Group_Label_Db()
        group_Label_Db.gourp_label  = U().line_break_delete(in_st:group_input.stringValue)
        try! realm.write() {
            realm.add(group_Label_Db)
        }
        m_dataArray.append(group_input.stringValue)
        comboBox.reloadData()
    }
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return m_dataArray.count
    }
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        group_content_p.st = m_dataArray[index]
        U().text_generate(param_:group_content_p,nsText_:group_content,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:false)
        return m_dataArray[index]
    }
    
}
