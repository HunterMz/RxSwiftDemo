//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by Hunter on 16/8/10.
//  Copyright © 2016年 Hunter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OperatorsViewController: UIViewController {

    @IBOutlet weak var firstTextfield: UITextField!
    
    @IBOutlet weak var secondTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        combineLatest()
        let disposeBag = DisposeBag()
        let behaviorSubject = BehaviorSubject(value: "z")
        behaviorSubject.subscribe { e in
            print("Subscription: 1, event: \(e)")
            }.addDisposableTo(disposeBag)
        
        behaviorSubject.on(.Next("a"))
        behaviorSubject.on(.Next("b"))
        
        behaviorSubject.subscribe { e in /// 我们可以在这里看到，这个订阅收到了四个数据
            print("Subscription: 2, event: \(e)")
            }.addDisposableTo(disposeBag)
        
        behaviorSubject.on(.Next("c"))
        behaviorSubject.on(.Next("d"))
        behaviorSubject.on(.Completed)
    }
}

// MARK: - Operators
extension OperatorsViewController {
    
    func example(description: String, @noescape action: Void -> Void) {
        printExampleHeader(description)
        action()
    }
    
    func printExampleHeader(description: String) {
        print("\n--- \(description) example ---")
    }
    
    func emptyTest() {
        let disposeBag = DisposeBag()
        Observable<Int>.empty()
            .subscribe { event in
                print(event)
            }
            .addDisposableTo(disposeBag)

    }

    
    func neverTest() {
        
        example("neverTest") {
            let disposeBag = DisposeBag()
            let neverSequence = Observable<String>.never()
            
            let neverSequenceSubscription = neverSequence
                .subscribe { _ in
                    print("This will never be printed")
            }
            
            neverSequenceSubscription.addDisposableTo(disposeBag)
        
        }
    }
    
    func justTest() {
        example("just") { (_) in
            let disposeBag = DisposeBag()
            let emptySequence = Observable<Int>.just(32)
            let subscription = emptySequence
                .subscribe { event in
                    print(event)
            }
            
            subscription.addDisposableTo(disposeBag)

        }
    }

    ///  有 Bug
    func fromTest() {
        example("from") { (_) in
            let disposeBag = DisposeBag()
            var array = Array<Int>()
            array.append(1)
            array.append(2)
            array.append(3)
            print(array)
            let fromSequence = Variable(array)
            let subscription = fromSequence.asObservable()
                .subscribe{ event in
                    print(event)
                }
            subscription.addDisposableTo(disposeBag)
        }
    }
    
    func createTest() {
        example("from") {
            let disposeBag = DisposeBag()
            let myJust = { (element: String) -> Observable<String> in
                return Observable.create({ (observer) -> Disposable in
                    observer.on(.Next(element))
                    observer.on(.Completed)
                    return NopDisposable.instance
                })
            }
            myJust("haha").subscribe { (event) in
                print(event)
            }.addDisposableTo(disposeBag)
        }
    }
    
    func deferredTest() {
        example("deferred") {
            let disposeBag = DisposeBag()
            var count = 1
            let deferredSequence = Observable<String>.deferred({ () -> Observable<String> in
                print("Creating\(count)")
                count += 1
                return Observable.create({ (observer) -> Disposable in
                    print("Emmiting....")
                    observer.onNext("😂")
                    observer.onNext("😈")
                    observer.onNext("😌")
                    return NopDisposable.instance
                })
            })
            
            deferredSequence.subscribeNext({ (element) in
                print(element)
            }).addDisposableTo(disposeBag)
            
            deferredSequence
                .subscribeNext { print($0) }
                .addDisposableTo(disposeBag)
        }
    }
    
    
    func toObserverTest() {
        example("toObserver") {
            let disposeBag = DisposeBag()
            
            ["🐶", "🐱", "🐭", "🐹"].toObservable()
                .subscribeNext { print($0) }
                .addDisposableTo(disposeBag)

        }
    }
    
    func publishSubject() {
        example("publishSubject") {
            let disposeBag = DisposeBag()
            let subject = PublishSubject<String>()
            
            
            subject.addObserver("1").addDisposableTo(disposeBag)
            subject.onNext("🐶")
            subject.onNext("🐱")
            
            subject.addObserver("2").addDisposableTo(disposeBag)
            subject.onNext("🅰️")
            subject.onNext("🅱️")

        }
    }
    
    func ReplaySubjectTest() {
        example("ReplaySubjecrt") {
            let disposeBag = DisposeBag()
            let subject = ReplaySubject<String>.create(bufferSize: 2)
            
            subject.addObserver("1").addDisposableTo(disposeBag)
            subject.onNext("🐶")
            subject.onNext("🐱")
            
            subject.addObserver("2").addDisposableTo(disposeBag)
            subject.onNext("🅰️")
            subject.onNext("🅱️")

        }
    }
    
