//
//  Randam_LocationController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/12.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Randam_LocationController: NSViewController {
    let realm = try! Realm()
    var m_theme = ""
    var m_idea_Stock_s:[String] = []
    var m_added_text_s:[CustomNSTextField] = []
    var m_x_y_Array:[Point_Store] = []
    var m_page_total = -999
    var m_page_now = 1
    var m_tag_count = 10000
    let TB_WIDTH = 115.0
    let TB_HEIGHT = 65.0
    
    var idea_count = 0
    let IDEA_ONE_DISP_UPPER_LIMIT = 25
    var first_falg = false
    var retrun_falg = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);

        first_appear()
    }
    func first_appear(){
       if first_falg == false{
           m_theme = UserDefaults.standard.object(forKey: "theme") as! String
           // ここに表示の処理を入れる
           var db_idea_Stock_s = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme)
           var db_idea_Stock_array = Array(db_idea_Stock_s)
           var temp :[String] = []
           for one in db_idea_Stock_array{
               if one.idea != ""{
                   temp.append(one.idea)
               }
           }
           let orderedSet = NSOrderedSet(array: temp)
           m_idea_Stock_s = orderedSet.array as! [String]
           if m_idea_Stock_s.count == 0{
               randam_generate(st_:"")
           }
           // 削除して、0から追加する。
           let deleting = realm.objects(Random_Loc_Idea.self).filter("theme == %@",m_theme)
           try! realm.write {
               realm.delete(deleting)
           }
           first_falg = true
       }
       var theme_content = NSTextField()
       var theme_content_p = Param(st_ :m_theme,x_:20,y_:575,width_:200,height_:50,fontSize_:9)
     U().text_generate(param_:theme_content_p,nsText_:theme_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
       
       // NSButtonの色の付け方が分からないので、NSClickGestureRecognizerで対応
       let retrun_button = NSTextField()
       retrun_button.isBordered = true
       retrun_button.isEditable = false
       retrun_button.isSelectable = true
       retrun_button.frame = CGRect(x:1000, y:10 , width:80, height:20);
       retrun_button.layer?.cornerRadius = 10.0
       retrun_button.stringValue = "保存せず戻る"
       retrun_button.wantsLayer = true
       retrun_button.backgroundColor = NSColor.green
       let clickDetection = NSClickGestureRecognizer()
       clickDetection.target = self
       clickDetection.action = #selector(self.return_button_click)
       retrun_button.addGestureRecognizer(clickDetection)
       self.view.addSubview(retrun_button)
       
       // NSButtonの色の付け方が分からないので、NSClickGestureRecognizerで対応
       let store_button = NSTextField()
       store_button.isBordered = true
       store_button.isEditable = false
       store_button.isSelectable = true
       store_button.frame = CGRect(x:1100, y:10 , width:80, height:20);
       store_button.layer?.cornerRadius = 10.0
       store_button.stringValue = "保存して戻る"
       store_button.wantsLayer = true
       store_button.backgroundColor = NSColor.green
       let clickDetection_2 = NSClickGestureRecognizer()
       clickDetection_2.target = self
       clickDetection_2.action = #selector(self.store_button_click)
       store_button.addGestureRecognizer(clickDetection_2)
       self.view.addSubview(store_button)
       // page番号の表示
       var page_title = NSTextField()
       var page_title_p = Param(st_ :"ページ",x_:880,y_: 35,width_:50,height_:20,fontSize_:14)
       U().text_generate(param_:page_title_p,nsText_:page_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
       
       m_page_total = Int(m_idea_Stock_s.count/21) + 1
       var page_cotent = NSTextField()
        var page_cotent_p = Param(st_ :String(m_page_now) + " / " + String(m_page_total) ,x_:930,y_: 35,width_:50,height_:20,fontSize_:14)
       U().text_generate(param_:page_cotent_p,nsText_:page_cotent,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        var next_page_btn_p = Param(st_ :"次のページ",x_:1060,y_:35,width_:90,height_:20,fontSize_:13)
              U().button_generate(param_:next_page_btn_p,viewCon_:self,view_:self.view,action: #selector(next_page_click))
        var return_page_btn_p = Param(st_ :"前のページ",x_:960,y_:35,width_:90,height_:20,fontSize_:13)
              U().button_generate(param_:return_page_btn_p,viewCon_:self,view_:self.view,action: #selector(return_page_click))

        if retrun_falg == false{
            var count = 0
            for one_idea_Stock in m_idea_Stock_s{
                count = count + 1
                if 0 + 20 * (m_page_now - 1) < count && count < 20 * m_page_now + 1{
                    randam_generate(st_:one_idea_Stock)
                }
            }
        }
//        print("m_page_now")
//        print(m_page_now)
        let disp_s = realm.objects(Random_Loc_Idea.self).filter("theme == %@",m_theme).filter("disp_num == %@",m_page_now)
//        print("disp_s")
//        print(disp_s)
        var disp_arr = Array(disp_s)
        var count_2 = 0
        for one in disp_arr{
//            print("one in disp_arr")
            count_2 = count_2 + 1
            randam_obj_disp(ran_loc_idea_: one)
        }
    }
    @objc func add_button_click(_ sender: CustomNSButton){
        randam_generate(st_:"")
    }
    @objc func deep_dip_button_click(_ sender: CustomNSButton){
        store_db()
        for v in view.subviews {
            v.removeFromSuperview()
        }
        m_x_y_Array.removeAll()
        m_added_text_s.removeAll()
        m_idea_Stock_s.removeAll()
        first_falg = false
        m_page_now = 1
        UserDefaults.standard.set(sender.st, forKey: "theme")
        UserDefaults.standard.synchronize()
        print("sender.st")
        print(sender.st)
        UserDefaults.standard.synchronize()
        for v in view.subviews {
            v.removeFromSuperview()
        }
        first_appear()
    }
    @objc func store_button_click(_ sender: CustomNSButton){
        store_db()
        self.dismiss(nil)
        U().screen_next(viewCon : self ,id:"Hierarchy_Theme" , storyboard:storyboard!)
    }
    func store_db(){
        // これが、今いる場面で追加があった場合の追加
        for one in m_added_text_s{
            var idea_stock = Idea_Stock()
            idea_stock.theme = m_theme
            idea_stock.idea = one.stringValue
            if one.stringValue != "" {
                try! realm.write() {
                    realm.add(idea_stock)
                }
            }
        }
        // こっちは、追加画面があった場合の追加
        let add_sock_s = realm.objects(Random_Loc_Idea.self).filter("theme == %@",m_theme)
        var add_sock_arr = Array(add_sock_s)
        for one in add_sock_arr{
            // Idea_Stockになければ追加する
            let serched = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme).filter("idea == %@",one.idea)
            if serched.count == 0{
                var idea_stock = Idea_Stock()
                idea_stock.theme = m_theme
                idea_stock.idea = one.idea
                try! realm.write() {
                    realm.add(idea_stock)
                }
            }
        }
    }
    @objc func return_button_click(_ sender: CustomNSButton){
        self.dismiss(nil)
        U().screen_next(viewCon : self ,id:"second" , storyboard:storyboard!)
    }
    func randam_generate(st_:String){
        var xRand = -999.0
        var yRand = -999.0
        var breakCount = 0
        var existFlag = false
        while true {
            breakCount = breakCount + 1
            xRand = Double.random(in: 10 ... 1000)
            yRand = Double.random(in: 60 ... 500)
            // 右下はボタンがあるため、そこには、表示されないようにはじく
            if xRand > 800 && yRand < 100 {
                existFlag = true
                break
            }
            for one_x_y_Array in m_x_y_Array{
                if Double(xRand - (TB_WIDTH + 5))  < Double(one_x_y_Array.x) && Double(one_x_y_Array.x) < Double(xRand + (TB_WIDTH + 5)) && Double(yRand - (TB_HEIGHT + 25)) < Double(one_x_y_Array.y) && Double(one_x_y_Array.y) < Double(yRand + (TB_HEIGHT + 25)){
                    existFlag = true
                }
            }
            if existFlag == false {
                let x_y = Point_Store()
                x_y.x = xRand
                x_y.y = yRand
                m_x_y_Array.append(x_y)
                break
            }
            if breakCount == 10000{
                break
            }
            existFlag = false
        }
        if existFlag == false {
//            print("existFlag == false")
            m_tag_count = m_tag_count + 1
            var random_loc_idea = Random_Loc_Idea()
            random_loc_idea.theme = m_theme
            random_loc_idea.idea = st_
            random_loc_idea.x = xRand
            random_loc_idea.y = yRand
            idea_count = idea_count + 1
            // 新しく追加したものに関しては、この時には、インサート出来ない。
            if st_ != ""{
                random_loc_idea.tag = m_tag_count + 10000
                random_loc_idea.disp_num = m_page_now
            }else{
                random_loc_idea.tag = m_tag_count
                random_loc_idea.disp_num = m_page_now
                randam_obj_disp(ran_loc_idea_:random_loc_idea)
            }
            try! realm.write() {
                realm.add(random_loc_idea)
            }
        }
    }
    @objc func next_page_click(){
        print("next_page_click")
        if m_page_now < m_page_total{
            // 追加されたテキストをDBに追加
            for one in m_added_text_s{
                var random_loc_idea = Random_Loc_Idea()
                random_loc_idea.theme = m_theme
                random_loc_idea.idea = one.stringValue
                random_loc_idea.x = one.loc_x
                random_loc_idea.y = one.loc_y
                random_loc_idea.disp_num = m_page_now

                try! realm.write() {
                    realm.add(random_loc_idea)
                }
            }
            
            m_page_now = m_page_now + 1
            for v in view.subviews {
                v.removeFromSuperview()
            }
            m_x_y_Array.removeAll()
            m_added_text_s.removeAll()
            first_appear()
        }
    }
    @objc func return_page_click(){
        print("return_page_click")
        if m_page_now > 1{
            for one in m_added_text_s{
                var random_loc_idea = Random_Loc_Idea()
                random_loc_idea.theme = m_theme
                random_loc_idea.idea = one.stringValue
                random_loc_idea.x = one.loc_x
                random_loc_idea.y = one.loc_y
                random_loc_idea.disp_num = m_page_now

                try! realm.write() {
                    realm.add(random_loc_idea)
                }
            }
            m_page_now = m_page_now - 1
            for v in view.subviews {
                v.removeFromSuperview()
            }
            m_x_y_Array.removeAll()
            m_added_text_s.removeAll()
            retrun_falg = true
            first_appear()
        }
    }
    func randam_obj_disp(ran_loc_idea_:Random_Loc_Idea){
        let random_content = CustomNSTextField()
        random_content.loc_x = ran_loc_idea_.x
        random_content.loc_y = ran_loc_idea_.y
        var random_content_p = Param(st_ :ran_loc_idea_.idea,x_:Int(ran_loc_idea_.x),y_:Int(ran_loc_idea_.y),width_:Int(TB_WIDTH),height_:Int(TB_HEIGHT),fontSize_:9)
        
        if ran_loc_idea_.idea != "" {
        U().text_generate(param_:random_content_p,nsText_:random_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
        }else{        U().text_generate(param_:random_content_p,nsText_:random_content,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
            m_added_text_s.append(random_content)
        }
        let add_button = CustomNSButton(title: "追加", target: self, action: #selector(add_button_click))
        add_button.frame = CGRect(x:ran_loc_idea_.x-5.0, y:ran_loc_idea_.y - 22.0, width:55.0, height:20.0);
        add_button.st = ran_loc_idea_.idea
        add_button.tag = 999
        self.view.addSubview(add_button)
        
        let deep_dip_button = CustomNSButton(title: "深掘り", target: self, action: #selector(deep_dip_button_click))
        deep_dip_button.frame = CGRect(x:ran_loc_idea_.x + 40, y:ran_loc_idea_.y - 22.0, width:65.0, height:20.0);
        deep_dip_button.st = ran_loc_idea_.idea
        deep_dip_button.tag = 777
        self.view.addSubview(deep_dip_button)
    }
}

