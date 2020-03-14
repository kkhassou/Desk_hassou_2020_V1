//
//  Randam_LocationController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/12.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Randam_LocationController: NSViewController {
    let realm = try! Realm()
    var m_theme = ""
    var m_idea_Stock_s:[String] = []
    var m_added_text_s:[NSTextField] = []
    var m_x_y_Array:[Point_Store] = []
    var m_disp_num = 1
    var m_tag_count = 10000
    let TB_WIDTH = 115.0
    let TB_HEIGHT = 65.0
    
    var idea_count = 0
    let IDEA_ONE_DISP_UPPER_LIMIT = 25
    var first_falg = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        
        if first_falg == false{
            m_theme = UserDefaults.standard.object(forKey: "theme") as! String
            // ここに表示の処理を入れる
            var db_idea_Stock_s = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme)
            var db_idea_Stock_array = Array(db_idea_Stock_s)
            var temp :[String] = []
            for one in db_idea_Stock_array{
                if one.idea != ""{
                    temp.append(one.idea)
                }
            }
            let orderedSet = NSOrderedSet(array: temp)
            m_idea_Stock_s = orderedSet.array as! [String]
            first_falg = true
        }
        first_appear()
    }
    func first_appear(){
       // テーマを左上に表示する
       // アイデアの個数によって、ページ数を決める
       // アイデアを、各位置にランダムに配置する
       // テキストと一緒にボタンを付ける。追加ボタンと深掘りボタン。
       // そして、DB保存のための、保存ボタンを作る。深掘りボタンを押したタイミングでもDB保存は行う。
       // 戻った時の処理を行う。保存ボタンを押した時だけ、元の階層表示に戻る。その時は、追加された状況を反映して戻る。
       // 戻った時の反映をする処理は、ここではなく、Hierarchy_ThemeControllerでするが、
       // この画面から戻った、という事を伝えるために、ローカルに保存したものを渡す必要はある。
       // これらを一からでなく、元作ったのを参考に作る
       // 残りやる事
       // アイデアの数が◯以上の時に、次のページを作る事。
       // １画面で収まらない時に、次の場所に行く事。
       // これ、新しいDBを作ったほうが楽だな。配列に収めるとまた、面倒な事になる。
       // x y 画面番号 テーマ アイデア これだけあれば、大丈夫だね。
       
       var theme_content = NSTextField()
       var theme_content_p = Param(st_ :m_theme,x_:20,y_:575,width_:200,height_:50,fontSize_:9)
    U().text_generate(param_:theme_content_p,nsText_:theme_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
       
       // NSButtonの色の付け方が分からないので、NSClickGestureRecognizerで対応
       let retrun_button = NSTextField()
       retrun_button.isBordered = true
       retrun_button.isEditable = false
       retrun_button.isSelectable = true
       retrun_button.frame = CGRect(x:1000, y:10 , width:80, height:20);
       retrun_button.layer?.cornerRadius = 10.0
       retrun_button.stringValue = "保存せず戻る"
       retrun_button.wantsLayer = true
       retrun_button.backgroundColor = NSColor.green
       let clickDetection = NSClickGestureRecognizer()
       clickDetection.target = self
       clickDetection.action = #selector(self.return_button_click)
       retrun_button.addGestureRecognizer(clickDetection)
       self.view.addSubview(retrun_button)
       
       // NSButtonの色の付け方が分からないので、NSClickGestureRecognizerで対応
       let store_button = NSTextField()
       store_button.isBordered = true
       store_button.isEditable = false
       store_button.isSelectable = true
       store_button.frame = CGRect(x:1100, y:10 , width:80, height:20);
       store_button.layer?.cornerRadius = 10.0
       store_button.stringValue = "保存して戻る"
       store_button.wantsLayer = true
       store_button.backgroundColor = NSColor.green
       let clickDetection_2 = NSClickGestureRecognizer()
       clickDetection_2.target = self
       clickDetection_2.action = #selector(self.store_button_click)
       store_button.addGestureRecognizer(clickDetection_2)
       self.view.addSubview(store_button)
       
        // 削除して、0から追加する。
        let deleting = realm.objects(Random_Loc_Idea.self).filter("theme == %@",m_theme)
        try! realm.write {
            realm.delete(deleting)
        }
        var count = 0
        for one_idea_Stock in m_idea_Stock_s{
            count = count + 1
            if 0 + 20 * (m_disp_num - 1) < count && count < 20 * m_disp_num + 1{
                randam_generate(st_:one_idea_Stock)
            }
        }
        let disp_s = realm.objects(Random_Loc_Idea.self).filter("theme == %@",m_theme).filter("disp_num == %@",m_disp_num)
        var disp_arr = Array(disp_s)
        var count_2 = 0
        for one in disp_arr{
            count_2 = count_2 + 1
            print("count")
            print(count)
            if 0 + 20 * (m_disp_num - 1) < count_2 && count_2 < 20 * m_disp_num + 1{
                randam_obj_disp(ran_loc_idea_: one)
            }
        }
    }
    @objc func add_button_click(_ sender: CustomNSButton){
        print("add_button_click")
        randam_generate(st_:"")
    }
    @objc func next_button_click(_ sender: CustomNSButton){

    }
    @objc func store_button_click(_ sender: CustomNSButton){
        for one in m_added_text_s{
            print("one.stringValue")
            print(one.stringValue)
        }
    }
    @objc func return_button_click(_ sender: CustomNSButton){
        self.dismiss(nil)
    }
    func randam_generate(st_:String){
        var xRand = -999.0
        var yRand = -999.0
        var breakCount = 0
        var existFlag = false
        while true {
            breakCount = breakCount + 1
            xRand = Double.random(in: 10 ... 1000)
            yRand = Double.random(in: 60 ... 500)
            // 右下はボタンがあるため、そこには、表示されないようにはじく
            if xRand > 800 && yRand < 100 {
                existFlag = true
                break
            }
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
            print("existFlag == false")
            m_tag_count = m_tag_count + 1
            var random_loc_idea = Random_Loc_Idea()
            random_loc_idea.theme = m_theme
            random_loc_idea.idea = st_
            random_loc_idea.x = xRand
            random_loc_idea.y = yRand
            idea_count = idea_count + 1
            // 新しく追加したものに関しては、この時には、インサート出来ない。
            if st_ != ""{
                print("st_ != ")
                random_loc_idea.tag = m_tag_count + 10000
                random_loc_idea.disp_num = Int(idea_count / 21) + 1
                
            }else{
                random_loc_idea.tag = m_tag_count
                random_loc_idea.disp_num = m_disp_num
                randam_obj_disp(ran_loc_idea_:random_loc_idea)
            }
            try! realm.write() {
                realm.add(random_loc_idea)
            }
        }
    }
    func randam_obj_disp(ran_loc_idea_:Random_Loc_Idea){
        print("test")
        let random_content = NSTextField()
        var random_content_p = Param(st_ :ran_loc_idea_.idea,x_:Int(ran_loc_idea_.x),y_:Int(ran_loc_idea_.y),width_:Int(TB_WIDTH),height_:Int(TB_HEIGHT),fontSize_:9)
    
        
        if ran_loc_idea_.idea != "" {
        U().text_generate(param_:random_content_p,nsText_:random_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
        }else{        U().text_generate(param_:random_content_p,nsText_:random_content,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
            m_added_text_s.append(random_content)
        }
        let add_button = CustomNSButton(title: "追加", target: self, action: #selector(add_button_click))
        add_button.frame = CGRect(x:ran_loc_idea_.x-5.0, y:ran_loc_idea_.y - 22.0, width:55.0, height:20.0);
        add_button.st = ran_loc_idea_.idea
        add_button.tag = 999
        self.view.addSubview(add_button)
        
        let next_button = CustomNSButton(title: "深掘り", target: self, action: #selector(next_button_click))
        next_button.frame = CGRect(x:ran_loc_idea_.x + 40, y:ran_loc_idea_.y - 22.0, width:65.0, height:20.0);
        next_button.st = ran_loc_idea_.idea
        next_button.tag = 777
        self.view.addSubview(next_button)
    }
}

