//
//  RXTableViewCell.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/10.
//  Copyright © 2016年 Hunter. All rights reserved.
//

import UIKit

class RxTableViewCell: UITableViewCell {
    
    var user: User?{
        willSet{
            
            let string = "\(newValue!.name)今年\(newValue!.age)岁，身高\(newValue!.height)"

            backgroundColor = tag % 2 == 0 ? UIColor.lightGrayColor() : UIColor.whiteColor()
            textLabel?.text = string
            textLabel?.numberOfLines = 0
        }
    }
}