    func variableTest() {
        example("Variable") {
            let disposeBag = DisposeBag()
            let variable = Variable("🔴")
            
            variable.asObservable().addObserver("1").addDisposableTo(disposeBag)
            variable.value = "🐶"
            variable.value = "🐱"
            
            variable.asObservable().addObserver("2").addDisposableTo(disposeBag)
            variable.value = "🅰️"
            variable.value = "🅱️"
        }
    }
    
    func mapTest() {
        example("map") {
            let disposeBag = DisposeBag()
            Observable.of(1, 2, 3)
                .map { $0 * $0 }
                .subscribeNext { print($0) }
                .addDisposableTo(disposeBag)
        }
    }
    
    func scanTest() {
        example("scan") {
            let disposeBag = DisposeBag()
            
            Observable.of(10, 100, 1000)
                .scan(1) { aggregateValue, newValue in
                    aggregateValue + newValue
                }
                .subscribeNext { print($0) }
                .addDisposableTo(disposeBag)
        }
    }
    
    func filterTest() {
        example("filter") { (_) in
            let disposeBag = DisposeBag()
            Observable.of(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
            .filter({ (element) -> Bool in
                element % 2 == 0
            })
            .subscribe({ (event) in
                print(event)
            }).addDisposableTo(disposeBag)
        }
    }
    
    func zipTest() {
        example("zip 1") {
            let disposeBag = DisposeBag()
            let stringSubject = PublishSubject<String>()
            let intSubject = PublishSubject<Int>()
            
            Observable.zip(stringSubject, intSubject) {"\($0) \($1)"}
            .subscribe{
                print($0)
            }
            .addDisposableTo(disposeBag)
            
            stringSubject.on(.Next("A"))
            intSubject.on(.Next(1))
            stringSubject.on(.Next("B"))
            stringSubject.on(.Next("C"))
            intSubject.on(.Next(2))
        }
    }
    
    func merge() {
        example("merge 1") {
            let disposeBag = DisposeBag()
            let subject1 = PublishSubject<Int>()
            let subject2 = PublishSubject<Int>()
            Observable.of(subject1, subject2)
                .merge()
                .subscribeNext { int in
                    print(int)
            }.addDisposableTo(disposeBag)
            subject1.on(.Next(1))
            subject1.on(.Next(2))
            subject2.on(.Next(3))
            subject1.on(.Next(4))
            subject2.on(.Next(5))
        }
    }
    
    func retryTest() {
        example("retry") {
            
            let disposeBag = DisposeBag()
            var count = 1 // bad practice, only for example purposes
            let funnyLookingSequence: Observable<Int> = Observable.create { observer in
                let error = NSError(domain: "Test", code: 0, userInfo: nil)
                observer.on(.Next(0))
                observer.on(.Next(1))
                if count < 2 {
                    observer.on(.Error(error))
                    count += 1
                }
                observer.on(.Next(2))
                observer.on(.Completed)
                return NopDisposable.instance
            }
            funnyLookingSequence
                .retry()
                .subscribe {
                    print($0)
            }.addDisposableTo(disposeBag)
        }
    }
    
    func doOnTest() {
        example("doOn") {
            let disposeBag = DisposeBag()
            let sequenceOfInts = PublishSubject<Int>()
            sequenceOfInts
                .doOn {
                    print("Intercepted event \($0)")
                }
                .subscribe {
                    print($0)
            }.addDisposableTo(disposeBag)
            sequenceOfInts.on(.Next(1))
            sequenceOfInts.on(.Completed)
        }
    }
    
    func reduceTest() {
        example("reduce") {
            let disposeBag = DisposeBag()
            Observable.of(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
                .reduce(0, accumulator: +)
                .subscribe {
                    print($0)
            }.addDisposableTo(disposeBag)
        }
    }
    
    func combineLatest() {
        let firstObserverable = firstTextfield.rx_text.map({"first" + $0})
        let secondObserverable = secondTextfield.rx_text.filter({$0.characters.count > 3})
        _ =  Observable.combineLatest(firstObserverable, secondObserverable, resultSelector:{ ($0 + $1,$0.characters.count + $1.characters.count)}).subscribeNext { (element) in
            print("combineLatest:\(element)")
        }
    }
}

extension ObservableType {
    
    /**
     Add observer with `id` and print each emitted event.
     - parameter id: an identifier for the subscription.
     */
    func addObserver(id: String) -> Disposable {
        return subscribe { print("Subscription:", id, "Event:", $0) }
    }
    
}