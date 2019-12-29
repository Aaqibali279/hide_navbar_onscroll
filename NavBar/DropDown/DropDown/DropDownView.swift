//
//  DropDownView.swift
//  DropDown
//
//  Created by Aqib Ali on 30/11/19.
//  Copyright © 2019 Aqib Ali. All rights reserved.
//

import UIKit

protocol DropDownViewDelegate:class {
    func selectedItem(item:DropDownItem)
    func selectedItems(items:Array<DropDownItem>)
    func close()
}


class DropDownItem{
    var name:String
    var isSelected:Bool
    
    init(name:String,isSelected:Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
}


class DropDownView: UIView,UIGestureRecognizerDelegate {
    
    
    var items = [DropDownItem](){
        didSet{
            tableView.reloadData()
        }
    }
    
    private let tableView = { () -> UITableView in
        let tbv = UITableView(frame: .zero, style: .plain)
        tbv.backgroundColor = .white
        tbv.layer.cornerRadius = 4
        tbv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tbv.register(DropDownCell.self, forCellReuseIdentifier: "DropDownCell")
        tbv.clipsToBounds = true
        tbv.translatesAutoresizingMaskIntoConstraints = false
        return tbv
    }()
    
    private var btn = { () -> UIButton in
        let btn = UIButton(frame: .zero)
        btn.setTitle("Close", for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        btn.isHidden = true
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return btn
    }()
    
    
    private let stack = { () -> UIStackView in
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    weak var delegate:DropDownViewDelegate?
    
    private var heightConstraint:NSLayoutConstraint?
    private var leadingConstraint:NSLayoutConstraint?
    private var widthConstraint:NSLayoutConstraint?
    private var topConstraint:NSLayoutConstraint?
    private var bottomConstraint:NSLayoutConstraint?
    
    var isBelow:Bool = true
    var isMultiSelect = false
    
    private let itemHeight:CGFloat = 44
    
    var actionFrame:CGRect = .zero{
        didSet{
            
            leadingConstraint?.constant = actionFrame.origin.x
            widthConstraint?.constant = actionFrame.width
            topConstraint?.isActive = false
            bottomConstraint?.isActive = false
            if isBelow{
                topConstraint?.constant = actionFrame.origin.y + actionFrame.height
                topConstraint?.isActive = true
            }else{
                bottomConstraint?.constant = actionFrame.origin.y
                bottomConstraint?.isActive = true
            }
            //tableView.frame = .init(origin: .init(x: actionFrame.origin.x, y: actionFrame.origin.y + actionFrame.height), size: .init(width: actionFrame.width, height: 200))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        addSubview(stack)
        
        leadingConstraint = stack.leadingAnchor.constraint(equalTo: leadingAnchor)
        leadingConstraint?.isActive = true
        topConstraint = stack.topAnchor.constraint(equalTo: topAnchor)
        bottomConstraint = stack.bottomAnchor.constraint(equalTo: topAnchor)
        heightConstraint = stack.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
        widthConstraint = stack.widthAnchor.constraint(equalToConstant: 0)
        widthConstraint?.isActive = true
        
        stack.addArrangedSubview(tableView)
        stack.addArrangedSubview(btn)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureAction))
        gesture.delegate = self
        addGestureRecognizer(gesture)
        
    }
    
    @objc func closeAction(){
        delegate?.close()
    }
    
    
    func showDropDown(frame:CGRect){
        isHidden = false
        let height = items.count > 5 ? 5 * itemHeight : CGFloat(items.count) * itemHeight
        heightConstraint?.constant =  height
        btn.isHidden = !isMultiSelect
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.layoutIfNeeded()
        })
    }
    
    func hideDropDown(){
        btn.isHidden = true
        heightConstraint?.constant = 0
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.layoutIfNeeded()
            },completion: { [weak self] finished in
                self?.isHidden = true
        })
    }
    
    
    @objc func gestureAction(gesture:UITapGestureRecognizer){
        delegate?.close()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if stack.frame.contains(touch.location(in: self)) {
            return false
        }
        return true
    }
    
}

extension DropDownView:UITableViewDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as! DropDownCell
        cell.item = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if isMultiSelect{
            item.isSelected = !item.isSelected
            delegate?.selectedItems(items: items.filter{$0.isSelected})
        }else{
            items.forEach { (item) in
                item.isSelected = false
            }
            item.isSelected = true
            delegate?.selectedItem(item: item)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight
    }
    
    
}
