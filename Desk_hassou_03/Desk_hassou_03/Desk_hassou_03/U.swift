//
//  U.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/03/01.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Foundation
import Cocoa
import Realm
import RealmSwift

class U {
    func text_generate(param_:Param,nsText_:NSTextField,view_:NSView,input_flag_:Bool,ajust_flag_:Bool,border_flag_:Bool){
        nsText_.frame = CGRect(x:param_.x, y:param_.y , width:param_.width, height:param_.height)
        if ajust_flag_{
            nsText_.stringValue = U().disp_adjust(in_st: param_.st,nstext :nsText_)
        }else{
            nsText_.stringValue = param_.st
            nsText_.font = NSFont.systemFont(ofSize: CGFloat(param_.fontSize))
        }
        if input_flag_{
            nsText_.isEditable = true
        }else{
            nsText_.isEditable = false
        }
        if border_flag_{
            nsText_.isBordered = true
        }else{
            nsText_.isBordered = false
        }
        nsText_.isSelectable = true
        if nsText_.backgroundColor == nil{
            nsText_.backgroundColor = NSColor.white
        }
        view_.addSubview(nsText_)
    }
    // ボタンの表示を変えられるversion
    func button_generate(param_:Param,nsButton_:NSButton,view_:NSView){
        nsButton_.frame = CGRect(x:param_.x, y:param_.y , width:param_.width, height:param_.height)
        nsButton_.font = NSFont.systemFont(ofSize: CGFloat(param_.fontSize))
        nsButton_.tag = param_.tag
        view_.addSubview(nsButton_)
    }
    // ボタンを動かす事が出来ないので、不便。
    func button_generate(param_:Param,viewCon_:NSViewController,view_:NSView,action: Selector){
        var nsButton  = NSButton(title: param_.st, target: viewCon_, action: action)
        nsButton.frame = CGRect(x:param_.x, y:param_.y , width:param_.width, height:param_.height)
        nsButton.font = NSFont.systemFont(ofSize: CGFloat(param_.fontSize))
        view_.addSubview(nsButton)
    }
    func screen_next(viewCon : NSViewController ,id:String , storyboard:NSStoryboard){
        viewCon.dismiss(nil)
        let next = storyboard.instantiateController(withIdentifier: id)
        viewCon.presentAsModalWindow(next as! NSViewController)
    }
    // Hint_Dbでしか使えないのがいまいち！！！
//    func random_hint_disp(ns_content : NSTextField ,view : NSView, realm: Realm,x:Int,y:Int,width:Int,height:Int,key_content:String){
    func random_hint_disp(param_:Param,hint_key_:String,ns_content_ : NSTextField ,view_ : NSView, realm_: Realm){
        let dbSelect = realm_.objects(Hint_Db.self).filter("theme == %@",hint_key_)
        let hintArray:[Hint_Db] = Array(dbSelect) as! [Hint_Db]
        let ranInt_2 = Int.random(in: 0 ... Array(dbSelect).count - 1)
   
        param_.st = hintArray[ranInt_2].content
        text_generate(param_:param_,nsText_:ns_content_,view_:view_,input_flag_:false,ajust_flag_:true,border_flag_:false)
    }
    // 引数が多いが、便利に使えるようにしよう。
    func idea_count_disp(param_:Param,theme_st_ : String ,ns_count_ : NSTextField ,view_ : NSView, realm_: Realm,dbObj_:Object.Type){
        if theme_st_ != ""{
            print(param_.st)
            print(theme_st_)
            let ideaSelect = realm_.objects(dbObj_).filter("theme == %@",U().line_break_delete(in_st:theme_st_))
            param_.st = String(ideaSelect.count)
            text_generate(param_:param_,nsText_:ns_count_ ,view_:view_,input_flag_:false,ajust_flag_:false,border_flag_:false)
        }
    }
    func theme_change(nstext : NSTextField ,view : NSView) -> NSTextField{
        let alert = NSAlert()
        let textField = NSTextField(frame: NSRect(x:0,y: 0,width:  400,height:  24))

        alert.accessoryView = textField
        alert.messageText = "テーマの入力"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "キャンセル")
        let response = alert.runModal()
        switch response {
        case .alertFirstButtonReturn:
            nstext.frame = CGRect(x:50, y:480 , width:400, height:100);
            nstext.stringValue = U().disp_adjust(in_st: (alert.accessoryView as!
                NSTextField).stringValue,nstext :nstext)
            nstext.isEditable = false
            nstext.isSelectable = false
            nstext.isBordered = false
            nstext.backgroundColor = NSColor.white
            view.addSubview(nstext)
        case .alertSecondButtonReturn:
            print("キャンセル")
        default:
            break
        }
        return nstext
    }
    func disp_adjust(in_st : String , nstext : NSTextField ) -> String {
        var st = ""
        if in_st.count > 95{
            nstext.font = NSFont.systemFont(ofSize: CGFloat(13))
            var count = 1
            for one in in_st{
                if count % 29 == 0{
                    st = st + String(one) + "\n"
                }else{
                    st = st + String(one)
                }
                count = count + 1
            }
        }else if in_st.count > 80{
            nstext.font = NSFont.systemFont(ofSize: CGFloat(14))
            var count = 1
            for one in in_st{
                if count % 27 == 0{
                    st = st + String(one) + "\n"
                }else{
                    st = st + String(one)
                }
                count = count + 1
            }
        }else if in_st.count > 65{
            nstext.font = NSFont.systemFont(ofSize: CGFloat(16))
            var count = 1
            for one in in_st{
                if count % 23 == 0{
                    st = st + String(one) + "\n"
                }else{
                    st = st + String(one)
                }
                count = count + 1
            }
        }else if in_st.count > 50{
            nstext.font = NSFont.systemFont(ofSize: CGFloat(20))
            var count = 1
            for one in in_st{
                if count % 18 == 0{
                    st = st + String(one) + "\n"
                }else{
                    st = st + String(one)
                }
                count = count + 1
            }

        }else
        {
            nstext.font = NSFont.systemFont(ofSize: CGFloat(25))
            st = in_st
        }
        nstext.maximumNumberOfLines = 0
        nstext.lineBreakMode = .byWordWrapping
        return st
    }
    func line_break_delete(in_st : String)->String{
        var st = ""
        for one in in_st{
            if one == "\n"{
                
            }else{
                st = st + String(one)
            }
        }
        return st
    }
}
