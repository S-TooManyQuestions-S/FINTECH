//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 16.02.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(log){
            print("UIViewController moved from <Disappeared> to <Appearing>: \(#function)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(log){
            print("UIViewController moved from <Appearing> to <Appeared>: \(#function)")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if(log){
            print("UIViewController: \(#function)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(log){
            print("UIViewController: \(#function)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(log){
            print("UIViewController moved from <Appeared> to <Disappearing>: \(#function)")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if(log){
            print("UIViewController moved from <Disappearing> to <Disappeared>: \(#function)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(log){
            print("UIViewController moved from <Loading View> to <Loaded View>: \(#function)")
        }
    }
}

