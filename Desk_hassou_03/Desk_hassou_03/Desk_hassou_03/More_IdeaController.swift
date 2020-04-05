//
//  More_IdeaController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/04/02.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//
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

class More_IdeaController: NSViewController {

    var m_hint_category = ""
    
    var m_idea_num = 0
    
    var m_idea_total_num = 0
    
    let realm = try! Realm()
    
    var theme_title = NSTextField()
    var theme_content = NSTextField()

    var ordering_idea_title = NSTextField()
    var ordering_idea_content = NSTextField()
    
    var hint_title = NSTextField()
    var hint_content = NSTextField()

    var idea_title = NSTextField()
    var idea_input = NSTextField()

    var theme_idea_count = NSTextField()
    var more_idea_count = NSTextField()
    var more_idea_total_count = NSTextField()
    var next_disp_btn = NSButton()
    var return_disp_btn = NSButton()
    var randam_store_btn = NSButton()
    var hint_category_select_btn = NSButton()
    var exit_btn = NSButton()
//    var theme_change_btn = NSButton()
//    var theme_select_btn = NSButton()

    var hintArray:[Hint_Db] = []
    var ideaArray:[Idea_Stock] = []
    
    var m_theme = ""
    var m_from_page = ""
    var nine_x_nine_idea:[String] = []
    var m_first_flag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_from_page = UserDefaults.standard.object(forKey: "from_page") as! String
        if m_from_page == "Flows_Progress"{
            m_theme = UserDefaults.standard.object(forKey: "selected_theme") as! String
        }else{
            m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        }
        m_hint_category = UserDefaults.standard.object(forKey: "mHintCategory") as! String
        
        self.view.frame = CGRect(x:10, y:10 , width:500, height:675);
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        theme_title.frame = CGRect(x:20, y:610 , width:100, height:30);
        theme_title.stringValue = "テーマ"
        theme_title.font = NSFont.systemFont(ofSize: CGFloat(20))
        theme_title.isEditable = false
        theme_title.isSelectable = false
        theme_title.backgroundColor = NSColor.white
        self.view.addSubview(theme_title)
        
        theme_content.frame = CGRect(x:20, y:550 , width:400, height:50);
        theme_content.stringValue = m_theme
        theme_content.font = NSFont.systemFont(ofSize: CGFloat(20))
        theme_content.isEditable = false
        theme_content.isSelectable = false
        theme_content.isBordered = false
        theme_content.backgroundColor = NSColor.white
        self.view.addSubview(theme_content)
        
        ordering_idea_title.frame = CGRect(x:20, y:490 , width:100, height:30);
        ordering_idea_title.stringValue = "アイデア"
        ordering_idea_title.font = NSFont.systemFont(ofSize: CGFloat(20))
        ordering_idea_title.isEditable = false
        ordering_idea_title.isSelectable = false
        ordering_idea_title.backgroundColor = NSColor.white
        self.view.addSubview(ordering_idea_title)
        
        random_disp(tag: "IDEA")
        
