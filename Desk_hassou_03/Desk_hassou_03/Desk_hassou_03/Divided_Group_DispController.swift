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
    var stocs_array:[Grouped_Stock] = []
    var m_page_total = -999
    var m_page_now = 1
    var m_max_x = 0
    var first_falg = true
    override func viewDidLoad() {
        first_appear()
    }
    func first_appear(){
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        // 最初に、表示インデックスを他の情報とあわせてDBに保存とグループの配列、ストックの配列はローカルに保持する
        // 一回目に行えば良いので、first_flagを使う
        if first_falg == true{
            let deleting = realm.objects(Grouped_Stock_Num.self).filter("theme == %@",m_theme)
            try! realm.write {
                realm.delete(deleting)
            }
            first_falg = false
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
            for y in 0..<8{
                var temp_max_x = 0
                    if y < unique_group.count{
                        var x = 1
                        for one_stocks in stocs_array{
                            if one_stocks.group == unique_group[y] {
                                // 最初のループはDB処理のみ
                                // そのほうが、処理が簡単
                                // ここは更新不要なので、削除&追加で大丈夫
                                let one_grouped_stock_num = Grouped_Stock_Num()
                                one_grouped_stock_num.theme  = m_theme
                                one_grouped_stock_num.group = unique_group[y]
                                one_grouped_stock_num.idea = one_stocks.idea
                                one_grouped_stock_num.num = x
                                try! realm.write() {
                                    realm.add(one_grouped_stock_num)
                                }
                                x = x + 1
                                temp_max_x = x
                            }
                        }
                    }
                if temp_max_x > m_max_x{
                    m_max_x = temp_max_x
                }
            }
        }
        // if first_falg上まで
        for y in 0..<8{
                if y < unique_group.count{
                    var group_content = NSTextField()
                    var group_content_p = Param(st_ :unique_group[y],x_:18,y_:550 - y*80,width_:130,height_:60,fontSize_:9)
                    group_content.tag = y*10
                    U().text_generate(param_:group_content_p,nsText_:group_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                    for x in 1..<8{
                        let serched = realm.objects(Grouped_Stock_Num.self).filter("theme == %@",m_theme).filter("group == %@",unique_group[y]).filter("num == %@",x + ((m_page_now - 1) * 7))
                        if serched.count != 0{
                            var indea_one_content = NSTextField()
                            var indea_one_content_p = Param(st_ :serched[0].idea,x_:18 + x*148,y_:550 - y*80,width_:130,height_:60,fontSize_:9)
                            U().text_generate(param_:indea_one_content_p,nsText_:indea_one_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                        }
                    }
                }
        }
        // page番号の表示
        var page_title = NSTextField()
        var page_title_p = Param(st_ :"ページ",x_:880,y_: 35,width_:50,height_:20,fontSize_:14)
        U().text_generate(param_:page_title_p,nsText_:page_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        var page_cotent = NSTextField()
        m_page_total =  m_max_x/7 + 1
        var page_cotent_p = Param(st_ :String(m_page_now) + " / " + String(m_page_total) ,x_:930,y_: 35,width_:50,height_:20,fontSize_:14)
        U().text_generate(param_:page_cotent_p,nsText_:page_cotent,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)

        var next_page_btn_p = Param(st_ :"次のページ",x_:1060,y_:35,width_:90,height_:20,fontSize_:13)
              U().button_generate(param_:next_page_btn_p,viewCon_:self,view_:self.view,action: #selector(next_page_click))
        var return_page_btn_p = Param(st_ :"前のページ",x_:960,y_:35,width_:90,height_:20,fontSize_:13)
              U().button_generate(param_:return_page_btn_p,viewCon_:self,view_:self.view,action: #selector(return_page_click))
        var return_btn_p = Param(st_ :"戻る",x_:925,y_:7,width_:75,height_:20,fontSize_:13)
        U().button_generate(param_:return_btn_p,viewCon_:self,view_:self.view,action: #selector(return_disp))

        var to_txt_disp_btn_p = Param(st_ :"テキスト表示",x_:1010,y_:7,width_:120,height_:20,fontSize_:13)
              U().button_generate(param_:to_txt_disp_btn_p,viewCon_:self,view_:self.view,action: #selector(to_txt_disp_click))
    }
    @objc func return_disp(){
        self.dismiss(nil)
    }
    @objc func to_txt_disp_click(){
        UserDefaults.standard.set("Divided_Group_Disp", forKey: "from_page")
        UserDefaults.standard.synchronize()
        U().screen_next(viewCon : self ,id:"Txt_Disp" , storyboard:storyboard!)
    }
    @objc func next_page_click(){
        print("m_page_now")
        print(m_page_now)
        print("m_page_total")
        print(m_page_total)
        if m_page_now < m_page_total{
            print("next_page_click")
            m_page_now = m_page_now + 1
            for v in view.subviews {
                v.removeFromSuperview()
            }
            first_appear()
        }
    }
    @objc func return_page_click(){
        
        if m_page_now > 1{
            print("return_page_click")
            m_page_now = m_page_now - 1
            for v in view.subviews {
                v.removeFromSuperview()
            }
            first_appear()
        }
    }
}
