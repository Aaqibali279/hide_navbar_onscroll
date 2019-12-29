//
//  DropDownCell.swift
//  DropDown
//
//  Created by Aqib Ali on 30/11/19.
//  Copyright © 2019 Aqib Ali. All rights reserved.
//

import UIKit
class DropDownCell:UITableViewCell{
    
    
    private var label = { () -> UILabel in
        let lb = UILabel(frame: .zero)
        lb.text = "Text"
        lb.textColor = .darkGray
        return lb
    }()
    
    
    private var iv = { () -> UIImageView in
        let iv = UIImageView(frame: .zero)
        iv.image = #imageLiteral(resourceName: "circle")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    var item:DropDownItem!{
        didSet{
            label.text = item.name
            iv.image = item.isSelected ? #imageLiteral(resourceName: "checked") : #imageLiteral(resourceName: "circle")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        addSubview(label)
        addSubview(iv)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iv.frame = .init(x: frame.width - 34, y: frame.height/2 - 8, width: 20, height: 20)
        label.frame = .init(x: 16, y: 0, width: bounds.width - 32, height: frame.height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
