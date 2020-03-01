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
    
    let IDEA_COUNT_SERCH_KEY = "theme"
    
    let SELF_X = 10
    let SELF_Y = 10
    let SELF_WIDTH = 500
    let SELF_HEITHT = 675
    
    var theme_title = NSTextField()
    let THEME_TITLE_ST = "テーマ"
    let THEME_TITLE_X = 20
    let THEME_TITLE_Y = 600
    let THEME_TITLE_WIDTH = 100
    let THEME_TITLE_HEITHT = 50
    let THEME_TITLE_FONT_SIZE = 30
    
    var theme_content = NSTextField()
    let THEME_CONTENT_X = 50
    let THEME_CONTENT_Y = 480
    let THEME_CONTENT_WIDTH = 400
    let THEME_CONTENT_HEITHT = 100
    
    var hint_title = NSTextField()
    let HINT_TITLE_ST = "ヒント"
    let HINT_TITLE_X = 20
    let HINT_TITLE_Y = 400
    let HINT_TITLE_WIDTH = 100
    let HINT_TITLE_HEITHT = 50
    let HINT_TITLE_FONT_SIZE = 30
    
    var hint_content = NSTextField()
    let HINT_CONTENT_X = 50
    let HINT_CONTENT_Y = 270
    let HINT_CONTENT_WIDTH = 400
    let HINT_CONTENT_HEITHT = 100
    
    var idea_title = NSTextField()
    let IDEA_TITLE_ST = "アイデア"
    let IDEA_TITLE_X = 20
    let IDEA_TITLE_Y = 200
    let IDEA_TITLE_WIDTH = 125
    let IDEA_TITLE_HEITHT = 50
    let IDEA_TITLE_FONT_SIZE = 30
    
    var idea_input = NSTextField()
    let IDEA_INPUT_X = 50
    let IDEA_INPUT_Y = 75
    let IDEA_INPUT_WIDTH = 400
    let IDEA_INPUT_HEITHT = 100
    let IDEA_INPUT_FONT_SIZE = 20
    
    var idea_count = NSTextField()
    let IDEA_COUNT_X = 450
    let IDEA_COUNT_Y = 600
    let IDEA_COUNT_WIDTH = 50
    let IDEA_COUNT_HEITHT = 50
    let IDEA_COUNT_FONT_SIZE = 30
    
    var theme_change_btn = NSButton()
    let THEME_CHANGE_BTN_ST = "テーマ変更"
    let THEME_CHANGE_BTN_X = 140
    let THEME_CHANGE_BTN_Y = 600
    let THEME_CHANGE_BTN_WIDTH = 150
    let THEME_CHANGE_BTN_HEIGHT = 50
    let THEME_CHANGE_BTN_FONT = 22
    let THEME_CHANGE_BTN_CLICK = #selector(theme_change_click)
    
    var theme_select_btn = NSButton()
    let THEME_SELECT_BTN_ST = "テーマ選択"
    let THEME_SELECT_BTN_X = 300
    let THEME_SELECT_BTN_Y = 600
    let THEME_SELECT_BTN_WIDTH = 150
    let THEME_SELECT_BTN_HEIGHT = 50
    let THEME_SELECT_BTN_FONT = 22
    let THEME_SELECT_BTN_CLICK = #selector(theme_select_click)
    
    var randam_store_btn = NSButton()
    let RANDOM_STORE_BTN_ST = "ランダム&保存"
    let RANDOM_STORE_BTN_X = 300
    let RANDOM_STORE_BTN_Y = 25
    let RANDOM_STORE_BTN_WIDTH = 180
    let RANDOM_STORE_BTN_HEIGHT = 50
    let RANDOM_STORE_BTN_FONT = 22
    let RANDOM_STORE_BTN_CLICK = #selector(randam_store_click)
    
    var hintArray:[Hint_Db] = []
    override func viewDidLoad() {
        m_HintCategory = UserDefaults.standard.object(forKey: "mHintCategory") as! String
        super.viewDidLoad()
        
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        
        self.view.frame = CGRect(x:SELF_X, y:SELF_Y , width:SELF_WIDTH, height:SELF_HEITHT);
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
    U().text_generate(nsText:theme_title,view:self.view,x:THEME_TITLE_X,y:THEME_TITLE_Y,width:THEME_TITLE_WIDTH,height:THEME_TITLE_HEITHT,st:THEME_TITLE_ST,input_flag:false,fontSize:THEME_TITLE_FONT_SIZE,ajust_flag:false,border_flag:true)
    U().text_generate(nsText:theme_content,view:self.view,x:THEME_CONTENT_X,y:THEME_CONTENT_Y,width:THEME_CONTENT_WIDTH,height:THEME_CONTENT_HEITHT,st:m_theme,input_flag:false,fontSize:0,ajust_flag:true,border_flag:false)
    U().text_generate(nsText:hint_title,view:self.view,x:HINT_TITLE_X,y:HINT_TITLE_Y,width:HINT_TITLE_WIDTH,height:HINT_TITLE_HEITHT,st:HINT_TITLE_ST,input_flag:false,fontSize:HINT_TITLE_FONT_SIZE,ajust_flag:false,border_flag:true)
   
        U().random_hint_disp(ns_content : hint_content ,view : self.view, realm: realm,x:HINT_CONTENT_X,y:HINT_CONTENT_Y,width:HINT_CONTENT_WIDTH,height:HINT_CONTENT_HEITHT,key_content:m_HintCategory)
    U().text_generate(nsText:idea_title,view:self.view,x:IDEA_TITLE_X,y:IDEA_TITLE_Y,width:IDEA_TITLE_WIDTH,height:IDEA_TITLE_HEITHT,st:IDEA_TITLE_ST,input_flag:false,fontSize:IDEA_TITLE_FONT_SIZE,ajust_flag:false,border_flag:true)
    U().text_generate(nsText:idea_input,view:self.view,x:IDEA_INPUT_X,y:IDEA_INPUT_Y,width:IDEA_INPUT_WIDTH,height:IDEA_INPUT_HEITHT,st:"",input_flag:true,fontSize:IDEA_INPUT_FONT_SIZE,ajust_flag:false,border_flag:true)
        
        U().idea_count_disp(ns_content : theme_content ,ns_count : idea_count ,view : self.view, realm: realm,x:IDEA_COUNT_X,y:IDEA_COUNT_Y,width:IDEA_COUNT_WIDTH,height:IDEA_COUNT_HEITHT,key:IDEA_COUNT_SERCH_KEY,fontSize:IDEA_COUNT_FONT_SIZE,dbObj:Idea_Stock.self)
        
        U().button_generate(viewCon : self ,view:self.view,x:THEME_CHANGE_BTN_X,y:THEME_CHANGE_BTN_Y,width:THEME_CHANGE_BTN_WIDTH,height:THEME_CHANGE_BTN_HEIGHT,st:THEME_CHANGE_BTN_ST,fontSize:THEME_CHANGE_BTN_FONT,action: THEME_CHANGE_BTN_CLICK)

        U().button_generate(viewCon : self ,view:self.view,x:THEME_SELECT_BTN_X,y:THEME_SELECT_BTN_Y,width:THEME_SELECT_BTN_WIDTH,height:THEME_SELECT_BTN_HEIGHT,st:THEME_SELECT_BTN_ST,fontSize:THEME_SELECT_BTN_FONT,action: THEME_SELECT_BTN_CLICK)
        
        U().button_generate(viewCon : self ,view:self.view,x:RANDOM_STORE_BTN_X,y:RANDOM_STORE_BTN_Y,width:RANDOM_STORE_BTN_WIDTH,height:RANDOM_STORE_BTN_HEIGHT,st:RANDOM_STORE_BTN_ST,fontSize:RANDOM_STORE_BTN_FONT,action: RANDOM_STORE_BTN_CLICK)
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
                U().random_hint_disp(ns_content : hint_content ,view : self.view, realm: realm,x:HINT_CONTENT_X,y:HINT_CONTENT_Y,width:HINT_CONTENT_WIDTH,height:HINT_CONTENT_HEITHT,key_content:m_HintCategory)
                U().idea_count_disp(ns_content : theme_content ,ns_count : idea_count ,view : self.view, realm: realm,x:IDEA_COUNT_X,y:IDEA_COUNT_Y,width:IDEA_COUNT_WIDTH,height:IDEA_COUNT_HEITHT,key:IDEA_COUNT_SERCH_KEY,fontSize:IDEA_COUNT_FONT_SIZE,dbObj:Idea_Stock.self)
                idea_input.stringValue = ""
            }else{
                let alert = NSAlert()
                alert.messageText = "重複したアイデアは登録出来ません。"
                alert.addButton(withTitle: "OK")
                let response = alert.runModal()
            }
        }else{
            U().random_hint_disp(ns_content : hint_content ,view : self.view, realm: realm,x:50,y:270,width:400,height:100,key_content:m_HintCategory)
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

