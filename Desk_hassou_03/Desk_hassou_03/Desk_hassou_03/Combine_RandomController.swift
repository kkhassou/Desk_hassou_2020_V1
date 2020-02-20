//
//  Combine_RandomController.swift
//  Desk_hassou_03
//
//  Created by kakegawa kouichi on 2020/02/21.
//  Copyright © 2020 kakegawa kouichi. All rights reserved.
//

import Cocoa

class Combine_RandomController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.frame = CGRect(x: 50, y: 50 , width: 1200, height: 650)
        
        var theme_title = NSTextField()
        theme_title.frame = CGRect(x:50, y:550 , width:100, height:50);
        theme_title.stringValue = "テーマ"
        theme_title.font = NSFont.systemFont(ofSize: CGFloat(30))
        theme_title.isEditable = false
        theme_title.isSelectable = false
        theme_title.backgroundColor = NSColor.white
        self.view.addSubview(theme_title)
        
        var category_1 = NSTextField()
        category_1.frame = CGRect(x:50, y:450 , width:100, height:50);
        category_1.stringValue = "カテゴリ_1"
        category_1.font = NSFont.systemFont(ofSize: CGFloat(15))
        category_1.isEditable = false
        category_1.isSelectable = false
        category_1.backgroundColor = NSColor.white
        self.view.addSubview(category_1)
        
        var category_2 = NSTextField()
        category_2.frame = CGRect(x:50, y:350 , width:100, height:50);
        category_2.stringValue = "カテゴリ_2"
        category_2.font = NSFont.systemFont(ofSize: CGFloat(15))
        category_2.isEditable = false
        category_2.isSelectable = false
        category_2.backgroundColor = NSColor.white
        self.view.addSubview(category_2)
        
        var category_3 = NSTextField()
        category_3.frame = CGRect(x:50, y:250 , width:100, height:50);
        category_3.stringValue = "カテゴリ_3"
        category_3.font = NSFont.systemFont(ofSize: CGFloat(15))
        category_3.isEditable = false
        category_3.isSelectable = false
        category_3.backgroundColor = NSColor.white
        self.view.addSubview(category_3)
        
        var think_idea = NSTextField()
        think_idea.frame = CGRect(x:50, y:150 , width:100, height:50);
        think_idea.stringValue = "思い付いた事"
        think_idea.font = NSFont.systemFont(ofSize: CGFloat(15))
        think_idea.isEditable = false
        think_idea.isSelectable = false
        think_idea.backgroundColor = NSColor.white
        self.view.addSubview(think_idea)
        
        var theme_title_content = NSTextField()
        theme_title_content.frame = CGRect(x:200, y:550 , width:300, height:50);
        theme_title_content.stringValue = "テーマ"
        theme_title_content.font = NSFont.systemFont(ofSize: CGFloat(30))
        theme_title_content.isEditable = false
        theme_title_content.isSelectable = false
        theme_title_content.backgroundColor = NSColor.white
        self.view.addSubview(theme_title_content)
        
        var category_1_content = NSTextField()
        category_1_content.frame = CGRect(x:200, y:450 , width:300, height:50);
        category_1_content.stringValue = "カテゴリ_1_content"
        category_1_content.font = NSFont.systemFont(ofSize: CGFloat(15))
        category_1_content.isEditable = false
        category_1_content.isSelectable = false
        category_1_content.backgroundColor = NSColor.white
        self.view.addSubview(category_1_content)
        
        var category_2_content = NSTextField()
        category_2_content.frame = CGRect(x:200, y:350 , width:300, height:50);
        category_2_content.stringValue = "カテゴリ_2_content"
        category_2_content.font = NSFont.systemFont(ofSize: CGFloat(15))
        category_2_content.isEditable = false
        category_2_content.isSelectable = false
        category_2_content.backgroundColor = NSColor.white
        self.view.addSubview(category_2_content)
        
        var category_3_content = NSTextField()
        category_3_content.frame = CGRect(x:200, y:250 , width:300, height:50);
        category_3_content.stringValue = "カテゴリ_3_content"
        category_3_content.font = NSFont.systemFont(ofSize: CGFloat(15))
        category_3_content.isEditable = false
        category_3_content.isSelectable = false
        category_3_content.backgroundColor = NSColor.white
        self.view.addSubview(category_3_content)
        
        var think_idea_content = NSTextField()
        think_idea_content.frame = CGRect(x:200, y:100 , width:300, height:100);
        think_idea_content.stringValue = "思い付いた事"
        think_idea_content.font = NSFont.systemFont(ofSize: CGFloat(15))
        think_idea_content.isEditable = true
        think_idea_content.isSelectable = true
        think_idea_content.backgroundColor = NSColor.white
        self.view.addSubview(think_idea_content)
        
        var theme_title_btn = NSButton()
        theme_title_btn.frame = CGRect(x:600, y:550 , width:100, height:50);
        theme_title_btn.stringValue = "テーマ"
        theme_title_btn.font = NSFont.systemFont(ofSize: CGFloat(30))
        self.view.addSubview(theme_title_btn)
        
        var category_1_btn = NSButton()
        category_1_btn.frame = CGRect(x:600, y:450 , width:100, height:50);
        category_1_btn.stringValue = "カテゴリ_1_btn"
        category_1_btn.font = NSFont.systemFont(ofSize: CGFloat(15))
        self.view.addSubview(category_1_btn)
        
        var category_2_btn = NSButton()
        category_2_btn.frame = CGRect(x:600, y:350 , width:100, height:50);
        category_2_btn.stringValue = "カテゴリ_2_btn"
        category_2_btn.font = NSFont.systemFont(ofSize: CGFloat(15))
        self.view.addSubview(category_2_btn)
        
        var category_3_btn = NSButton()
        category_3_btn.frame = CGRect(x:600, y:250 , width:100, height:50);
        category_3_btn.stringValue = "カテゴリ_3_btn"
        category_3_btn.font = NSFont.systemFont(ofSize: CGFloat(15))
        self.view.addSubview(category_3_btn)
        
        var think_idea_btn = NSButton()
        think_idea_btn.frame = CGRect(x:600, y:150 , width:100, height:50);
        think_idea_btn.stringValue = "思い付いた事"
        think_idea_btn.font = NSFont.systemFont(ofSize: CGFloat(15))
        self.view.addSubview(think_idea_btn)
    }
    
}
