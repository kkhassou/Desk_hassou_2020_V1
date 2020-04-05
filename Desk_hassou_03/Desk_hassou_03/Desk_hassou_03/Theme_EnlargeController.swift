//
//  Theme_EnlargeController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/04/04.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Theme_EnlargeController: NSViewController {
    
    let realm = try! Realm()
    var m_flow_start_theme = ""
    var m_question_s:[CustomNSTextField] = []
    var m_theme_s:[CustomNSTextField] = []
    var viewForContent = NSView()
    var titele_st = ["スタートテーマ","想像力豊かに「もし、◯◯だったら？」と考えてみよう","事実重視で「〜は何か？」と考えてみよう","希望をもって、「何ができるか？」と考えてみよう","否定的に「何が出来ないか？」と考えてみよう","言い方を少しかえてみよう","語順を変えてみよう",
        "より抽象的に考えてみよう","より具体的に考えてみよう","視点を変えてみよう","違う役割を想定して考えてみよう","関係ない分野で解決のヒントはないか考えてみよう","テーマを擬人化して考えてみよう",
        "連想する事をいくつかあげて、テーマにしてみよう","類語を使ってみる"]
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
                 
        m_flow_start_theme = UserDefaults.standard.object(forKey: "flow_start_theme") as! String
        
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
                title.tag = y * 100 + x
                var title_p = Param(st_ :titele_st[x*5+y],x_:10 + 400*x,y_: 1220 - y*115,width_:350,height_:40,fontSize_:12)
                U().text_generate(param_:title_p,nsText_:title,view_:viewForContent,input_flag_:false,ajust_flag_:false,border_flag_:false)
                title.tag = y * 100 + x
                m_question_s.append(title)
                
                var content = CustomNSTextField()
                content.tag = y * 100 + x
                
                // ボタンを各TEXTに追加する

                var select_btn = NSButton()
                select_btn = NSButton(title:"決定", target: self, action: #selector(select_click))
                select_btn.frame = CGRect(x:10 + 400 * x + 345,y:1220 - y * 115 - 30,width:50,height:50)
                select_btn.font = NSFont.systemFont(ofSize: 10)
                select_btn.tag = y * 100 + x
                viewForContent.addSubview(select_btn)
                
                if y == 0 && x == 0{
                    var content_p = Param(st_ :m_flow_start_theme,x_:10 + 400*x,y_: 1150 - y*115,width_:350,height_:80,fontSize_:15)
                    U().text_generate(param_:content_p,nsText_:content,view_:viewForContent,input_flag_:false,ajust_flag_:false,border_flag_:true)
                    m_theme_s.append(content)
                }else{
                    var stock_answer = ""
                    let disp = realm.objects(Flows_Theme_Db.self).filter("start_theme == %@",m_flow_start_theme).filter("enlarge_question == %@",titele_st[x*5+y])
                    if disp.count != 0{
                        stock_answer = disp[0].enlarge_theme
                    }
                    var content_p = Param(st_ :stock_answer,x_:10 + 400*x,y_: 1150 - y*115,width_:350,height_:80,fontSize_:15)
                    U().text_generate(param_:content_p,nsText_:content,view_:viewForContent,input_flag_:true,ajust_flag_:false,border_flag_:true)
                    m_theme_s.append(content)
                }
            }
        }
    }

    @objc func select_click(_ sender: NSButton){
        print("102")
        // 渡すものとしては、ボタンを押したテキスト
        for one in m_theme_s{
            if one.tag == sender.tag{
                print("105")
                print(one.tag)
                print(one.stringValue)
                UserDefaults.standard.set(one.stringValue, forKey: "selected_theme")
                UserDefaults.standard.synchronize()
                store_db()
                self.dismiss(nil)
                // ProcessControllerに戻す
                let next = storyboard?.instantiateController(withIdentifier: "Flows_Progress")
                self.presentAsModalWindow(next! as! NSViewController)
            }
        }
    }

    @objc func store_click(_ sender: NSButton){
        store_db()
        self.dismiss(nil)
    }
    func store_db(){
        let deleting = realm.objects(Flows_Theme_Db.self).filter("start_theme == %@",m_flow_start_theme)
        try! realm.write {
            realm.delete(deleting)
        }
        for one in m_question_s{
            var flows_theme_db = Flows_Theme_Db()
            flows_theme_db.start_theme = m_flow_start_theme
            for one_2 in m_theme_s{
                if one.tag == one_2.tag{
                    flows_theme_db.enlarge_question = one.stringValue
                    flows_theme_db.enlarge_theme = one_2.stringValue
                    try! realm.write {
                        realm.add(flows_theme_db)
                    }
                }
            }
        }
//        let disp = realm.objects(Proposal_Seed.self).filter("seed == %@",m_trigger_idea)
//        print("disp")
//        print(disp)
    }
}
