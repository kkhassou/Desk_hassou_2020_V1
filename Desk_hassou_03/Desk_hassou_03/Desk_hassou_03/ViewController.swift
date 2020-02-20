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

    var mHintCategory = ""
    
    let realm = try! Realm()
    
    var theme_title = NSTextField()
    var theme_change_btn = NSButton()
    var theme_select_btn = NSButton()
    var theme_content = NSTextField()
    var theme_idea_count = NSTextField()
    var hint_title = NSTextField()
    var hint_content = NSTextField()
    var idea_title = NSTextField()
    var idea_input = NSTextField()
    var randam_store_btn = NSButton()
    var hintArray:[Hint_Db] = []
    override func viewDidLoad() {
        mHintCategory = UserDefaults.standard.object(forKey: "mHintCategory") as! String
        // 内容を一覧するためにの処理。不要な時はfalseにしておく。
        if true{
            let stocks = realm.objects(Nine_x_Nine_Stock.self)
            if stocks.count == 0{
                print("NO Nine_x_Nine_Stock")
            }else{
                for one in stocks{
                    print(one.y4_x4)
                }
            }
        }
        if false{
            let stocks = realm.objects(Nine_x_Nine_Stock.self)
            try! realm.write {
                realm.delete(stocks)
            }

        }
        if false{
            let stocks = realm.objects(Idea_Stock.self)
            var temp:[String] = []
            for one in stocks{
                temp.append(one.theme)
            }
            let orderedSet = NSOrderedSet(array: temp)
            let uniques = orderedSet.array as! [String]
            var temp_2:[Idea_Stock] = []
            for one_stocks in stocks{
                var reFlag = false
                for temp_2_one in temp_2{
                    if temp_2_one.idea == one_stocks.idea
                        && temp_2_one.theme == one_stocks.theme{
                        reFlag = true
                    }
                }
                if reFlag == false{
                    temp_2.append(one_stocks)
                }
            }
            for one_uniques in uniques{
                print("------------------------------")
                print("theme:" + one_uniques)
                for one_temp_2 in temp_2{
                    if one_uniques == one_temp_2.theme{
                        print("・" + one_temp_2.idea)
                    }
                }
            }
        }
        // DB関係の操作
        if false{
            var hint_Db_s :[Hint_Db] = []
            for one in simple_hint_1{
                let hint_Db = Hint_Db()
                hint_Db.theme = simple_hint_1_theme
                hint_Db.content  = one
                hint_Db_s.append(hint_Db)
            }
            for one in triz_1{
                let hint_Db = Hint_Db()
                hint_Db.theme = triz_1_theme
                hint_Db.content  = one
                hint_Db_s.append(hint_Db)
            }
            for one in braneStearing_1{
                let hint_Db = Hint_Db()
                hint_Db.theme = braneStearing_1_theme
                hint_Db.content  = one
                hint_Db_s.append(hint_Db)
            }
            for one in osborneChecklist_1{
                let hint_Db = Hint_Db()
                hint_Db.theme = osborneChecklist_1_theme
                hint_Db.content  = one
                hint_Db_s.append(hint_Db)
            }
            for one in not_related_hint_1{
                let hint_Db = Hint_Db()
                hint_Db.theme = not_related_hint_1_theme
                hint_Db.content  = one
                hint_Db_s.append(hint_Db)
            }
            try! realm.write() {
                realm.add(hint_Db_s)
            }
            print("test-----")
            let hint_Db_select = realm.objects(Hint_Db.self)//
            for one in hint_Db_select{
                print("^^^^^^")
                print(one.theme)
                print(one.content)
                print("^^^^^^")
            }
            print("test-----")
        }
        if false{
            var hint_Db_s :[Hint_Db] = []
            for one in myThemes_1{
                let hint_Db = Hint_Db()
                hint_Db.theme = myThemes_1_theme
                hint_Db.content  = one
                hint_Db_s.append(hint_Db)
            }
            try! realm.write() {
                realm.add(hint_Db_s)
            }
            let themeSelect = realm.objects(Hint_Db.self).filter("theme == %@", myThemes_1_theme)
            var idea_Stock = Idea_Stock()
            var idea_Stock_s:[Idea_Stock] = []
            for one in themeSelect{
                var idea_Stock = Idea_Stock()
                idea_Stock.theme = one.theme
                idea_Stock.idea = one.content
                idea_Stock_s.append(idea_Stock)
            }
            try! realm.write() {
                realm.add(idea_Stock_s)
            }
        }
        super.viewDidLoad()
        
        var theme = UserDefaults.standard.object(forKey: "theme") as! String
        
        self.view.frame = CGRect(x:10, y:10 , width:500, height:675);
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        theme_title.frame = CGRect(x:20, y:600 , width:100, height:50);
        theme_title.stringValue = "テーマ"
        theme_title.font = NSFont.systemFont(ofSize: CGFloat(30))
        theme_title.isEditable = false
        theme_title.isSelectable = false
        theme_title.backgroundColor = NSColor.white
        self.view.addSubview(theme_title)
        
        theme_change_btn = NSButton(title: "テーマ変更", target: self, action: #selector(theme_change_click))
        theme_change_btn.frame = CGRect(x: 140, y: 600 , width: 150, height: 50)
        theme_change_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(theme_change_btn)

        theme_select_btn = NSButton(title: "テーマ選択", target: self, action: #selector(theme_select_click))
        theme_select_btn.frame = CGRect(x: 300, y: 600 , width: 150, height: 50)
        theme_select_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(theme_select_btn)
        
        theme_content.frame = CGRect(x:50, y:500 , width:400, height:50);
        theme_content.stringValue = theme
        theme_content.font = NSFont.systemFont(ofSize: CGFloat(30))
        theme_content.isEditable = false
        theme_content.isSelectable = false
        theme_content.isBordered = false
        theme_content.backgroundColor = NSColor.white
        self.view.addSubview(theme_content)
        
        hint_title.frame = CGRect(x:20, y:400 , width:100, height:50);
        hint_title.stringValue = "ヒント"
        hint_title.font = NSFont.systemFont(ofSize: CGFloat(30))
        hint_title.isEditable = false
        hint_title.isSelectable = false
        hint_title.backgroundColor = NSColor.white
        self.view.addSubview(hint_title)
        
        idea_title.frame = CGRect(x:20, y:200 , width:125, height:50);
        idea_title.stringValue = "アイデア"
        idea_title.font = NSFont.systemFont(ofSize: CGFloat(30))
        idea_title.isEditable = false
        idea_title.isSelectable = false
        idea_title.backgroundColor = NSColor.white
        self.view.addSubview(idea_title)
        
        idea_input.frame = CGRect(x:50, y:75 , width:400, height:100);
        idea_input.stringValue = ""
        idea_input.font = NSFont.systemFont(ofSize: CGFloat(20))
        idea_input.backgroundColor = NSColor.white
        self.view.addSubview(idea_input)
        
        randam_store_btn = NSButton(title: "ランダム&保存", target: self, action: #selector(randam_store_click))
        randam_store_btn.frame = CGRect(x: 300, y: 25 , width: 180, height: 50)
        randam_store_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(randam_store_btn)
        
        random_hint_disp_part_1()
        idea_count_disp()
    }
    func random_hint_disp_part_1(){
        
        let dbSelect = realm.objects(Hint_Db.self).filter("theme == %@",mHintCategory)
        hintArray = Array(dbSelect)
        let ranInt_2 = Int.random(in: 0 ... hintArray.count - 1)
        hint_content.lineBreakMode = .byWordWrapping
        hint_content.maximumNumberOfLines = 0
        var word_2 = ""
        var char_count_4 = 0
        for one in hintArray[ranInt_2].content{
            if char_count_4 % 22 == 0 && char_count_4 != 0{
                word_2 = word_2 + "\n" + String(one)
            }else{
                word_2 = word_2 + String(one)
            }
            char_count_4 = char_count_4 + 1
        }
        hint_content.stringValue = word_2
        hint_content.frame = CGRect(x: 50, y: 250 , width: 400, height: 100)
        if hintArray[ranInt_2].content.count < 10{
            hint_content.font = NSFont.systemFont(ofSize: CGFloat(50))
        }else{
            hint_content.font = NSFont.systemFont(ofSize: CGFloat(30))
        }
        hint_content.isBordered = false
        hint_content.isEditable = false
        hint_content.isBordered = false
        view.self.addSubview(hint_content)
    }
    @objc func randam_store_click(_ sender: NSButton) {
        if idea_input.stringValue != ""{
            let exitstIt = realm.objects(Idea_Stock.self).filter("theme == %@",theme_content.stringValue).filter("idea == %@",idea_input.stringValue)
            if exitstIt.count == 0{
                let idea_Stock = Idea_Stock()
                idea_Stock.theme  = theme_content.stringValue
                idea_Stock.hint = hint_content.stringValue
                idea_Stock.idea = idea_input.stringValue
                try! realm.write() {
                    realm.add(idea_Stock)
                }
                random_hint_disp_part_1()
                idea_count_disp()
                idea_input.stringValue = ""
            }else{
                let alert = NSAlert()
                alert.messageText = "重複したアイデアは登録出来ません。"
                alert.addButton(withTitle: "OK")
                let response = alert.runModal()
            }
        }else{
            random_hint_disp_part_1()
        }
    }
    @objc func theme_change_click(_ sender: NSButton) {
        let alert = NSAlert()
        let textField = NSTextField(frame: NSRect(x:0,y: 0,width:  400,height:  24))

        alert.accessoryView = textField
        alert.messageText = "テーマの入力"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "キャンセル")
        let response = alert.runModal()
        switch response {
        case .alertFirstButtonReturn:
            theme_content.stringValue = (alert.accessoryView as!
            NSTextField).stringValue
        case .alertSecondButtonReturn:
            print("キャンセル")
        default:
            break
        }
    }
    
    @objc func theme_select_click(_ sender: NSButton) {
        UserDefaults.standard.set(theme_content.stringValue, forKey: "theme")
        UserDefaults.standard.synchronize()
        self.dismiss(nil)
        let next = storyboard?.instantiateController(withIdentifier: "second")
        self.presentAsModalWindow(next! as! NSViewController)        
    }
    func idea_count_disp(){
        if theme_content.stringValue != ""{
            let ideaSelect = realm.objects(Idea_Stock.self).filter("theme == %@",theme_content.stringValue)
            theme_idea_count.frame = CGRect(x: 320, y: 70 , width: 30, height: 30)
            theme_idea_count.frame = CGRect(x:450, y:600 , width:50, height:50);
            theme_idea_count.stringValue = String(ideaSelect.count)
            theme_idea_count.font = NSFont.systemFont(ofSize: CGFloat(30))
            theme_idea_count.isEditable = false
            theme_idea_count.isSelectable = false
            theme_idea_count.isBordered = false
            theme_idea_count.backgroundColor = NSColor.white
            self.view.addSubview(theme_idea_count)
        }
    }
}

