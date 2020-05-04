//
//  View_0_ver2_Controller.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/05/01.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa

class View_0_ver2_Controller: NSViewController {
    
    let SELF_X = 10
    let SELF_Y = 10
    let SELF_WIDTH = 500
    let SELF_HEITHT = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.frame = CGRect(x:SELF_X, y:SELF_Y , width:SELF_WIDTH, height:SELF_HEITHT);
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        var theme_title = NSTextField()
        var theme_title_p = Param(st_ :"発想支援PCアプリLITE",x_:20,y_:450,width_:300,height_:20,fontSize_:20)
        U().text_generate(param_:theme_title_p,nsText_:theme_title,view_:self.view,input_flag_:false,ajust_flag_:false,border_flag_:false)
        
        var start_btn_p = Param(st_ :"一人でブレーンストーミング",x_:20,y_:400,width_:300,height_:30,fontSize_:20)
        U().button_generate(param_:start_btn_p,viewCon_:self,view_:self.view,action: #selector(start))
    }
    @objc func start(){
        UserDefaults.standard.set("One_Brainstorming", forKey: "to_page")
        UserDefaults.standard.synchronize()
        self.dismiss(nil)
        U().screen_next(viewCon : self ,id:"List" , storyboard:storyboard!)
    }
}
