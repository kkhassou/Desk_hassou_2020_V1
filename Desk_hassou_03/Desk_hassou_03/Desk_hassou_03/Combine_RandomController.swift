//
//  Combine_RandomController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/02/21.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Combine_RandomController: NSViewController {

    let realm = try! Realm()
    
    var randomFlag_1 = true
    var randomFlag_2 = true
    var randomFlag_3 = true
    
    var m_randamo_hint_category_1 = ""
    var m_randamo_hint_category_2 = ""
    var m_randamo_hint_category_3 = ""

    var m_randamo_hint_1 = ""
    var m_randamo_hint_2 = ""
    var m_randamo_hint_3 = ""
    
    var randam_or_fix_1 = NSTextField()
    var randam_or_fix_2 = NSTextField()
    var randam_or_fix_3 = NSTextField()
    
    var category_1_content_btn = NSButton(title: "ヒントを選択して固定", target: self, action: #selector(randam_or_fix_switch_click))
    var category_2_content_btn = NSButton(title: "ヒントを選択して固定", target: self, action: #selector(randam_or_fix_switch_click))
    var category_3_content_btn = NSButton(title: "ヒントを選択して固定", target: self, action: #selector(randam_or_fix_switch_click))
    
    
    var category_1 = NSTextField()
    var category_2 = NSTextField()
    var category_3 = NSTextField()
    var think_idea_content = NSTextField()
    
    var category_1_content = NSTextField()
    var category_2_content = NSTextField()
    var category_3_content = NSTextField()
    
    var CATEGORY_CONTENT_START_Y      = 430
    var CATEGORY_CONTENT_WIDTH        = 380
    var CATEGORY_CONTENT_HEIGHT       = 75
    
    override func viewDidLoad() {
        super.viewDidLoad()
    UserDefaults.standard.register(defaults:["return_from_List_Theme_Combine_Random" : false])
        var return_from_List_Theme_Combine_Random_flag = UserDefaults.standard.object(forKey: "return_from_List_Theme_Combine_Random") as! Bool
        if return_from_List_Theme_Combine_Random_flag{
            var hint_theme_num = UserDefaults.standard.object(forKey: "hint_theme_num") as! Int
            UserDefaults.standard.register(defaults:["hint_theme" : ""])
            var hint_theme = UserDefaults.standard.object(forKey: "hint_theme") as! String
            if hint_theme_num == 1{
                UserDefaults.standard.set(hint_theme, forKey: "hint_theme_1")
                UserDefaults.standard.synchronize()
            }else if hint_theme_num == 2{
                UserDefaults.standard.set(hint_theme, forKey: "hint_theme_2")
                UserDefaults.standard.synchronize()
            }else if hint_theme_num == 3{
                UserDefaults.standard.set(hint_theme, forKey: "hint_theme_3")
                UserDefaults.standard.synchronize()
            }
            UserDefaults.standard.set(false, forKey: "return_from_List_Theme_Combine_Random")
            UserDefaults.standard.synchronize()
        }
        //
    UserDefaults.standard.register(defaults:["return_from_List_Content_Combine_Random" : false])
        var return_from_List_Content_Combine_Random_flag = UserDefaults.standard.object(forKey: "return_from_List_Content_Combine_Random") as! Bool
        if return_from_List_Content_Combine_Random_flag{
            var hint_content_num = UserDefaults.standard.object(forKey: "hint_content_num") as! Int
            UserDefaults.standard.register(defaults:["hint_content" : ""])
            var hint_content = UserDefaults.standard.object(forKey: "hint_content") as! String
            print("hint_content_num")
            print(hint_content_num)
            if hint_content_num == 11{
                print("from_con_1")
                category_1_content_btn = NSButton(title: "ランダム選択に戻す", target: self, action: #selector(randam_or_fix_switch_click))
                category_1_content_btn.frame = CGRect(x:600, y:470 , width:180, height:50);
                category_1_content_btn.font = NSFont.systemFont(ofSize: CGFloat(15))
                category_1_content_btn.tag = 11
                self.view.addSubview(category_1_content_btn)
                randam_or_fix_1.frame = CGRect(x:610, y:450 , width:75, height:20);
                randam_or_fix_1.stringValue = "固定表示"
                randam_or_fix_1.font = NSFont.systemFont(ofSize: CGFloat(15))
                randam_or_fix_1.isEditable = false
                randam_or_fix_1.isSelectable = false
                randam_or_fix_1.backgroundColor = NSColor.white
                self.view.addSubview(randam_or_fix_1)
                category_1_content.frame = CGRect(x:200, y:CATEGORY_CONTENT_START_Y , width:CATEGORY_CONTENT_WIDTH, height:CATEGORY_CONTENT_HEIGHT);
                category_1_content.stringValue = hint_content
                category_1_content.font =  NSFont.systemFont(ofSize: CGFloat(15))
                category_1_content.isEditable = false
                category_1_content.isSelectable = false
                category_1_content.backgroundColor = NSColor.white
                self.view.addSubview(category_1_content)
                randomFlag_1 = false
            }else if hint_content_num == 22{
                print("from_con_2")
                category_2_content_btn = NSButton(title: "ランダム選択に戻す", target: self, action: #selector(randam_or_fix_switch_click))
                category_2_content_btn.frame = CGRect(x:600, y:370 , width:180, height:50);
                category_2_content_btn.font = NSFont.systemFont(ofSize: CGFloat(15))
                category_2_content_btn.tag = 22
                self.view.addSubview(category_2_content_btn)
                randam_or_fix_2.frame = CGRect(x:610, y:350 , width:75, height:20);
                randam_or_fix_2.stringValue = "固定表示"
                randam_or_fix_2.font = NSFont.systemFont(ofSize: CGFloat(15))
                randam_or_fix_2.isEditable = false
                randam_or_fix_2.isSelectable = false
                randam_or_fix_2.backgroundColor = NSColor.white
                self.view.addSubview(randam_or_fix_2)
                category_2_content.frame = CGRect(x:200, y:CATEGORY_CONTENT_START_Y - 100 , width:CATEGORY_CONTENT_WIDTH, height:CATEGORY_CONTENT_HEIGHT);
                category_2_content.stringValue = hint_content
                category_2_content.font =  NSFont.systemFont(ofSize: CGFloat(15))
                category_2_content.isEditable = false
                category_2_content.isSelectable = false
                category_2_content.backgroundColor = NSColor.white
                self.view.addSubview(category_2_content)
                randomFlag_2 = false
            }else if hint_content_num == 33{
                print("from_con_3")
                category_3_content_btn = NSButton(title: "ランダム選択に戻す", target: self, action: #selector(randam_or_fix_switch_click))
                category_3_content_btn.frame = CGRect(x:600, y:270 , width:180, height:50);
                category_3_content_btn.font = NSFont.systemFont(ofSize: CGFloat(15))
                category_3_content_btn.tag = 33
                self.view.addSubview(category_3_content_btn)
                randam_or_fix_3.frame = CGRect(x:610, y:250 , width:75, height:20);
                randam_or_fix_3.stringValue = "固定表示"
                randam_or_fix_3.font = NSFont.systemFont(ofSize: CGFloat(15))
                randam_or_fix_3.isEditable = false
                randam_or_fix_3.isSelectable = false
                randam_or_fix_3.backgroundColor = NSColor.white
                self.view.addSubview(randam_or_fix_3)
                category_3_content.frame = CGRect(x:200, y:CATEGORY_CONTENT_START_Y - 200 , width:CATEGORY_CONTENT_WIDTH, height:CATEGORY_CONTENT_HEIGHT);
                category_3_content.stringValue = hint_content
                category_3_content.font =  NSFont.systemFont(ofSize: CGFloat(15))
                category_3_content.isEditable = false
                category_3_content.isSelectable = false
                category_3_content.backgroundColor = NSColor.white
                self.view.addSubview(category_3_content)
                randomFlag_3 = false
            }
            UserDefaults.standard.set(false, forKey: "return_from_List_Content_Combine_Random")
            UserDefaults.standard.synchronize()
        }
        //
        
        // Do view setup here.
        self.view.frame = CGRect(x: 50, y: 50 , width: 900, height: 550)
        
//        var theme_title = NSTextField()
//        theme_title.frame = CGRect(x:50, y:550 , width:100, height:50);
//        theme_title.stringValue = "テーマ"
//        theme_title.font = NSFont.systemFont(ofSize: CGFloat(30))
//        theme_title.isEditable = false
//        theme_title.isSelectable = false
//        theme_title.backgroundColor = NSColor.white
//        self.view.addSubview(theme_title)
        
        category_1.frame = CGRect(x:50, y:450 , width:100, height:50);
        UserDefaults.standard.register(defaults:["hint_theme_1" : "hint_theme_1"])
        var hint_theme_1 = UserDefaults.standard.object(forKey: "hint_theme_1") as! String
        category_1.stringValue = hint_theme_1
        m_randamo_hint_category_1 = hint_theme_1
        category_1.font = NSFont.systemFont(ofSize: CGFloat(15))
        category_1.isEditable = false
        category_1.isSelectable = false
        category_1.backgroundColor = NSColor.white
        self.view.addSubview(category_1)
        
        category_2.frame = CGRect(x:50, y:350 , width:100, height:50);
        UserDefaults.standard.register(defaults:["hint_theme_2" : "hint_theme_2"])
        var hint_theme_2 = UserDefaults.standard.object(forKey: "hint_theme_2") as! String
        category_2.stringValue = hint_theme_2
        m_randamo_hint_category_2 = hint_theme_2
        category_2.font = NSFont.systemFont(ofSize: CGFloat(15))
        category_2.isEditable = false
        category_2.isSelectable = false
        category_2.backgroundColor = NSColor.white
        self.view.addSubview(category_2)
        
        category_3.frame = CGRect(x:50, y:250 , width:100, height:50);
        UserDefaults.standard.register(defaults:["hint_theme_3" : "hint_theme_3"])
        var hint_theme_3 = UserDefaults.standard.object(forKey: "hint_theme_3") as! String
        category_3.stringValue = hint_theme_3
        m_randamo_hint_category_3 = hint_theme_3
        category_3.font = NSFont.systemFont(ofSize: CGFloat(15))
        category_3.isEditable = false
        category_3.isSelectable = false
        category_3.backgroundColor = NSColor.white
        self.view.addSubview(category_3)
        
        var category_1_btn = NSButton(title:"選択", target: self, action: #selector(category_select_click))
        category_1_btn.tag = 1
        category_1_btn.frame = CGRect(x:50, y:420 , width:50, height:30);
        category_1_btn.font = NSFont.systemFont(ofSize: CGFloat(10))
        self.view.addSubview(category_1_btn)
        
        var category_1_add_btn = NSButton(title:"追加", target: self, action: #selector(category_add_click))
        category_1_add_btn.tag = 1
        category_1_add_btn.frame = CGRect(x:105, y:420 , width:50, height:30);
        category_1_add_btn.font = NSFont.systemFont(ofSize: CGFloat(10))
        self.view.addSubview(category_1_add_btn)
        
        var category_2_btn = NSButton(title:"選択", target: self, action: #selector(category_select_click))
        category_2_btn.tag = 2
        category_2_btn.frame = CGRect(x:50, y:320 , width:50, height:30);
        category_2_btn.font = NSFont.systemFont(ofSize: CGFloat(10))
        self.view.addSubview(category_2_btn)
        
        var category_2_add_btn = NSButton(title:"追加", target: self, action: #selector(category_add_click))
        category_2_add_btn.tag = 2
        category_2_add_btn.frame = CGRect(x:105, y:320 , width:50, height:30);
        category_2_add_btn.font = NSFont.systemFont(ofSize: CGFloat(10))
        self.view.addSubview(category_2_add_btn)
        
        var category_3_btn = NSButton(title:"選択", target: self, action: #selector(category_select_click))
        category_3_btn.tag = 3
        category_3_btn.frame = CGRect(x:50, y:220 , width:50, height:30);
        category_3_btn.font = NSFont.systemFont(ofSize: CGFloat(10))
        self.view.addSubview(category_3_btn)
        
        var category_3_add_btn = NSButton(title:"追加", target: self, action: #selector(category_add_click))
        category_3_add_btn.tag = 3
        category_3_add_btn.frame = CGRect(x:105, y:220 , width:50, height:30);
        category_3_add_btn.font = NSFont.systemFont(ofSize: CGFloat(10))
        self.view.addSubview(category_3_add_btn)
        
        var think_idea = NSTextField()
        think_idea.frame = CGRect(x:50, y:150 , width:100, height:50);
        think_idea.stringValue = "思い付いた事\n考えた事など"
        think_idea.font = NSFont.systemFont(ofSize: CGFloat(15))
        think_idea.isEditable = false
        think_idea.isSelectable = false
        think_idea.backgroundColor = NSColor.white
        self.view.addSubview(think_idea)
        
//        var theme_title_content = NSTextField()
//        theme_title_content.frame = CGRect(x:200, y:550 , width:300, height:50);
//        theme_title_content.stringValue = "テーマ"
//        theme_title_content.font = NSFont.systemFont(ofSize: CGFloat(30))
//        theme_title_content.isEditable = false
//        theme_title_content.isSelectable = false
//        theme_title_content.backgroundColor = NSColor.white
//        self.view.addSubview(theme_title_content)
        
        randam_disp()
        
        think_idea_content.frame = CGRect(x:200, y:100 , width:CATEGORY_CONTENT_WIDTH, height:100);
        think_idea_content.stringValue = ""
        think_idea_content.font = NSFont.systemFont(ofSize: CGFloat(15))
        think_idea_content.isEditable = true
        think_idea_content.isSelectable = true
        think_idea_content.backgroundColor = NSColor.white
        self.view.addSubview(think_idea_content)
        
        category_1_content_btn.frame = CGRect(x:600, y:470 , width:180, height:50);
        category_1_content_btn.font = NSFont.systemFont(ofSize: CGFloat(15))
        category_1_content_btn.tag = 11
        self.view.addSubview(category_1_content_btn)
        if randomFlag_1 == true{
            randam_or_fix_1.frame = CGRect(x:610, y:450 , width:100, height:20);
            randam_or_fix_1.stringValue = "ランダム選択"
            randam_or_fix_1.font = NSFont.systemFont(ofSize: CGFloat(15))
            randam_or_fix_1.isEditable = false
            randam_or_fix_1.isSelectable = false
            randam_or_fix_1.backgroundColor = NSColor.white
            self.view.addSubview(randam_or_fix_1)
        }
        category_2_content_btn.frame = CGRect(x:600, y:370 , width:180, height:50);
        category_2_content_btn.font = NSFont.systemFont(ofSize: CGFloat(15))
        category_2_content_btn.tag = 22
        self.view.addSubview(category_2_content_btn)
        if randomFlag_2 == true{
            randam_or_fix_2.frame = CGRect(x:610, y:350 , width:100, height:20);
            randam_or_fix_2.stringValue = "ランダム選択"
            randam_or_fix_2.font = NSFont.systemFont(ofSize: CGFloat(15))
            randam_or_fix_2.isEditable = false
            randam_or_fix_2.isSelectable = false
            randam_or_fix_2.backgroundColor = NSColor.white
            self.view.addSubview(randam_or_fix_2)
        }
        category_3_content_btn.frame = CGRect(x:600, y:270 , width:180, height:50);
        category_3_content_btn.font = NSFont.systemFont(ofSize: CGFloat(15))
        category_3_content_btn.tag = 33
        self.view.addSubview(category_3_content_btn)
        if randomFlag_3 == true{
            randam_or_fix_3.frame = CGRect(x:610, y:250 , width:100, height:20);
            randam_or_fix_3.stringValue = "ランダム選択"
            randam_or_fix_3.font = NSFont.systemFont(ofSize: CGFloat(15))
            randam_or_fix_3.isEditable = false
            randam_or_fix_3.isSelectable = false
            randam_or_fix_3.backgroundColor = NSColor.white
            self.view.addSubview(randam_or_fix_3)
        }
        var randam_store_btn = NSButton(title: "ランダム&保存", target: self, action: #selector(randam_store_click))
        randam_store_btn.frame = CGRect(x: 190, y: 50 , width: 180, height: 50)
        randam_store_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(randam_store_btn)
        
        var index_btn = NSButton(title: "蓄積した一覧を表示", target: self, action: #selector(index_click))
        index_btn.frame = CGRect(x: 650, y: 50 , width: 220, height: 50)
        index_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(index_btn)
    }
    @objc func index_click(_ sender: NSButton) {
        self.dismiss(nil)
        let next = storyboard?.instantiateController(withIdentifier: "List_Combine_Random")
        self.presentAsModalWindow(next! as! NSViewController)
    }
    func randam_disp() {
        if randomFlag_1 {
            let dbSelect_1 = realm.objects(Hint_Db.self).filter("theme == %@",m_randamo_hint_category_1)
            let hintArray_1 = Array(dbSelect_1)
            let ranInt_1 = Int.random(in: 0 ... hintArray_1.count - 1)
            m_randamo_hint_1 = hintArray_1[ranInt_1].content as! String
            category_1_content.frame = CGRect(x:200, y:CATEGORY_CONTENT_START_Y , width:CATEGORY_CONTENT_WIDTH, height:CATEGORY_CONTENT_HEIGHT);
            category_1_content.stringValue = m_randamo_hint_1
            category_1_content.font = NSFont.systemFont(ofSize: CGFloat(15))
            category_1_content.isEditable = false
            category_1_content.isSelectable = false
            category_1_content.backgroundColor = NSColor.white
            self.view.addSubview(category_1_content)
        }
        if randomFlag_2 {
            let dbSelect_2 = realm.objects(Hint_Db.self).filter("theme == %@",m_randamo_hint_category_2)
            let hintArray_2 = Array(dbSelect_2)
            let ranInt_2 = Int.random(in: 0 ... hintArray_2.count - 1)
            m_randamo_hint_2 = hintArray_2[ranInt_2].content as! String
            category_2_content.frame = CGRect(x:200, y:CATEGORY_CONTENT_START_Y - 100 , width:CATEGORY_CONTENT_WIDTH, height:CATEGORY_CONTENT_HEIGHT);
            category_2_content.stringValue = m_randamo_hint_2
            category_2_content.font = NSFont.systemFont(ofSize: CGFloat(15))
            category_2_content.isEditable = false
            category_2_content.isSelectable = false
            category_2_content.backgroundColor = NSColor.white
            self.view.addSubview(category_2_content)
        }
        if randomFlag_3 {
            let dbSelect_3 = realm.objects(Hint_Db.self).filter("theme == %@",m_randamo_hint_category_3)
            let hintArray_3 = Array(dbSelect_3)
            let ranInt_3 = Int.random(in: 0 ... hintArray_3.count - 1)
            m_randamo_hint_3 = hintArray_3[ranInt_3].content as! String
            category_3_content.frame = CGRect(x:200, y:CATEGORY_CONTENT_START_Y - 200 , width:CATEGORY_CONTENT_WIDTH, height:CATEGORY_CONTENT_HEIGHT);
            category_3_content.stringValue = m_randamo_hint_3
            category_3_content.font = NSFont.systemFont(ofSize: CGFloat(15))
            category_3_content.isEditable = false
            category_3_content.isSelectable = false
            category_3_content.backgroundColor = NSColor.white
            self.view.addSubview(category_3_content)
        }
    }
    
    @objc func category_select_click(_ sender: NSButton) {
        UserDefaults.standard.set(sender.tag, forKey: "hint_theme_num")
        UserDefaults.standard.synchronize()
        self.dismiss(nil)
        let next = storyboard?.instantiateController(withIdentifier: "List_Theme_Combine_Random")
        self.presentAsModalWindow(next! as! NSViewController)
    }
    @objc func category_add_click(_ sender: NSButton) {
        let alert = NSAlert()
        alert.messageText = "ヒントカテゴリの入力"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "キャンセル")
        let category_label = NSTextField(frame: NSRect(x:0, y:110 , width:70, height:20))
        category_label.stringValue = "カテゴリ"
        let alert_textField_category = NSTextField(frame: NSRect(x: 0, y: 80, width: 500, height: 24))
        let content_label = NSTextField(frame: NSRect(x:0, y:50 , width:70, height:24))
        content_label.stringValue = "ヒント"
        let alert_textField_content = NSTextField(frame: NSRect(x: 0, y: 20, width: 500, height: 24))
        let stackViewer = NSStackView(frame: NSRect(x: 0, y: 0, width: 500, height: 150))
        stackViewer.addSubview(category_label)
        stackViewer.addSubview(alert_textField_category)
        stackViewer.addSubview(content_label)
        stackViewer.addSubview(alert_textField_content)
        
        alert.accessoryView = stackViewer

        let response = alert.runModal()
        switch response {
        case .alertFirstButtonReturn:
            if alert_textField_category.stringValue != "" && alert_textField_content.stringValue != ""{
                let exitstIt = realm.objects(Hint_Db.self).filter("theme == %@",alert_textField_category.stringValue).filter("content == %@",alert_textField_content.stringValue)
                if exitstIt.count == 0{
                    let hint_Db = Hint_Db()
                    hint_Db.theme  = alert_textField_category.stringValue
                    hint_Db.content = alert_textField_content.stringValue
                    try! realm.write() {
                        realm.add(hint_Db)
                    }
                    if sender.tag == 1{
                        category_1.stringValue = alert_textField_category.stringValue
                        UserDefaults.standard.set(alert_textField_category.stringValue, forKey: "hint_theme_1")
                        UserDefaults.standard.synchronize()
                        m_randamo_hint_category_1 = alert_textField_category.stringValue
                        category_1_content.stringValue = alert_textField_content.stringValue
                    }else if sender.tag == 2{
                        category_2.stringValue = alert_textField_category.stringValue
                        UserDefaults.standard.set(alert_textField_category.stringValue, forKey: "hint_theme_2")
                        UserDefaults.standard.synchronize()
                        m_randamo_hint_category_2 = alert_textField_category.stringValue
                        category_2_content.stringValue = alert_textField_content.stringValue
                    }else if sender.tag == 3{
                        category_3.stringValue = alert_textField_category.stringValue
                        UserDefaults.standard.set(alert_textField_category.stringValue, forKey: "hint_theme_3")
                        UserDefaults.standard.synchronize()
                        m_randamo_hint_category_3 = alert_textField_category.stringValue
                        category_3_content.stringValue = alert_textField_content.stringValue
                    }
                }else{
                    let alert = NSAlert()
                    alert.messageText = "重複したアイデアは登録出来ません。"
                    alert.addButton(withTitle: "OK")
                    let response = alert.runModal()
                }
            }else{
                let alert = NSAlert()
                alert.messageText = "カテゴリとヒントの両方入力してください。。"
                alert.addButton(withTitle: "OK")
                let response = alert.runModal()
            }

            break
        case .alertSecondButtonReturn:
            print("キャンセル")
            break
        default:
            break
        }
    }
    @objc func randam_store_click(_ sender: NSButton) {
        
        if think_idea_content.stringValue != ""{
            let exitstIt = realm.objects(Rnadom_Conb_Db.self).filter("think == %@",think_idea_content.stringValue)
            if exitstIt.count == 0{
                let rnadom_Conb_Db = Rnadom_Conb_Db()
                rnadom_Conb_Db.hint_1 = category_1_content.stringValue
                rnadom_Conb_Db.hint_2 = category_2_content.stringValue
                rnadom_Conb_Db.hint_3 = category_3_content.stringValue
                rnadom_Conb_Db.think  = think_idea_content.stringValue
                try! realm.write() {
                    realm.add(rnadom_Conb_Db)
                }
                randam_disp()
                think_idea_content.stringValue = ""
            }else{
                let alert = NSAlert()
                alert.messageText = "重複したアイデアは登録出来ません。"
                alert.addButton(withTitle: "OK")
                let response = alert.runModal()
            }
        }else{
            randam_disp()
        }
    }
    @objc func randam_or_fix_switch_click(_ sender: NSButton) {
        if sender.tag == 11{
            if randomFlag_1 == true{
                print("1_r")
            UserDefaults.standard.set(category_1.stringValue, forKey: "hint_category_for_serch")
                UserDefaults.standard.set(sender.tag, forKey: "hint_content_num")
                UserDefaults.standard.synchronize()
                self.dismiss(nil)
                let next = storyboard?.instantiateController(withIdentifier: "List_Content_Combine_Random")
                self.presentAsModalWindow(next! as! NSViewController)
            }else{
                print("1_f")
                for v in view.subviews {
                    if let v = v as? NSButton, v.tag == 11  {
                        v.removeFromSuperview()
                    }
                }
                category_1_content_btn = NSButton(title: "ヒントを選択して固定", target: self, action: #selector(randam_or_fix_switch_click))
                category_1_content_btn.frame = CGRect(x:600, y:470 , width:180, height:50);
                category_1_content_btn.font = NSFont.systemFont(ofSize: CGFloat(15))
                category_1_content_btn.tag = 11
                self.view.addSubview(category_1_content_btn)
                randam_or_fix_1.frame = CGRect(x:610, y:450 , width:100, height:20);
                randam_or_fix_1.stringValue = "ランダム選択"
                randam_or_fix_1.font = NSFont.systemFont(ofSize: CGFloat(15))
                randam_or_fix_1.isEditable = false
                randam_or_fix_1.isSelectable = false
                randam_or_fix_1.backgroundColor = NSColor.white
                self.view.addSubview(randam_or_fix_1)
                randomFlag_1 = true
            }
        }else if sender.tag == 22{
            if randomFlag_2 == true{
                print("2_r")
            UserDefaults.standard.set(category_2.stringValue, forKey: "hint_category_for_serch")
                UserDefaults.standard.set(sender.tag, forKey: "hint_content_num")
                UserDefaults.standard.synchronize()
                self.dismiss(nil)
                let next = storyboard?.instantiateController(withIdentifier: "List_Content_Combine_Random")
                self.presentAsModalWindow(next! as! NSViewController)
            }else{
                print("2_f")
                for v in view.subviews {
                    if let v = v as? NSButton, v.tag == 22  {
                        v.removeFromSuperview()
                    }
                }
                category_2_content_btn = NSButton(title: "ヒントを選択して固定", target: self, action: #selector(randam_or_fix_switch_click))
                category_2_content_btn.frame = CGRect(x:600, y:370 , width:180, height:50);
                category_2_content_btn.font = NSFont.systemFont(ofSize: CGFloat(15))
                category_2_content_btn.tag = 22
                self.view.addSubview(category_2_content_btn)
                randam_or_fix_2.frame = CGRect(x:610, y:350 , width:100, height:20);
                randam_or_fix_2.stringValue = "ランダム選択"
                randam_or_fix_2.font = NSFont.systemFont(ofSize: CGFloat(15))
                randam_or_fix_2.isEditable = false
                randam_or_fix_2.isSelectable = false
                randam_or_fix_2.backgroundColor = NSColor.white
                self.view.addSubview(randam_or_fix_2)
                randomFlag_2 = true
            }
        }else if sender.tag == 33{
            if randomFlag_3 == true{
                print("3_r")
            UserDefaults.standard.set(category_3.stringValue, forKey: "hint_category_for_serch")
                    UserDefaults.standard.synchronize()
                UserDefaults.standard.set(sender.tag, forKey: "hint_content_num")
                self.dismiss(nil)
                let next = storyboard?.instantiateController(withIdentifier: "List_Content_Combine_Random")
                self.presentAsModalWindow(next! as! NSViewController)
            }else{
                print("3_f")
                for v in view.subviews {
                    if let v = v as? NSButton, v.tag == 33  {
                        v.removeFromSuperview()
                    }
                }
                category_3_content_btn = NSButton(title: "ヒントを選択して固定", target: self, action: #selector(randam_or_fix_switch_click))
                category_3_content_btn.frame = CGRect(x:600, y:270 , width:180, height:50);
                category_3_content_btn.font = NSFont.systemFont(ofSize: CGFloat(15))
                category_3_content_btn.tag = 33
                self.view.addSubview(category_3_content_btn)
                randam_or_fix_3.frame = CGRect(x:610, y:250 , width:100, height:20);
                randam_or_fix_3.stringValue = "ランダム選択"
                randam_or_fix_3.font = NSFont.systemFont(ofSize: CGFloat(15))
                randam_or_fix_3.isEditable = false
                randam_or_fix_3.isSelectable = false
                randam_or_fix_3.backgroundColor = NSColor.white
                self.view.addSubview(randam_or_fix_3)
                randomFlag_3 = true
            }
        }
    }

}
