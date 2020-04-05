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

class Flows_ProgressController: NSViewController {
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
    var m_flow_start_theme = ""
    var m_selected_theme = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        m_flow_start_theme = UserDefaults.standard.object(forKey: "flow_start_theme") as! String
        m_selected_theme = UserDefaults.standard.object(forKey: "selected_theme") as! String
        viewForContent = NSView(frame:NSRect(x: 0, y: 0, width: CONTENTWIDTH, height: CONTENTHEIGHT))
        first_appear()
        first_appear_basic()
    }
    func first_appear(){
        var start_theme_title = NSTextField()
        start_theme_title.frame = CGRect(x:20, y:CONTENTHEIGHT - 100, width:200, height:30);
        start_theme_title.font = NSFont.systemFont(ofSize: 20)
        start_theme_title.stringValue = "スタートテーマ"
        start_theme_title.isEditable = false
        start_theme_title.isBordered = false
        viewForContent.addSubview(start_theme_title)
        
        var start_theme_content = NSTextField()
        start_theme_content.frame = CGRect(x:20, y:CONTENTHEIGHT - 150, width:400, height:30);
        start_theme_content.stringValue = m_flow_start_theme
        start_theme_content.font = NSFont.systemFont(ofSize: 15)
        start_theme_content.isEditable = false
        start_theme_content.isBordered = false
        viewForContent.addSubview(start_theme_content)
        
        var theme_enlage_select_btn = NSButton(title: "テーマ増幅&選択", target: self, action: #selector(theme_enlage_select_click))
        theme_enlage_select_btn.frame = CGRect(x:0, y:CONTENTHEIGHT - 180, width:200, height:30);
        theme_enlage_select_btn.font = NSFont.systemFont(ofSize: 20)
        viewForContent.addSubview(theme_enlage_select_btn)
        
        let yajirusi_1 = Line_Flows_Progress(frame: self.view.frame, start_x_: 100.0, start_y_: Double(CONTENTHEIGHT) - 190.0, end_x_: 100.0, end_y_: Double(CONTENTHEIGHT) - 220.0,direction_:Direction.tate)
        yajirusi_1.translatesAutoresizingMaskIntoConstraints = false
        viewForContent.addSubview(yajirusi_1)
        yajirusi_1.topAnchor.constraint(equalTo: viewForContent.topAnchor).isActive = true
        yajirusi_1.bottomAnchor.constraint(equalTo: viewForContent.bottomAnchor).isActive = true
        yajirusi_1.leftAnchor.constraint(equalTo: viewForContent.leftAnchor).isActive = true
        yajirusi_1.rightAnchor.constraint(equalTo: viewForContent.rightAnchor).isActive = true
        
        var selected_theme_title = NSTextField()
        selected_theme_title.frame = CGRect(x:20, y:CONTENTHEIGHT - 260, width:200, height:30);
        selected_theme_title.font = NSFont.systemFont(ofSize: 20)
        selected_theme_title.stringValue = "選んだテーマ"
        selected_theme_title.isEditable = false
        selected_theme_title.isBordered = false
        viewForContent.addSubview(selected_theme_title)

        var selected_theme_content = NSTextField()
        selected_theme_content.frame = CGRect(x:20, y:CONTENTHEIGHT - 310, width:400, height:30);
        print("m_selected_theme")
        print(m_selected_theme)
        selected_theme_content.stringValue = m_selected_theme
        selected_theme_content.font = NSFont.systemFont(ofSize: 15)
        selected_theme_content.isEditable = false
        selected_theme_content.isBordered = false
        viewForContent.addSubview(selected_theme_content)
        
        var frame_9x9_btn = NSButton(title: "9x9分析", target: self, action: #selector(frame_9x9_click))
        frame_9x9_btn.frame = CGRect(x:0, y:CONTENTHEIGHT - 340, width:200, height:30);
        frame_9x9_btn.font = NSFont.systemFont(ofSize: 20)
        viewForContent.addSubview(frame_9x9_btn)
    }
    @objc func frame_9x9_click(_ sender: NSButton) {
//        UserDefaults.standard.set("Deep_Enlarge_Pre", forKey: "to_page")
//        UserDefaults.standard.synchronize()
        let next = storyboard?.instantiateController(withIdentifier: "Nine_x_Nine")
        self.presentAsModalWindow(next! as! NSViewController)
        self.dismiss(nil)
    }
    @objc func theme_enlage_select_click(_ sender: NSButton) {
//        UserDefaults.standard.set("Deep_Enlarge_Pre", forKey: "to_page")
//        UserDefaults.standard.synchronize()
        let next = storyboard?.instantiateController(withIdentifier: "Theme_Enlarge")
        self.presentAsModalWindow(next! as! NSViewController)
        self.dismiss(nil)
    }
    func first_appear_basic(){
        // NSScrollView 内の領域
        let scrollContentView = NSClipView(frame:
            NSRect(x: 0, y: 0, width: CONTENTWIDTH, height: CONTENTHEIGHT))
        scrollContentView.documentView = viewForContent
        // ちょっと上が空くが気にしない。最初のスクロールの位置を上にする。
        scrollContentView.scroll(to: NSPoint(x: 0, y: 650))
        // NSScrollView の本体
        let scrollView = NSScrollView(frame: NSRect(x: 10, y: 10, width: 1180, height: 630))
        scrollView.contentView = scrollContentView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = false
        self.view.addSubview(scrollView)
    }
}
class Line_Flows_Progress: NSView {
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
