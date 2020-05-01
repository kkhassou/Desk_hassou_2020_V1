//
//  Randam_Area_S_Controller.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/19.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Randam_Area_S_Ver2_Controller: NSViewController {
    let realm = try! Realm()
    var m_theme = ""
    var theme_stocks:[String] = []
    let TB_WIDTH = 110.0
    let TB_HEIGHT = 50.0
    let CONTENTWIDTH: CGFloat = 3600
    let CONTENTHEIGHT: CGFloat = 2400
    let LINE_WIDTH = 600
    let LINE_HEIGHT = 400
    let MAGIN_WIDTH = 20
    let MAGIN_HEIGHT = 80
    let margin: CGFloat = 50
    var viewForContent:NSView = NSView()
    
    var m_x_y_Array:[Point_Store] = []
    var m_added_text_s:[CustomNSTextField] = []
    var m_title_text_s:[CustomNSTextField] = []
    var m_tag_count = 0
    var m_area_count = 0
    var m_tate = -999
    var m_yoko = -999
    
    var first_flag = true
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        
        viewForContent = NSView(frame:
            NSRect(x: 0, y: 0, width: CONTENTWIDTH, height: CONTENTHEIGHT))
         
        var store_btn = NSButton(title: "保存", target: self, action: #selector(store_click))
        store_btn.frame = CGRect(x:0, y:CONTENTHEIGHT - 30, width:100, height:30);
        store_btn.font = NSFont.systemFont(ofSize: 12)
        viewForContent.addSubview(store_btn)
        
        var text_disp_btn = NSButton(title: "テキスト表示", target: self, action: #selector(text_disp_click))
        text_disp_btn.frame = CGRect(x:120, y:CONTENTHEIGHT - 30, width:150, height:30);
        text_disp_btn.font = NSFont.systemFont(ofSize: 12)
        viewForContent.addSubview(text_disp_btn)
        
        var hozon_disp = NSTextField()
        hozon_disp.frame = CGRect(x:0, y:CONTENTHEIGHT - 80, width:20, height:50);
        hozon_disp.font = NSFont.systemFont(ofSize: 12)
        hozon_disp.stringValue = "↑保存"
        hozon_disp.isEditable = false
        hozon_disp.isBordered = false
        viewForContent.addSubview(hozon_disp)
        
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        
        let db_start_theme = realm.objects(Randam_Area_S_DB.self).filter("start_theme == %@",m_theme)
        if db_start_theme.count == 0{
            first_appear()
        }else{
            first_flag = false
            // 2重にループを回す必要がある。
            var temp :[String] = []
            for one in db_start_theme{
                temp.append(one.theme)
            }
            let orderedSet = NSOrderedSet(array: temp)
            var unique_theme = orderedSet.array as! [String]
            m_area_count = unique_theme.count - 1
            for one in unique_theme{
                var first_for = true
                let db_theme = realm.objects(Randam_Area_S_DB.self).filter("theme == %@",one)
                for one_2 in db_theme{
                    if first_for == true{
                        count2tate_yoko(area_count_: one_2.disp_count)
                    }
                    randam_generate(st_:one_2.idea,area_count: one_2.disp_count)
                    if first_for == true{
                        add_area(area_count: one_2.disp_count,theme_:one,click_loc: -999)
                        first_for = false
                    }
                }
                
            }
        }
    }
    func first_appear(){
        count2tate_yoko(area_count_: m_area_count)
        randam_generate(st_:"",area_count: m_area_count)
        add_area(area_count: m_area_count,theme_:m_theme,click_loc: 0)
    }
    func add_area(area_count:Int,theme_:String,click_loc:Int){
        var theme_content = CustomNSTextField()
        if click_loc == -999{
            theme_content.stringValue = theme_
        }else{
            if first_flag == true{
                theme_content.stringValue = String(area_count + 1) + "- " + theme_
                first_flag = false
            }else{
                for one in m_title_text_s{
                    if click_loc == one.area_loc{
                        let arr:[String] = one.stringValue.components(separatedBy: "-")
                        var index = ""
                        var count = 0
                        var initial_roop = true
                        for one_2 in arr{
                            count = count + 1
                            if initial_roop == true{
                                index = one_2
                                initial_roop = false
                            }else{
                                index = index + "-" + one_2
                            }
                            if count == arr.count - 1{
                                break
                            }
                        }
                        // 配列を何度も回すのは、馬鹿らしいので、
                        // DBにindexを格納して、同じものがあれば、一つ増やす、という処理にしよう。
                        var roop_continue = true
                        var roop_start = 1
                        while roop_continue{
                            var index_added = index + "-" + String(roop_start) + "-"
                            roop_start = roop_start + 1
                            let serched = realm.objects(Index_Collect.self).filter("theme == %@",m_theme).filter("index == %@",index_added)
                            if serched.count == 0{
                                let index_collect = Index_Collect()
                                index_collect.theme = m_theme
                                index_collect.index = index_added
                                try! realm.write {
                                    realm.add(index_collect)
                                }
                                theme_content.stringValue = index_added + " " + theme_
                                roop_continue = false
                            }
                        }
                    }
                }
            }
        }
        theme_content.frame = CGRect(x:20 + CGFloat(400 * (m_yoko)), y:CONTENTHEIGHT - 70 - CGFloat((LINE_HEIGHT + MAGIN_HEIGHT) * (m_tate)), width:400, height:30);
        theme_content.font = NSFont.systemFont(ofSize: 12)
        theme_content.isEditable = false
        theme_content.isBordered = false
        theme_content.area_loc = area_count
        m_title_text_s.append(theme_content)
        viewForContent.addSubview(theme_content)
        // NSScrollView 内の領域
        let scrollContentView = NSClipView(frame:
            NSRect(x: 0, y: 0, width: CONTENTWIDTH, height: CONTENTHEIGHT))
        scrollContentView.documentView = viewForContent
        // ちょっと上が空くが気にしない。最初のスクロールの位置を上にする。
        scrollContentView.scroll(to: NSPoint(x: 0, y: CONTENTHEIGHT))
        add_area_line(area_count_:area_count)
        // NSScrollView の本体
        let scrollView = NSScrollView(frame: NSRect(x: 10, y: 10, width: 1180, height: 630))
        scrollView.contentView = scrollContentView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = false
        self.view.addSubview(scrollView)
    }
    func add_area_line(area_count_:Int){
        // まず、枠の線を引こう
        let yoko_2 = Randam_Area_S_Ver2_Line(frame: self.view.frame, x_: m_yoko + 1, y_: m_tate + 1)
        yoko_2.translatesAutoresizingMaskIntoConstraints = false
        viewForContent.addSubview(yoko_2)
        yoko_2.topAnchor.constraint(equalTo: viewForContent.topAnchor).isActive = true
        yoko_2.bottomAnchor.constraint(equalTo: viewForContent.bottomAnchor).isActive = true
        yoko_2.leftAnchor.constraint(equalTo: viewForContent.leftAnchor).isActive = true
        yoko_2.rightAnchor.constraint(equalTo: viewForContent.rightAnchor).isActive = true
    }
    func randam_generate(st_:String,area_count: Int){
        // こっちはこっちで、横縦の位置を取得せねばならない。
        var hani_yoko = area_count % 5
        var hani_tate = Int(area_count / 5)
        
        var xRand = -999.0
        var yRand = -999.0
        var breakCount = 0
        var existFlag = false
        while true {
            breakCount = breakCount + 1
            // テキストを配置する範囲を決める
            var hidariX = MAGIN_WIDTH + ((LINE_WIDTH + MAGIN_WIDTH) * (hani_yoko))
            var migiiX = hidariX + LINE_WIDTH - Int(TB_WIDTH)
            // 一旦横への移動だけ考慮する。
            var ueY = Int(CONTENTHEIGHT) - (hani_tate + 1) * MAGIN_HEIGHT  - (hani_tate) * LINE_HEIGHT - 30
            var sitaY = Int(CONTENTHEIGHT) - (hani_tate + 1) * (MAGIN_HEIGHT + LINE_HEIGHT) + 30
            xRand = Double.random(in: Double(hidariX) ... Double(migiiX))
            yRand = Double.random(in: Double(sitaY) ... Double(ueY))
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
            var random_loc_idea = Random_Loc_Idea()
            random_loc_idea.theme = m_theme
            random_loc_idea.idea = st_
            random_loc_idea.x = xRand
            random_loc_idea.y = yRand
            random_loc_idea.disp_num = area_count
            // 新しく追加したものに関しては、この時には、インサート出来ない。
            if st_ != ""{
                randam_obj_disp(ran_loc_idea_:random_loc_idea)
            }else{
                randam_obj_disp(ran_loc_idea_:random_loc_idea)
            }
        }
    }
    func count2tate_yoko(area_count_:Int){
        m_yoko = area_count_ % 5
        m_tate = Int(area_count_ / 5)
    }
    func randam_obj_disp(ran_loc_idea_:Random_Loc_Idea){
        m_tag_count = m_tag_count + 1
        let random_content = CustomNSTextField()
        random_content.loc_x = ran_loc_idea_.x
        random_content.loc_y = ran_loc_idea_.y
        random_content.frame = CGRect(x:Int(ran_loc_idea_.x), y:Int(ran_loc_idea_.y), width:Int(TB_WIDTH), height:Int(TB_HEIGHT))
        random_content.font = NSFont.systemFont(ofSize: CGFloat(9))
        random_content.isEditable = true
        random_content.isBordered = true
        random_content.tag = m_tag_count
        random_content.area_loc = ran_loc_idea_.disp_num
        random_content.stringValue = ran_loc_idea_.idea
        viewForContent.addSubview(random_content)
        m_added_text_s.append(random_content)
        
        let add_button = CustomNSButton(title: "追加", target: self, action: #selector(add_button_click))
        add_button.frame = CGRect(x:ran_loc_idea_.x-15.0, y:ran_loc_idea_.y - 22.0, width:45.0, height:20.0);
        add_button.st = ran_loc_idea_.idea
        add_button.tag = m_tag_count
        add_button.area_loc = ran_loc_idea_.disp_num
        add_button.font = NSFont.systemFont(ofSize: 8)
        viewForContent.addSubview(add_button)
        
        let deep_dip_button = CustomNSButton(title: "深掘り", target: self, action: #selector(deep_dip_button_click))
        deep_dip_button.frame = CGRect(x:ran_loc_idea_.x + 20.0, y:ran_loc_idea_.y - 22.0, width:50.0, height:20.0);
        deep_dip_button.st = ran_loc_idea_.idea
        deep_dip_button.tag = m_tag_count
        deep_dip_button.area_loc = ran_loc_idea_.disp_num
        deep_dip_button.font = NSFont.systemFont(ofSize: 8)
        viewForContent.addSubview(deep_dip_button)
        
        let proposal_button = CustomNSButton(title: "企画", target: self, action: #selector(proposal_button_click))
        proposal_button.frame = CGRect(x:ran_loc_idea_.x + 65.0, y:ran_loc_idea_.y - 22.0, width:45.0, height:20.0);
        proposal_button.st = ran_loc_idea_.idea
        proposal_button.tag = m_tag_count
        proposal_button.area_loc = ran_loc_idea_.disp_num
        proposal_button.font = NSFont.systemFont(ofSize: 8)
        viewForContent.addSubview(proposal_button)
    }
    func store_db(){
        let deleting = realm.objects(Randam_Area_S_DB.self).filter("start_theme == %@",m_theme)
        try! realm.write {
            realm.delete(deleting)
        }
        for one in m_added_text_s{
            var randam_area_s_db = Randam_Area_S_DB()
            randam_area_s_db.start_theme = m_theme
            for one_2 in m_title_text_s{
                if one.area_loc == one_2.area_loc{
                    randam_area_s_db.theme = one_2.stringValue
                }
            }
            randam_area_s_db.disp_count = one.area_loc
            randam_area_s_db.idea = one.stringValue
            try! realm.write {
                realm.add(randam_area_s_db)
            }
        }
    }
    @objc func proposal_button_click(_ sender: NSButton){
        store_db()
        self.dismiss(nil)
        // 別画面へ遷移する。
        // そこで、アイデアを企画にまとめられるようにする。
        for one in m_added_text_s{
            if one.tag == sender.tag {
                UserDefaults.standard.set(m_theme + ">>" + one.stringValue, forKey: "trigger_idea")
            }
        }
        UserDefaults.standard.set("Randam_Area_S", forKey: "from_page")
        UserDefaults.standard.synchronize()
        let next = storyboard?.instantiateController(withIdentifier: "Proposal")
        self.presentAsModalWindow(next! as! NSViewController)
    }
    @objc func store_click(_ sender: NSButton){
        store_db()
        self.dismiss(nil)
    }
    @objc func text_disp_click(_ sender: CustomNSButton){
        store_db()
        UserDefaults.standard.set("Randam_Area_S", forKey: "from_page")
        UserDefaults.standard.synchronize()
        let next = storyboard?.instantiateController(withIdentifier: "Txt_Disp")
        self.presentAsModalWindow(next! as! NSViewController)
    }
    @objc func add_button_click(_ sender: CustomNSButton){
        randam_generate(st_:"",area_count: sender.area_loc)
    }
    @objc func deep_dip_button_click(_ sender: CustomNSButton){
        print("sender.area_loc")
        print(sender.area_loc)
        m_area_count = m_area_count + 1
        count2tate_yoko(area_count_:m_area_count)
        randam_generate(st_:"",area_count: m_area_count)
        for one in m_added_text_s{
            if one.tag == sender.tag {
                add_area(area_count: m_area_count,theme_: one.stringValue,click_loc:sender.area_loc)
            }
        }
    }
}
class Randam_Area_S_Ver2_Line: NSView {
    var x = -999
    var y = -999
    var derection = Direction.none
    init(frame frameRect: NSRect, x_: Int, y_: Int) {
        super.init(frame: frameRect)
        self.x = x_
        self.y = y_
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        addLine()
    }
    func addLine() {
        let CONTENTWIDTH = 3600
        let CONTENTHEIGHT = 2400
        let LINE_WIDTH = 600
        let LINE_HEIGHT = 400
        let MAGIN_WIDTH = 20
        let MAGIN_HEIGHT = 80
        let hidariUe = NSPoint(x: Double((x - 1)*LINE_WIDTH + MAGIN_WIDTH), y: Double(CONTENTHEIGHT - ((y)*(MAGIN_HEIGHT)) - (y - 1)*LINE_HEIGHT))
        let migiiUe = NSPoint(x: Double((x)*LINE_WIDTH + MAGIN_WIDTH), y: Double(CONTENTHEIGHT - ((y)*(MAGIN_HEIGHT)) - (y - 1)*LINE_HEIGHT))
        let hidariSita = NSPoint(x: Double((x - 1)*LINE_WIDTH + MAGIN_WIDTH), y: Double(CONTENTHEIGHT - y*(MAGIN_HEIGHT + LINE_HEIGHT)))
        let migiSita = NSPoint(x: Double((x)*LINE_WIDTH + MAGIN_WIDTH), y: Double(CONTENTHEIGHT - y*(MAGIN_HEIGHT + LINE_HEIGHT)))
        // 正方形なので4本線を引く
        let path_1 = NSBezierPath()
        path_1.move(to: hidariUe)
        path_1.line(to: hidariSita)
        path_1.close()
        path_1.stroke()
        let path_2 = NSBezierPath()
        path_2.move(to: hidariSita)
        path_2.line(to: migiSita)
        path_2.close()
        path_2.stroke()
        let path_3 = NSBezierPath()
        path_3.move(to: migiSita)
        path_3.line(to: migiiUe)
        path_3.close()
        path_3.stroke()
        let path_4 = NSBezierPath()
        path_4.move(to: migiiUe)
        path_4.line(to: hidariUe)
        path_4.close()
        path_4.stroke()
    }
}
