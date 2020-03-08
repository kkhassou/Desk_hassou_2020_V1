//
//  Divided_Group_DispController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/07.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Divided_Group_DispController: NSViewController {
    
    let realm = try! Realm()
    var m_theme = ""
    var unique_group:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        // まず、グループを、表示。
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        let stocks = realm.objects(Grouped_Stock.self).filter("theme == %@",m_theme)
        var stocs_array = Array(stocks)
        var temp :[String] = []
        for one in stocks{
            if one.group != ""{
                temp.append(one.group)
            }
        }
        let orderedSet = NSOrderedSet(array: temp)
        unique_group = orderedSet.array as! [String]
        print(unique_group)
        for y in 0..<8{
                if y < unique_group.count{
                    var group_content = NSTextField()
                    var group_content_p = Param(st_ :unique_group[y],x_:18,y_:550 - y*80,width_:130,height_:60,fontSize_:9)
                    group_content.tag = y*10
                    U().text_generate(param_:group_content_p,nsText_:group_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                    var x = 1
                    for one_stocks in stocs_array{
                        if one_stocks.group == unique_group[y] {
                            print("one_stocks.idea")
                            print(one_stocks.idea)
                            var indea_one_content = NSTextField()
                            var idea_one = one_stocks.idea
                            var indea_one_content_p = Param(st_ :idea_one,x_:18 + x*148,y_:550 - y*80,width_:130,height_:60,fontSize_:9)
                                               indea_one_content.tag = y*10 + x
                            U().text_generate(param_:indea_one_content_p,nsText_:indea_one_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                            x = x + 1
                        }
                    }
                }
        }
    }
}
