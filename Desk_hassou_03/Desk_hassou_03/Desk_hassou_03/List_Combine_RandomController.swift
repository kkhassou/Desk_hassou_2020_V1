//
//  List_Theme_Combine_RandomController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/02/22.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//
import Cocoa
import Realm
import RealmSwift

class List_Combine_RandomController: NSViewController, NSTableViewDelegate, NSTableViewDataSource{
    
    let realm = try! Realm()
    var unique_stocks:[String] = []
    
    var return_btn = NSButton()
    
    @IBOutlet weak var tableView: NSTableView!
    
    var select_stock = ""
    var mtheme = ""
    
    var m_hint_theme_num = -999
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.action = #selector(onItemClicked)
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        let stocks = realm.objects(Rnadom_Conb_Db.self)
        var temp :[String] = []
        for one in stocks{
            temp.append(one.think)
            print(one.think)
        }
        let orderedSet = NSOrderedSet(array: temp)
        unique_stocks = orderedSet.array as! [String]
        
        return_btn = NSButton(title: "戻る", target: self, action: #selector(return_disp))
        return_btn.frame = CGRect(x: 25, y: 30 , width: 75, height: 50)
        return_btn.font = NSFont.systemFont(ofSize: 22)
        view.self.addSubview(return_btn)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return unique_stocks.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return unique_stocks[row]
    }
    @objc func return_disp(){
        self.dismiss(nil)
        let next = storyboard?.instantiateController(withIdentifier: "Combine_Random")
        self.presentAsModalWindow(next! as! NSViewController)
    }
    @objc func onItemClicked() {
        if tableView.clickedRow > -1{
            select_stock = unique_stocks[tableView.clickedRow]
        }
    }
}

