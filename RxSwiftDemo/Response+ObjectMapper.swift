//
//  Response+ObjectMapper.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/25.
//  Copyright © 2016年 Hunter. All rights reserved.
//

import ObjectMapper
import Moya

extension Response {
    
    public func mapObject<T: Mappable>() throws ->T {
        guard let json = try mapJSON() as? [String: AnyObject] else {
            throw Error.JSONMapping(self)
        }
        
        guard let object = Mapper<T>().map(json["data"]) else {
            throw Error.Data(self)
        }
        
        return object
    }
    
    public func mapArray<T: Mappable>() throws ->[T] {
        guard let json = try mapJSON() as? [String: AnyObject] else {
            throw Error.JSONMapping(self)
        }
        
        guard let object = Mapper<T>().mapArray(json["data"]) else {
            throw Error.Data(self)
        }
        
        return object
    }
}
