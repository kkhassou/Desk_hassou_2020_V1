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
    var text_content_st = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        var scrollView = NSScrollView()//NSTextField()
        scrollView.frame = NSRect(x:10,y:10,width:1180,height:630)
        
        var from_page = UserDefaults.standard.object(forKey: "from_page") as! String
        
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        if from_page == "Divided_Group_Disp" {
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
            
            for one in unique_group{
                text_content_st = text_content_st + "●" + one + "\n"
                var group_stocks = realm.objects(Grouped_Stock.self).filter("theme == %@",m_theme).filter("group == %@",one)
                for i in 0..<group_stocks.count{
                    text_content_st = text_content_st + "・" + group_stocks[i].idea + "\n"
                }
            }
            for i in 0..<3 {
                text_content_st = text_content_st + "\n"
            }
        } else if from_page == "View_2_only" {
            print("from View_2_only")
            let stocks = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme)
            var stocs_array = Array(stocks)
            for one in stocs_array {
                print("one.idea")
                print(one.idea)
                text_content_st = text_content_st + "●" + one.idea + "\n"
            }
            for i in 0..<3 {
                text_content_st = text_content_st + "\n"
            }
        } else if from_page == "View_2_hierarchy" {
            print("from View_2_hierarchy")
            db_serch(theme_:m_theme)
            for i in 0..<3 {
                text_content_st = text_content_st + "\n"
            }
        }else if from_page == "Randam_Area_S"{
            let stocks = realm.objects(Randam_Area_S_DB.self).filter("start_theme == %@",m_theme)
            var temp :[String] = []
            for one in stocks{
                if one.theme != ""{
                    temp.append(one.theme)
                }
            }
            let orderedSet = NSOrderedSet(array: temp)
            let unique_theme = orderedSet.array as! [String]
            
            for one in unique_theme{
                text_content_st = text_content_st + "●" + one + "\n"
                var theme_stocks = realm.objects(Randam_Area_S_DB.self).filter("start_theme == %@",m_theme).filter("theme == %@",one)
                for one in theme_stocks{
                    text_content_st = text_content_st + "・" + one.idea + "\n"
                }
            }
            for i in 0..<3 {
                text_content_st = text_content_st + "\n"
            }
        }else if from_page == "Process"{
            let stocks = realm.objects(Process_s_DB_2.self).filter("theme == %@",m_theme)
            // indexの順番に並べる必要がある。
            for i in 0 ..< stocks.count{
                for one in stocks{
                    if i == one.index{
                        text_content_st = text_content_st + "[" + String(i + 1) + "]\n" + one.content + "\nコメント\n"
                        text_content_st = text_content_st + one.comment + "\n↓\n"
                    }
                }
            }
            for i in 0..<3 {
                text_content_st = text_content_st + "\n"
            }
        }
        var text_content = NSTextField()
        text_content.stringValue = text_content_st
        text_content.frame = CGRect(x:10, y:10 , width:1200, height:650);
        text_content.font = NSFont.systemFont(ofSize: 9)
        scrollView.addSubview(text_content)
        self.view.addSubview(scrollView)
    }
    var idea_s:[String] = []
    func db_serch(theme_:String){
        idea_s.removeAll()
        let stocks = realm.objects(Idea_Stock.self).filter("theme == %@",theme_)
        text_content_st = text_content_st + "◯" + theme_ + "\n"
        var arr = Array(stocks)
        for one in arr{
            text_content_st = text_content_st + "・" + one.idea + "\n"
            idea_s.append(one.idea)
        }
        for one in idea_s{
            db_serch(theme_:one)
        }
    }
}
