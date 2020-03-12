//
//  Hierarchy_ThemeController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/10.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Hierarchy_ThemeController: NSViewController {
    
    let realm = try! Realm()
    var m_theme = ""
    var theme_stocks:[String] = []
    var TEXT_WIDTH = 150
    var TEXT_HEIGHT = 75
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        
        let contentWidth: CGFloat = 2400
        let contentHeight: CGFloat = 1300
        let margin: CGFloat = 50
         
        // scrollContentView の中身
        let viewForContent = NSView(frame:
            NSRect(x: 0, y: 0, width: contentWidth, height: contentHeight))
         
        // これで、画面枠width1200,height650より大きなサイズもスクロールして表示出来るようになった。
        // とりあえず、縦横倍だが、もっと、大きくてもいけるようだ。
        
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        
        // 一旦、削除してから追加しする。
        let deleting = realm.objects(Hierarchy_Theme_Db_v4.self).filter("start_theme == %@",m_theme)
        try! realm.write {
            realm.delete(deleting)
        }
        db_serch(theme_: m_theme,index_count_: 1)
        // db_serchでの再帰ループが終わった後に、リストは出来上がっているので、これを元に、
        // 表示をする。self_point_xだけは、全体との兼ね合いで決まるので、
        // ここで決めねばならない。
        // ちょっと、待てよ。全体をs取得するのに、スタートのテーマは、全体で持っておいたほうがいいな。
        let hierarchy_theme_db = realm.objects(Hierarchy_Theme_Db_v4.self).filter("start_theme == %@",m_theme)

        // last
        // 狙いの値は取れたので、次に、self_point_xの値を設定する。ここが難所。
        // その前に、ラストflagを取得せねばならない。
        // last_flagの設定は、一旦、DBに格納した後でないと出来ないので、ここで行う。
        // その際に、一緒に、
        var hierarchy_theme_arr = Array(hierarchy_theme_db)
        var last_index_count = 1
        for one in hierarchy_theme_arr{
            let last_decide = realm.objects(Hierarchy_Theme_Db_v4.self).filter("parent_theme == %@",one.self_theme)
            if last_decide.count == 0{
                try! realm.write {
                    one.last_flag = true
                    one.last_index = last_index_count
                    one.self_point_x = last_index_count
                }
                last_index_count = last_index_count + 1
            }else{
                try! realm.write {
                    one.last_flag = false
                }
            }
        }

        var end_flag = false
        var mugen_stop = 0
        while end_flag == false {
            // self_point_xが-999以外で、かつ、self_xの子を持つ親は、その子のself_point_x
            // を当てはめる。下からどんどん、適応されるので、1週で全部格納されない場合（縦が３以上の列がある場合）
            var all_update = realm.objects(Hierarchy_Theme_Db_v4.self).filter("start_theme == %@",m_theme)
            for one in all_update {
                if one.self_point_x == -999{
                    var child_s = realm.objects(Hierarchy_Theme_Db_v4.self).filter("parent_theme == %@",one.self_theme)
                    for one_child in child_s{
                        if one_child.self_point_x != -999 && one_child.self_x == 1{
                            try! realm.write {
                                one.self_point_x = one_child.self_point_x
                            }
                        }
                    }
                }
            }
            let all_serch = realm.objects(Hierarchy_Theme_Db_v4.self).filter("start_theme == %@",m_theme)
            end_flag = true
            for one in all_serch{
                if one.self_point_x == -999{
                    end_flag = false
                }
            }
            mugen_stop = mugen_stop + 1
            if mugen_stop == 100{
                print("100")
                break
            }
        }
        let disp_arr = realm.objects(Hierarchy_Theme_Db_v4.self).filter("start_theme == %@",m_theme)
        print("disp_arr")
        print(disp_arr)
        // 試した感じ、大丈夫そうなので、別途、
        for one_disp in disp_arr{
            // textの表示
            var one_disp_content = NSTextField()
            one_disp_content.font = NSFont.systemFont(ofSize: 11)
            one_disp_content.stringValue = one_disp.self_theme
            var point_x = 20 + ((one_disp.self_point_x - 1) * 175)
            var point_y = 1250 - (one_disp.self_y * 100)

            one_disp_content.frame = NSRect(x: point_x, y: point_y, width: TEXT_WIDTH, height: TEXT_HEIGHT)
            one_disp_content.isEditable = false
            one_disp_content.isSelectable = true
            one_disp_content.isBordered = true
            viewForContent.addSubview(one_disp_content)
            
            var add_button = CustomNSButton(title: "アイデア追加", target: self, action: #selector(randam_location))
            add_button.st = one_disp.self_theme
            add_button.frame = CGRect(x:point_x - 5, y:point_y - 20 , width:70, height:20);
            add_button.font = NSFont.systemFont(ofSize: 8)
            viewForContent.addSubview(add_button)
            
            if one_disp.last_flag == false {
                // これが、縦線下半分
                let tate_ue = MyLine(frame: self.view.frame, x_: Double(point_x), y_: Double(point_y),direction_:Direction.tate)
                tate_ue.translatesAutoresizingMaskIntoConstraints = false
                viewForContent.addSubview(tate_ue)
                tate_ue.topAnchor.constraint(equalTo: viewForContent.topAnchor).isActive = true
                tate_ue.bottomAnchor.constraint(equalTo: viewForContent.bottomAnchor).isActive = true
                tate_ue.leftAnchor.constraint(equalTo: viewForContent.leftAnchor).isActive = true
                tate_ue.rightAnchor.constraint(equalTo: viewForContent.rightAnchor).isActive = true
            }
            // これが、縦線上半分
            if one_disp.self_y != 1{
                let tate_sita = MyLine(frame: self.view.frame, x_: Double(point_x), y_: Double(point_y) + 75 + 12.5,direction_:Direction.tate)
                tate_sita.translatesAutoresizingMaskIntoConstraints = false
                viewForContent.addSubview(tate_sita)
                tate_sita.topAnchor.constraint(equalTo: viewForContent.topAnchor).isActive = true
                tate_sita.bottomAnchor.constraint(equalTo: viewForContent.bottomAnchor).isActive = true
                tate_sita.leftAnchor.constraint(equalTo: viewForContent.leftAnchor).isActive = true
                tate_sita.rightAnchor.constraint(equalTo: viewForContent.rightAnchor).isActive = true
            }
            // これが、横線
            if one_disp.self_x != 1 {
                let yoko = MyLine(frame: self.view.frame, x_: Double(point_x), y_: Double(point_y) + 75 + 12.5,direction_:Direction.yoko)
                yoko.translatesAutoresizingMaskIntoConstraints = false
                viewForContent.addSubview(yoko)
                yoko.topAnchor.constraint(equalTo: viewForContent.topAnchor).isActive = true
                yoko.bottomAnchor.constraint(equalTo: viewForContent.bottomAnchor).isActive = true
                yoko.leftAnchor.constraint(equalTo: viewForContent.leftAnchor).isActive = true
                yoko.rightAnchor.constraint(equalTo: viewForContent.rightAnchor).isActive = true
            }
        }
        
        // NSScrollView 内の領域
        let scrollContentView = NSClipView(frame:
            NSRect(x: 0, y: 0, width: contentWidth, height: contentHeight))
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
    var parent_theme = ""
    var first_falg = true
    var index_count = -999
    var before_parent_theme = ""
    func db_serch(theme_:String,index_count_:Int){
        index_count = index_count_
        // 再起処理で書かないと無理
        let stocks = realm.objects(Idea_Stock.self).filter("theme == %@",theme_)
        if false{
            let deleting = realm.objects(Hierarchy_Theme_Db_v4.self)
            try! realm.write {
                realm.delete(deleting)
            }
            exit(0)
        }
        
        var arr = Array(stocks)
        if arr.count != 0{
//            print("--------------")
//            print("parent_theme")
//            print(parent_theme)
//            print("theme_")
//            print(theme_)
            if before_parent_theme != parent_theme{
                index_count = 1
            }
//            print("index_count")
//            print(index_count)
            if first_falg == true{
                let hierarchy_theme_db = Hierarchy_Theme_Db_v4()
                // 当たり前だが、最初は、start_themeとself_themeが同じ
                hierarchy_theme_db.start_theme = m_theme
                hierarchy_theme_db.self_theme  = m_theme
                hierarchy_theme_db.parent_theme = ""
                hierarchy_theme_db.self_x = 1
                hierarchy_theme_db.self_y = 1
                hierarchy_theme_db.self_y = 1
                try! realm.write() {
                    realm.add(hierarchy_theme_db)
                }
                first_falg = false
            }else{
                // この時点のparent_themeでDBのself_themeと突合して、
                // その結果のyに＋1すれば、この時点のDBのyが判明する。
                
                let serched = realm.objects(Hierarchy_Theme_Db_v4.self).filter("self_theme == %@",parent_theme)

//                print("parent_theme")
//                print(parent_theme)
//                print("theme_")
//                print(theme_)
//                print("theme_")
//                print(theme_)
//                print("serched[0].self_x")
//                print(serched[0].self_x)
//                print("serched[0].self_y")
//                print(serched[0].self_y)
//                print("index_count")
//                print(index_count)
                
                let hierarchy_theme_db_2 = Hierarchy_Theme_Db_v4()
                // 当たり前だが、start_themeはずっと同じで良いので、変わらず、m_themeを取得
                hierarchy_theme_db_2.start_theme = m_theme
                hierarchy_theme_db_2.parent_theme = parent_theme
                // parent_xが最重要。これで、どこからきたかが分かる。yは(self_y-1)なので、あまり不要だが、分かりやすくするために保存。
                hierarchy_theme_db_2.parent_x = serched[0].self_x
                hierarchy_theme_db_2.parent_y = serched[0].self_y
                hierarchy_theme_db_2.self_theme  = theme_
                hierarchy_theme_db_2.self_x = index_count
                hierarchy_theme_db_2.self_y = serched[0].self_y + 1
                try! realm.write() {
                    realm.add(hierarchy_theme_db_2)
                }
            }
            index_count = index_count + 1
//            print("--------------")
            before_parent_theme = parent_theme
        }else{
            
        }
        
        for one in arr{
            parent_theme = theme_
            db_serch(theme_:one.idea,index_count_: index_count)
        }
    }
    @objc func randam_location(_ sender: CustomNSButton){
        print("sender.st")
        print(sender.st)
//        self.dismiss(nil)
    }
}
class MyLine: NSView {
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
            path.line(to: NSPoint(x: Double(x + (150 / 2)), y: Double(Double(y) - 12.5)))
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
