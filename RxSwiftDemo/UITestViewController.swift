//
//  UITestViewController.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/22.
//  Copyright © 2016年 Hunter. All rights reserved.
//

import UIKit
import RxSwift
import Then

class UITestViewController: UIViewController {

    @IBOutlet weak var firstNumber: UITextField!
    
    @IBOutlet weak var secondNumber: UITextField!
    
    @IBOutlet weak var resultNumber: UITextField!
    
    @IBOutlet weak var testButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNumber.isFirstResponder()
        
        Observable.combineLatest(firstNumber.rx_text, secondNumber.rx_text) { String(($0 as NSString).intValue + ($1 as NSString).intValue)}
            .bindTo(resultNumber.rx_text)
            .addDisposableTo(disposeBag)
        
        
        testButton.rx_tap
            .subscribeNext {
                
//                let alertViewController = UIAlertController(title: nil, message: "试试就试试", preferredStyle: .Alert)
//                let cancelAction = UIAlertAction(title: "不敢试了", style: UIAlertActionStyle.Cancel, handler: nil )
//                let okAction = UIAlertAction(title: "还想再试试", style: .Default, handler: nil)
//                alertViewController.addAction(cancelAction);
//                alertViewController.addAction(okAction);
                
                let alertViewController: UIAlertController = UIAlertController(title: nil, message: "试试就试试", preferredStyle: .Alert).then {
                    $0.addAction(UIAlertAction(title: "不敢试了😂", style: .Cancel, handler: nil ))
                    $0.addAction(UIAlertAction(title: "还想试试😈", style: .Default, handler: nil))
                }
                
                self.presentViewController(alertViewController, animated: true, completion: nil)
                
            }.addDisposableTo(disposeBag)

    }
}
