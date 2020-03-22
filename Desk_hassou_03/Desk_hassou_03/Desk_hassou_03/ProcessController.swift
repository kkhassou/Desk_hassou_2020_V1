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
    var m_memo_button_s:[CustomNSButton] = []
    var m_up_add_button_s:[CustomNSButton] = []
    var m_bottom_add_button_s:[CustomNSButton] = []
    var m_delete_button_s:[CustomNSButton] = []
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
    var process_index = -999
    var memo_content_st = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:FRAME_WIDTH, height:FRAME_HEIGT);
        
        let margin: CGFloat = 50
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        
//        let deleting = realm.objects(Process_s_DB_2.self).filter("theme == %@",m_theme)
//        try! realm.write {
//            realm.delete(deleting)
//        }
//        exit(0)
        
        var from_memo_flag = UserDefaults.standard.object(forKey: "from_memo") as! Bool
        if from_memo_flag == true{
            // メモの内容とインデックスを受け取る
            process_index = UserDefaults.standard.object(forKey: "process_index") as! Int
            memo_content_st = UserDefaults.standard.object(forKey: "memo_content_st") as! String
            print("memo_content_st")
            print(memo_content_st)
        }
        first_appear()
        UserDefaults.standard.set(false, forKey: "from_memo")
        UserDefaults.standard.synchronize()
    }
    func first_appear(){
        
        viewForContent = NSView(frame:
            NSRect(x: 0, y: 0, width: contentWidth, height: contentHeight))
        
        start_x = 30 //FRAME_WIDTH / 2 - TB_WIDTH
        start_y = 30 //FRAME_HEIGT / 2 - TB_HEIGHT
        
        let db_start = realm.objects(Process_s_DB_2.self).filter("theme == %@",m_theme)
        print("db_start")
        print(db_start)
        if db_start.count == 0{
            print("if db_start.count == 0{")
            add_textbox(num:total_textbox,st:"",memo_st:"")
            add_yajirusi_line(num: total_textbox)
            var count = 0
            for one in m_added_text_s{
                viewForContent.addSubview(one)
                viewForContent.addSubview(m_up_add_button_s[count])
                viewForContent.addSubview(m_bottom_add_button_s[count])
                viewForContent.addSubview(m_yajirusi_s[count])
                viewForContent.addSubview(m_memo_button_s[count])
                viewForContent.addSubview(m_delete_button_s[count])
                count = count + 1
            }
            add_scroll()
        }else{
            total_textbox = db_start.count - 1
            
            for one in db_start{
                if one.index == process_index{
                    print("L 85")
                    add_textbox(num:one.index,st:one.content,memo_st:memo_content_st)
                }else{
                    print("L 88")
                    add_textbox(num:one.index,st:one.content,memo_st:one.comment)
                }
                add_yajirusi_line(num: one.index)
            }
            var count = 0
            for one in m_added_text_s{
                print("one.stringValue")
                print(one.stringValue)
                print("one.index")
                print(one.index)
                viewForContent.addSubview(one)
                viewForContent.addSubview(m_up_add_button_s[count])
                viewForContent.addSubview(m_bottom_add_button_s[count])
                viewForContent.addSubview(m_yajirusi_s[count])
                viewForContent.addSubview(m_memo_button_s[count])
                viewForContent.addSubview(m_delete_button_s[count])
                count = count + 1
            }
            add_scroll()
        }
    }
    @objc func delete_click(_ sender: CustomNSButton){
        // DBの削除と配列の削除の両方を行うべし
        // そっかー、上書きじゃないから、オブジェクトの削除も行わなきゃいけないのね、
        //
        for v in view.subviews {
            v.removeFromSuperview()
        }
        
        // dbから、そのタグの分だけ削除して、一つ、前にずらして、登録、その後、
        // 初期表示を行えばOK!
        // 難しく考えず、現時点のテキスト配列を読み込んんで、インデックスがクリックしたインデックスは削除
        // より上はインデックスを-1、より下はそのままで、DB保存すれば、良いだけ。
        let deleting = realm.objects(Process_s_DB_2.self).filter("theme == %@",m_theme)
        try! realm.write {
            realm.delete(deleting)
        }
        
        var count = 0
        for one in m_added_text_s{
            if one.index == sender.index {
                print("one.index == sender.index")
                print("one.stringValue")
                print(one.stringValue)
                // ここで削除するのでなく、最初に全部を削除しておいて、現状のものをDB保存すればOK
            }else if one.index > sender.index{
                let process_s_db = Process_s_DB_2()
                process_s_db.theme  = m_theme
                process_s_db.index = one.index - 1
                process_s_db.content = one.stringValue
                process_s_db.comment = m_memo_button_s[count].st
                try! realm.write() {
                    realm.add(process_s_db)
                }
            }else if one.index < sender.index{
                let process_s_db = Process_s_DB_2()
                process_s_db.theme  = m_theme
                process_s_db.index = one.index
                process_s_db.content = one.stringValue
                process_s_db.comment = m_memo_button_s[count].st
                try! realm.write() {
                    realm.add(process_s_db)
                }
            }
            count = count + 1
        }
        
        m_added_text_s.removeAll()
        m_up_add_button_s.removeAll()
        m_bottom_add_button_s.removeAll()
        m_memo_button_s.removeAll()
        m_delete_button_s.removeAll()
        first_appear()
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
            add_textbox(num:total_textbox,st:"",memo_st:"")
            add_yajirusi_line(num: total_textbox)
            var count = 0
            for one in m_added_text_s{
                // このprintがないと文字列が消える。なんか、SWIFTのバグっぽい。
                print(one.stringValue)
                viewForContent.addSubview(one)
                viewForContent.addSubview(m_up_add_button_s[count])
                viewForContent.addSubview(m_bottom_add_button_s[count])
                viewForContent.addSubview(m_yajirusi_s[count])
                viewForContent.addSubview(m_memo_button_s[count])
                viewForContent.addSubview(m_delete_button_s[count])
                count = count + 1
            }
        }else{
            total_textbox = total_textbox + 1
            let deleting = realm.objects(Process_s_DB_2.self).filter("theme == %@",m_theme)
            try! realm.write {
                realm.delete(deleting)
            }
            var count_1 = 0
            for one in m_added_text_s{
                let process_s_db = Process_s_DB_2()
                process_s_db.theme  = m_theme
                process_s_db.index = one.index
                process_s_db.content = one.stringValue
                print("m_memo_button_s[count_1].st")
                print(m_memo_button_s[count_1].st)
                process_s_db.comment = m_memo_button_s[count_1].st
                try! realm.write() {
                    realm.add(process_s_db)
                }
                count_1 = count_1 + 1
            }
            var temp_s:[CustomNSTextField] = []
            temp_s.append(contentsOf: m_added_text_s)
            m_added_text_s.removeAll()
            m_up_add_button_s.removeAll()
            m_bottom_add_button_s.removeAll()
            m_memo_button_s.removeAll()
            m_delete_button_s.removeAll()
            for one in temp_s{
                // より大きいものの位置を1つ1つ位置を右にずらして追加する必要がある。
                if one.index > sender.index{
                    add_textbox(num:one.index + 1,st:"",memo_st:"")
                }else if one.index <= sender.index{
                    add_textbox(num:one.index,st:"",memo_st:"")
                }
            }
            add_textbox(num:sender.index + 1,st:"",memo_st:"")
            var count_2 = 0
            // 再度、構築し直さなければならない
            
            for one in m_added_text_s{
                if one.index > sender.index + 1{
                    let serched = realm.objects(Process_s_DB_2.self).filter("theme == %@",m_theme).filter("index == %@",(one.index - 1)).last
                    one.stringValue = serched!.content
                    m_memo_button_s[count_2].st = serched!.content
                }else  if one.index == sender.index + 1{
                    one.stringValue = ""
                }else{
                    let serched = realm.objects(Process_s_DB_2.self).filter("theme == %@",m_theme).filter("index == %@",one.index).last
                    one.stringValue = serched!.content
                    m_memo_button_s[count_2].st = serched!.content
                }
                add_yajirusi_line(num: one.index)
                viewForContent.addSubview(one)
                viewForContent.addSubview(m_up_add_button_s[count_2])
                viewForContent.addSubview(m_bottom_add_button_s[count_2])
                viewForContent.addSubview(m_yajirusi_s[one.index])
                viewForContent.addSubview(m_memo_button_s[count_2])
                viewForContent.addSubview(m_delete_button_s[count_2])
                count_2 = count_2 + 1
            }
        }
        add_scroll()
    }
    @objc func bottom_add_click(_ sender: CustomNSButton){
            total_textbox = total_textbox + 1
            let deleting = realm.objects(Process_s_DB_2.self).filter("theme == %@",m_theme)
            try! realm.write {
                realm.delete(deleting)
            }
            print("----------")
            var count_1 = 0
            for one in m_added_text_s{
                let process_s_db = Process_s_DB_2()
                process_s_db.theme  = m_theme
                process_s_db.index = one.index
                process_s_db.content = one.stringValue
                process_s_db.comment = m_memo_button_s[count_1].st
                try! realm.write() {
                    realm.add(process_s_db)
                }
                count_1 = count_1 + 1
            }
            var temp_s:[CustomNSTextField] = []
            temp_s.append(contentsOf: m_added_text_s)
            m_added_text_s.removeAll()
            m_up_add_button_s.removeAll()
            m_bottom_add_button_s.removeAll()
            m_memo_button_s.removeAll()
            m_delete_button_s.removeAll()
            for one in temp_s{
                // より大きいものの位置を1つ1つ位置を右にずらして追加する必要がある。
                if one.index >= sender.index{
                    add_textbox(num:one.index + 1,st:"",memo_st:"")
                }else if one.index < sender.index{
                    add_textbox(num:one.index,st:"",memo_st:"")
                }
            }
            add_textbox(num:sender.index,st:"",memo_st:"")
            var count = 0
            
            for one in m_added_text_s{
                if one.index > sender.index{
                    let serched = realm.objects(Process_s_DB_2.self).filter("theme == %@",m_theme).filter("index == %@",(one.index - 1)).last
                    one.stringValue = serched!.content
                    m_memo_button_s[count].st = serched!.comment
                }else  if one.index == sender.index{
                    one.stringValue = ""
                }else{
                    let serched = realm.objects(Process_s_DB_2.self).filter("theme == %@",m_theme).filter("index == %@",one.index).last
                    one.stringValue = serched!.content
                    m_memo_button_s[count].st = serched!.comment
                }
                add_yajirusi_line(num: one.index)
                viewForContent.addSubview(one)
                viewForContent.addSubview(m_up_add_button_s[count])
                viewForContent.addSubview(m_bottom_add_button_s[count])
                viewForContent.addSubview(m_yajirusi_s[one.index])
                viewForContent.addSubview(m_memo_button_s[count])
                viewForContent.addSubview(m_delete_button_s[count])
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
        var theme_content_p = Param(st_ :m_theme,x_:50,y_:550,width_:Int(TB_WIDTH),height_:Int(TB_HEIGHT),fontSize_:12)
        U().text_generate(param_:theme_content_p,nsText_:theme_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
        // これは、あえて左上に固定したいので、スクロールに付与しない
        var store_btn_p = Param(st_ :"保存",x_:200,y_:550,width_:100,height_:20,fontSize_:13)
        U().button_generate(param_:store_btn_p,viewCon_:self,view_:self.view,action: #selector(store_click))
        var text_disp_btn_p = Param(st_ :"テキスト表示",x_:320,y_:550,width_:150,height_:20,fontSize_:13)
        U().button_generate(param_:text_disp_btn_p,viewCon_:self,view_:self.view,action: #selector(text_disp_click))
    }
    @objc func store_click(_ sender: CustomNSButton){
        store_db()
        self.dismiss(nil)
    }
    func store_db(){
        let deleting = realm.objects(Process_s_DB_2.self).filter("theme == %@",m_theme)
        try! realm.write {
            realm.delete(deleting)
        }
        var count = 0
        for one in m_added_text_s{
            var process_db = Process_s_DB_2()
            process_db.theme = m_theme
            process_db.content = one.stringValue
            // これでいいのかな？
            print("one.index")
            print(one.index)
            print("m_memo_button_s[count].st")
            print(m_memo_button_s[count].st)
            process_db.comment = m_memo_button_s[count].st
            process_db.index = one.index
            try! realm.write {
                realm.add(process_db)
            }
            count = count + 1
        }
    }
    @objc func text_disp_click(_ sender: CustomNSButton){
        store_db()
        self.dismiss(nil)
        UserDefaults.standard.set("Process", forKey: "from_page")
        UserDefaults.standard.synchronize()
        self.dismiss(nil)
        let next = storyboard?.instantiateController(withIdentifier: "Txt_Disp")
        self.presentAsModalWindow(next! as! NSViewController)
    }
    @objc func memo_click(_ sender: CustomNSButton){
        store_db()
        UserDefaults.standard.set(sender.index, forKey: "process_index")
        UserDefaults.standard.set(sender.st, forKey: "memo_content_st")
        UserDefaults.standard.synchronize()
        self.dismiss(nil)
        let next = storyboard?.instantiateController(withIdentifier: "Memo")
        self.presentAsModalWindow(next! as! NSViewController)
    }
    func add_textbox(num:Int,st:String,memo_st:String){
        var process_element = CustomNSTextField()
        now_x = start_x + INTERVAL_YOKO * Double(num)
        now_y = start_y + INTERVAL_TATE * Double(num)
        process_element.frame = CGRect(x:now_x, y:now_y, width:TB_WIDTH, height:TB_HEIGHT);
        process_element.stringValue = st
        process_element.font = NSFont.systemFont(ofSize: 10)
        process_element.isEditable = true
        process_element.isBordered = true
        process_element.index = num
        process_element.tag = 999
        m_added_text_s.append(process_element)
        
        // 矢印の横あたりにメモを残せるようにする。
        let memo_button = CustomNSButton(title: "メモ", target: self, action: #selector(memo_click))
        memo_button.frame = CGRect(x:now_x + TB_WIDTH + 10, y:now_y + TB_HEIGHT - 15, width:65.0, height:20.0);
        memo_button.font = NSFont.systemFont(ofSize: 10)
        memo_button.st = memo_st
        memo_button.index = num
        memo_button.tag = 999
        m_memo_button_s.append(memo_button)
        
        let up_add_button = CustomNSButton(title: "前に追加", target: self, action: #selector(bottom_add_click))
        up_add_button.frame = CGRect(x:now_x-10.0, y:now_y - 22.0, width:60.0, height:20.0);
        up_add_button.font = NSFont.systemFont(ofSize: 8)
        up_add_button.index = num
        up_add_button.tag = 999
        m_up_add_button_s.append(up_add_button)
        
        let bottom_add_button = CustomNSButton(title: "次に追加", target: self, action: #selector(up_add_click))
        bottom_add_button.frame = CGRect(x:now_x + 40, y:now_y - 22.0, width:60.0, height:20.0);
        bottom_add_button.font = NSFont.systemFont(ofSize: 8)
        bottom_add_button.index = num
        bottom_add_button.tag = 999
        m_bottom_add_button_s.append(bottom_add_button)
        
        let delete_button = CustomNSButton(title: "削除", target: self, action: #selector(delete_click))
        delete_button.frame = CGRect(x:now_x + 90, y:now_y - 22.0, width:50.0, height:20.0);
        delete_button.font = NSFont.systemFont(ofSize: 8)
        delete_button.index = num
        delete_button.tag = 999
        m_delete_button_s.append(delete_button)
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
