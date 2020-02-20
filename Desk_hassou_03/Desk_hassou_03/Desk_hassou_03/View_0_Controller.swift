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
    var comboBox =  NSComboBox()
    var dataArray:[String] = []
    let realm = try! Realm()
    var unique_stocks:[String] = []
    var category_title = NSTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        category_title.frame = CGRect(x: 50, y: 200 , width: 150, height: 20)
        category_title.stringValue = "ランダムヒントカテゴリ"
        category_title.isEditable = false
        category_title.isSelectable = false
        category_title.isBordered = false
        category_title.backgroundColor = NSColor.green
        self.view.addSubview(category_title)
        
        comboBox.usesDataSource = true
        comboBox.dataSource = self
        comboBox.frame = CGRect(x: 50, y: 150 , width: 250, height: 50)
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
        randam_brest_btn = NSButton(title: "ランダム ブレスト", target: self, action: #selector(randam_brest_click))
        randam_brest_btn.frame = CGRect(x: 50, y: 50 , width: 250, height: 50)
        randam_brest_btn.font = NSFont.systemFont(ofSize: 22)
        self.view.addSubview(randam_brest_btn)
        
        randam_9x9_btn = NSButton(title: "9x9 ブレスト", target: self, action: #selector(nine_x_nine_brest_click))
        randam_9x9_btn.frame = CGRect(x: 50, y: 100 , width: 250, height: 50)
        randam_9x9_btn.font = NSFont.systemFont(ofSize: 22)
        self.view.addSubview(randam_9x9_btn)
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
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return dataArray.count
    }
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        mHintCategory = dataArray[index]
        return dataArray[index]
    }
}
