//
//  DropDown.swift
//  DropDown
//
//  Created by Aqib Ali on 30/11/19.
//  Copyright © 2019 Aqib Ali. All rights reserved.
//

import UIKit

@IBDesignable
class DropDown:UIView{
    
    
    @IBInspectable var placeholder:String?{
        didSet{
            label.text = placeholder
        }
    }
    
    @IBInspectable var showDropDownBelow:Bool = true
    @IBInspectable var isMultiSelect:Bool = false
    
    private let btn = { () -> UIButton in
        let btn = UIButton(frame: .zero)
        btn.addTarget(self, action: #selector(dropDownAction), for: .touchUpInside)
        return btn
    }()
    
    private var label = { () -> UILabel in
        let lb = UILabel(frame: .zero)
        lb.text = "Select"
        lb.textColor = .darkGray
        return lb
    }()
    
    private var iv = { () -> UIImageView in
        let iv = UIImageView(frame: .zero)
        iv.image = #imageLiteral(resourceName: "down")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let dropDownView = { () -> DropDownView in
        let v = DropDownView(frame: .zero)
        return v
    }()
    
    private var isDropDownOpen = false
    
    
    //use this incase of single selection
    var selectedItem:DropDownItem?{
        didSet{
            label.text = selectedItem?.name
        }
    }
    
    //use this incase of multiselection
    var selectedItems:Array<DropDownItem>?{
        didSet{
            label.text = (selectedItems?.count ?? 0) > 0 ? selectedItems?.map{$0.name}.joined(separator: ",") : placeholder
        }
    }
    
    var items = [DropDownItem](){
        didSet{
            dropDownView.items = items
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 4
        clipsToBounds = true
        
        label.frame = .init(origin: .init(x: 16, y: 0), size: .init(width: bounds.width - 32, height: bounds.height))
        addSubview(label)
        iv.frame = .init(x: bounds.width - 32, y: bounds.height/2 - 8, width: 16, height: 16)
        addSubview(iv)
        btn.frame = bounds
        addSubview(btn)
        
        if let v = vc()?.view{
            dropDownView.frame = v.bounds
            v.addSubview(dropDownView)
            dropDownView.isHidden = true
        }
        dropDownView.isMultiSelect = isMultiSelect
        dropDownView.isBelow = showDropDownBelow
        dropDownView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dropDownView.actionFrame = frame
    }
    
    @objc func dropDownAction(btn:UIButton){
        
        if isDropDownOpen{
            dropDownView.hideDropDown()
        }else{
            dropDownView.showDropDown(frame: frame)
        }
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let this = self else{return}
            this.iv.transform = this.isDropDownOpen ? CGAffineTransform(rotationAngle: .pi) : .identity
        })
        isDropDownOpen = !isDropDownOpen
    }
    
    
    
}

extension DropDown:DropDownViewDelegate{
    
    func selectedItems(items: Array<DropDownItem>) {
        selectedItems = items
    }
    
    func selectedItem(item: DropDownItem) {
        selectedItem = item
        dropDownAction(btn: btn)
    }
    
    func close() {
        dropDownAction(btn: btn)
    }
}

extension UIView {
    func vc() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.vc()
        } else {
            return nil
        }
    }
}
