//
//  Index_Group_DivideController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/07.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Index_Group_DivideController: NSViewController , NSComboBoxDataSource{

    let realm = try! Realm()
    var unique_stocks:[String] = []
    var group_seted_stocks_s:[St_Set_group] = []
    var group_stocks:[String] = []
    var initial_grouped_stock_s:[Grouped_Stock] = []
    
    var unique_group_stocks:[String] = []
    var group_set_color_s:[group_set_color] = []
    var m_theme = ""
    var comboBox = NSComboBox()
    var group_input_content = NSTextField()
    var group_set_content = NSTextField()
    var border_color_array:[NSColor] = [NSColor.green,NSColor.blue,NSColor.orange,NSColor.purple,NSColor.gray,NSColor.red,NSColor.lightGray,NSColor.linkColor,NSColor.headerColor,NSColor.yellow]
    let Y_LENGTH = 7
    let X_LENGTH = 8
    
    var m_page_total = -999
    var m_page_now = 1
    var first_flag = true
    var first_db_store_flag = true
    override func viewDidLoad() {
        first_appear()
    }
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return unique_group_stocks.count
    }
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return unique_group_stocks[index]
    }
    @objc func group_set_click(){
        var st = group_set_content.stringValue
        let arr:[String] = st.components(separatedBy: " ")
        var index = 0
        for y in 0..<Y_LENGTH{
            for x in 0..<X_LENGTH{
                if  index < unique_stocks.count {
                    for one in arr{
                        if  index == Int(one)! - 1{
                            var idea_group_content = NSTextField()
                            var idea_group_content_p = Param(st_ :comboBox.stringValue,x_:18 + x*148,y_: 612 - y*80,width_:130,height_:13,fontSize_:9)
                            idea_group_content.tag = y*10 + x
                            
                            // 後で取り出せるように、グループを配列に格納
                            group_stocks[index] = comboBox.stringValue
                            U().text_generate(param_:idea_group_content_p,nsText_:idea_group_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                            var color_frame = NSTextField()
                            var color_frame_p = Param(st_ :"",x_:18 + x*148,y_: 546 - y*80,width_:130,height_:81,fontSize_:9)
                            color_frame.tag = y*10 + x
                            color_frame.wantsLayer = true
                            color_frame.backgroundColor = NSColor.clear
                            var set_color = NSColor.black.cgColor
                            for one in group_set_color_s{
                                if one.group == comboBox.stringValue{
                                    set_color = one.backColor.cgColor
                                }
                            }
                            color_frame.layer?.borderColor = set_color
                            color_frame.layer?.borderWidth = 2.0
                            U().text_generate(param_:color_frame_p,nsText_:color_frame,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                        }
                    }
                }
                index = index + 1
            }
        }
        
    }
    @objc func group_input_click(){
        let group_Label_Db = Group_Label_Db_ver3()
        group_Label_Db.theme = m_theme
        group_Label_Db.gourp_label  = U().line_break_delete(in_st:group_input_content.stringValue)
        try! realm.write() {
            realm.add(group_Label_Db)
        }
        // テストで追加
        unique_group_stocks.append(group_input_content.stringValue)
        var count = 0
        for one in unique_group_stocks{
            var one_set = group_set_color()
            one_set.backColor = border_color_array[count]
            one_set.group = one
            count = count + 1
            group_set_color_s.append(one_set)
        }
        comboBox.reloadData()
    }
    
    @objc func next_page_click(){
        if m_page_now < m_page_total{
            m_page_now = m_page_now + 1
            group_seted_stocks_s.removeAll()
            for v in view.subviews {
                v.removeFromSuperview()
            }
            page_move_db_store()
            first_appear()
        }
    }
    func page_move_db_store(){
        var index = 0
        for y in 0..<Y_LENGTH{
            for x in 0..<X_LENGTH{
                if  index < unique_stocks.count {
                    if group_stocks[index] != "" {
                        var one_group_stock = Grouped_Stock()
                        one_group_stock.theme = m_theme
                        one_group_stock.idea = unique_stocks[index]
                        one_group_stock.group = group_stocks[index]
                        let results = realm.objects(Grouped_Stock.self).filter("theme == %@",m_theme).filter("idea == %@",unique_stocks[index])
                        if results.count == 0{
                            var one_group_stock = Grouped_Stock()
                            one_group_stock.theme = m_theme
                            one_group_stock.idea = unique_stocks[index]
                            one_group_stock.group = group_stocks[index]
                            try! realm.write {
                                realm.add(one_group_stock)
                            }
                        }else{
                            try! realm.write {
                                results[0].theme = m_theme
                                results[0].idea = unique_stocks[index]
                                results[0].group = group_stocks[index]
                            }
                        }
                    }
                }
                index = index + 1
            }
        }
    }
    @objc func return_page_click(){
        if m_page_now > 1{
            m_page_now = m_page_now - 1
            group_seted_stocks_s.removeAll()
            for v in view.subviews {
                v.removeFromSuperview()
            }
            page_move_db_store()
            first_appear()
        }
    }
    @objc func store_next_click(){
        delet_DB()
        store_DB()
        U().screen_next(viewCon : self ,id:"Divided_Group_Disp" , storyboard:storyboard!)
    }
    func delet_DB(){
        // 更新なので、削除してから追加
        let deleting = realm.objects(Grouped_Stock.self).filter("theme == %@",m_theme)
        try! realm.write {
            realm.delete(deleting)
        }
    }
    func store_DB(){
        var group_stock_s:[Grouped_Stock] = []
        var index = 0
        for y in 0..<Y_LENGTH{
            for x in 0..<X_LENGTH{
                if  index < unique_stocks.count {
                    if group_stocks[index] != "" {
                        var one_group_stock = Grouped_Stock()
                        one_group_stock.theme = m_theme
                        one_group_stock.idea = unique_stocks[index]
                        one_group_stock.group = group_stocks[index]
                        group_stock_s.append(one_group_stock)
                    }
                }
                index = index + 1
            }
        }
        // 単純に追加すると、被ったところで、どっちが採用されるか分からないので、
        // 被っているところは、initial_grouped_stock_sのほうは、追加しない。
        for one_initial_grouped_stock in initial_grouped_stock_s{
            var exist_flag = false
            for one_group_stock in group_stock_s{
                if one_group_stock.idea == one_initial_grouped_stock.idea{
                    exist_flag = true
                }
            }
            if exist_flag == false{
                group_stock_s.append(contentsOf: initial_grouped_stock_s)
            }
        }
        try! realm.write() {
            realm.add(group_stock_s)
        }
        // 別のページの保存が出来ないので、この処理を入れてみるが、うまくいくかな？
        // なんか、凄い、重複しまくっている気がするが。
        var fill_difference_db_s = realm.objects(Grouped_Stock.self).filter("theme == %@",m_theme)
        var arry_fill_difference_db_s = Array(fill_difference_db_s)
        for one in arry_fill_difference_db_s{
            var temp_falg = true
            for one_2 in group_stock_s{
                if one_2.idea == one.idea{
                    temp_falg = false
                }
            }
            if temp_falg == true{
                // 追加
                var in_one = Grouped_Stock()
                in_one.theme = m_theme
                in_one.idea = one.idea
                in_one.group = one.group
                try! realm.write() {
                    realm.add(in_one)
                }
            }else{
                // 更新
                var temp_db_s = realm.objects(Grouped_Stock.self).filter("theme == %@",m_theme).filter("idea == %@",one.idea)
                try! realm.write {
                    temp_db_s[0].group = one.group
                }
            }
        }

    }
    func first_appear(){
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        let stocks = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme)
        var temp :[String] = []
        for one in stocks{
            temp.append(one.idea)
        }
        let orderedSet = NSOrderedSet(array: temp)
        unique_stocks = orderedSet.array as! [String]
        m_page_total = Int(unique_stocks.count / (Y_LENGTH * X_LENGTH)) + 1
        if m_page_now == 1{
            //そのままでOKのはず
        }else{
            for i in 0..<((m_page_now - 1) * 56) {
                unique_stocks.remove(at: 0)
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
        
        let group_label_s = realm.objects(Group_Label_Db_ver3.self).filter("theme == %@",m_theme)
        var temp_2 :[String] = []
        if group_label_s.count != 0{
            var none_exist_flag = true
            for one in group_label_s{
                temp_2.append(one.gourp_label)
            }
            let orderedSet_2 = NSOrderedSet(array: temp_2)
            unique_group_stocks = orderedSet_2.array as! [String]
            // テストで追加
            var count = 0
            for one in unique_group_stocks{
                var one_set = group_set_color()
                one_set.backColor = border_color_array[count]
                one_set.group = one
                count = count + 1
                group_set_color_s.append(one_set)
            }
        }else{
            unique_group_stocks.append("")
        }
        comboBox.usesDataSource = true
        comboBox.dataSource = self
        comboBox.frame = CGRect(x: 10, y: 10 , width: 200, height:28)
        comboBox.isEditable = false
        comboBox.stringValue = ""
        self.view.addSubview(comboBox)
        
        //ここから、グループを検索してセットする
        for one in unique_stocks {
            let serched = realm.objects(Grouped_Stock.self).filter("theme == %@",m_theme).filter("idea == %@",one)
            var one_st_set_group = St_Set_group()
            if serched.count == 0{
                one_st_set_group.group = ""
                one_st_set_group.idea = one
            }else{
                one_st_set_group.group = serched[0].group
                one_st_set_group.idea = one
                // これを入れないと、おかしな事になるので注意。
                if first_flag == true{
                    var one_grouped_stock = Grouped_Stock()
                    one_grouped_stock.theme = m_theme
                    one_grouped_stock.group = serched[0].group
                    one_grouped_stock.idea = one
                    initial_grouped_stock_s.append(one_grouped_stock)
                }else{

                }
            }
            group_seted_stocks_s.append(one_st_set_group)
        }
        first_flag = false
//        print("----------")
//        print(group_seted_stocks_s)
        // 一旦、目一杯、画面に、縦横にマスを並べてみよう。
        // 空の文字列を用意
        var index = 0
        for y in 0..<Y_LENGTH{
            for x in 0..<X_LENGTH{
                if  index < group_seted_stocks_s.count {
                    var indea_one_content = NSTextField()
                    var idea_one = group_seted_stocks_s[index].idea
                    var indea_one_content_p = Param(st_ :idea_one,x_:18 + x*148,y_:550 - y*80,width_:130,height_:60,fontSize_:9)
                    indea_one_content.tag = y*10 + x
                    U().text_generate(param_:indea_one_content_p,nsText_:indea_one_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                    var indea_group_content = NSTextField()
                    var group_st = "グループ"
                    if group_seted_stocks_s[index].group == ""{
                        var indea_group_content_p = Param(st_ :group_st,x_:18 + x*148,y_: 612 - y*80,width_:130,height_:13,fontSize_:9)
                        indea_group_content.tag = y*10 + x
                        U().text_generate(param_:indea_group_content_p,nsText_:indea_group_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                        
                    }else{
                        group_st = group_seted_stocks_s[index].group
                        var indea_group_content_p = Param(st_ :group_st,x_:18 + x*148,y_: 612 - y*80,width_:130,height_:13,fontSize_:9)
                        indea_group_content.tag = y*10 + x
                        U().text_generate(param_:indea_group_content_p,nsText_:indea_group_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                        // ここに枠を追加表示する処理を追加。
                        var color_frame = NSTextField()
                        var color_frame_p = Param(st_ :"",x_:18 + x*148,y_: 546 - y*80,width_:130,height_:81,fontSize_:9)
                        color_frame.tag = y*10 + x
                        color_frame.wantsLayer = true
                        color_frame.backgroundColor = NSColor.clear
                        var set_color = NSColor.black.cgColor
                        for one in group_set_color_s{
                            if one.group == group_st{
                                set_color = one.backColor.cgColor
                            }
                        }
                        color_frame.layer?.borderColor = set_color
                        color_frame.layer?.borderWidth = 2.0
                        U().text_generate(param_:color_frame_p,nsText_:color_frame,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                    }
                    var indea_index = NSTextField()
                    var indea_index_p = Param(st_ :String(index + 1),x_:2 + x*148,y_: 611 - y*80,width_:16,height_:13,fontSize_:9)
                    indea_index.tag = y*10 + x
                    U().text_generate(param_:indea_index_p,nsText_:indea_index,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
                    // 空の文字列を用意
                    group_stocks.append("")
                }
                index = index + 1
            }
        }
        var comboBox_titel = NSTextField()
        var comboBox_titel_p = Param(st_ :"セットするグループを選択",x_: 10, y_: 38 , width_: 170, height_:13,fontSize_:9)
        U().text_generate(param_:comboBox_titel_p,nsText_:comboBox_titel,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        var group_set_titel = NSTextField()
        var group_set_titel_p = Param(st_ :"セットする番号を入力。区切りは半角スペース",x_: 230, y_: 38 , width_: 270, height_:13,fontSize_:9)
        U().text_generate(param_:group_set_titel_p,nsText_:group_set_titel,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)

        
        var group_set_content_p = Param(st_ :"",x_:230,y_:10,width_:300,height_:28,fontSize_:13)
        U().text_generate(param_:group_set_content_p,nsText_:group_set_content,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
        
        var group_set_btn_p = Param(st_ :"グループをセット",x_:535,y_:12,width_:130,height_:20,fontSize_:13)
        U().button_generate(param_:group_set_btn_p,viewCon_:self,view_:self.view,action: #selector(group_set_click))
        
        var group_input_titel = NSTextField()
        var group_input_titel_p = Param(st_ :"追加するグループを入力",x_: 680, y_: 38 , width_: 70, height_:13,fontSize_:9)
        U().text_generate(param_:group_input_titel_p,nsText_:group_input_titel,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)


        var group_input_content_p = Param(st_ :"",x_:680,y_:10,width_:180,height_:28,fontSize_:13)
        U().text_generate(param_:group_input_content_p,nsText_:group_input_content,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
        
        var group_input_btn_p = Param(st_ :"グループを追加",x_:860,y_:8,width_:130,height_:20,fontSize_:13)
              U().button_generate(param_:group_input_btn_p,viewCon_:self,view_:self.view,action: #selector(group_input_click))
        
        var store_next_btn_p = Param(st_ :"保存&整理後を表示",x_:1000,y_:8,width_:160,height_:20,fontSize_:13)
              U().button_generate(param_:store_next_btn_p,viewCon_:self,view_:self.view,action: #selector(store_next_click))
    }
}
