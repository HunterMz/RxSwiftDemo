//
//  RXViewModel.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/10.
//  Copyright © 2016年 Hunter. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources


struct User {
    let name: String
    let age: Int
    let height: Double
}

class RxViewModel: NSObject {
    
    func getUsers() -> Observable<[SectionModel<String, User>]> {
        return Observable.create { (observer) -> Disposable in

            let users = [User(name: "张三", age: 12, height: 1.78),
                         User(name: "李四", age: 13, height: 1.98),
                         User(name: "王麻子", age: 33, height: 1.58)]
            
            let section = [SectionModel(model: "", items: users)]
            observer.onNext(section)
            observer.onCompleted()
            return AnonymousDisposable{}
        }
    }
    
}