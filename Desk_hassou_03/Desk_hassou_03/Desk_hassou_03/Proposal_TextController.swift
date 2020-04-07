//
//  Flows_ProgressController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/04/04.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Proposal_TextController: NSViewController {
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
    var viewForContent_1:NSView = NSView()
    var viewForContent_2:NSView = NSView()
    var m_flow_start_theme = ""
    var m_selected_theme = ""
    var m_from_page = ""
    var conversion_space_content = NSTextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        m_from_page = UserDefaults.standard.object(forKey: "from_page") as! String
        if m_from_page == "Flows_Progress"{
            m_selected_theme = UserDefaults.standard.object(forKey: "selected_theme") as! String
        }
        viewForContent_1 = NSView(frame:NSRect(x: 10, y: 10, width: 1200, height: 1300))
        viewForContent_2 = NSView(frame:NSRect(x: 10, y: 10, width: 1200, height: 1300))
        first_appear()
        first_appear_basic()
    }
    func first_appear(){
        var db_text_content = NSTextField()
        db_text_content.frame = CGRect(x:0, y:0, width:1200, height:1300);
        db_text_content.font = NSFont.systemFont(ofSize: 10)
        // DBから検索して、テキストに一覧表示を行う
        var db_text = ""
        if m_from_page == "Flows_Progress"{
            for i in 0..<1 {
                db_text = db_text + "\n"
            }
            db_text = db_text + "テーマ:" + m_selected_theme + "\n"
            let idea_s = realm.objects(More_Idea_Stock_1.self).filter("theme == %@",m_selected_theme).value(forKeyPath: "@distinctUnionOfObjects.idea") as! [String]
            for one in idea_s{
                // 9x9のフレームも一緒に表示する
                var frame_s = realm.objects(Nine_x_Nine_Stock.self).filter("y4_x4 == %@",m_selected_theme)
                for x in 0..<9{
                    for y in 0..<9{
                        var frame_sech = realm.objects(Nine_x_Nine_Stock.self).filter("y4_x4 == %@",m_selected_theme)
                    }
                }
                db_text = db_text + "●" + one + "\n"
                var more_idea_s = realm.objects(More_Idea_Stock_1.self).filter("theme == %@",m_selected_theme).filter("idea == %@",one).value(forKey: "more_idea_1") as! [String]
                for one_2 in more_idea_s{
                    db_text = db_text + "・" + one_2 + "\n"
                }
            }
            for i in 0..<3 {
                db_text = db_text + "\n"
            }
        }
        db_text_content.stringValue = db_text
        db_text_content.isEditable = false
        db_text_content.isSelectable = true
        db_text_content.isBordered = true
        viewForContent_1.addSubview(db_text_content)
        
        
        conversion_space_content.frame = CGRect(x:0, y:0, width:1200, height:1300);
        conversion_space_content.font = NSFont.systemFont(ofSize: 10)
        let idea_s = realm.objects(Proposal_text_db.self).filter("theme == %@",m_selected_theme).value(forKeyPath: "content") as! [String]
        if idea_s.count != 0 {
            conversion_space_content.stringValue = idea_s[0]
        }else{
            conversion_space_content.stringValue = ""
        }
        conversion_space_content.isEditable = true
        conversion_space_content.isBordered = true
        viewForContent_2.addSubview(conversion_space_content)
        
        var store_btn = NSButton(title: "保存", target: self, action: #selector(store_click))
        store_btn.frame = CGRect(x:1000, y:610, width:150, height:30);
        store_btn.font = NSFont.systemFont(ofSize: 20)
        self.view.addSubview(store_btn)
    }
    @objc func store_click(_ sender: NSButton) {
        let proposal_text_db = Proposal_text_db()
        proposal_text_db.theme = m_selected_theme
        proposal_text_db.content = conversion_space_content.stringValue
        try! realm.write() {
            realm.add(proposal_text_db)
        }
        let next = storyboard?.instantiateController(withIdentifier: "Flows_Progress")
        self.presentAsModalWindow(next! as! NSViewController)
        self.dismiss(nil)
    }
    func first_appear_basic(){
        // NSScrollView 内の領域
        let scrollContentView_1 = NSClipView(frame:
            NSRect(x: 10, y: 10, width: 500, height: 600))
        scrollContentView_1.documentView = viewForContent_1
        // ちょっと上が空くが気にしない。最初のスクロールの位置を上にする。
        scrollContentView_1.scroll(to: NSPoint(x: 0, y: 720))
        // NSScrollView の本体
        let scrollView_1 = NSScrollView(frame: NSRect(x: 10, y: 10, width: 500, height: 600))
        scrollView_1.contentView = scrollContentView_1
        scrollView_1.hasVerticalScroller = true
        scrollView_1.hasHorizontalScroller = true
        scrollView_1.autohidesScrollers = false
        self.view.addSubview(scrollView_1)
        
        // NSScrollView 内の領域
        let scrollContentView_2 = NSClipView(frame:
            NSRect(x: 10, y: 10, width: 600, height: 600))
        scrollContentView_2.documentView = viewForContent_2
        // ちょっと上が空くが気にしない。最初のスクロールの位置を上にする。
        scrollContentView_2.scroll(to: NSPoint(x: 0, y: 720))
        // NSScrollView の本体
        let scrollView_2 = NSScrollView(frame: NSRect(x: 600, y: 10, width: 600, height: 600))
        scrollView_2.contentView = scrollContentView_2
        scrollView_2.hasVerticalScroller = true
        scrollView_2.hasHorizontalScroller = true
        scrollView_2.autohidesScrollers = false
        self.view.addSubview(scrollView_2)
    }
}
class Line_Proposal_Text: NSView {
    var start_x = 0.0
    var start_y = 0.0
    var end_x = 0.0
    var end_y = 0.0
    var derection = Direction.none
    init(frame frameRect: NSRect, start_x_: Double, start_y_: Double, end_x_: Double, end_y_: Double,direction_:Direction) {
        super.init(frame: frameRect)
        self.start_x = start_x_
        self.start_y = start_y_
        self.end_x = end_x_
        self.end_y = end_y_
        self.derection = direction_
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        addLine()
    }
    func addLine() {
        if self.derection == Direction.tate{
            let path_1 = NSBezierPath()
            path_1.move(to: NSPoint(x: Double(start_x), y: Double(start_y)))
            path_1.line(to: NSPoint(x: Double(end_x), y: Double(end_y)))
            path_1.close()
            path_1.stroke()
            let path_2 = NSBezierPath()
            path_2.move(to: NSPoint(x: Double(end_x), y: Double(end_y)))
            path_2.line(to: NSPoint(x: Double(end_x - 15), y: Double(end_y + 15)))
            path_2.close()
            path_2.stroke()
            let path_3 = NSBezierPath()
            path_3.move(to: NSPoint(x: Double(end_x), y: Double(end_y)))
            path_3.line(to: NSPoint(x: Double(end_x + 15), y: Double(end_y + 15)))
            path_3.close()
            path_3.stroke()
        }else if self.derection == Direction.yoko{
            let path = NSBezierPath()

            path.move(to: NSPoint(x: Double(start_x + (150 / 2)), y: Double(start_y)))
            path.line(to: NSPoint(x: Double(end_x + (150 / 2) - 175), y: Double(end_y)))
            path.close()
            path.stroke()
        }
    }
}
