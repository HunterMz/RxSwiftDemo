//
//  BasicTableViewCell.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/10.
//  Copyright © 2016年 Hunter. All rights reserved.
//

import UIKit

class BasicTableViewCell: UITableViewCell {
    
    
    let nameLabel: UILabel = UILabel(frame: CGRect(x: 20,y: 5,width: 50,height: 20))
    let ageLabel: UILabel = UILabel(frame: CGRect(x: 200,y: 5,width: 50,height: 20))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(ageLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
