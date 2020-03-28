//
//  ProposalController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/28.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class ProposalController: NSViewController {
    
    let realm = try! Realm()
    var m_trigger_idea = ""
    var m_question_s:[CustomNSTextField] = []
    var m_answer_s:[CustomNSTextField] = []
    var viewForContent = NSView()
    var titele_st = ["きっかけのアイデア","どんな企画？","その企画をする意味は？","何がメリットか？","対象は？","いつ行うべきか？","誰と協力するべきか？",
        "どんな可能性があるか？","どんなプロセスで実現出来そうか？","実現の障害になりそうな事は？","課題は何か？","この企画の興味深い点は？","どこで行うべきか？",
        "追加で必要なアイデアは何か？","コラボについては？"]
    let CONTENTWIDTH: CGFloat = 2400
    let CONTENTHEIGHT: CGFloat = 1300
    let margin: CGFloat = 50
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
         
        viewForContent = NSView(frame:
            NSRect(x: 0, y: 0, width: CONTENTWIDTH, height: CONTENTHEIGHT))
                 
        m_trigger_idea = UserDefaults.standard.object(forKey: "trigger_idea") as! String
        
        // NSScrollView 内の領域
        let scrollContentView = NSClipView(frame:
            NSRect(x: 0, y: 0, width: CONTENTWIDTH, height: CONTENTHEIGHT))
        scrollContentView.documentView = viewForContent
        // ちょっと上が空くが気にしない。最初のスクロールの位置を上にする。
        scrollContentView.scroll(to: NSPoint(x: 0, y: 650))
        
        first_appear()
        
        // NSScrollView の本体
        let scrollView = NSScrollView(frame: NSRect(x: 10, y: 10, width: 1180, height: 630))
        scrollView.contentView = scrollContentView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = false
        self.view.addSubview(scrollView)
    }
    func first_appear(){
        
        var store_btn = NSButton(title: "保存", target: self, action: #selector(store_click))
        store_btn.frame = CGRect(x:0, y:CONTENTHEIGHT - 30, width:100, height:30);
        store_btn.font = NSFont.systemFont(ofSize: 12)
        viewForContent.addSubview(store_btn)
        
        for y in 0..<5{
            for x in 0..<3{
                // テーマ
                var title = CustomNSTextField()
                title.tag = y * 10 + x
                var title_p = Param(st_ :titele_st[x*5+y],x_:10 + 400*x,y_: 1220 - y*115,width_:350,height_:40,fontSize_:20)
                U().text_generate(param_:title_p,nsText_:title,view_:viewForContent,input_flag_:false,ajust_flag_:false,border_flag_:false)
                m_question_s.append(title)
                
                var content = CustomNSTextField()
                content.tag = y * 10 + x
                if y == 0 && x == 0{
                    var content_p = Param(st_ :m_trigger_idea,x_:10 + 400*x,y_: 1150 - y*115,width_:350,height_:80,fontSize_:15)
                    U().text_generate(param_:content_p,nsText_:content,view_:viewForContent,input_flag_:false,ajust_flag_:false,border_flag_:true)
                    m_answer_s.append(content)
                }else{
                    var content_p = Param(st_ :"",x_:10 + 400*x,y_: 1150 - y*115,width_:350,height_:80,fontSize_:15)
                    U().text_generate(param_:content_p,nsText_:content,view_:viewForContent,input_flag_:true,ajust_flag_:false,border_flag_:true)
                    m_answer_s.append(content)
                }
            }
        }
    }
    @objc func store_click(_ sender: NSButton){
        store_db()
        self.dismiss(nil)
    }
    func store_db(){
        let deleting = realm.objects(Proposal_Seed.self).filter("seed == %@",m_trigger_idea)
        try! realm.write {
            realm.delete(deleting)
        }
        for one in m_question_s{
            var proposal_seed = Proposal_Seed()
            proposal_seed.seed = m_trigger_idea
            for one_2 in m_answer_s{
                if one.tag == one_2.tag{
                    proposal_seed.question = one.stringValue
                    proposal_seed.answer = one_2.stringValue
                    try! realm.write {
                        realm.add(proposal_seed)
                    }
                }
            }
        }
    }
}
class MyLine2: NSView {
    var x = 0.0
    var y = 0.0
    var derection = Direction.none
    init(frame frameRect: NSRect, x_: Double, y_: Double,direction_:Direction) {
        super.init(frame: frameRect)
        self.x = x_
        self.y = y_
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
            let path = NSBezierPath()
            path.move(to: NSPoint(x: Double(x + (150 / 2)), y: Double(y)))
            path.line(to: NSPoint(x: Double(x + (150 / 2)), y: Double(Double(y) - 17.5)))
            path.close()
            path.stroke()
        }else if self.derection == Direction.yoko{
            let path = NSBezierPath()
            path.move(to: NSPoint(x: Double(x + (150 / 2)), y: Double(y)))
            path.line(to: NSPoint(x: Double(x + (150 / 2) - 175), y: Double(y)))
            path.close()
            path.stroke()
        }
    }
}
