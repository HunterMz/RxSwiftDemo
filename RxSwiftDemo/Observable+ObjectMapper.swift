//
//  Observable+ObjectMapper.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/25.
//  Copyright © 2016年 Hunter. All rights reserved.
//

import RxSwift
import Moya
import ObjectMapper

public extension ObservableType where E == Response {
    
    public func mapObject<T: Mappable>(type: T.Type) ->Observable<T> {
        return observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMap({ (response) -> Observable<T> in
                return Observable.just(try response.mapObject())
            })
            .observeOn(MainScheduler.instance)
    }
    
    public func mapArray<T: Mappable>(type: T.Type) ->Observable<[T]> {
        return observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMap({ (response) -> Observable<[T]> in
                return Observable.just(try response.mapArray())
            })
            .observeOn(MainScheduler.instance)
    }
}
