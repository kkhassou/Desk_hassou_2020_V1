//
//  Index_Group_DivideController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/07.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Index_Group_DivideController: NSViewController , NSComboBoxDataSource{

    let realm = try! Realm()
    var unique_stocks:[String] = []
    var unique_group_stocks:[String] = []
    var m_theme = ""
    var comboBox = NSComboBox()
    var group_input_content = NSTextField()
    var group_set_content = NSTextField()

    
    override func viewDidLoad() {

        
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        
        m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        let stocks = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme)
        var temp :[String] = []
        for one in stocks{
            temp.append(one.idea)
        }
        let orderedSet = NSOrderedSet(array: temp)
        unique_stocks = orderedSet.array as! [String]
        
        // 一旦、目一杯、画面に、縦横にマスを並べてみよう。
        var index = 0
        for y in 0..<8{
            for x in 0..<8{
                if  index < unique_stocks.count - 1 {
                    var indea_one_content = NSTextField()

                    var idea_one = unique_stocks[index]
                    index = index + 1
                    var indea_one_content_p = Param(st_ :idea_one,x_:18 + x*148,y_:550 - y*80,width_:130,height_:60,fontSize_:9)
                    indea_one_content.tag = y*10 + x
                    U().text_generate(param_:indea_one_content_p,nsText_:indea_one_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                    var indea_group_content = NSTextField()
                    var indea_group_content_p = Param(st_ :"グループ",x_:18 + x*148,y_: 612 - y*80,width_:130,height_:13,fontSize_:9)
                    indea_group_content.tag = y*10 + x
                    U().text_generate(param_:indea_group_content_p,nsText_:indea_group_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                    var indea_index = NSTextField()
                    var indea_index_p = Param(st_ :String(index),x_:2 + x*148,y_: 611 - y*80,width_:16,height_:13,fontSize_:9)
                    indea_index.tag = y*10 + x
                    U().text_generate(param_:indea_index_p,nsText_:indea_index,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
                }
            }
        }
        var comboBox_titel = NSTextField()
        var comboBox_titel_p = Param(st_ :"セットするグループを選択",x_: 10, y_: 38 , width_: 170, height_:13,fontSize_:9)
        U().text_generate(param_:comboBox_titel_p,nsText_:comboBox_titel,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        var group_set_titel = NSTextField()
        var group_set_titel_p = Param(st_ :"セットする番号を入力。区切りは半角スペース",x_: 230, y_: 38 , width_: 270, height_:13,fontSize_:9)
        U().text_generate(param_:group_set_titel_p,nsText_:group_set_titel,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)

        
        var group_set_content_p = Param(st_ :"",x_:230,y_:10,width_:300,height_:28,fontSize_:13)
        U().text_generate(param_:group_set_content_p,nsText_:group_set_content,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
        
        var group_set_btn_p = Param(st_ :"グループをセット",x_:535,y_:12,width_:130,height_:20,fontSize_:13)
        U().button_generate(param_:group_set_btn_p,viewCon_:self,view_:self.view,action: #selector(group_set_click))
        
        var group_input_titel = NSTextField()
        var group_input_titel_p = Param(st_ :"追加するグループを入力",x_: 680, y_: 38 , width_: 270, height_:13,fontSize_:9)
        U().text_generate(param_:group_input_titel_p,nsText_:group_input_titel,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)


        var group_input_content_p = Param(st_ :"",x_:680,y_:10,width_:180,height_:28,fontSize_:13)
        U().text_generate(param_:group_input_content_p,nsText_:group_input_content,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
        
        var group_input_btn_p = Param(st_ :"グループを追加",x_:860,y_:12,width_:130,height_:20,fontSize_:13)
              U().button_generate(param_:group_input_btn_p,viewCon_:self,view_:self.view,action: #selector(group_input_click))
        
        let group_label_s = realm.objects(Group_Label_Db_ver3.self).filter("theme == %@",m_theme)
        var temp_2 :[String] = []
        if group_label_s.count != 0{
            for one in group_label_s{
                temp_2.append(one.gourp_label)
            }
            let orderedSet_2 = NSOrderedSet(array: temp_2)
            unique_group_stocks = orderedSet_2.array as! [String]
        }else{
            unique_group_stocks.append("")
        }


        comboBox.usesDataSource = true
        comboBox.dataSource = self
        comboBox.frame = CGRect(x: 10, y: 10 , width: 200, height:28)
        comboBox.isEditable = false
        comboBox.stringValue = ""
        self.view.addSubview(comboBox)
    }
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return unique_group_stocks.count
    }
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return unique_group_stocks[index]
    }
    @objc func group_set_click(){
        var st = group_set_content.stringValue
        let arr:[String] = st.components(separatedBy: " ")
        var index = 0
        for y in 0..<8{
            for x in 0..<8{
                if  index < unique_stocks.count - 1 {
                    index = index + 1
                    for one in arr{
                        if  index == Int(one){
                            var indea_group_content = NSTextField()
                            var indea_group_content_p = Param(st_ :comboBox.stringValue,x_:18 + x*148,y_: 612 - y*80,width_:130,height_:13,fontSize_:9)
                            indea_group_content.tag = y*10 + x
                            indea_group_content.backgroundColor = NSColor.green
                            U().text_generate(param_:indea_group_content_p,nsText_:indea_group_content,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:true)
                        }
                    }
                }
            }
        }
    }
    @objc func group_input_click(){
        let group_Label_Db = Group_Label_Db_ver3()
        group_Label_Db.theme = m_theme
        group_Label_Db.gourp_label  = U().line_break_delete(in_st:group_input_content.stringValue)
        try! realm.write() {
            realm.add(group_Label_Db)
        }
        unique_group_stocks.append(group_input_content.stringValue)
        comboBox.reloadData()
    }
}
