//
//  ListController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/29.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class ListController: NSViewController, NSTableViewDelegate, NSTableViewDataSource{
    var db_stocks:[String] = []
    var select_stock = ""
    let realm = try! Realm()
    var m_to_page = ""
    var m_theme = ""
    @IBOutlet weak var tableview: NSTableView!
    var child_category_input = NSTextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        m_to_page = UserDefaults.standard.object(forKey: "to_page") as! String
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        UserDefaults.standard.set("", forKey: "to_page")
        UserDefaults.standard.synchronize()
        if m_to_page == "Proposal_List"{
            let stocks = realm.objects(Proposal_Seed.self)
            var temp :[String] = []
            for one in stocks{
                temp.append(one.seed)
            }
            let orderedSet = NSOrderedSet(array: temp)
            db_stocks = orderedSet.array as! [String]
            var select_btn_p = Param(st_ :"決定",x_:10,y_:30,width_:75,height_:50,fontSize_:22)
            U().button_generate(param_:select_btn_p,viewCon_:self,view_:self.view,action: #selector(select_theme))
        }else if m_to_page == "Concurrent_List"{
            let stocks = realm.objects(Concurrent_db.self)
            var temp :[String] = []
            for one in stocks{
                temp.append(one.theme)
            }
            let orderedSet = NSOrderedSet(array: temp)
            db_stocks = orderedSet.array as! [String]
            var select_btn_p = Param(st_ :"決定",x_:10,y_:30,width_:75,height_:50,fontSize_:22)
            U().button_generate(param_:select_btn_p,viewCon_:self,view_:self.view,action: #selector(select_theme))
            
            var new_btn_p = Param(st_ :"新規作成",x_:85,y_:30,width_:100,height_:50,fontSize_:22)
            U().button_generate(param_:new_btn_p,viewCon_:self,view_:self.view,action: #selector(new_theme))
        }else if m_to_page == "Hint_Category_List"{
            let stocks = realm.objects(Hint_Db.self)
            var temp :[String] = []
            for one in stocks{
                temp.append(one.theme)
            }
            let orderedSet = NSOrderedSet(array: temp)
            db_stocks = orderedSet.array as! [String]
            var select_btn_p = Param(st_ :"決定",x_:10,y_:30,width_:75,height_:50,fontSize_:22)
            U().button_generate(param_:select_btn_p,viewCon_:self,view_:self.view,action: #selector(select_theme))
        }else if m_to_page == "Deep_Enlarge_Pre"{
            // ここの処理が少し複雑
            let stocks = realm.objects(Deep_Enlarge_Db.self).filter("theme == %@",m_theme)
            // themeとcategory_1から10を重複なく、取得する
            var temp :[String] = []
            temp.append("[THEME]:" + m_theme)
            for one in stocks{
                if one.category_1 != ""{
                    temp.append("1:" + one.category_1)
                }
                if one.category_2 != ""{
                    temp.append("2:" + one.category_2)
                }
                if one.category_3 != ""{
                    temp.append("3:" + one.category_3)
                }
                if one.category_4 != ""{
                    temp.append("4:" + one.category_4)
                }
                if one.category_5 != ""{
                    temp.append("5:" + one.category_5)
                }
                if one.category_6 != ""{
                    temp.append("6:" + one.category_6)
                }
                if one.category_7 != ""{
                    temp.append("7:" + one.category_7)
                }
                if one.category_8 != ""{
                    temp.append("8:" + one.category_8)
                }
                if one.category_9 != ""{
                    temp.append("9:" + one.category_9)
                }
            }
            var temp_2 :[String] = []
            for one in temp{
                if one != ""{
                    temp_2.append(one)
                }
            }
            let orderedSet = NSOrderedSet(array: temp_2)
            db_stocks = orderedSet.array as! [String]
            
            var parent_category_title = NSTextField()
            var parent_category_title_p = Param(st_ :"親カテゴリの選択",x_:20,y_: 770,width_:150,height_:20,fontSize_:14)
            U().text_generate(param_:parent_category_title_p,nsText_:parent_category_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
            var child_category_title = NSTextField()
            var child_category_title_p = Param(st_ :"子カテゴリの入力",x_:20,y_: 30,width_:150,height_:20,fontSize_:14)
            U().text_generate(param_:child_category_title_p,nsText_:child_category_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
            
            
            var child_category_input_p = Param(st_ :"",x_:180,y_: 30,width_:400,height_:20,fontSize_:14)
            U().text_generate(param_:child_category_input_p,nsText_:child_category_input,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
            
            var select_btn_p = Param(st_ :"決定",x_:590,y_:30,width_:70,height_:20,fontSize_:22)
            U().button_generate(param_:select_btn_p,viewCon_:self,view_:self.view,action: #selector(select_theme))
            
            var re_start_p = Param(st_ :"途中から再開",x_:660,y_:30,width_:160,height_:20,fontSize_:22)
            U().button_generate(param_:re_start_p,viewCon_:self,view_:self.view,action: #selector(re_start))
            
            var list_confirm_p = Param(st_ :"リスト確認",x_:830,y_:30,width_:140,height_:20,fontSize_:22)
            U().button_generate(param_:list_confirm_p,viewCon_:self,view_:self.view,action: #selector(list_confirm))
        }else if m_to_page == "Deep_Enlarge_List_Confirm"{
            var deep_enlarge_select = UserDefaults.standard.object(forKey: "deep_enlarge_select") as! String
            var arr:[String] = deep_enlarge_select.components(separatedBy: ":")
            var serch_parent_category = "category_" + arr[0]
            var serch_parent_idea = "idea_" + arr[0]
            let stocks = realm.objects(Deep_Enlarge_Db.self).filter("theme == %@",m_theme).filter(serch_parent_category + " == %@",arr[1]).value(forKey: serch_parent_idea) as! [String]
            var temp :[String] = []
            for one in stocks{
                temp.append(one)
            }
            let orderedSet = NSOrderedSet(array: temp)
            db_stocks = orderedSet.array as! [String]
            var return_page_btn_p = Param(st_ :"戻る",x_:10,y_:30,width_:75,height_:50,fontSize_:22)
            U().button_generate(param_:return_page_btn_p,viewCon_:self,view_:self.view,action: #selector(return_page))
            
            var parent_category_content = NSTextField()
            var parent_category_content_p = Param(st_ :"カテゴリ:" + arr[1],x_:20,y_: 770,width_:200,height_:20,fontSize_:14)
            U().text_generate(param_:parent_category_content_p,nsText_:parent_category_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        }
        
        tableview.action = #selector(onItemClicked)
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return db_stocks.count
    }
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return db_stocks[row]
    }
    @objc func onItemClicked() {
        if tableview.clickedRow > -1{
            select_stock = db_stocks[tableview.clickedRow]
        }else{
            print("配列の範囲外")
        }
    }
    @objc func re_start(){
        // DBからクリックいしたテーマの上位のテーマを検索して、それをparentに選択されているものをchildにして、他は一緒で、画面遷移すれば、OK
        
        var local_parent_category = ""
        // 親を子から探さないといけない
        var arr:[String] = select_stock.components(separatedBy: ":")

        if arr[0] == "[THEME]"{
            // テーマからの再開はできないので、
            let alert = NSAlert()
            alert.messageText = "再開したい場合はテーマ以外を選んでください"
            alert.addButton(withTitle: "OK")
            let response = alert.runModal()
        }else if arr[0] == "1"{
            UserDefaults.standard.set(select_stock, forKey: arr[0])
            UserDefaults.standard.set("[THEME]" + ":" + m_theme, forKey: "parent_category")
        }else{
            UserDefaults.standard.set(select_stock, forKey: "child_category")
            var serch_parent_category = "category_" + String(Int(arr[0])! - 1)
            var serch_child_category = "category_" + (arr[0])
            var temp:[String] = []
            temp = realm.objects(Deep_Enlarge_Db.self).filter("theme == %@",m_theme).filter(serch_child_category + " == %@",arr[1]).value(forKey: serch_parent_category) as! [String]
            UserDefaults.standard.set( String(Int(arr[0])! - 1) + ":" + temp[0], forKey: "parent_category")
        }
        UserDefaults.standard.synchronize()
        self.dismiss(nil)
        let next = storyboard?.instantiateController(withIdentifier: "Deep_Enlarge")
        self.presentAsModalWindow(next! as! NSViewController)
    }
    @objc func list_confirm(){
        // クリックしたものを親にして、選択すれば良いだけ！
        UserDefaults.standard.set("Deep_Enlarge_List_Confirm", forKey: "to_page")
        UserDefaults.standard.set(select_stock, forKey: "deep_enlarge_select")
        UserDefaults.standard.synchronize()
        let next = storyboard?.instantiateController(withIdentifier: "List")
        self.presentAsModalWindow(next! as! NSViewController)
        self.dismiss(nil)
    }
    @objc func new_theme(){
        let alert = NSAlert()
        alert.messageText = "新規テーマで作成"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "キャンセル")
        let new_theme_input = NSTextField(frame: NSRect(x: 0, y: 80, width: 500, height: 24))
        let stackViewer = NSStackView(frame: NSRect(x: 0, y: 0, width: 500, height: 150))
        stackViewer.addSubview(new_theme_input)
        alert.accessoryView = stackViewer

        let response = alert.runModal()
        switch response {
        case .alertFirstButtonReturn:
            if new_theme_input.stringValue != ""{
                var exitstIt = realm.objects(Concurrent_db.self).filter("theme == %@",new_theme_input.stringValue)
                if exitstIt.count == 0{
                    let new_Db = Concurrent_db()
                    new_Db.theme  = new_theme_input.stringValue
                    try! realm.write() {
                        realm.add(new_Db)
                    }
                    UserDefaults.standard.set(new_theme_input.stringValue, forKey: "concurrent_theme")
                    UserDefaults.standard.synchronize()
                    self.dismiss(nil)
                    let next = storyboard?.instantiateController(withIdentifier: "Concurrent")
                    self.presentAsModalWindow(next! as! NSViewController)
                }else{
                    let alert = NSAlert()
                    alert.messageText = "重複したアイデアは登録出来ません。"
                    let response = alert.runModal()
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
    @objc func return_page(){
        UserDefaults.standard.set("Deep_Enlarge_Pre", forKey: "to_page")
        UserDefaults.standard.synchronize()
        let next = storyboard?.instantiateController(withIdentifier: "List")
        self.presentAsModalWindow(next! as! NSViewController)
        self.dismiss(nil)
    }
    @objc func select_theme(){
        if select_stock != ""{
            if m_to_page == "Proposal_List"{
                UserDefaults.standard.set(select_stock, forKey: "trigger_idea")
                UserDefaults.standard.synchronize()
                self.dismiss(nil)
                let next = storyboard?.instantiateController(withIdentifier: "Proposal")
                self.presentAsModalWindow(next! as! NSViewController)
            }else if m_to_page == "Concurrent_List"{
                UserDefaults.standard.set(select_stock, forKey: "concurrent_theme")
                UserDefaults.standard.synchronize()
                self.dismiss(nil)
                let next = storyboard?.instantiateController(withIdentifier: "Concurrent")
                self.presentAsModalWindow(next! as! NSViewController)
            }else if m_to_page == "Hint_Category_List"{
                UserDefaults.standard.set(select_stock, forKey: "mHintCategory")
                UserDefaults.standard.synchronize()
                self.dismiss(nil)
                let next = storyboard?.instantiateController(withIdentifier: "More_Idea")
                self.presentAsModalWindow(next! as! NSViewController)
            }else if m_to_page == "Deep_Enlarge_Pre"{
                if child_category_input.stringValue != ""{
                    // child_category_input.stringValue、既存と同じものは許可しない
                    var same_exist = false
                    for one in db_stocks{
                        if one == child_category_input.stringValue{
                            same_exist = true
                        }
                    }
                    if same_exist == false{
                        UserDefaults.standard.set(select_stock, forKey: "parent_category")
                        UserDefaults.standard.set(child_category_input.stringValue, forKey: "child_category")
                        UserDefaults.standard.synchronize()
                        self.dismiss(nil)
                        let next = storyboard?.instantiateController(withIdentifier: "Deep_Enlarge")
                        self.presentAsModalWindow(next! as! NSViewController)
                    }else{
                        let alert = NSAlert()
                        alert.messageText = "子カテゴリの重複は認められません"
                        alert.addButton(withTitle: "OK")
                        let response = alert.runModal()
                    }
                }else{
                    let alert = NSAlert()
                    alert.messageText = "子カテゴリを入力してください"
                    alert.addButton(withTitle: "OK")
                    let response = alert.runModal()
                }
            }
        }else{
            let alert = NSAlert()
            if m_to_page == "Deep_Enlarge_Pre"{
                alert.messageText = "親カテゴリを選択してください"
            }else{
                alert.messageText = "テーマを選択してください"
            }
            alert.addButton(withTitle: "OK")
            let response = alert.runModal()
        }
    }
}
