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

class Randam_Area_S_Controller: NSViewController {
    let realm = try! Realm()
    var m_theme = ""
    var theme_stocks:[String] = []
    let TB_WIDTH = 100.0
    let TB_HEIGHT = 35.0
    let CONTENTWIDTH: CGFloat = 2400
    let CONTENTHEIGHT: CGFloat = 1300
    let LINE_WIDTH = 400
    let LINE_HEIGHT = 250
    let MAGIN_WIDTH = 20
    let MAGIN_HEIGHT = 80
    let margin: CGFloat = 50
    var viewForContent:NSView = NSView()
    
    var m_x_y_Array:[Point_Store] = []
    var m_added_text_s:[CustomNSTextField] = []
    
    var m_tag_count = 0
    var m_area_count = 0
    var m_tate = -999
    var m_yoko = -999
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        

         
        viewForContent = NSView(frame:
            NSRect(x: 0, y: 0, width: CONTENTWIDTH, height: CONTENTHEIGHT))
                 
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        
        count2tate_yoko(area_count_: m_area_count)
        randam_generate(st_:"",area_count: m_area_count)
        add_area(area_count: m_area_count,theme_:m_theme)
    }
    func add_area(area_count:Int,theme_:String){
        var theme_content = NSTextField()
        theme_content.stringValue = String(area_count) + "-" + theme_
        theme_content.frame = CGRect(x:20 + CGFloat(400 * (m_yoko)), y:CONTENTHEIGHT - 70 - CGFloat((LINE_HEIGHT + MAGIN_HEIGHT) * (m_tate)), width:400, height:30);
        theme_content.font = NSFont.systemFont(ofSize: 12)
        theme_content.isEditable = false
        theme_content.isBordered = false
        viewForContent.addSubview(theme_content)
        // NSScrollView 内の領域
        let scrollContentView = NSClipView(frame:
            NSRect(x: 0, y: 0, width: CONTENTWIDTH, height: CONTENTHEIGHT))
        scrollContentView.documentView = viewForContent
        // ちょっと上が空くが気にしない。最初のスクロールの位置を上にする。
        scrollContentView.scroll(to: NSPoint(x: 0, y: 650))
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
        let yoko_2 = AreaLine(frame: self.view.frame, x_: m_yoko + 1, y_: m_tate + 1)
        yoko_2.translatesAutoresizingMaskIntoConstraints = false
        viewForContent.addSubview(yoko_2)
        yoko_2.topAnchor.constraint(equalTo: viewForContent.topAnchor).isActive = true
        yoko_2.bottomAnchor.constraint(equalTo: viewForContent.bottomAnchor).isActive = true
        yoko_2.leftAnchor.constraint(equalTo: viewForContent.leftAnchor).isActive = true
        yoko_2.rightAnchor.constraint(equalTo: viewForContent.rightAnchor).isActive = true
    }
    func randam_generate(st_:String,area_count: Int){
        var xRand = -999.0
        var yRand = -999.0
        var breakCount = 0
        var existFlag = false
        while true {
            breakCount = breakCount + 1
            // テキストを配置する範囲を決める
            var hidariX = MAGIN_WIDTH + ((LINE_WIDTH + MAGIN_WIDTH) * (m_yoko))
            var migiiX = hidariX + LINE_WIDTH - Int(TB_WIDTH)
            // 一旦横への移動だけ考慮する。
//            var ueY = Int(CONTENTHEIGHT) - ((m_area_count - 1)*LINE_HEIGHT) - MAGIN_HEIGHT - Int(TB_HEIGHT)
            var ueY = Int(CONTENTHEIGHT) - MAGIN_HEIGHT - Int(TB_HEIGHT) - ((LINE_HEIGHT) * (m_tate))
            var sitaY = ueY - LINE_HEIGHT + Int(TB_HEIGHT*2)
//            print(hidariX)
//            print(migiiX)
//            print(ueY)
//            print(sitaY)
            xRand = Double.random(in: Double(hidariX) ... Double(migiiX))
            yRand = Double.random(in: Double(sitaY) ... Double(ueY))
//            print(xRand)
//            print(yRand)
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
        viewForContent.addSubview(random_content)
        m_added_text_s.append(random_content)
        
        let add_button = CustomNSButton(title: "追加", target: self, action: #selector(add_button_click))
        add_button.frame = CGRect(x:ran_loc_idea_.x-5.0, y:ran_loc_idea_.y - 22.0, width:55.0, height:20.0);
        add_button.st = ran_loc_idea_.idea
        add_button.tag = m_tag_count
        add_button.area_loc = ran_loc_idea_.disp_num
        viewForContent.addSubview(add_button)
        
        let deep_dip_button = CustomNSButton(title: "深掘り", target: self, action: #selector(deep_dip_button_click))
        deep_dip_button.frame = CGRect(x:ran_loc_idea_.x + 40, y:ran_loc_idea_.y - 22.0, width:65.0, height:20.0);
        deep_dip_button.st = ran_loc_idea_.idea
        deep_dip_button.tag = m_tag_count
        deep_dip_button.area_loc = ran_loc_idea_.disp_num
        // ここで、クリックした時のエリアも取得できるので、後は、表示する時の座標を決める時に使えばOK
        
        viewForContent.addSubview(deep_dip_button)
    }
    @objc func add_button_click(_ sender: CustomNSButton){
        print("sender.area_loc")
        print(sender.area_loc)
        randam_generate(st_:"",area_count: sender.area_loc)
    }
    @objc func deep_dip_button_click(_ sender: CustomNSButton){
        // まずは、追加だけでやってみよう。
        m_area_count = m_area_count + 1
        count2tate_yoko(area_count_:m_area_count)
        randam_generate(st_:"",area_count: m_area_count)
        for one in m_added_text_s{
            if one.tag == sender.tag {
                add_area(area_count: m_area_count,theme_: one.stringValue)
            }
        }
    }
}
class AreaLine: NSView {
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
        let LINE_WIDTH = 400
        let LINE_HEIGHT = 250
        let MAGIN_WIDTH = 20
        let MAGIN_HEIGHT = 80
        let CONTENTHEIGHT = 1300
        let hidariUe = NSPoint(x: Double((x - 1)*LINE_WIDTH + MAGIN_WIDTH), y: Double(CONTENTHEIGHT - ((y - 1)*(LINE_HEIGHT + MAGIN_HEIGHT)) - MAGIN_HEIGHT))
        let migiiUe = NSPoint(x: Double((x)*LINE_WIDTH + MAGIN_WIDTH), y: Double(CONTENTHEIGHT - ((y - 1)*(LINE_HEIGHT + MAGIN_HEIGHT)) - MAGIN_HEIGHT))
        let hidariSita = NSPoint(x: Double((x - 1)*LINE_WIDTH + MAGIN_WIDTH), y: Double(CONTENTHEIGHT - ((y)*(LINE_HEIGHT + MAGIN_HEIGHT)) - MAGIN_HEIGHT))
        let migiSita = NSPoint(x: Double((x)*LINE_WIDTH + MAGIN_WIDTH), y: Double(CONTENTHEIGHT - ((y)*(LINE_HEIGHT + MAGIN_HEIGHT)) - MAGIN_HEIGHT))
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