        return_disp_btn = NSButton(title: "前へ", target: self, action: #selector(return_disp_click))
        return_disp_btn.frame = CGRect(x: 330, y: 480 , width: 80, height: 50)
        return_disp_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(return_disp_btn)
        
        next_disp_btn = NSButton(title: "次へ", target: self, action: #selector(next_disp_click))
        next_disp_btn.frame = CGRect(x: 410, y: 480 , width: 80, height: 50)
        next_disp_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(next_disp_btn)
        
        hint_title.frame = CGRect(x:20, y:340 , width:100, height:30);
        hint_title.stringValue = "ヒント"
        hint_title.font = NSFont.systemFont(ofSize: CGFloat(20))
        hint_title.isEditable = false
        hint_title.isSelectable = false
        hint_title.backgroundColor = NSColor.white
        self.view.addSubview(hint_title)
        
        hint_category_select_btn = NSButton(title: "ヒントカテゴリ選択", target: self, action: #selector(hint_category_select_click))
        hint_category_select_btn.frame = CGRect(x: 140, y: 330 , width: 200, height: 50)
        hint_category_select_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(hint_category_select_btn)
        
        idea_title.frame = CGRect(x:20, y:180 , width:150, height:30);
        idea_title.stringValue = "更なるアイデア"
        idea_title.font = NSFont.systemFont(ofSize: CGFloat(20))
        idea_title.isEditable = false
        idea_title.isSelectable = false
        idea_title.backgroundColor = NSColor.white
        self.view.addSubview(idea_title)
        
        idea_input.frame = CGRect(x:20, y:70 , width:400, height:100);
        idea_input.stringValue = ""
        idea_input.font = NSFont.systemFont(ofSize: CGFloat(20))
        idea_input.backgroundColor = NSColor.white
        self.view.addSubview(idea_input)
        
        randam_store_btn = NSButton(title: "ランダム&保存", target: self, action: #selector(randam_store_click))
        randam_store_btn.frame = CGRect(x: 300, y: 0 , width: 180, height: 50)
        randam_store_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(randam_store_btn)
        
        if m_from_page == "Flows_Progress"{
            exit_btn = NSButton(title: "終了", target: self, action: #selector(exit_click))
            exit_btn.frame = CGRect(x: 20, y: 0 , width: 180, height: 50)
            exit_btn.font = NSFont.systemFont(ofSize: 22)
            view.self.addSubview(exit_btn)
        }
        
        random_disp(tag: "HINT")
        idea_count_disp()
        more_idea_count_disp()
        more_idea_total_count_disp()
    }
    func random_disp(tag:String){
        if tag == "HINT"{
            let dbSelect = realm.objects(Hint_Db.self).filter("theme == %@",m_hint_category)
            hintArray = Array(dbSelect)
            let ranInt_2 = Int.random(in: 0 ... hintArray.count - 1)
            hint_content.lineBreakMode = .byWordWrapping
            hint_content.maximumNumberOfLines = 0
            var word_2 = ""
            var char_count_4 = 0
            for one in hintArray[ranInt_2].content{
                if char_count_4 % 30 == 0 && char_count_4 != 0{
                    word_2 = word_2 + "\n" + String(one)
                }else{
                    word_2 = word_2 + String(one)
                }
                char_count_4 = char_count_4 + 1
            }
            hint_content.stringValue = word_2
            hint_content.frame = CGRect(x: 20, y: 220 , width: 430, height: 100)
            if hintArray[ranInt_2].content.count < 10{
                hint_content.font = NSFont.systemFont(ofSize: CGFloat(20))
            }else{
                hint_content.font = NSFont.systemFont(ofSize: CGFloat(15))
            }
            hint_content.isBordered = false
            hint_content.isEditable = false
            hint_content.isBordered = false
            view.self.addSubview(hint_content)
        }else if tag == "IDEA"{
            idea_disp()
        }
    }
    @objc func exit_click(_ sender: NSButton) {
            let next = storyboard?.instantiateController(withIdentifier: "Flows_Progress")
            self.presentAsModalWindow(next! as! NSViewController)
            self.dismiss(nil)
    }
    @objc func next_disp_click(_ sender: NSButton) {
        print("m_idea_num")
        print(m_idea_num)
        print("m_idea_total_num")
        print(m_idea_total_num)
        if m_idea_num < m_idea_total_num - 1{
            m_idea_num = m_idea_num + 1
            idea_disp()
            idea_count_disp()
            more_idea_count_disp()
            more_idea_total_count_disp()
            random_disp(tag: "HINT")
        }
    }
    @objc func return_disp_click(_ sender: NSButton) {
        if m_idea_num > 0{
            m_idea_num = m_idea_num - 1
            idea_disp()
            idea_count_disp()
            more_idea_count_disp()
            more_idea_total_count_disp()
            random_disp(tag: "HINT")
        }
    }
    func more_idea_count_disp(){
        var ideaSelect_count = -999
        let ideaSelect = realm.objects(More_Idea_Stock_1.self).filter("theme == %@",theme_content.stringValue).filter("idea == %@",ordering_idea_content.stringValue)
        ideaSelect_count = ideaSelect.count
        more_idea_count.frame = CGRect(x:270, y:170 , width:100, height:35);
        more_idea_count.stringValue = "個別:" + String(ideaSelect_count)
        more_idea_count.font = NSFont.systemFont(ofSize: CGFloat(20))
        more_idea_count.isEditable = false
        more_idea_count.isSelectable = false
        more_idea_count.isBordered = false
        more_idea_count.backgroundColor = NSColor.white
        self.view.addSubview(more_idea_count)
    }
    func more_idea_total_count_disp(){
        let ideaSelect = realm.objects(More_Idea_Stock_1.self).filter("theme == %@",theme_content.stringValue)
        more_idea_total_count.frame = CGRect(x:370, y:170 , width:100, height:35);
        more_idea_total_count.stringValue = "合計:" + String(ideaSelect.count)
        more_idea_total_count.font = NSFont.systemFont(ofSize: CGFloat(20))
        more_idea_total_count.isEditable = false
        more_idea_total_count.isSelectable = false
        more_idea_total_count.isBordered = false
        more_idea_total_count.backgroundColor = NSColor.white
        self.view.addSubview(more_idea_total_count)
    }
    func idea_disp(){
        var word_2 = ""
        if m_from_page == "Flows_Progress"{
            // Nine_x_Nine_Stockからアイデアを84個、取得する
            if m_first_flag == true{
                for x in 0..<9{
                    for y in 0..<9{
                        var flag = false
                        for i in 0..<3{
                            for j in 0..<3{
                                if x == 1 + i * 3 && y == 1 + j * 3{
                                    flag = true
                                }
                            }
                        }
                        if flag == false{
                            let dbSelect = realm.objects(Nine_x_Nine_Stock.self).filter("y4_x4 == %@",m_theme).value(forKey: "y" + String(y) + "_x" + String(x)) as! [String]
                            if dbSelect[0] != ""{
                                nine_x_nine_idea.append(dbSelect[0])
                            }
                        }
                    }
                }
                m_first_flag = false
            }
            print("nine_x_nine_idea")
            print(nine_x_nine_idea)
            print("m_idea_num")
            print(m_idea_num)
            var char_count_4 = 0
            for one in nine_x_nine_idea[m_idea_num]{
                if char_count_4 % 30 == 0 && char_count_4 != 0{
                    word_2 = word_2 + "\n" + String(one)
                }else{
                    word_2 = word_2 + String(one)
                }
                char_count_4 = char_count_4 + 1
            }
        }else{
            let dbSelect = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme)
            ideaArray = Array(dbSelect)
            var char_count_4 = 0
            for one in ideaArray[m_idea_num].idea{
                if char_count_4 % 30 == 0 && char_count_4 != 0{
                    word_2 = word_2 + "\n" + String(one)
                }else{
                    word_2 = word_2 + String(one)
                }
                char_count_4 = char_count_4 + 1
            }
        }

        ordering_idea_content.stringValue = word_2
        ordering_idea_content.frame = CGRect(x:20, y:370 , width:430, height:100);
        ordering_idea_content.font = NSFont.systemFont(ofSize: CGFloat(15))
        ordering_idea_content.isEditable = false
        ordering_idea_content.isSelectable = false
        ordering_idea_content.isBordered = false
        ordering_idea_content.backgroundColor = NSColor.white
        self.view.addSubview(ordering_idea_content)
    }
    @objc func hint_category_select_click(_ sender: NSButton) {
            UserDefaults.standard.set("Hint_Category_List", forKey: "to_page")
            UserDefaults.standard.synchronize()
            let next = storyboard?.instantiateController(withIdentifier: "List")
            self.presentAsModalWindow(next! as! NSViewController)
            self.dismiss(nil)
    }
    @objc func randam_store_click(_ sender: NSButton) {
        if idea_input.stringValue != ""{
            let exitstIt = realm.objects(More_Idea_Stock_1.self).filter("theme == %@",theme_content.stringValue).filter("idea == %@",ordering_idea_content.stringValue).filter("more_idea_1 == %@",idea_input.stringValue)
            if exitstIt.count == 0{
                let more_idea_stock_1 = More_Idea_Stock_1()
                more_idea_stock_1.theme  = theme_content.stringValue
                more_idea_stock_1.hint = hint_content.stringValue
                more_idea_stock_1.idea = ordering_idea_content.stringValue
                more_idea_stock_1.more_idea_1 = idea_input.stringValue
                try! realm.write() {
                    realm.add(more_idea_stock_1)
                }
                random_disp(tag: "HINT")
                more_idea_count_disp()
                more_idea_total_count_disp()
                idea_input.stringValue = ""
            }else{
                let alert = NSAlert()
                alert.messageText = "重複したアイデアは登録出来ません。"
                alert.addButton(withTitle: "OK")
                let response = alert.runModal()
            }
        }else{
            random_disp(tag: "HINT")
        }
    }

    func idea_count_disp(){
        if theme_content.stringValue != ""{
            if m_from_page == "Flows_Progress"{
                m_idea_total_num = nine_x_nine_idea.count
            }else{
                let ideaSelect = realm.objects(Idea_Stock.self).filter("theme == %@",theme_content.stringValue)
                m_idea_total_num = ideaSelect.count
            }
            theme_idea_count.frame = CGRect(x:220, y:468 , width:100, height:50);
            theme_idea_count.stringValue = String(m_idea_num + 1) + " / " + String(m_idea_total_num)
            theme_idea_count.font = NSFont.systemFont(ofSize: CGFloat(20))
            theme_idea_count.isEditable = false
            theme_idea_count.isSelectable = false
            theme_idea_count.isBordered = false
            theme_idea_count.backgroundColor = NSColor.white
            self.view.addSubview(theme_idea_count)
        }
    }
}
