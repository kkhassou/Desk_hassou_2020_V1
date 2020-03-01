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
    func text_generate(nsText:NSTextField,view:NSView,x:Int,y:Int,width:Int,height:Int,st:String,input_flag:Bool,fontSize:Int,ajust_flag:Bool,border_flag:Bool){
        nsText.frame = CGRect(x:x, y:y , width:width, height:height)
        if ajust_flag{
            nsText.stringValue = U().disp_adjust(in_st: st,nstext :nsText)
        }else{
            nsText.stringValue = st
            nsText.font = NSFont.systemFont(ofSize: CGFloat(fontSize))
        }
        if input_flag{
            nsText.isEditable = true
        }else{
            nsText.isEditable = false
        }
        if border_flag{
            nsText.isBordered = true
        }else{
            nsText.isBordered = false
        }
        nsText.isSelectable = true
        nsText.backgroundColor = NSColor.white
        view.addSubview(nsText)
    }
    // ボタンを動かす事が出来ないので、不便。
    func button_generate(viewCon : NSViewController ,view:NSView,x:Int,y:Int,width:Int,height:Int,st:String,fontSize:Int,action: Selector){
        var nsButton  = NSButton(title: st, target: viewCon, action: action)
        nsButton.frame = CGRect(x:x, y:y , width:width, height:height)
        nsButton.font = NSFont.systemFont(ofSize: CGFloat(fontSize))
        view.addSubview(nsButton)
    }
    func screen_next(viewCon : NSViewController ,id:String , storyboard:NSStoryboard){
        viewCon.dismiss(nil)
        let next = storyboard.instantiateController(withIdentifier: id)
        viewCon.presentAsModalWindow(next as! NSViewController)
    }
    // Hint_Dbでしか使えないのがいまいち！！！
    func random_hint_disp(ns_content : NSTextField ,view : NSView, realm: Realm,x:Int,y:Int,width:Int,height:Int,key_content:String){
        let dbSelect = realm.objects(Hint_Db.self).filter("theme == %@",key_content)
        let hintArray:[Hint_Db] = Array(dbSelect) as! [Hint_Db]
        let ranInt_2 = Int.random(in: 0 ... Array(dbSelect).count - 1)
    U().text_generate(nsText:ns_content,view:view,x:x,y:y,width:width,height:height,st:hintArray[ranInt_2].content,input_flag:false,fontSize:0,ajust_flag:true,border_flag:false)
    }
    // 引数が多いが、便利に使えるようにしよう。
    func idea_count_disp(ns_content : NSTextField ,ns_count : NSTextField ,view : NSView, realm: Realm,x:Int,y:Int,width:Int,height:Int,key:String,fontSize:Int,dbObj:Object.Type){
        if ns_content.stringValue != ""{
            let ideaSelect = realm.objects(dbObj).filter(key + " == %@",U().line_break_delete(in_st:ns_content.stringValue))
        U().text_generate(nsText:ns_count,view:view,x:x,y:y,width:width,height:height,st:String(ideaSelect.count),input_flag:false,fontSize:fontSize,ajust_flag:false,border_flag:false)
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
