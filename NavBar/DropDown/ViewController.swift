//
//  ViewController.swift
//  DropDown
//
//  Created by Aqib Ali on 30/11/19.
//  Copyright © 2019 Aqib Ali. All rights reserved.
//

import UIKit


extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "Row: \(indexPath.row)"
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = view.safeAreaLayoutGuide.layoutFrame.size.height
        let scrolled = scrollView.panGestureRecognizer.translation(in: scrollView).y
        if !(scrollView.visibleSize.height - height >= 90) {
            if  scrolled < 0 {
                navigationController?.setNavigationBarHidden(true, animated: true)
            } else {
                navigationController?.setNavigationBarHidden(false, animated: true)
            }
        }
    }
    
}

class ViewController: UIViewController {

    
    @IBOutlet weak var single:DropDown!
    @IBOutlet weak var multi:DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Hello"
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        
        
//        single.items = [
//            DropDownItem(name: "Hello"),
//            DropDownItem(name: "Item "),
//            DropDownItem(name: "This")
//        ]
//
//
//        multi.items = [
//            DropDownItem(name: "Hello"),
//            DropDownItem(name: "Item "),
//            DropDownItem(name: "This"),
//            DropDownItem(name: "Is"),
//            DropDownItem(name: "Veg"),
//            DropDownItem(name: "Cookie"),
//        ]
    }
    
    @IBAction func action(_ sender: UIButton) {
        toast(message: "Hello this is the message for toast Hello this is the message for toast")
    }
    

}


extension UIViewController{
    
    fileprivate static var isToastShowing = false
    
    func toast(message:String?,title:String? = "Librums",completion:(()->())? = nil){
        guard !UIViewController.isToastShowing else { return  }
        
        
        UIViewController.isToastShowing = true
        guard let message = message else {return}
        
        let lb = { (text:String?,font:UIFont?) -> UILabel in
            let lb = UILabel()
            lb.textColor = UIColor.white
            lb.textAlignment = .left
            lb.numberOfLines = 0
            lb.text = text
            lb.font = font
            return lb
        }
        
        let messageLabel = lb(message,UIFont.systemFont(ofSize: 16))
        let titleLabel = lb(title,UIFont.boldSystemFont(ofSize: 16))

        
        let v = UIView()
        v.backgroundColor = .blue
        v.layer.cornerRadius = 8
        v.layer.masksToBounds = false
        v.layer.shadowColor = UIColor.lightGray.cgColor
        v.layer.shadowOffset = .init(width: -1, height: 1)
        v.layer.shadowRadius = 10
        let stack = UIStackView(arrangedSubviews: [titleLabel,messageLabel])
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 4
        
        let width = view.frame.width - 40
        let height = message.height(font: messageLabel.font, width: width) + 30 + 24
        
        let frame = CGRect(x: 20, y: 40, width: width, height: height)
        v.frame = frame
        var superview:UIView
        if let nvc = navigationController{
            superview = nvc.view
        }else{
            superview = view
        }
        superview.addSubview(v)
        stack.frame = .init(x: 10, y: 8, width: width - 20, height: height - 16)
        v.addSubview(stack)
        
        let translationY = -(height + 100)
        v.transform = .init(translationX: 0, y: translationY)
        
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            v.transform = .identity
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 1.5, options: .curveEaseInOut, animations: {
                v.transform = .init(translationX: 0, y: translationY)
            }, completion: { _ in
                UIViewController.isToastShowing = false
                v.removeFromSuperview()
            })
        })
    }
    
    
    
}

extension String{
    func height(font:UIFont?, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height:CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    
    func width(font:UIFont, height:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.width
    }
}




