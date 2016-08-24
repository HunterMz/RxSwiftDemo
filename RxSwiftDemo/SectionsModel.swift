//
//  SectionsModel.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/24.
//  Copyright © 2016年 Hunter. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionsModel {
    let name: String
    let age: Int
}

extension SectionsModel: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}

func == (lhs: SectionsModel, rhs: SectionsModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

extension SectionsModel: IdentifiableType {
    var identity: Int {
        return hashValue
    }
}

extension SectionsModel: CustomStringConvertible {
    var description: String {
        return "\(name) 's age is \(age)"
    }
}