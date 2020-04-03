//
//  View_0_Controller.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/01/03.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class View_0_Controller: NSViewController, NSComboBoxDataSource{

    var mHintCategory = ""
    var randam_brest_btn = NSButton()
    var randam_9x9_btn = NSButton()
    var combine_random_btn = NSButton()
    var comboBox =  NSComboBox()
    var dataArray:[String] = []
    let realm = try! Realm()
    var unique_stocks:[String] = []
    
    var category_title = NSTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:675);
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
//        let stocks2 = realm.objects(Deep_Enlarge_Db.self)
//        try! realm.write {
//            realm.delete(stocks2)
//        }
//        exit(0)
        
        if false{
//            let deleting = realm.objects(Random_Loc_Idea.self)
//            try! realm.write {
//                realm.delete(deleting)
//            }
//            let deleting_2 = realm.objects(Hierarchy_Theme_Db_v5.self)
//            try! realm.write {
//                realm.delete(deleting_2)
//            }
//            let idea_Stock = realm.objects(Idea_Stock.self).filter("theme == %@","書籍で読んだ内容を、この発想支援アプリで、活用しやすいような機能を作る")
//            print(idea_Stock)
            let deleting = realm.objects(Idea_Stock.self).filter("idea == %@","アイデア発想支援アプリを使っているシーンを撮影して発信する")
            try! realm.write {
                realm.delete(deleting)
            }
            let deleting_2 = realm.objects(Idea_Stock.self).filter("theme == %@","アイデア発想支援アプリを使っているシーンを撮影して発信する")
            try! realm.write {
                realm.delete(deleting_2)
            }
            exit(0)
        }
        if false{
            let stocks = realm.objects(Hint_Db.self).filter("theme == %@","SDGs169の具体的な目標")
            try! realm.write {
                realm.delete(stocks)
            }
        }
        if false{
            var hint_Db_s:[Hint_Db] = []
            let content_s = [""
            ]
            for one in content_s {
                var hint_Db = Hint_Db()
                hint_Db.theme  = "SDGs169の具体的な目標"
                hint_Db.content = one
                hint_Db_s.append(hint_Db)
            }
            try! realm.write() {
                realm.add(hint_Db_s)
            }
        }
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
//        var category_title_p = Param(st_ :"ランダムヒントカテゴリ",x_:50,y_:600,width_:150,height_:20,fontSize_:20)
//    U().text_generate(param_:category_title_p,nsText_:category_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        comboBox.usesDataSource = true
        comboBox.dataSource = self
        comboBox.frame = CGRect(x: 50, y: 600 , width: 250, height: 50)
        comboBox.isEditable = false
        
        let stocks = realm.objects(Hint_Db.self)
        var temp :[String] = []
        for one in stocks{
            temp.append(one.theme)
        }
        let orderedSet = NSOrderedSet(array: temp)
        unique_stocks = orderedSet.array as! [String]
        
        self.dataArray = unique_stocks
        comboBox.stringValue = self.dataArray[0]

        mHintCategory = self.dataArray[0]
        comboBox.addItems(withObjectValues: self.dataArray)
        self.view.addSubview(comboBox)
        
        var randam_brest_p = Param(st_ :"ランダム ブレスト",x_:50,y_:550,width_:250,height_:50,fontSize_:22)
        U().button_generate(param_:randam_brest_p,viewCon_:self,view_:self.view,action: #selector(randam_brest_click))
        
        var combine_random_p = Param(st_ :"ランダム組み合わせ",x_:50,y_:500,width_:250,height_:50,fontSize_:22)
        U().button_generate(param_:combine_random_p,viewCon_:self,view_:self.view,action: #selector(combine_random_click))
        
        var randam_9x9_p = Param(st_ :"9x9 ブレスト",x_:50,y_:450,width_:250,height_:50,fontSize_:22)
        U().button_generate(param_:randam_9x9_p,viewCon_:self,view_:self.view,action: #selector(nine_x_nine_brest_click))
        
        var proposal_list_p = Param(st_ :"企画一覧",x_:50,y_:400,width_:250,height_:50,fontSize_:22)
        U().button_generate(param_:proposal_list_p,viewCon_:self,view_:self.view,action: #selector(proposal_list_click))
        
        var concurrent_p = Param(st_ :"複数同時入力",x_:50,y_:350,width_:250,height_:50,fontSize_:22)
        U().button_generate(param_:concurrent_p,viewCon_:self,view_:self.view,action: #selector(concurrent_click))
    }
    @objc func concurrent_click(_ sender: NSButton) {
        UserDefaults.standard.set("Concurrent_List", forKey: "to_page")
        UserDefaults.standard.set(mHintCategory, forKey: "mHintCategory")
        UserDefaults.standard.synchronize()
        let next = storyboard?.instantiateController(withIdentifier: "List")
        self.presentAsModalWindow(next! as! NSViewController)
        self.dismiss(nil)
    }
    @objc func proposal_list_click(_ sender: NSButton) {
        UserDefaults.standard.set("Proposal_List", forKey: "to_page")
        UserDefaults.standard.synchronize()
        let next = storyboard?.instantiateController(withIdentifier: "List")
        self.presentAsModalWindow(next! as! NSViewController)
        self.dismiss(nil)
    }
    @objc func randam_brest_click(_ sender: NSButton) {
        UserDefaults.standard.set(mHintCategory, forKey: "mHintCategory")
        UserDefaults.standard.synchronize()
        let next = storyboard?.instantiateController(withIdentifier: "first")
        self.presentAsModalWindow(next! as! NSViewController)
        self.dismiss(nil)
    }
    @objc func nine_x_nine_brest_click(_ sender: NSButton) {
        let next = storyboard?.instantiateController(withIdentifier: "List_Nine_x_Nine")
        self.presentAsModalWindow(next! as! NSViewController)
        self.dismiss(nil)
    }
    @objc func combine_random_click(_ sender: NSButton) {
        let next = storyboard?.instantiateController(withIdentifier: "Combine_Random")
        self.presentAsModalWindow(next! as! NSViewController)
        self.dismiss(nil)
    }
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return dataArray.count
    }
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        mHintCategory = dataArray[index]
        return dataArray[index]
    }
}
