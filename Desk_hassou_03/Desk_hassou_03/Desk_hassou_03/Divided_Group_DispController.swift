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
    var m_page_total = -999
    var m_page_now = 1
    var m_max_x = 0
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
        for y in 0..<8{
            var temp_max_x = 0
                if y < unique_group.count{
                    var group_content = NSTextField()
                    var group_content_p = Param(st_ :unique_group[y],x_:18,y_:550 - y*80,width_:130,height_:60,fontSize_:9)
                    group_content.tag = y*10
                    U().text_generate(param_:group_content_p,nsText_:group_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                    var x = 1
                    for one_stocks in stocs_array{
                        if one_stocks.group == unique_group[y] {
                            var indea_one_content = NSTextField()
                            var idea_one = one_stocks.idea
                            var indea_one_content_p = Param(st_ :idea_one,x_:18 + x*148,y_:550 - y*80,width_:130,height_:60,fontSize_:9)
                                               indea_one_content.tag = y*10 + x
                            U().text_generate(param_:indea_one_content_p,nsText_:indea_one_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                            x = x + 1
                            temp_max_x = x
                        }
                    }
                }
            if temp_max_x > m_max_x{
                m_max_x = temp_max_x
            }
        }
        // page番号の表示
        var page_title = NSTextField()
        var page_title_p = Param(st_ :"ページ",x_:880,y_: 35,width_:50,height_:20,fontSize_:14)
        U().text_generate(param_:page_title_p,nsText_:page_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        
        var page_cotent = NSTextField()
        var page_cotent_p = Param(st_ :String(m_page_now) + " / " + String(m_page_total) ,x_:930,y_: 35,width_:50,height_:20,fontSize_:14)
        U().text_generate(param_:page_cotent_p,nsText_:page_cotent,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)

        var next_page_btn_p = Param(st_ :"次のページ",x_:1060,y_:35,width_:90,height_:20,fontSize_:13)
              U().button_generate(param_:next_page_btn_p,viewCon_:self,view_:self.view,action: #selector(next_page_click))
        var return_page_btn_p = Param(st_ :"前のページ",x_:960,y_:35,width_:90,height_:20,fontSize_:13)
              U().button_generate(param_:return_page_btn_p,viewCon_:self,view_:self.view,action: #selector(return_page_click))
    }
    @objc func next_page_click(){
        if m_page_now < m_page_total{
        }
    }
    @objc func return_page_click(){
        if m_page_now > 1{
        }
    }
}
