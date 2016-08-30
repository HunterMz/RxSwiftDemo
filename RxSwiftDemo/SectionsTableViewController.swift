//
//  SectionsTableViewController.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/24.
//  Copyright © 2016年 Hunter. All rights reserved.
//


import RxSwift
import RxCocoa
import RxDataSources

typealias TableViewSectionModel = AnimatableSectionModel<String, SectionsModel>

// 实现 tableView 推荐此写法
class SectionsTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    let sections = Variable([TableViewSectionModel]())
    
    static let initialValue: [SectionsModel] = [
        SectionsModel(name: "Jack", age: 18),
        SectionsModel(name: "Tim", age: 20),
        SectionsModel(name: "Andy", age: 24)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
//        tableView.registerClass(SectionsTableViewCell.self, forCellReuseIdentifier: "SectionsCell")
        let tvDataSource = RxTableViewSectionedReloadDataSource<TableViewSectionModel>()
        
        sections.asObservable()
            .bindTo(tableView.rx_itemsWithDataSource(tvDataSource))
            .addDisposableTo(disposeBag)
        
        sections.value = [TableViewSectionModel(model: "", items: SectionsTableViewController.initialValue)]
        
        tvDataSource.configureCell = { (_, tv, ip, i) in
            let cell = tv.dequeueReusableCellWithIdentifier("SectionsCell") as! SectionsTableViewCell
            cell.nameLabel.text = i.name
            cell.ageLabel.text = String(i.age)
            return cell
        }
        
        tableView.rx_modelSelected(SectionsModel)
            .subscribeNext {
                print($0)
                Alert.showInfo($0.name, message: "\($0.age)")
            }
            .addDisposableTo(disposeBag)
    }
}
