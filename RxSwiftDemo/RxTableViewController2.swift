//
//  RxTableViewController2.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/10.
//  Copyright © 2016年 Hunter. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class RxTableViewController2: UITableViewController {

    let dataSource = Variable([BasicModel]())
    
    let disposeBag = DisposeBag()
    
    static let initialValue = [
        BasicModel(name: "Jack", age: 18),
        BasicModel(name: "Tim", age: 20),
        BasicModel(name: "Andy", age: 24)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
//        tableView.registerClass(BasicTableViewCell.self, forCellReuseIdentifier: "BasicCell")
        
        dataSource.asObservable()
            .bindTo(tableView.rx_itemsWithCellIdentifier("BasicCell", cellType: BasicTableViewCell.self)) { (_, element, cell) in
                cell.nameLabel.text = element.name
                cell.ageLabel.text = String(element.age)
            }.addDisposableTo(disposeBag)
        
        dataSource.value.appendContentsOf(RxTableViewController2.initialValue)
        
        tableView.rx_modelSelected(BasicModel)
            .subscribeNext { (model) in
                
                Alert.showInfo(model.name, message: "\(model.age)")
        
            }.addDisposableTo(disposeBag)
    
        tableView
            .rx_contentOffset
            .map { (contenOffset) -> String in
                return "contentOffset.y = \(contenOffset.y)"
            }
            .bindTo(self.rx_title)
            .addDisposableTo(disposeBag)
    }
}
struct Alert {
    
    static func showInfo(title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        UIApplication.topViewController()?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    static func rx_showInfo(title: String, message: String? = nil) -> Observable<UIAlertActionStyle> {
        return Observable.create { observer in
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .Default) { action in
                observer.on(.Next(action.style))
                })
            
            UIApplication.topViewController()?.presentViewController(alertController, animated: true, completion: nil)
            
            return NopDisposable.instance
            
        }
    }
}

extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    public var rx_networkActivityIndicatorVisible: AnyObserver<Bool> {
        return AnyObserver { event in
            MainScheduler.ensureExecutingOnScheduler()
            switch event {
            case .Next(let value):
                self.networkActivityIndicatorVisible = value
            case .Error:
                self.networkActivityIndicatorVisible = false
                break
            case .Completed:
                break
            }
        }
    }
}
