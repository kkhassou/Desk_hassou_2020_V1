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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.frame = CGRect(x:10, y:10 , width:1200, height:650);
        var m_theme = UserDefaults.standard.object(forKey: "theme") as! String
        // ここに表示の処理を入れる
        let stocks = realm.objects(Idea_Stock.self).filter("theme == %@",m_theme)
        print(stocks)
    }
    
}
