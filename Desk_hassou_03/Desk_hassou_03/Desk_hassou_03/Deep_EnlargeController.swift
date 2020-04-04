//
//  Deep_EnlargeController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/04/03.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Deep_EnlargeController: NSViewController {

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
    var this_count = NSTextField()
    var total_count = NSTextField()
    var next_disp_btn = NSButton()
    var return_disp_btn = NSButton()
    var randam_store_btn = NSButton()
    var hint_category_select_btn = NSButton()
     var return_page_btn = NSButton()
    
//    var theme_change_btn = NSButton()
//    var theme_select_btn = NSButton()

    var hintArray:[Hint_Db] = []
    var ideaArray:[Deep_Enlarge_Db] = []
    
    var m_theme = ""
    var m_parent_category = ""
    var m_child_category = ""
    var m_level = ""
    var this_is_theme = false
    
    override func viewDidLoad() {
//        print("56")
        super.viewDidLoad()
        m_hint_category = UserDefaults.standard.object(forKey: "mHintCategory") as! String

        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        
//        let ideaSelect = realm.objects(Deep_Enlarge_Db.self).filter("theme == %@",m_theme)
//        print(ideaSelect)
//        exit(0)
        
        m_parent_category = UserDefaults.standard.object(forKey: "parent_category") as! String
//        print("m_parent_category")
//        print(m_parent_category)
        m_child_category = UserDefaults.standard.object(forKey: "child_category") as! String

//        print("64")

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
        
//        print("87")
        
        var arr:[String] = m_parent_category.components(separatedBy: ":")
        if arr[0] != "[THEME]"{
//            print("91")
            ordering_idea_title.frame = CGRect(x:20, y:490 , width:250, height:30);
            ordering_idea_title.stringValue = arr[1]
            ordering_idea_title.font = NSFont.systemFont(ofSize: CGFloat(20))
            ordering_idea_title.isEditable = false
            ordering_idea_title.isSelectable = false
            ordering_idea_title.backgroundColor = NSColor.white
            self.view.addSubview(ordering_idea_title)
            m_level = arr[0]
            random_disp(tag: "IDEA")
            
            return_disp_btn = NSButton(title: "前へ", target: self, action: #selector(return_disp_click))
            return_disp_btn.frame = CGRect(x: 330, y: 480 , width: 80, height: 50)
            return_disp_btn.font = NSFont.systemFont(ofSize: 22)
            view.self.addSubview(return_disp_btn)
            
            next_disp_btn = NSButton(title: "次へ", target: self, action: #selector(next_disp_click))
            next_disp_btn.frame = CGRect(x: 410, y: 480 , width: 80, height: 50)
            next_disp_btn.font = NSFont.systemFont(ofSize: 22)
            view.self.addSubview(next_disp_btn)
//            print("111")
            idea_count_disp()
//            print("113")
        }else{
            this_is_theme = true
        }
            
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
        
        idea_title.frame = CGRect(x:20, y:180 , width:250, height:30);
        idea_title.stringValue = m_child_category
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
        
        return_page_btn = NSButton(title: "戻る", target: self, action: #selector(return_page_click))
        return_page_btn.frame = CGRect(x: 20, y: 0 , width: 100, height: 50)
        return_page_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(return_page_btn)
        
//        print("149")
        
        random_disp(tag: "HINT")
//        print("152")
        
//        print("154")
        this_count_disp()
        total_count_disp()
//        print("157")
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
            element_disp()
        }
    }
    
    @objc func return_page_click(_ sender: NSButton) {
        UserDefaults.standard.set("Deep_Enlarge_Pre", forKey: "to_page")
        UserDefaults.standard.synchronize()
        let next = storyboard?.instantiateController(withIdentifier: "List")
        self.presentAsModalWindow(next! as! NSViewController)
        self.dismiss(nil)
    }
    @objc func next_disp_click(_ sender: NSButton) {
        if m_idea_num < m_idea_total_num - 1{
            m_idea_num = m_idea_num + 1
            if this_is_theme == false{
                element_disp()
                idea_count_disp()
            }
            this_count_disp()
            total_count_disp()
            random_disp(tag: "HINT")
        }
    }
    @objc func return_disp_click(_ sender: NSButton) {
        if m_idea_num > 0{
            m_idea_num = m_idea_num - 1
            if this_is_theme == false{
                element_disp()
                idea_count_disp()
            }
            this_count_disp()
            total_count_disp()
            random_disp(tag: "HINT")
        }
    }
    func this_count_disp(){
        var ideaSelect_count = -99
        let dummy = realm.objects(Deep_Enlarge_Db.self).filter("theme == %@",m_theme)
        print("dummy")
        print(dummy)
        if m_level == ""{
            print("228")
            var arr:[String] = m_child_category.components(separatedBy: ":")
            print("m_theme")
            print(m_theme)
            print("m_child_category")
            print(m_child_category)
            let ideaSelect = realm.objects(Deep_Enlarge_Db.self).filter("theme == %@",m_theme).filter("category_1 == %@",m_child_category).filter("category_2 == %@","")
            ideaSelect_count = ideaSelect.count
        }else{
            print("233")
            var serch_parent_category = "category_" + m_level
            var serch_child_category = "category_" + String(Int(m_level)! + 1)
            var serch_parent_idea = "idea_" + m_level
            var arr:[String] = m_parent_category.components(separatedBy: ":")
            print("m_theme")
            print(m_theme)
            print("serch_parent_category")
            print(serch_parent_category)
            print("arr[1]")
            print(arr[1])
            print("serch_child_category")
            print(serch_child_category)
            print("m_child_category")
            print(m_child_category)
//            var arr_2:[String] = m_child_category.components(separatedBy: ":")
            let ideaSelect = realm.objects(Deep_Enlarge_Db.self).filter("theme == %@",m_theme).filter(serch_parent_category + " == %@",arr[1]).filter(serch_parent_idea + " == %@",ordering_idea_content.stringValue).filter(serch_child_category + " == %@",m_child_category)
            ideaSelect_count = ideaSelect.count
        }
        this_count.frame = CGRect(x:280, y:170 , width:100, height:35);
        this_count.stringValue = "個別:" + String(ideaSelect_count)
        this_count.font = NSFont.systemFont(ofSize: CGFloat(20))
        this_count.isEditable = false
        this_count.isSelectable = false
        this_count.isBordered = false
        this_count.backgroundColor = NSColor.white
        self.view.addSubview(this_count)
    }
    func total_count_disp(){
        let ideaSelect = realm.objects(Deep_Enlarge_Db.self).filter("theme == %@",m_theme)
        total_count.frame = CGRect(x:370, y:170 , width:100, height:35);
        total_count.stringValue = "合計:" + String(ideaSelect.count)
        total_count.font = NSFont.systemFont(ofSize: CGFloat(20))
        total_count.isEditable = false
        total_count.isSelectable = false
        total_count.isBordered = false
        total_count.backgroundColor = NSColor.white
        self.view.addSubview(total_count)
    }
    func element_disp(){
//        print("251")
        var serch_category = "category_" + m_level
        var serch_idea = "idea_" + m_level
        var serch_child_category = "category_" + String(Int(m_level)! + 1)
        var arr:[String] = m_parent_category.components(separatedBy: ":")
        let dbSelect = realm.objects(Deep_Enlarge_Db.self).filter("theme == %@",m_theme).filter(serch_category + " == %@",arr[1]).filter(serch_child_category + " == %@","")
//        print("251")
        ideaArray = Array(dbSelect)
        
        var local_chiled_idea = ""
        if m_level == "1"{
            local_chiled_idea = ideaArray[m_idea_num].idea_1
        }else if m_level == "2"{
            local_chiled_idea = ideaArray[m_idea_num].idea_2
        }else if m_level == "3"{
            local_chiled_idea = ideaArray[m_idea_num].idea_3
        }else if m_level == "4"{
            local_chiled_idea = ideaArray[m_idea_num].idea_4
        }else if m_level == "5"{
            local_chiled_idea = ideaArray[m_idea_num].idea_5
        }else if m_level == "6"{
            local_chiled_idea = ideaArray[m_idea_num].idea_6
        }else if m_level == "7"{
            local_chiled_idea = ideaArray[m_idea_num].idea_7
        }else if m_level == "8"{
            local_chiled_idea = ideaArray[m_idea_num].idea_8
        }else if m_level == "9"{
            local_chiled_idea = ideaArray[m_idea_num].idea_9
        }
//        print("279")
        var word_2 = ""
        var char_count_4 = 0
        for one in local_chiled_idea{
            if char_count_4 % 30 == 0 && char_count_4 != 0{
                word_2 = word_2 + "\n" + String(one)
            }else{
                word_2 = word_2 + String(one)
            }
            char_count_4 = char_count_4 + 1
        }
//        print("290")
        ordering_idea_content.stringValue = word_2
        ordering_idea_content.frame = CGRect(x:20, y:370 , width:430, height:100);
        ordering_idea_content.font = NSFont.systemFont(ofSize: CGFloat(15))
        ordering_idea_content.isEditable = false
        ordering_idea_content.isSelectable = false
        ordering_idea_content.isBordered = false
        ordering_idea_content.backgroundColor = NSColor.white
        self.view.addSubview(ordering_idea_content)
//        print("299")
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
            var exist_count =  -99
            if m_level == ""{
                var exitstIt = realm.objects(Deep_Enlarge_Db.self).filter("theme == %@",theme_content.stringValue).filter("category_1 == %@",m_child_category).filter("idea_1 == %@",idea_input.stringValue)
                exist_count = exitstIt.count
            }else{
                var serch_parent_category = "category_" + m_level
                var serch_child_category = "category_" + String(Int(m_level)! + 1)
                var serch_parent_idea = "idea_" + m_level
                var serch_child_idea = "idea_" + String(Int(m_level)! + 1)
                var arr:[String] = m_parent_category.components(separatedBy: ":")
                var exitstIt = realm.objects(Deep_Enlarge_Db.self).filter("theme == %@",theme_content.stringValue).filter(serch_parent_category + " == %@",arr[1]).filter(serch_parent_idea + " == %@",ordering_idea_content.stringValue).filter(serch_child_category + " == %@",m_child_category).filter(serch_child_idea + " == %@",idea_input.stringValue)
                exist_count = exitstIt.count
            }
            if exist_count == 0{
                let deep_enlarge_eb = Deep_Enlarge_Db()
                deep_enlarge_eb.theme  = theme_content.stringValue
                var arr:[String] = m_parent_category.components(separatedBy: ":")
                if m_level == ""{
                    deep_enlarge_eb.category_1 = m_child_category
                    deep_enlarge_eb.hint_1 = hint_content.stringValue
                    deep_enlarge_eb.idea_1 = idea_input.stringValue
                }else if m_level == "1"{
                    deep_enlarge_eb.category_1 = arr[1]
                    deep_enlarge_eb.idea_1 = ordering_idea_content.stringValue
                    deep_enlarge_eb.category_2 = m_child_category
                    deep_enlarge_eb.hint_2 = hint_content.stringValue
                    deep_enlarge_eb.idea_2 = idea_input.stringValue
                }else if m_level == "2"{
                    deep_enlarge_eb.category_2 = arr[1]
                    deep_enlarge_eb.idea_2 = ordering_idea_title.stringValue
                    deep_enlarge_eb.category_3 = m_child_category
                    deep_enlarge_eb.hint_3 = hint_content.stringValue
                    deep_enlarge_eb.idea_3 = idea_input.stringValue
                }else if m_level == "3"{
                    deep_enlarge_eb.category_3 = arr[1]
                    deep_enlarge_eb.idea_3 = ordering_idea_title.stringValue
                    deep_enlarge_eb.category_4 = m_child_category
                    deep_enlarge_eb.hint_4 = hint_content.stringValue
                    deep_enlarge_eb.idea_4 = idea_input.stringValue
                }else if m_level == "4"{
                    deep_enlarge_eb.category_4 = arr[1]
                    deep_enlarge_eb.idea_4 = ordering_idea_title.stringValue
                    deep_enlarge_eb.category_5 = m_child_category
                    deep_enlarge_eb.hint_5 = hint_content.stringValue
                    deep_enlarge_eb.idea_5 = idea_input.stringValue
                }else if m_level == "5"{
                    deep_enlarge_eb.category_5 = arr[1]
                    deep_enlarge_eb.idea_5 = ordering_idea_title.stringValue
                    deep_enlarge_eb.category_6 = m_child_category
                    deep_enlarge_eb.hint_6 = hint_content.stringValue
                    deep_enlarge_eb.idea_6 = idea_input.stringValue
                }else if m_level == "6"{
                    deep_enlarge_eb.category_6 = arr[1]
                    deep_enlarge_eb.idea_6 = ordering_idea_title.stringValue
                    deep_enlarge_eb.category_7 = m_child_category
                    deep_enlarge_eb.hint_7 = hint_content.stringValue
                    deep_enlarge_eb.idea_7 = idea_input.stringValue
                }else if m_level == "7"{
                    deep_enlarge_eb.category_7 = arr[1]
                    deep_enlarge_eb.idea_7 = ordering_idea_title.stringValue
                    deep_enlarge_eb.category_8 = m_child_category
                    deep_enlarge_eb.hint_8 = hint_content.stringValue
                    deep_enlarge_eb.idea_8 = idea_input.stringValue
                }else if m_level == "8"{
                    deep_enlarge_eb.category_8 = arr[1]
                    deep_enlarge_eb.idea_8 = ordering_idea_title.stringValue
                    deep_enlarge_eb.category_9 = m_child_category
                    deep_enlarge_eb.hint_9 = hint_content.stringValue
                    deep_enlarge_eb.idea_9 = idea_input.stringValue
                }else if m_level == "9"{
                    deep_enlarge_eb.category_9 = arr[1]
                    deep_enlarge_eb.idea_9 = ordering_idea_title.stringValue
                    deep_enlarge_eb.category_10 = m_child_category
                    deep_enlarge_eb.hint_10 = hint_content.stringValue
                    deep_enlarge_eb.idea_10 = idea_input.stringValue
                }
                try! realm.write() {
                    realm.add(deep_enlarge_eb)
                }
                this_count_disp()
                total_count_disp()
                idea_input.stringValue = ""
                random_disp(tag: "HINT")
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
        var serch_category = "category_" + m_level
        var serch_idea = "idea_" + m_level
        var serch_child_category = "category_" + String(Int(m_level)! + 1)
        var arr:[String] = m_parent_category.components(separatedBy: ":")
        print("m_theme")
        print(m_theme)
        print("serch_category")
        print(serch_category)
        print("arr[1]")
        print(arr[1])
        print("serch_idea")
        print(serch_idea)
        print("ordering_idea_content.stringValue")
        print(ordering_idea_content.stringValue)
        
        let ideaSelect = realm.objects(Deep_Enlarge_Db.self).filter("theme == %@",m_theme).filter(serch_category + " == %@",arr[1]).filter(serch_child_category + " == %@","")
        theme_idea_count.frame = CGRect(x:280, y:468 , width:50, height:50);
        m_idea_total_num = ideaSelect.count
        theme_idea_count.stringValue = String(m_idea_num + 1) + " / " + String(ideaSelect.count)
        theme_idea_count.font = NSFont.systemFont(ofSize: CGFloat(20))
        theme_idea_count.isEditable = false
        theme_idea_count.isSelectable = false
        theme_idea_count.isBordered = false
        theme_idea_count.backgroundColor = NSColor.white
        self.view.addSubview(theme_idea_count)
    }
}

