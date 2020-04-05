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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        m_flow_start_theme = UserDefaults.standard.object(forKey: "flow_start_theme") as! String
        viewForContent = NSView(frame:
            NSRect(x: 0, y: 0, width: CONTENTWIDTH, height: CONTENTHEIGHT))
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
        theme_enlage_select_btn.frame = CGRect(x:0, y:CONTENTHEIGHT - 200, width:200, height:30);
        theme_enlage_select_btn.font = NSFont.systemFont(ofSize: 20)
        viewForContent.addSubview(theme_enlage_select_btn)
    }
    @objc func theme_enlage_select_click(_ sender: NSButton) {
        UserDefaults.standard.set("Deep_Enlarge_Pre", forKey: "to_page")
        UserDefaults.standard.synchronize()
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
