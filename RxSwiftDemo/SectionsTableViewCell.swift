//
//  SectionsTableViewCell.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/24.
//  Copyright © 2016年 Hunter. All rights reserved.
//

import UIKit
import Then

class SectionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    
//    let nameLabel: UILabel = UILabel().then {
//        $0.frame = CGRect(x: 20,y: 5,width: 50,height: 20)
//        $0.textColor = UIColor.greenColor()
//    }
//    
//    let ageLabel: UILabel = UILabel().then {
//        $0.frame = CGRect(x: 200,y: 5,width: 50,height: 20)
//    }
    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        self.contentView.addSubview(nameLabel)
//        self.contentView.addSubview(ageLabel)
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

}
