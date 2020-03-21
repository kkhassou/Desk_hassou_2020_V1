//
//  ProcessController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/21.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift
class ProcessController: NSViewController {
    let realm = try! Realm()
    var m_theme = ""
    var m_idea_Stock_s:[String] = []
    var m_added_text_s:[CustomNSTextField] = []
    var m_up_add_button_s:[CustomNSButton] = []
    var m_bottom_add_button_s:[CustomNSButton] = []
    var m_yajirusi_s:[YajirusiLine] = []
    var m_x_y_Array:[Point_Store] = []
    var m_page_total = -999
    var m_page_now = 1
    var m_tag_count = 10000
    let TB_WIDTH = 125.0
    let TB_HEIGHT = 50.0
    var total_textbox = 0
    var INTERVAL_YOKO = 150.0
    var INTERVAL_TATE = 90.0
    var start_x = -999.0
    var start_y = -999.0
    var now_x = -999.0
    var now_y = -999.0
    var FRAME_WIDTH = 1200.0
    var FRAME_HEIGT = 650.0
    var viewForContent = NSView()
    let contentWidth: CGFloat = 2400
    let contentHeight: CGFloat = 1300
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:FRAME_WIDTH, height:FRAME_HEIGT);

        let margin: CGFloat = 50
         
        viewForContent = NSView(frame:
            NSRect(x: 0, y: 0, width: contentWidth, height: contentHeight))
        
        start_x = 30 //FRAME_WIDTH / 2 - TB_WIDTH
        start_y = 30 //FRAME_HEIGT / 2 - TB_HEIGHT
        
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        
        add_textbox(num:total_textbox)
        add_yajirusi_line(num: total_textbox)
        add_yajirusi_line(num: total_textbox)
        var count = 0
        for one in m_added_text_s{
            viewForContent.addSubview(one)
            viewForContent.addSubview(m_up_add_button_s[count])
            viewForContent.addSubview(m_bottom_add_button_s[count])
            viewForContent.addSubview(m_yajirusi_s[count])
            count = count + 1
        }
        add_scroll()
    }
    @objc func up_add_click(_ sender: CustomNSButton){
        // sender.index より大きい数字がなければ、末尾に追加
        var big_exist = false
        for one in m_added_text_s {
            if one.index > sender.index{
                big_exist = true
            }
        }
        if big_exist == false{
            total_textbox = total_textbox + 1
            add_textbox(num:total_textbox)
            add_yajirusi_line(num: total_textbox)
            var count = 0
            for one in m_added_text_s{
                // このprintがないと文字列が消える。なんか、SWIFTのバグっぽい。
                print(one.stringValue)
                viewForContent.addSubview(one)
                viewForContent.addSubview(m_up_add_button_s[count])
                viewForContent.addSubview(m_bottom_add_button_s[count])
                viewForContent.addSubview(m_yajirusi_s[count])
                count = count + 1
            }
        }else{
            total_textbox = total_textbox + 1
            let deleting = realm.objects(Process_s_DB.self).filter("theme == %@",m_theme)
            try! realm.write {
                realm.delete(deleting)
            }
            print("----------")
            for one in m_added_text_s{
                print("^^^^^^^^^")
                print("one.index")
                print(one.index)
                print("one.stringValue")
                print(one.stringValue)
                let process_s_db = Process_s_DB()
                process_s_db.theme  = m_theme
                process_s_db.index = one.index
                process_s_db.content = one.stringValue
                try! realm.write() {
                    realm.add(process_s_db)
                }
                print("^^^^^^^^^")
            }
            print("----------")
            var temp_s:[CustomNSTextField] = []
            temp_s.append(contentsOf: m_added_text_s)
            m_added_text_s.removeAll()
            m_up_add_button_s.removeAll()
            m_bottom_add_button_s.removeAll()
            for one in temp_s{
                // より大きいものの位置を1つ1つ位置を右にずらして追加する必要がある。
                if one.index >= sender.index{
                    add_textbox(num:one.index + 1)
                }else if one.index < sender.index{
                    add_textbox(num:one.index)
                }
            }
            add_textbox(num:sender.index)
            var count = 0
//            print("----------")
            // 再度、構築し直さなければならない
            
            for one in m_added_text_s{
//                print("one.index")
//                print(one.index)
                if one.index > sender.index{
                    let serched = realm.objects(Process_s_DB.self).filter("theme == %@",m_theme).filter("index == %@",(one.index - 1)).last
//                    print("^^^^^^^^^")
//                    print("serched!.content mae")
//                    print(serched!.content)
//                    print("^^^^^^^^^")
                    one.stringValue = serched!.content
                }else  if one.index == sender.index{
                    one.stringValue = ""
                }else{
                    let serched = realm.objects(Process_s_DB.self).filter("theme == %@",m_theme).filter("index == %@",one.index).last
//                    print("^^^^^^^^^")
//                    print("serched!.content ato")
//                    print(serched!.content)
//                    print("^^^^^^^^^")
                    one.stringValue = serched!.content
                }
                viewForContent.addSubview(one)
                viewForContent.addSubview(m_up_add_button_s[count])
                viewForContent.addSubview(m_bottom_add_button_s[count])
                add_yajirusi_line(num: one.index)
                viewForContent.addSubview(m_yajirusi_s[one.index])
                count = count + 1
            }
//            print("----------")

        }
        add_scroll()
    }
    @objc func bottom_add_click(_ sender: CustomNSButton){
            total_textbox = total_textbox + 1
            let deleting = realm.objects(Process_s_DB.self).filter("theme == %@",m_theme)
            try! realm.write {
                realm.delete(deleting)
            }
            print("----------")
            for one in m_added_text_s{
                let process_s_db = Process_s_DB()
                process_s_db.theme  = m_theme
                process_s_db.index = one.index
                process_s_db.content = one.stringValue
                try! realm.write() {
                    realm.add(process_s_db)
                }
            }
            var temp_s:[CustomNSTextField] = []
            temp_s.append(contentsOf: m_added_text_s)
            m_added_text_s.removeAll()
            m_up_add_button_s.removeAll()
            m_bottom_add_button_s.removeAll()
            for one in temp_s{
                // より大きいものの位置を1つ1つ位置を右にずらして追加する必要がある。
                if one.index >= sender.index{
                    add_textbox(num:one.index + 1)
                }else if one.index < sender.index{
                    add_textbox(num:one.index)
                }
            }
            add_textbox(num:sender.index)
            var count = 0
            
            for one in m_added_text_s{
                if one.index > sender.index{
                    let serched = realm.objects(Process_s_DB.self).filter("theme == %@",m_theme).filter("index == %@",(one.index - 1)).last
                    one.stringValue = serched!.content
                }else  if one.index == sender.index{
                    one.stringValue = ""
                }else{
                    let serched = realm.objects(Process_s_DB.self).filter("theme == %@",m_theme).filter("index == %@",one.index).last
                    one.stringValue = serched!.content
                }
                viewForContent.addSubview(one)
                viewForContent.addSubview(m_up_add_button_s[count])
                viewForContent.addSubview(m_bottom_add_button_s[count])
                add_yajirusi_line(num: one.index)
                viewForContent.addSubview(m_yajirusi_s[one.index])
                count = count + 1
            }

            
            add_scroll()
    }
    func add_scroll(){
        // NSScrollView 内の領域
        let scrollContentView = NSClipView(frame:
            NSRect(x: 0, y: 0, width: contentWidth, height: contentHeight))
        scrollContentView.documentView = viewForContent
        // ちょっと上が空くが気にしない。最初のスクロールの位置を上にする。
        // 左下から始めるからここ。
        scrollContentView.scroll(to: NSPoint(x: 0, y: 0))
        
        // NSScrollView の本体
        let scrollView = NSScrollView(frame: NSRect(x: 10, y: 10, width: 1180, height: 630))
        scrollView.contentView = scrollContentView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = false
        self.view.addSubview(scrollView)
        
        // これは、あえて左上に固定したいので、スクロールに付与しない
        var theme_content = NSTextField()
        theme_content.frame = CGRect(x:50, y:550, width:TB_WIDTH, height:TB_HEIGHT);
        theme_content.stringValue = m_theme
        theme_content.font = NSFont.systemFont(ofSize: 12)
        theme_content.isEditable = false
        theme_content.isBordered = false
        self.view.addSubview(theme_content)
    }
    func add_textbox(num:Int){
        var process_element = CustomNSTextField()
        now_x = start_x + INTERVAL_YOKO * Double(num)
        now_y = start_y + INTERVAL_TATE * Double(num)
        process_element.frame = CGRect(x:now_x, y:now_y, width:TB_WIDTH, height:TB_HEIGHT);
        process_element.stringValue = ""
        process_element.font = NSFont.systemFont(ofSize: 10)
        process_element.isEditable = true
        process_element.isBordered = true
        process_element.index = num
        m_added_text_s.append(process_element)
//        viewForContent.addSubview(process_element)
        
        let up_add_button = CustomNSButton(title: "前に追加", target: self, action: #selector(bottom_add_click))
        up_add_button.frame = CGRect(x:now_x-5.0, y:now_y - 22.0, width:65.0, height:20.0);
        up_add_button.font = NSFont.systemFont(ofSize: 10)
        up_add_button.index = num
        m_up_add_button_s.append(up_add_button)
//        viewForContent.addSubview(up_add_button)
        
        let bottom_add_button = CustomNSButton(title: "次に追加", target: self, action: #selector(up_add_click))
        bottom_add_button.frame = CGRect(x:now_x + 60, y:now_y - 22.0, width:65.0, height:20.0);
        bottom_add_button.font = NSFont.systemFont(ofSize: 10)
        bottom_add_button.index = num
        m_bottom_add_button_s.append(bottom_add_button)
    }
    func add_yajirusi_line(num:Int){
        // まず、枠の線を引こう
        let yajirusi = YajirusiLine(frame: self.view.frame, num_: num)
        viewForContent.addSubview(yajirusi)
        yajirusi.translatesAutoresizingMaskIntoConstraints = false
        yajirusi.topAnchor.constraint(equalTo: viewForContent.topAnchor).isActive = true
        yajirusi.bottomAnchor.constraint(equalTo: viewForContent.bottomAnchor).isActive = true
        yajirusi.leftAnchor.constraint(equalTo: viewForContent.leftAnchor).isActive = true
        yajirusi.rightAnchor.constraint(equalTo: viewForContent.rightAnchor).isActive = true
        m_yajirusi_s.append(yajirusi)
    }
}
class YajirusiLine: NSView {
    let TB_WIDTH = 125.0
    let TB_HEIGHT = 50.0
    var x = -999
    var y = -999
    var start_x = 30
    var start_y = 30
    var INTERVAL_YOKO = 150.0
    var INTERVAL_TATE = 90.0
    
    init(frame frameRect: NSRect,  num_: Int){//x_: Int, y_: Int) {
        super.init(frame: frameRect)
        var now_x = Double(start_x) + INTERVAL_YOKO * Double(num_)
        var now_y = Double(start_y) + INTERVAL_TATE * Double(num_)
        self.x = Int(now_x)
        self.y = Int(now_y)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        addLine()
    }
    func addLine() {
        let start_point = NSPoint(x: x + Int(TB_WIDTH), y: y + Int(TB_HEIGHT))
        let end_point = NSPoint(x: x + Int(TB_WIDTH) + 20, y: y + Int(TB_HEIGHT) + 20)
        let yajirusi_end_point_1 = NSPoint(x: Int(end_point.x) - 10, y: Int(end_point.y))
        let yajirusi_end_point_2 = NSPoint(x: Int(end_point.x), y: Int(end_point.y) - 10)
        // 正方形なので4本線を引く
        let path_1 = NSBezierPath()
        path_1.move(to: start_point)
        path_1.line(to: end_point)
        path_1.close()
        path_1.stroke()
        let path_2 = NSBezierPath()
        path_2.move(to: end_point)
        path_2.line(to: yajirusi_end_point_1)
        path_2.close()
        path_2.stroke()
        let path_3 = NSBezierPath()
        path_3.move(to: end_point)
        path_3.line(to: yajirusi_end_point_2)
        path_3.close()
        path_3.stroke()
    }
}
