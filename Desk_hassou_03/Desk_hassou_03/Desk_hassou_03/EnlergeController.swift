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

class EnlergeController: NSViewController {

    var mHintCategory = ""
    
    let realm = try! Realm()
    
    var theme_title = NSTextField()
    var theme_content = NSTextField()

    var randam_idea_title = NSTextField()
    var randam_idea_content = NSTextField()
    
    var hint_title = NSTextField()
    var hint_content = NSTextField()

    var idea_title = NSTextField()
    var idea_input = NSTextField()

    var theme_idea_count = NSTextField()
    
    var randam_store_btn = NSButton()
    var theme_change_btn = NSButton()
    var theme_select_btn = NSButton()

    var hintArray:[Hint_Db] = []
    var ideaArray:[Idea_Stock] = []
    
    var mtheme = ""
    override func viewDidLoad() {
        mHintCategory = UserDefaults.standard.object(forKey: "mHintCategory") as! String
        
        super.viewDidLoad()
        
        mtheme = UserDefaults.standard.object(forKey: "theme") as! String
        
        self.view.frame = CGRect(x:10, y:10 , width:500, height:675);
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        theme_change_btn = NSButton(title: "テーマ変更", target: self, action: #selector(theme_change_click))
        theme_change_btn.frame = CGRect(x: 140, y: 600 , width: 150, height: 50)
        theme_change_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(theme_change_btn)

        theme_select_btn = NSButton(title: "テーマ選択", target: self, action: #selector(theme_select_click))
        theme_select_btn.frame = CGRect(x: 300, y: 600 , width: 150, height: 50)
        theme_select_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(theme_select_btn)
        
        theme_title.frame = CGRect(x:20, y:610 , width:100, height:30);
        theme_title.stringValue = "テーマ"
        theme_title.font = NSFont.systemFont(ofSize: CGFloat(20))
        theme_title.isEditable = false
        theme_title.isSelectable = false
        theme_title.backgroundColor = NSColor.white
        self.view.addSubview(theme_title)
        
        theme_content.frame = CGRect(x:50, y:550 , width:400, height:50);
        theme_content.stringValue = mtheme
        theme_content.font = NSFont.systemFont(ofSize: CGFloat(20))
        theme_content.isEditable = false
        theme_content.isSelectable = false
        theme_content.isBordered = false
        theme_content.backgroundColor = NSColor.white
        self.view.addSubview(theme_content)
        
        randam_idea_title.frame = CGRect(x:20, y:490 , width:400, height:30);
        randam_idea_title.stringValue = "ランダムに選んだアイデア"
        randam_idea_title.font = NSFont.systemFont(ofSize: CGFloat(20))
        randam_idea_title.isEditable = false
        randam_idea_title.isSelectable = false
        randam_idea_title.backgroundColor = NSColor.white
        self.view.addSubview(randam_idea_title)
        
        random_disp(tag: "IDEA")
        
        hint_title.frame = CGRect(x:20, y:370 , width:100, height:30);
        hint_title.stringValue = "ヒント"
        hint_title.font = NSFont.systemFont(ofSize: CGFloat(20))
        hint_title.isEditable = false
        hint_title.isSelectable = false
        hint_title.backgroundColor = NSColor.white
        self.view.addSubview(hint_title)
        
        idea_title.frame = CGRect(x:20, y:200 , width:200, height:30);
        idea_title.stringValue = "更なるアイデア"
        idea_title.font = NSFont.systemFont(ofSize: CGFloat(20))
        idea_title.isEditable = false
        idea_title.isSelectable = false
        idea_title.backgroundColor = NSColor.white
        self.view.addSubview(idea_title)
        
        idea_input.frame = CGRect(x:50, y:70 , width:400, height:100);
        idea_input.stringValue = ""
        idea_input.font = NSFont.systemFont(ofSize: CGFloat(20))
        idea_input.backgroundColor = NSColor.white
        self.view.addSubview(idea_input)
        
        randam_store_btn = NSButton(title: "ランダム&保存", target: self, action: #selector(randam_store_click))
        randam_store_btn.frame = CGRect(x: 300, y: 0 , width: 180, height: 50)
        randam_store_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(randam_store_btn)
        
        random_disp(tag: "HINT")
        idea_count_disp()
    }
    func random_disp(tag:String){
        if tag == "HINT"{
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
        }else if tag == "IDEA"{
            let dbSelect = realm.objects(Idea_Stock.self).filter("theme == %@",mtheme)
            ideaArray = Array(dbSelect)
            let ranInt_2 = Int.random(in: 0 ... ideaArray.count - 1)
            randam_idea_content.lineBreakMode = .byWordWrapping
            randam_idea_content.maximumNumberOfLines = 0
            var word_2 = ""
            var char_count_4 = 0
            for one in ideaArray[ranInt_2].idea{
                if char_count_4 % 22 == 0 && char_count_4 != 0{
                    word_2 = word_2 + "\n" + String(one)
                }else{
                    word_2 = word_2 + String(one)
                }
                char_count_4 = char_count_4 + 1
            }
            randam_idea_content.stringValue = word_2
            randam_idea_content.frame = CGRect(x:50, y:430 , width:400, height:50);
            randam_idea_content.font = NSFont.systemFont(ofSize: CGFloat(20))
            randam_idea_content.isEditable = false
            randam_idea_content.isSelectable = false
            randam_idea_content.isBordered = false
            randam_idea_content.backgroundColor = NSColor.white
            self.view.addSubview(randam_idea_content)
        }
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
                random_disp(tag: "HINT")
                random_disp(tag: "IDEA")
                idea_count_disp()
                idea_input.stringValue = ""
            }else{
                let alert = NSAlert()
                alert.messageText = "重複したアイデアは登録出来ません。"
                alert.addButton(withTitle: "OK")
                let response = alert.runModal()
            }
        }else{
            random_disp(tag: "HINT")
            random_disp(tag: "IDEA")
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
            break
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

