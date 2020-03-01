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
    let THEME_TITLE_ST = "テーマ"
    let THEME_TITLE_X = 10
    let THEME_TITLE_Y = 615
    let THEME_TITLE_WIDTH = 55
    let THEME_TITLE_HEITHT = 20
    let THEME_TITLE_FONT_SIZE = 15
    
    var theme_content = NSTextField()
    let THEME_CONTENT_X = 10
    let THEME_CONTENT_Y = 540
    let THEME_CONTENT_WIDTH = 480
    let THEME_CONTENT_HEITHT = 60
    
    var idea_title = NSTextField()
    let IDEA_TITLE_ST = "アイデア"
    let IDEA_TITLE_X = 10
    let IDEA_TITLE_Y = 485
    let IDEA_TITLE_WIDTH = 70
    let IDEA_TITLE_HEITHT = 20
    let IDEA_TITLE_FONT_SIZE = 15    
    
    var idea_content = NSTextField()
    let IDEA_CONTENT_X = 10
    let IDEA_CONTENT_Y = 405
    let IDEA_CONTENT_WIDTH = 480
    let IDEA_CONTENT_HEITHT = 60
    let IDEA_CONTENT_FONT_SIZE = 15    
    
    var group_title = NSTextField()
    let GROUP_TITLE_ST = "グループ分け"
    let GROUP_TITLE_X = 10
    let GROUP_TITLE_Y = 345
    let GROUP_TITLE_WIDTH = 90
    let GROUP_TITLE_HEITHT = 20
    let GROUP_TITLE_FONT_SIZE = 15
    
    var group_content = NSTextField()
    let GROUP_CONTENT_X = 10
    let GROUP_CONTENT_Y = 315
    let GROUP_CONTENT_WIDTH = 480
    let GROUP_CONTENT_HEITHT = 20
    let GROUP_CONTENT_FONT_SIZE = 13
    
    var group_input = NSTextField()
    
    var comment_title = NSTextField()
    
    var comment_input = NSTextField()

    var m_stock_num = 0
    var m_theme = ""
    var m_idea = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = CGRect(x:SELF_X, y:SELF_Y , width:SELF_WIDTH, height:SELF_HEITHT);
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
    U().text_generate(nsText:theme_title,view:self.view,x:THEME_TITLE_X,y:THEME_TITLE_Y,width:THEME_TITLE_WIDTH,height:THEME_TITLE_HEITHT,st:THEME_TITLE_ST,input_flag:false,fontSize:THEME_TITLE_FONT_SIZE,ajust_flag:false,border_flag:true)
    U().text_generate(nsText:theme_content,view:self.view,x:THEME_CONTENT_X,y:THEME_CONTENT_Y,width:THEME_CONTENT_WIDTH,height:THEME_CONTENT_HEITHT,st:m_theme,input_flag:false,fontSize:0,ajust_flag:true,border_flag:false)
    U().text_generate(nsText:idea_title,view:self.view,x:IDEA_TITLE_X,y:IDEA_TITLE_Y,width:IDEA_TITLE_WIDTH,height:IDEA_TITLE_HEITHT,st:IDEA_TITLE_ST,input_flag:false,fontSize:IDEA_TITLE_FONT_SIZE,ajust_flag:false,border_flag:true)
        
        let stocks = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme)
        var temp :[String] = []
        for one in stocks{
            temp.append(one.idea)
        }
        let orderedSet = NSOrderedSet(array: temp)
        m_unique_stocks = orderedSet.array as! [String]
        
        let group_label_s = realm.objects(Group_Label_Db.self)
        var temp_2 :[String] = []
        for one in group_label_s{
            temp_2.append(one.gourp_label)
        }
        let orderedSet_2 = NSOrderedSet(array: temp_2)
        m_dataArray = orderedSet_2.array as! [String]
        m_idea = m_unique_stocks[m_stock_num]
    U().text_generate(nsText:idea_content,view:self.view,x:IDEA_CONTENT_X,y:IDEA_CONTENT_Y,width:IDEA_CONTENT_WIDTH,height:IDEA_CONTENT_HEITHT,st:m_idea,input_flag:false,fontSize:0,ajust_flag:true,border_flag:false)
    U().text_generate(nsText:idea_title,view:self.view,x:GROUP_TITLE_X,y:GROUP_TITLE_Y,width:GROUP_TITLE_WIDTH,height:GROUP_TITLE_HEITHT,st:GROUP_TITLE_ST,input_flag:false,fontSize:GROUP_TITLE_FONT_SIZE,ajust_flag:false,border_flag:true)
        
        var comboBox = NSComboBox()
        comboBox.usesDataSource = true
        comboBox.dataSource = self
        comboBox.frame = CGRect(x: 10, y: 265 , width: 480, height: 50)
        comboBox.isEditable = false
        comboBox.stringValue = ""
        self.view.addSubview(comboBox)
        
        group_input.frame = CGRect(x:10, y:235 , width:480, height:20);
        group_input.stringValue = ""
        group_input.font = NSFont.systemFont(ofSize: 13)
        group_input.backgroundColor = NSColor.white
        self.view.addSubview(group_input)
                
        comment_title.frame = CGRect(x:10, y:185 , width:70, height:20);
        comment_title.stringValue = "コメント"
        comment_title.font = NSFont.systemFont(ofSize: 13)
        comment_title.isEditable = false
        comment_title.isSelectable = false
        comment_title.isBordered = true
        comment_title.backgroundColor = NSColor.white
        self.view.addSubview(comment_title)
        
        comment_input.frame = CGRect(x:10, y:85 , width:480, height:80);
        comment_input.stringValue = ""
        comment_input.font = NSFont.systemFont(ofSize: 13)
        comment_input.backgroundColor = NSColor.white
        self.view.addSubview(comment_input)
        
        // 値があれば、上書きする
        db_select_and_disp()
        
        var group_1_input_btn = NSButton(title:"リストにセット", target: self, action: #selector(group_1_input_click))
        group_1_input_btn.frame = CGRect(x:380, y:205 , width:120, height:30);
        group_1_input_btn.font = NSFont.systemFont(ofSize: CGFloat(10))
        self.view.addSubview(group_1_input_btn)
        
        var next_idea_btn = NSButton(title: "次へ", target: self, action: #selector(next_idea_click))
        next_idea_btn.frame = CGRect(x: 135, y: 0 , width: 100, height: 50)
        next_idea_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(next_idea_btn)
        
        var return_idea_btn = NSButton(title: "前へ", target: self, action: #selector(return_idea_click))
        return_idea_btn.frame = CGRect(x: 25, y: 0 , width: 100, height: 50)
        return_idea_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(return_idea_btn)
    }
    func db_select_and_disp(){
        var temp =
            realm.objects(Group_Divide_Db.self).filter(" theme == %@",m_theme).filter(" idea == %@",m_idea).last
        if temp != nil{
            print("temp!.gourp_label")
            print(temp!.gourp_label)
        U().text_generate(nsText:group_content,view:self.view,x:GROUP_CONTENT_X,y:GROUP_CONTENT_Y,width:GROUP_CONTENT_WIDTH,height:GROUP_CONTENT_HEITHT,st:temp!.gourp_label,input_flag:false,fontSize:GROUP_CONTENT_FONT_SIZE,ajust_flag:false,border_flag:false)
            
            comment_input.frame = CGRect(x:10, y:85 , width:480, height:80);
            comment_input.stringValue = temp!.comment
            comment_input.font = NSFont.systemFont(ofSize: 13)
            comment_input.backgroundColor = NSColor.white
            self.view.addSubview(comment_input)
        }else{
        U().text_generate(nsText:group_content,view:self.view,x:GROUP_CONTENT_X,y:GROUP_CONTENT_Y,width:GROUP_CONTENT_WIDTH,height:GROUP_CONTENT_HEITHT,st:"",input_flag:false,fontSize:GROUP_CONTENT_FONT_SIZE,ajust_flag:false,border_flag:false)
            
            comment_input.frame = CGRect(x:10, y:85 , width:480, height:80);
            comment_input.stringValue = ""
            comment_input.font = NSFont.systemFont(ofSize: 13)
            comment_input.backgroundColor = NSColor.white
            self.view.addSubview(comment_input)
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
    @objc func group_1_input_click(){    U().text_generate(nsText:group_content,view:self.view,x:GROUP_CONTENT_X,y:GROUP_CONTENT_Y,width:GROUP_CONTENT_WIDTH,height:GROUP_CONTENT_HEITHT,st:group_input.stringValue,input_flag:false,fontSize:GROUP_CONTENT_FONT_SIZE,ajust_flag:false,border_flag:false)
    }
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return m_dataArray.count
    }
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
    U().text_generate(nsText:group_content,view:self.view,x:GROUP_CONTENT_X,y:GROUP_CONTENT_Y,width:GROUP_CONTENT_WIDTH,height:GROUP_CONTENT_HEITHT,st:m_dataArray[index],input_flag:false,fontSize:GROUP_CONTENT_FONT_SIZE,ajust_flag:false,border_flag:false)
        return m_dataArray[index]
    }
    
}
