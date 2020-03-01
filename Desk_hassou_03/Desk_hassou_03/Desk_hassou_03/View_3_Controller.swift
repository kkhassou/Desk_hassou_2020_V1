//
//  View_3_Controller.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/01/03.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class View_3_Controller: NSViewController, NSTableViewDelegate, NSTableViewDataSource{
    
    let realm = try! Realm()
    
    var unique_stocks:[String] = []
    
    var return_btn = NSButton()
    let RETURN_BTN_ST = "戻る"
    let RETURN_BTN_X = 25
    let RETURN_BTN_Y = 30
    let RETURN_BTN_WIDTH = 75
    let RETURN_BTN_HEIGHT = 50
    let RETURN_BTN_FONT = 22
    let RETURN_BTN_CLICK = #selector(return_disp)
    
    var select_btn = NSButton()
    let SELECT_BTN_ST = "決定"
    let SELECT_BTN_X = 375
    let SELECT_BTN_Y = 30
    let SELECT_BTN_WIDTH = 75
    let SELECT_BTN_HEIGHT = 50
    let SELECT_BTN_FONT = 22
    let SELECT_BTN_CLICK = #selector(select_theme)
    
    var nine_x_nine_btn = NSButton()
    let NINE_X_NINE_BTN_ST = "9x9へ"
    let NINE_X_NINE_BTN_X = 25
    let NINE_X_NINE_BTN_Y = 0
    let NINE_X_NINE_BTN_WIDTH = 100
    let NINE_X_NINE_BTN_HEIGHT = 50
    let NINE_X_NINE_BTN_FONT = 22
    let NINE_X_NINE_BTN_CLICK = #selector(select_nine_x_nine)
    
    var group_divide_btn = NSButton()
    let GROUP_DIVIDE_BTN_ST = "グループ分け"
    let GROUP_DIVIDE_BTN_X = 150
    let GROUP_DIVIDE_BTN_Y = 0
    let GROUP_DIVIDE_BTN_WIDTH = 150
    let GROUP_DIVIDE_BTN_HEIGHT = 50
    let GROUP_DIVIDE_BTN_FONT = 22
    let GROUP_DIVIDE_BTN_CLICK = #selector(group_divide)
    
    var delete_btn = NSButton()
    let DELETE_BTN_ST = "削除"
    let DELETE_BTN_X = 300
    let DELETE_BTN_Y = 30
    let DELETE_BTN_WIDTH = 75
    let DELETE_BTN_HEIGHT = 50
    let DELETE_BTN_FONT = 22
    let DELETE_BTN_CLICK = #selector(delete_db)
    
    @IBOutlet weak var tableView: NSTableView!

    var m_select_stock = ""
    var m_theme = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.action = #selector(onItemClicked)
        
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        let stocks = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme)
        var temp :[String] = []
        for one in stocks{
            temp.append(one.idea)
        }
        let orderedSet = NSOrderedSet(array: temp)
        unique_stocks = orderedSet.array as! [String]
        
        U().button_generate(viewCon : self ,view:self.view,x:RETURN_BTN_X,y:RETURN_BTN_Y,width:RETURN_BTN_WIDTH,height:RETURN_BTN_HEIGHT,st:RETURN_BTN_ST,fontSize:RETURN_BTN_FONT,action: RETURN_BTN_CLICK)
        
        U().button_generate(viewCon : self ,view:self.view,x:SELECT_BTN_X,y:SELECT_BTN_Y,width:SELECT_BTN_WIDTH,height:SELECT_BTN_HEIGHT,st:SELECT_BTN_ST,fontSize:SELECT_BTN_FONT,action: SELECT_BTN_CLICK)
        
        U().button_generate(viewCon : self ,view:self.view,x:NINE_X_NINE_BTN_X,y:NINE_X_NINE_BTN_Y,width:NINE_X_NINE_BTN_WIDTH,height:NINE_X_NINE_BTN_HEIGHT,st:NINE_X_NINE_BTN_ST,fontSize:NINE_X_NINE_BTN_FONT,action: NINE_X_NINE_BTN_CLICK)

        U().button_generate(viewCon : self ,view:self.view,x:GROUP_DIVIDE_BTN_X,y:GROUP_DIVIDE_BTN_Y,width:GROUP_DIVIDE_BTN_WIDTH,height:GROUP_DIVIDE_BTN_HEIGHT,st:GROUP_DIVIDE_BTN_ST,fontSize:GROUP_DIVIDE_BTN_FONT,action: GROUP_DIVIDE_BTN_CLICK)
        
        U().button_generate(viewCon : self ,view:self.view,x:DELETE_BTN_X,y:DELETE_BTN_Y,width:DELETE_BTN_WIDTH,height:DELETE_BTN_HEIGHT,st:DELETE_BTN_ST,fontSize:DELETE_BTN_FONT,action: DELETE_BTN_CLICK)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return unique_stocks.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return unique_stocks[row]
    }
    @objc func return_disp(){
        U().screen_next(viewCon : self ,id:"second" , storyboard:storyboard!)
    }
    @objc func select_theme(){
        if m_select_stock != ""{
            UserDefaults.standard.set(m_select_stock, forKey: "theme")
            UserDefaults.standard.synchronize()
            U().screen_next(viewCon : self ,id:"first" , storyboard:storyboard!)
        }else{
            let alert = NSAlert()
            alert.messageText = "テーマを選択してください"
            alert.addButton(withTitle: "OK")
            let response = alert.runModal()
        }
    }
    @objc func select_nine_x_nine(){
        if m_select_stock != ""{
            UserDefaults.standard.set(m_select_stock, forKey: "theme")
            UserDefaults.standard.synchronize()
            U().screen_next(viewCon : self ,id:"Nine_x_Nine" , storyboard:storyboard!)
        }else{
            let alert = NSAlert()
            alert.messageText = "テーマを選択してください"
            alert.addButton(withTitle: "OK")
            let response = alert.runModal()
        }
    }
    @objc func group_divide(){
        U().screen_next(viewCon : self ,id:"Group_Divide" , storyboard:storyboard!)
    }
    @objc func delete_db(){
        if m_select_stock != ""{
            let alert = NSAlert()
            alert.messageText = "本当に、" + m_select_stock + "を削除して良いですか？"
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "キャンセル")
            let response = alert.runModal()
            switch response {
            case .alertFirstButtonReturn:
                let stocks = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme).filter("idea == %@",m_select_stock)
                try! realm.write {
                    realm.delete(stocks)
                }
                let deleted = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme)
                var temp :[String] = []
                for one in deleted{
                    temp.append(one.idea)
                }
                let orderedSet = NSOrderedSet(array: temp)
                unique_stocks = orderedSet.array as! [String]
                tableView.reloadData()
                break
            case .alertSecondButtonReturn:
                print("キャンセル")
                break
            default:
                break
            }
        }else{
            let alert = NSAlert()
            alert.messageText = "テーマを選択してください"
            alert.addButton(withTitle: "OK")
            let response = alert.runModal()
        }
    }
    @objc func onItemClicked() {
        if tableView.clickedRow > -1{
            m_select_stock = unique_stocks[tableView.clickedRow]
        }
    }
}
