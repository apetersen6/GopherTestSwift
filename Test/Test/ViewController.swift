//
//  ViewController.swift
//  Gopher Image Profile Test
//
//  Created by Andreas
//  Copyright © 2019 Archetapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var profileBtn = dropDownBtn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Configure the button
        profileBtn = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        profileBtn.setImage(UIImage(named: "dog1"), for: .normal)
        profileBtn.translatesAutoresizingMaskIntoConstraints = false
        profileBtn.layer.cornerRadius = 64
        profileBtn.layer.borderColor = UIColor.white.cgColor
        profileBtn.layer.borderWidth = 4
        profileBtn.clipsToBounds = true
        
        
        //Add Button to the View Controller
        self.view.addSubview(profileBtn)
        
        //button Constraints
        profileBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -236).isActive = true
        profileBtn.widthAnchor.constraint(equalToConstant: 128).isActive = true
        profileBtn.heightAnchor.constraint(equalToConstant: 128).isActive = true

        //Set the drop down images for the Profile button
        profileBtn.dropView.dropDownOptions = [UIImage(named: "dog1"),
                                               UIImage(named: "dog2"),
                                               UIImage(named: "dog1"),
                                               UIImage(named: "dog2"),
                                               UIImage(named: "dog1"),
                                               UIImage(named: "dog2"),
                                               UIImage(named: "dog1"),
                                               UIImage(named: "dog2"),
                                               UIImage(named: "dog1"),
                                               UIImage(named: "dog2")] as! [UIImage]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

protocol dropDownProtocol {
    func dropDownPressed(profImg : UIImage)
}

class dropDownBtn: UIButton, dropDownProtocol {
    
    func dropDownPressed(profImg: UIImage) {
        self.setImage(profImg, for: .normal)
        self.dismissDropDown()
    }
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dropView.widthAnchor.constraint(equalToConstant: 158).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 350 {
                self.height.constant = 350
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 10, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0, delay: 0.1, usingSpringWithDamping: 10, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0, delay: 0.1, usingSpringWithDamping: 10, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var dropDownOptions = [UIImage]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tableView.rowHeight = 128
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
//        tableView.layer.borderWidth = 4
//        tableView.layer.borderColor = UIColor.white.cgColor
//        tableView.layer.cornerRadius = 15
        tableView.clipsToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.imageView?.image = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(profImg: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



















