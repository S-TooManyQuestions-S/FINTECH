//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 25.02.2021.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            Logger.logProcess(fullDescription: "UIViewController moved from <Disappeared> to <Appearing>: \(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            Logger.logProcess(fullDescription: "UIViewController moved from <Appearing> to <Appeared>: \(#function)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
            Logger.logProcess(fullDescription: "UIViewController: \(#function)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Logger.logProcess(fullDescription: "UIViewController: \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Logger.logProcess(fullDescription: "UIViewController moved from <Appeared> to <Disappearing>: \(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Logger.logProcess(fullDescription: "UIViewController moved from <Disappearing> to <Disappeared>: \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.logProcess(fullDescription: "UIViewController moved from <Loading View> to <Loaded View>: \(#function)")
    }
}
