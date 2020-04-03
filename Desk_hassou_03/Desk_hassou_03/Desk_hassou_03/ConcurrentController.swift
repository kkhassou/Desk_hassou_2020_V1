//
//  ConcurrentController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/04/01.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift
class ConcurrentController: NSViewController {
    let realm = try! Realm()
    var m_theme = ""
    var m_hint_category = ""
    var m_frame_1 = ""
    var m_frame_2 = ""
    var m_rand_hint = ""
    let SELF_WIDTH = 500
    let SELF_HEITHT = 675
    
    var hint_content = NSTextField()
    var frame_1_content = NSTextField()
    var frame_2_content = NSTextField()
    var input_1_content = NSTextField()
    var input_2_content = NSTextField()
    
    var m_frame_s:[NSTextField] = []
    var m_input_s:[NSTextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:SELF_WIDTH, height:SELF_HEITHT);
        m_hint_category = UserDefaults.standard.object(forKey: "mHintCategory") as! String
        m_theme = UserDefaults.standard.object(forKey: "concurrent_theme") as! String
        
        m_frame_1 = UserDefaults.standard.object(forKey: "frame_1") as! String
        m_frame_2 = UserDefaults.standard.object(forKey: "frame_2") as! String
        var theme_title = NSTextField()
        var theme_title_p = Param(st_ :"テーマ",x_:20,y_:630,width_:100,height_:20,fontSize_:20)
        U().text_generate(param_:theme_title_p,nsText_:theme_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        var theme_content = NSTextField()
        var theme_content_p = Param(st_ :m_theme,x_:20,y_:580,width_:400,height_:40,fontSize_:15)
        U().text_generate(param_:theme_content_p,nsText_:theme_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        var hint_title = NSTextField()
        var hint_title_p = Param(st_ :"ヒント",x_:20,y_:510,width_:100,height_:20,fontSize_:20)
        U().text_generate(param_:hint_title_p,nsText_:hint_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        random_hint_disp_2()
//        var hint_content_p = Param(st_ :m_rand_hint,x_:20,y_:460,width_:400,height_:40,fontSize_:15)
//        U().text_generate(param_:hint_content_p,nsText_:hint_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        var frame_1_title = NSTextField()
        var frame_1_title_p = Param(st_ :"フレーム_1",x_:20,y_:410,width_:100,height_:20,fontSize_:20)
        U().text_generate(param_:frame_1_title_p,nsText_:frame_1_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        var set_1_btn_p = Param(st_ :"設定_1",x_:130,y_:390,width_:100,height_:50,fontSize_:22)
        set_1_btn_p.tag = 1
        U().button_generate(param_:set_1_btn_p,viewCon_:self,view_:self.view,action: #selector(set_click))
        
        var frame_1_content_p = Param(st_ :m_frame_1,x_:20,y_:370,width_:400,height_:20,fontSize_:15)
        U().text_generate(param_:frame_1_content_p,nsText_:frame_1_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
                
        
        var input_1_content_p = Param(st_ :"",x_:20,y_:260,width_:400,height_:100,fontSize_:12)
        U().text_generate(param_:input_1_content_p,nsText_:input_1_content,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
        
        var frame_2_title = NSTextField()
        var frame_2_title_p = Param(st_ :"フレーム_2",x_:20,y_:220,width_:100,height_:20,fontSize_:20)
        U().text_generate(param_:frame_2_title_p,nsText_:frame_2_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        var set_2_btn_p = Param(st_ :"設定_2",x_:130,y_:200,width_:100,height_:50,fontSize_:22)
        set_2_btn_p.tag = 2
        U().button_generate(param_:set_2_btn_p,viewCon_:self,view_:self.view,action: #selector(set_click))
        
        var frame_2_content_p = Param(st_ :m_frame_2,x_:20,y_:180,width_:400,height_:20,fontSize_:15)
        U().text_generate(param_:frame_2_content_p,nsText_:frame_2_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
                
        var input_2_content_p = Param(st_ :"",x_:20,y_:70,width_:400,height_:100,fontSize_:12)
        U().text_generate(param_:input_2_content_p,nsText_:input_2_content,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
        
        var ramdom_store_btn_p = Param(st_ :"ランダム&保存",x_:300,y_:10,width_:180,height_:50,fontSize_:22)
        U().button_generate(param_:ramdom_store_btn_p,viewCon_:self,view_:self.view,action: #selector(randam_store_click))
        
        m_frame_s.append(frame_1_content)
        m_frame_s.append(frame_2_content)
        m_input_s.append(input_1_content)
        m_input_s.append(input_2_content)
    }
    func random_hint_disp_2(){
        var index = 0
        for one in m_frame_s {
            let concurrent_db = Concurrent_db()
            
            var maxId: Int { return try! Realm().objects(Concurrent_db.self).sorted(byKeyPath: "id").last?.id ?? 0 }
            concurrent_db.id = maxId + 1
            concurrent_db.theme  = m_theme
            concurrent_db.frame = one.stringValue
            concurrent_db.idea = m_input_s[index].stringValue
            try! realm.write() {
                realm.add(concurrent_db)
            }
            index = index + 1
        }
         let dbSelect = realm.objects(Hint_Db.self).filter("theme == %@",m_hint_category)
         let hintArray:[Hint_Db] = Array(dbSelect) as! [Hint_Db]
         let ranInt_2 = Int.random(in: 0 ... Array(dbSelect).count - 1)
         m_rand_hint = hintArray[ranInt_2].content
        var hint_content_p = Param(st_ :m_rand_hint,x_:20,y_:460,width_:400,height_:40,fontSize_:15)
        U().text_generate(param_:hint_content_p,nsText_:hint_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        input_1_content.stringValue = ""
        input_2_content.stringValue = ""
//        let test = realm.objects(Concurrent_db.self).filter("theme == %@",m_theme)
//        print(test)
    }
    @objc func set_click(_ sender: NSButton) {
        let alert = NSAlert()
        if sender.tag == 1{
            alert.messageText = "フレーム_1を設定"
        }else if sender.tag == 2{
            alert.messageText = "フレーム_2を設定"
        }
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "キャンセル")
        let new_frame_input = NSTextField(frame: NSRect(x: 0, y: 80, width: 500, height: 24))
        let stackViewer = NSStackView(frame: NSRect(x: 0, y: 0, width: 500, height: 150))
        stackViewer.addSubview(new_frame_input)
        alert.accessoryView = stackViewer

        let response = alert.runModal()
        switch response {
        case .alertFirstButtonReturn:
            if new_frame_input.stringValue != ""{
                if sender.tag == 1{
                    UserDefaults.standard.set(new_frame_input.stringValue, forKey: "frame_1")
                    UserDefaults.standard.synchronize()
                    frame_1_content.stringValue = new_frame_input.stringValue
                }else if sender.tag == 2{
                    UserDefaults.standard.set(new_frame_input.stringValue, forKey: "frame_2")
                    UserDefaults.standard.synchronize()
                    frame_2_content.stringValue = new_frame_input.stringValue
                }
            }else{
                let alert = NSAlert()
                alert.messageText = "テーマを入力してください。。"
                alert.addButton(withTitle: "OK")
                let response = alert.runModal()
            }

            break
        case .alertSecondButtonReturn:
            break
        default:
            break
        }
    }
    @objc func randam_store_click(_ sender: NSButton) {
        if input_1_content.stringValue != "" && input_2_content.stringValue != ""{
            // セットで、同じものをあるかどうかを検索すると結構面倒
            let exitst_frame_1 = realm.objects(Concurrent_db.self).filter("theme == %@",m_theme).filter("frame == %@",frame_1_content.stringValue)
            let exitst_frame_2 = realm.objects(Concurrent_db.self).filter("theme == %@",m_theme).filter("frame == %@",frame_2_content.stringValue)
            let exitst_idea_1 = realm.objects(Concurrent_db.self).filter("theme == %@",m_theme).filter("idea == %@",input_1_content.stringValue)
            let exitst_idea_2 = realm.objects(Concurrent_db.self).filter("theme == %@",m_theme).filter("idea == %@",input_2_content.stringValue)

            if exitst_frame_1.count != 0 && exitst_frame_2.count != 0 && exitst_idea_1.count != 0 && exitst_idea_2.count != 0{
                if exitst_frame_1[0].id == exitst_frame_2[0].id && exitst_frame_1[0].id == exitst_idea_1[0].id && exitst_frame_1[0].id == exitst_frame_2[0].id{
                    let alert = NSAlert()
                    alert.messageText = "重複したアイデアは登録出来ません。"
                    alert.addButton(withTitle: "OK")
                    let response = alert.runModal()
                }else{
                    random_hint_disp_2()
                }
            }else{
                random_hint_disp_2()
            }

        }else{
            random_hint_disp_2()
        }
    }
}
