//
//  MoyaTableViewController.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/25.
//  Copyright © 2016年 Hunter. All rights reserved.
//

import RxCocoa
import RxSwift
import RxDataSources

typealias MoyaSectionModel = AnimatableSectionModel<String,UserModel>

class MoyaTableViewController: UITableViewController {

    let disposeBag = DisposeBag()
    
    let sections = Variable([MoyaSectionModel]())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = nil
        tableView.delegate = nil
        
        let tvDataSources = RxTableViewSectionedReloadDataSource<MoyaSectionModel>()
        
        tvDataSources.configureCell = { (_, tv, indexPath, model) in
            let cell = tv.dequeueReusableCellWithIdentifier("UserCell") as! UserTableViewCell
            cell.nameLabel.text = model.name
            cell.ageLabel.text = model.age
            return cell
        }
        
        sections.asObservable()
            .bindTo(tableView.rx_itemsWithDataSource(tvDataSources))
            .addDisposableTo(disposeBag)
        
        
        UserProvider
            .request(.Users)
            .mapObject(UserListModel)
            .subscribeNext { [unowned self] userlist in
                self.sections.value.append(MoyaSectionModel(model: "Users", items: userlist.users))
            }
            .addDisposableTo(disposeBag)
    }
}
