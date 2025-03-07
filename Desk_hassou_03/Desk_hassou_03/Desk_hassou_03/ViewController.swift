//
//  ViewController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/01/03.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class ViewController: NSViewController {
    
    let realm = try! Realm()
    
    var m_theme = ""
    var m_HintCategory = ""
    
    let SELF_X = 10
    let SELF_Y = 10
    let SELF_WIDTH = 500
    let SELF_HEITHT = 675
    
    var theme_title = NSTextField()
    var theme_title_p = Param(st_ :"テーマ",x_:20,y_:600,width_:100,height_:50,fontSize_:30)
    
    var theme_content = NSTextField()
    var theme_content_p = Param(st_ :"",x_:50,y_:480,width_:400,height_:100,fontSize_:0)
    
    var hint_title = NSTextField()
    var hint_title_p = Param(st_ :"ヒント",x_:20,y_:400,width_:100,height_:50,fontSize_:30)
    
    var hint_content = NSTextField()
    var hint_content_p = Param(st_ :"ヒント",x_:50,y_:270,width_:400,height_:100,fontSize_:0)
    
    var idea_title = NSTextField()
    var idea_title_p = Param(st_ :"アイデア",x_:20,y_:200,width_:125,height_:50,fontSize_:30)
    
    var idea_input = NSTextField()
    var idea_input_p = Param(st_ :"",x_:50,y_:75,width_:400,height_:100,fontSize_:15)
    
    var idea_count = NSTextField()
    var idea_count_p = Param(st_ :"",x_:450,y_:590,width_:50,height_:50,fontSize_:20)
    
    var theme_change_btn_p = Param(st_ :"テーマ変更",x_:140,y_:600,width_:150,height_:50,fontSize_:22)

    var theme_select_btn_p = Param(st_ :"テーマ選択",x_:290,y_:600,width_:150,height_:50,fontSize_:22)
    
    var ramdom_store_btn_p = Param(st_ :"ランダム&保存",x_:300,y_:25,width_:180,height_:50,fontSize_:22)
    
    var hintArray:[Hint_Db] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        m_HintCategory = UserDefaults.standard.object(forKey: "mHintCategory") as! String
        
        self.view.frame = CGRect(x:SELF_X, y:SELF_Y , width:SELF_WIDTH, height:SELF_HEITHT);
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        U().text_generate(param_:theme_title_p,nsText_:theme_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
        
        theme_content_p.st = m_theme
        U().text_generate(param_:theme_content_p,nsText_:theme_content,view_:self.view,input_flag_:false,ajust_flag_:true,border_flag_:false)
        U().text_generate(param_:hint_title_p,nsText_:hint_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
        
        hint_content_p.st = m_HintCategory
        
        U().random_hint_disp(param_:hint_content_p,hint_key_:m_HintCategory,ns_content_ : hint_content,view_ : self.view, realm_: realm)
        U().text_generate(param_:idea_title_p,nsText_:idea_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
        U().text_generate(param_:idea_input_p,nsText_:idea_input,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
        
        U().idea_count_disp(param_:idea_count_p,theme_st_ : m_theme ,ns_count_ : idea_count ,view_ : self.view, realm_: realm,dbObj_:Idea_Stock.self)

        U().button_generate(param_:theme_change_btn_p,viewCon_:self,view_:self.view,action: #selector(theme_change_click))
        
        U().button_generate(param_:theme_select_btn_p,viewCon_:self,view_:self.view,action: #selector(theme_select_click))
        
        U().button_generate(param_:ramdom_store_btn_p,viewCon_:self,view_:self.view,action: #selector(randam_store_click))
    }

    @objc func randam_store_click(_ sender: NSButton) {
        if idea_input.stringValue != ""{
            let exitstIt = realm.objects(Idea_Stock.self).filter("theme == %@",U().line_break_delete(in_st:theme_content.stringValue)).filter("idea == %@",U().line_break_delete(in_st:idea_input.stringValue))
            if exitstIt.count == 0{
                let idea_Stock = Idea_Stock()
                idea_Stock.theme  = U().line_break_delete(in_st:theme_content.stringValue)
                idea_Stock.hint = U().line_break_delete(in_st:hint_content.stringValue)
                idea_Stock.idea = U().line_break_delete(in_st:idea_input.stringValue)
                try! realm.write() {
                    realm.add(idea_Stock)
                }
                U().random_hint_disp(param_:hint_content_p,hint_key_:m_HintCategory,ns_content_ : hint_content,view_ : self.view, realm_: realm)
                U().idea_count_disp(param_:idea_count_p,theme_st_ : theme_content.stringValue ,ns_count_ : idea_count ,view_ : self.view, realm_: realm,dbObj_:Idea_Stock.self)
                idea_input.stringValue = ""
            }else{
                let alert = NSAlert()
                alert.messageText = "重複したアイデアは登録出来ません。"
                alert.addButton(withTitle: "OK")
                let response = alert.runModal()
            }
        }else{
            U().random_hint_disp(param_:hint_content_p,hint_key_:m_HintCategory,ns_content_ : hint_content,view_ : self.view, realm_: realm)
        }
    }
    @objc func theme_change_click(_ sender: NSButton) {
        U().theme_change(nstext: theme_content, view: self.view)
    }
    
    @objc func theme_select_click(_ sender: NSButton) {
        UserDefaults.standard.set(U().line_break_delete(in_st:theme_content.stringValue), forKey: "theme")
        UserDefaults.standard.synchronize()
        U().screen_next(viewCon : self ,id:"second" , storyboard:storyboard!)
    }
}

