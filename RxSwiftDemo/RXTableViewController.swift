//
//  RXTableViewController.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/10.
//  Copyright © 2016年 Hunter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class RXTableViewController: UIViewController {

    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, User>>()
    
    let tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: .Plain)
    let reuseIdentifier = "\(RxTableViewCell.self)"
    
    let viewModel = RxViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.registerClass(RxTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        dataSource.configureCell = {
            _, tableView, indexPath, user in
            let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! RxTableViewCell
            cell.tag = indexPath.row
            cell.user = user
            return cell
        }
        
        viewModel.getUsers()
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        tableView
            .rx_contentOffset
            .map {$0.y}
            .subscribeNext { [unowned self] in
                self.title = "contenOffset.y = \($0)"
            }.addDisposableTo(disposeBag)
    }
}
