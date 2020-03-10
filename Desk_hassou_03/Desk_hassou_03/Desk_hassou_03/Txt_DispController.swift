//
//  Txt_DispController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/09.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Txt_DispController: NSViewController {
    let realm = try! Realm()
    var m_theme = ""
    var unique_group:[String] = []
    var stocs_array:[Grouped_Stock] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        var scrollView = NSScrollView()//NSTextField()
        scrollView.frame = NSRect(x:10,y:10,width:1180,height:630)
        
        // ここまでうまくいってるので、あとは、テキストにして、並べて表示すればOK
        //まず、グループの重複のないリストを作る
        // まず、グループを、表示。
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        let stocks = realm.objects(Grouped_Stock.self).filter("theme == %@",m_theme)
        stocs_array = Array(stocks)
        var temp :[String] = []
        for one in stocks{
            if one.group != ""{
                temp.append(one.group)
            }
        }
        let orderedSet = NSOrderedSet(array: temp)
        unique_group = orderedSet.array as! [String]
        var text_content_st = ""
        for one in unique_group{
            text_content_st = text_content_st + "●" + one + "\n"
            var group_stocks = realm.objects(Grouped_Stock.self).filter("theme == %@",m_theme).filter("group == %@",one)
            for i in 0..<group_stocks.count{
                text_content_st = text_content_st + "・" + group_stocks[i].idea + "\n"
            }
        }
        var text_content = NSTextField()
        text_content.stringValue = text_content_st
        text_content.frame = CGRect(x:10, y:10 , width:1200, height:650);
        text_content.font = NSFont.systemFont(ofSize: 9)
        scrollView.addSubview(text_content)
        self.view.addSubview(scrollView)
    }
}
