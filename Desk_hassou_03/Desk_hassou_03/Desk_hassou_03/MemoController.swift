//
//  MemoController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/22.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa

class MemoController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:400, height:300);
        
        
        var memo_title = NSTextField()
        var memo_title_p = Param(st_ :"メモ",x_:50,y_:220,width_:100,height_:50,fontSize_:12)
        U().text_generate(param_:memo_title_p,nsText_:memo_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        var memo_content = NSTextField()
        var memo_content_p = Param(st_ :"",x_:50,y_:50,width_:300,height_:200,fontSize_:12)
        U().text_generate(param_:memo_content_p,nsText_:memo_content,view_:self.view,input_flag_:true,ajust_flag_:false,border_flag_:true)
        
        var return_btn_p = Param(st_ :"保存",x_:925,y_:7,width_:75,height_:20,fontSize_:13)
        U().button_generate(param_:return_btn_p,viewCon_:self,view_:self.view,action: #selector(store_click))
    }
    @objc func store_click(_ sender: CustomNSButton){
        UserDefaults.standard.set(true, forKey: "from_memo")
        UserDefaults.standard.synchronize()
    }
}
