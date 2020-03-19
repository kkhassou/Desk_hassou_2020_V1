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
    var TEXT_WIDTH = 150
    var TEXT_HEIGHT = 75
    let CONTENTWIDTH: CGFloat = 2400
    let CONTENTHEIGHT: CGFloat = 1300
    let margin: CGFloat = 50
    var viewForContent:NSView = NSView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        

         
        viewForContent = NSView(frame:
            NSRect(x: 0, y: 0, width: CONTENTWIDTH, height: CONTENTHEIGHT))
                 
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        
        add_area()
    }
    func add_area(){
        
        var theme_content = NSTextField()
        theme_content.stringValue = "1-" + m_theme
        theme_content.frame = CGRect(x:20, y:CONTENTHEIGHT - 80, width:500, height:30);
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
        add_area_line()
        // NSScrollView の本体
        let scrollView = NSScrollView(frame: NSRect(x: 10, y: 10, width: 1180, height: 630))
        scrollView.contentView = scrollContentView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = false
        self.view.addSubview(scrollView)
    }
    func add_area_line(){
        // まず、枠の線を引こう
        let yoko_2 = AreaLine(frame: self.view.frame, x_: 1, y_: 1)
        yoko_2.translatesAutoresizingMaskIntoConstraints = false
        viewForContent.addSubview(yoko_2)
        yoko_2.topAnchor.constraint(equalTo: viewForContent.topAnchor).isActive = true
        yoko_2.bottomAnchor.constraint(equalTo: viewForContent.bottomAnchor).isActive = true
        yoko_2.leftAnchor.constraint(equalTo: viewForContent.leftAnchor).isActive = true
        yoko_2.rightAnchor.constraint(equalTo: viewForContent.rightAnchor).isActive = true
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
        let hidariUe = NSPoint(x: Double((x - 1)*LINE_WIDTH + MAGIN_WIDTH), y: Double(CONTENTHEIGHT - ((y - 1)*LINE_HEIGHT) - MAGIN_HEIGHT))
        let migiiUe = NSPoint(x: Double((x)*LINE_WIDTH + MAGIN_WIDTH), y: Double(CONTENTHEIGHT - ((y - 1)*LINE_HEIGHT) - MAGIN_HEIGHT))
        let hidariSita = NSPoint(x: Double((x - 1)*LINE_WIDTH + MAGIN_WIDTH), y: Double(CONTENTHEIGHT - ((y)*LINE_HEIGHT) - MAGIN_HEIGHT))
        let migiSita = NSPoint(x: Double((x)*LINE_WIDTH + MAGIN_WIDTH), y: Double(CONTENTHEIGHT - ((y)*LINE_HEIGHT) - MAGIN_HEIGHT))
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
