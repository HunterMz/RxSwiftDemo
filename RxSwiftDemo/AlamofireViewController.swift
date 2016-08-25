//
//  AlamofireViewController.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/23.
//  Copyright © 2016年 Hunter. All rights reserved.
//

import UIKit
import Alamofire
import RxAlamofire
import RxDataSources
import RxSwift

typealias AlamofireSectionModel = AnimatableSectionModel<String, UserModel>

class AlamofireViewController: UITableViewController {

    let disposeBag = DisposeBag()
    let sections = Variable([AlamofireSectionModel]())
    let manager = Manager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        let tvDataSource = RxTableViewSectionedReloadDataSource<AlamofireSectionModel>()
        
        tvDataSource.configureCell = { (_, tv, indexPath, model) in
            let cell = tv.dequeueReusableCellWithIdentifier("UserCell") as! UserTableViewCell
            cell.nameLabel.text = model.name
            cell.ageLabel.text = model.age
            return cell
        }
        
        sections.asObservable()
            .bindTo(tableView.rx_itemsWithDataSource(tvDataSource))
            .addDisposableTo(disposeBag)
        
        manager.rx_responseJSON(.GET, "https://rxswift.leanapp.cn/users")
            .mapObject(UserListModel)
            .subscribeNext { [unowned self] in
                self.sections.value.append(AlamofireSectionModel(model: "Users", items: $0.users))
            }
            .addDisposableTo(disposeBag)
    }
}
