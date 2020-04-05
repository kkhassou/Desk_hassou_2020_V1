//
//  Nine_x_NineController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/02/16.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa
import Realm
import RealmSwift

class Nine_x_NineController: NSViewController {

    let realm = try! Realm()
    var textField_s:[NSTextField] = []
    var m_from_page = ""
    var m_theme  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let myView = MyView()
        myView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(myView)
        myView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        for x in 0..<9{
            for y in 0..<9{
                var textField = NSTextField()
                textField.frame = CGRect(x: 130 * x + 20, y: 60 * y + 20 + 80 , width: 120, height: 50)
                textField.font = NSFont.systemFont(ofSize: 12)
                textField.tag = x + y * 10
                self.view.addSubview(textField)
                textField_s.append(textField)
            }
        }

        
        m_from_page = UserDefaults.standard.object(forKey: "from_page") as! String
        if m_from_page == "Flows_Progress"{
            m_theme = UserDefaults.standard.object(forKey: "selected_theme") as! String
        }else{
            m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        }
        UserDefaults.standard.set("", forKey: "from_page")
        UserDefaults.standard.synchronize()
        // ここに表示の処理を入れる
        let stocks = realm.objects(Nine_x_Nine_Stock.self).filter("y4_x4 == %@",m_theme).last
            for one in textField_s{
                if stocks == nil{
                    switch one.tag {
                    case 44:
                        one.stringValue = m_theme
                        break
                    default:
                        break
                    }
                }else{
                    switch one.tag {
                    case 0:
                        one.stringValue = stocks!.y0_x0
                        break
                    case 1:
                        one.stringValue = stocks!.y0_x1
                        break
                    case 2:
                        one.stringValue = stocks!.y0_x2
                        break
                    case 3:
                        one.stringValue = stocks!.y0_x3
                        break
                    case 4:
                        one.stringValue = stocks!.y0_x4
                        break
                    case 5:
                        one.stringValue = stocks!.y0_x5
                        break
                    case 6:
                        one.stringValue = stocks!.y0_x6
                        break
                    case 7:
                        one.stringValue = stocks!.y0_x7
                        break
                    case 8:
                        one.stringValue = stocks!.y0_x8
                        break
                    case 10:
                        one.stringValue = stocks!.y1_x0
                        break
                    case 11:
                        one.stringValue = stocks!.y1_x1
                        break
                    case 12:
                        one.stringValue = stocks!.y1_x2
                        break
                    case 13:
                        one.stringValue = stocks!.y1_x3
                        break
                    case 14:
                        one.stringValue = stocks!.y1_x4
                        break
                    case 15:
                        one.stringValue = stocks!.y1_x5
                        break
                    case 16:
                        one.stringValue = stocks!.y1_x6
                        break
                    case 17:
                        one.stringValue = stocks!.y1_x7
                        break
                    case 18:
                        one.stringValue = stocks!.y1_x8
                        break
                    case 20:
                        one.stringValue = stocks!.y2_x0
                        break
                    case 21:
                        one.stringValue = stocks!.y2_x1
                        break
                    case 22:
                        one.stringValue = stocks!.y2_x2
                        break
                    case 23:
                        one.stringValue = stocks!.y2_x3
                        break
                    case 24:
                        one.stringValue = stocks!.y2_x4
                        break
                    case 25:
                        one.stringValue = stocks!.y2_x5
                        break
                    case 26:
                        one.stringValue = stocks!.y2_x6
                        break
                    case 27:
                        one.stringValue = stocks!.y2_x7
                        break
                    case 28:
                        one.stringValue = stocks!.y2_x8
                        break
                    case 30:
                        one.stringValue = stocks!.y3_x0
                        break
                    case 31:
                        one.stringValue = stocks!.y3_x1
                        break
                    case 32:
                        one.stringValue = stocks!.y3_x2
                        break
                    case 33:
                        one.stringValue = stocks!.y3_x3
                        break
                    case 34:
                        one.stringValue = stocks!.y3_x4
                        break
                    case 35:
                        one.stringValue = stocks!.y3_x5
                        break
                    case 36:
                        one.stringValue = stocks!.y3_x6
                        break
                    case 37:
                        one.stringValue = stocks!.y3_x7
                        break
                    case 38:
                        one.stringValue = stocks!.y3_x8
                        break
                    case 40:
                        one.stringValue = stocks!.y4_x0
                        break
                    case 41:
                        one.stringValue = stocks!.y4_x1
                        break
                    case 42:
                        one.stringValue = stocks!.y4_x2
                        break
                    case 43:
                        one.stringValue = stocks!.y4_x3
                        break
                    case 44:
                        one.stringValue = stocks!.y4_x4
                        break
                    case 45:
                        one.stringValue = stocks!.y4_x5
                        break
                    case 46:
                        one.stringValue = stocks!.y4_x6
                        break
                    case 47:
                        one.stringValue = stocks!.y4_x7
                        break
                    case 48:
                        one.stringValue = stocks!.y4_x8
                        break
                    case 50:
                        one.stringValue = stocks!.y5_x0
                        break
                    case 51:
                        one.stringValue = stocks!.y5_x1
                        break
                    case 52:
                        one.stringValue = stocks!.y5_x2
                        break
                    case 53:
                        one.stringValue = stocks!.y5_x3
                        break
                    case 54:
                        one.stringValue = stocks!.y5_x4
                        break
                    case 55:
                        one.stringValue = stocks!.y5_x5
                        break
                    case 56:
                        one.stringValue = stocks!.y5_x6
                        break
                    case 57:
                        one.stringValue = stocks!.y5_x7
                        break
                    case 58:
                        one.stringValue = stocks!.y5_x8
                        break
                    case 60:
                        one.stringValue = stocks!.y6_x0
                        break
                    case 61:
                        one.stringValue = stocks!.y6_x1
                        break
                    case 62:
                        one.stringValue = stocks!.y6_x2
                        break
                    case 63:
                        one.stringValue = stocks!.y6_x3
                        break
                    case 64:
                        one.stringValue = stocks!.y6_x4
                        break
                    case 65:
                        one.stringValue = stocks!.y6_x5
                        break
                    case 66:
                        one.stringValue = stocks!.y6_x6
                        break
                    case 67:
                        one.stringValue = stocks!.y6_x7
                        break
                    case 68:
                        one.stringValue = stocks!.y6_x8
                        break
                    case 70:
                        one.stringValue = stocks!.y7_x0
                        break
                    case 71:
                        one.stringValue = stocks!.y7_x1
                        break
                    case 72:
                        one.stringValue = stocks!.y7_x2
                        break
                    case 73:
                        one.stringValue = stocks!.y7_x3
                        break
                    case 74:
                        one.stringValue = stocks!.y7_x4
                        break
                    case 75:
                        one.stringValue = stocks!.y7_x5
                        break
                    case 76:
                        one.stringValue = stocks!.y7_x6
                        break
                    case 77:
                        one.stringValue = stocks!.y7_x7
                        break
                    case 78:
                        one.stringValue = stocks!.y7_x8
                        break
                    case 80:
                        one.stringValue = stocks!.y8_x0
                        break
                    case 81:
                        one.stringValue = stocks!.y8_x1
                        break
                    case 82:
                        one.stringValue = stocks!.y8_x2
                        break
                    case 83:
                        one.stringValue = stocks!.y8_x3
                        break
                    case 84:
                        one.stringValue = stocks!.y8_x4
                        break
                    case 85:
                        one.stringValue = stocks!.y8_x5
                        break
                    case 86:
                        one.stringValue = stocks!.y8_x6
                        break
                    case 87:
                        one.stringValue = stocks!.y8_x7
                        break
                    case 88:
                        one.stringValue = stocks!.y8_x8
                        break
                    default:
                        break
                    }
                }
            }
        var store_btn = NSButton()
        store_btn = NSButton(title:"保存", target: self, action: #selector(store_btn_click))
        store_btn.frame = CGRect(x: 1050, y: 20 , width: 100, height: 50)
        store_btn.font = NSFont.systemFont(ofSize: 22)
        self.view.addSubview(store_btn)
        
        var expansion_btn = NSButton()
        expansion_btn = NSButton(title:"軸を展開", target: self, action: #selector(expansion_btn_click))
        expansion_btn.frame = CGRect(x: 800, y: 20 , width: 200, height: 50)
        expansion_btn.font = NSFont.systemFont(ofSize: 22)
        self.view.addSubview(expansion_btn)
    }
    @objc func store_btn_click(_ sender: NSButton) {
//        var stock_s:[Nine_x_Nine_Stock] = []
        var stock = Nine_x_Nine_Stock()
        var deletting_theme = ""
        for one in textField_s{            
            switch one.tag {
            case 0:
                stock.y0_x0 = one.stringValue
                break
            case 1:
                stock.y0_x1 = one.stringValue
                break
            case 2:
                stock.y0_x2 = one.stringValue
                break
            case 3:
                stock.y0_x3 = one.stringValue
                break
            case 4:
                stock.y0_x4 = one.stringValue
                break
            case 5:
                stock.y0_x5 = one.stringValue
                break
            case 6:
                stock.y0_x6 = one.stringValue
                break
            case 7:
                stock.y0_x7 = one.stringValue
                break
            case 8:
                stock.y0_x8 = one.stringValue
                break
            case 10:
                stock.y1_x0 = one.stringValue
                break
            case 11:
                stock.y1_x1 = one.stringValue
                break
            case 12:
                stock.y1_x2 = one.stringValue
                break
            case 13:
                stock.y1_x3 = one.stringValue
                break
            case 14:
                stock.y1_x4 = one.stringValue
                break
            case 15:
                stock.y1_x5 = one.stringValue
                break
            case 16:
                stock.y1_x6 = one.stringValue
                break
            case 17:
                stock.y1_x7 = one.stringValue
                break
            case 18:
                stock.y1_x8 = one.stringValue
                break
            case 20:
                stock.y2_x0 = one.stringValue
                break
            case 21:
                stock.y2_x1 = one.stringValue
                break
            case 22:
                stock.y2_x2 = one.stringValue
                break
            case 23:
                stock.y2_x3 = one.stringValue
                break
            case 24:
                stock.y2_x4 = one.stringValue
                break
            case 25:
                stock.y2_x5 = one.stringValue
                break
            case 26:
                stock.y2_x6 = one.stringValue
                break
            case 27:
                stock.y2_x7 = one.stringValue
                break
            case 28:
                stock.y2_x8 = one.stringValue
                break
            case 30:
                stock.y3_x0 = one.stringValue
                break
            case 31:
                stock.y3_x1 = one.stringValue
                break
            case 32:
                stock.y3_x2 = one.stringValue
                break
            case 33:
                stock.y3_x3 = one.stringValue
                break
            case 34:
                stock.y3_x4 = one.stringValue
                break
            case 35:
                stock.y3_x5 = one.stringValue
                break
            case 36:
                stock.y3_x6 = one.stringValue
                break
            case 37:
                stock.y3_x7 = one.stringValue
                break
            case 38:
                stock.y3_x8 = one.stringValue
                break
            case 40:
                stock.y4_x0 = one.stringValue
                break
            case 41:
                stock.y4_x1 = one.stringValue
                break
            case 42:
                stock.y4_x2 = one.stringValue
                break
            case 43:
                stock.y4_x3 = one.stringValue
                break
            case 44:
                deletting_theme = one.stringValue
                stock.y4_x4 = one.stringValue
                break
            case 45:
                stock.y4_x5 = one.stringValue
                break
            case 46:
                stock.y4_x6 = one.stringValue
                break
            case 47:
                stock.y4_x7 = one.stringValue
                break
            case 48:
                stock.y4_x8 = one.stringValue
                break
            case 50:
                stock.y5_x0 = one.stringValue
                break
            case 51:
                stock.y5_x1 = one.stringValue
                break
            case 52:
                stock.y5_x2 = one.stringValue
                break
            case 53:
                stock.y5_x3 = one.stringValue
                break
            case 54:
                stock.y5_x4 = one.stringValue
                break
            case 55:
                stock.y5_x5 = one.stringValue
                break
            case 56:
                stock.y5_x6 = one.stringValue
                break
            case 57:
                stock.y5_x7 = one.stringValue
                break
            case 58:
                stock.y5_x8 = one.stringValue
                break
            case 60:
                stock.y6_x0 = one.stringValue
                break
            case 61:
                stock.y6_x1 = one.stringValue
                break
            case 62:
                stock.y6_x2 = one.stringValue
                break
            case 63:
                stock.y6_x3 = one.stringValue
                break
            case 64:
                stock.y6_x4 = one.stringValue
                break
            case 65:
                stock.y6_x5 = one.stringValue
                break
            case 66:
                stock.y6_x6 = one.stringValue
                break
            case 67:
                stock.y6_x7 = one.stringValue
                break
            case 68:
                stock.y6_x8 = one.stringValue
                break
            case 70:
                stock.y7_x0 = one.stringValue
                break
            case 71:
                stock.y7_x1 = one.stringValue
                break
            case 72:
                stock.y7_x2 = one.stringValue
                break
            case 73:
                stock.y7_x3 = one.stringValue
                break
            case 74:
                stock.y7_x4 = one.stringValue
                break
            case 75:
                stock.y7_x5 = one.stringValue
                break
            case 76:
                stock.y7_x6 = one.stringValue
                break
            case 77:
                stock.y7_x7 = one.stringValue
                break
            case 78:
                stock.y7_x8 = one.stringValue
                break
            case 80:
                stock.y8_x0 = one.stringValue
                break
            case 81:
                stock.y8_x1 = one.stringValue
                break
            case 82:
                stock.y8_x2 = one.stringValue
                break
            case 83:
                stock.y8_x3 = one.stringValue
                break
            case 84:
                stock.y8_x4 = one.stringValue
                break
            case 85:
                stock.y8_x5 = one.stringValue
                break
            case 86:
                stock.y8_x6 = one.stringValue
                break
            case 87:
                stock.y8_x7 = one.stringValue
                break
            case 88:
                stock.y8_x8 = one.stringValue
                break
            default:
                break
            }            
        }

        try! realm.write() {
            realm.add(stock)
        }
        self.dismiss(nil)
        if m_from_page == "Flows_Progress"{
            UserDefaults.standard.set("", forKey: "from_page")
            UserDefaults.standard.synchronize()
            let next = storyboard?.instantiateController(withIdentifier: "Flows_Progress")
            self.presentAsModalWindow(next! as! NSViewController)
        }else{
            let next = storyboard?.instantiateController(withIdentifier: "zero")
            self.presentAsModalWindow(next! as! NSViewController)
        }
    }
    @objc func expansion_btn_click(_ sender: NSButton) {
        var xm1_ym1 = ""
        var xm1_y = ""
        var xm1_yp1 = ""
        var x_ym1 = ""
        var x_yp1 = ""
        var xp1_ym1 = ""
        var xp1_y = ""
        var xp1_yp1 = ""
        
        for temp in textField_s{
            if temp.tag == 33 {
                xm1_ym1 = temp.stringValue
            }
            if temp.tag == 43 {
                x_ym1 = temp.stringValue
            }
            if temp.tag == 53 {
                xp1_ym1 = temp.stringValue
            }
            if temp.tag == 34 {
                xm1_y = temp.stringValue
            }
            if temp.tag == 54 {
                xp1_y = temp.stringValue
            }
            if temp.tag == 35 {
                xm1_yp1 = temp.stringValue
            }
            if temp.tag == 45 {
                x_yp1 = temp.stringValue
            }
            if temp.tag == 55 {
                xp1_yp1 = temp.stringValue
            }
        }
        for temp in textField_s{
            if temp.tag == 11 {
                temp.stringValue = xm1_ym1
            }
            if temp.tag == 41 {
                temp.stringValue = x_ym1
            }
            if temp.tag == 71 {
                temp.stringValue = xp1_ym1
            }
            if temp.tag == 14 {
                temp.stringValue = xm1_y
            }
            if temp.tag == 74 {
                temp.stringValue = xp1_y
            }
            if temp.tag == 17 {
                temp.stringValue = xm1_yp1
            }
            if temp.tag == 47 {
                temp.stringValue = x_yp1
            }
            if temp.tag == 77 {
                temp.stringValue = xp1_yp1
            }
        }
    }
    
}
class MyView: NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        addLine()
    }
    
    func addLine() {
        let path_1 = NSBezierPath()
        path_1.move(to: NSPoint(x: 10.0, y: 275.0))
        path_1.line(to: NSPoint(x: 1190.0, y: 275.0))
        path_1.close()
        path_1.stroke()
        let path_2 = NSBezierPath()
        path_2.move(to: NSPoint(x: 10.0, y: 455.0))
        path_2.line(to: NSPoint(x: 1190.0, y: 455.0))
        path_2.close()
        path_2.stroke()
        let path_3 = NSBezierPath()
        path_3.move(to: NSPoint(x: 405.0, y: 100.0))
        path_3.line(to: NSPoint(x: 405.0, y: 640.0))
        path_3.close()
        path_3.stroke()
        let path_4 = NSBezierPath()
        path_4.move(to: NSPoint(x: 795.0, y: 100.0))
        path_4.line(to: NSPoint(x: 795.0, y: 640.0))
        path_4.close()
        path_4.stroke()
    }
}
