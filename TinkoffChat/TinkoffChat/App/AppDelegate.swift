//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 16.02.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var tinkoffCell: CAEmitterCell = {
        var tinkoffCell = CAEmitterCell()
        tinkoffCell.contents = UIImage(named: "tinkoffCell")?.cgImage
        tinkoffCell.scale = 0.5
        tinkoffCell.scaleRange = 0.3
        tinkoffCell.emissionRange = 2 * .pi
        tinkoffCell.lifetime = 1
        tinkoffCell.birthRate = 15
        tinkoffCell.spin = -5
        tinkoffCell.spinRange = 1.0
        
        tinkoffCell.velocity = -30
        tinkoffCell.velocityRange = -20

        return tinkoffCell
    }()
    
    lazy var tinkoffLayer: CAEmitterLayer  = {
        let tinkoffLayer = CAEmitterLayer()
        
        guard let window = window else {
            tinkoffLayer.emitterSize = .zero
            return tinkoffLayer
        }
        
        tinkoffLayer.emitterSize = window.bounds.size
        tinkoffLayer.emitterCells = [tinkoffCell]
        tinkoffLayer.timeOffset = CFTimeInterval(arc4random_uniform(6) + 5)
        return tinkoffLayer
    }()
    
    var window: UIWindow?
    
    @objc func longGesturePress(gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            window?.layer.addSublayer(tinkoffLayer)
            tinkoffLayer.emitterPosition = gesture.location(in: window)
            tinkoffLayer.beginTime = CACurrentMediaTime()
        case .changed:
            tinkoffLayer.emitterPosition = gesture.location(in: window)
        case .ended:
            tinkoffLayer.removeFromSuperlayer()
        default:
            print("nothing")
        }
    }
    
    // Вызывается при успешном запуске приложения
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let laterActionPress = UILongPressGestureRecognizer(target: self, action: #selector(longGesturePress(gesture:)))
        laterActionPress.minimumPressDuration = 0.5
        window?.addGestureRecognizer(laterActionPress)
        
        Logger.logProcess(fullDescription: "Application moved from <Not running> to <Inactive>: \(#function)")
        FirebaseApp.configure()
        // RootAssembly.serviceAssembly.coreDataHandler.showDetailedDataChannels()
        // Override point for customization after application launch.
        return true
    }
    
    // Обработка процессов в активном режиме (перезапуск и т.п.)
    func applicationDidBecomeActive(_ application: UIApplication) {
        Logger.logProcess(fullDescription: "Application moved from <Inactive> to <Active>: \(#function)")
        
        // Restart any tasks that were paused (or not yet started)
        // while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    // Подготовка к переходу приложения в неактивное состояние
    func applicationWillResignActive(_ application: UIApplication) {
        Logger.logProcess(fullDescription: "Application moved from <Active> to <Inactive>: \(#function)")
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions
        // (such as an incoming phone call or SMS message)
        // or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    // Обработка данных приложения в фоновом режиме
    func applicationDidEnterBackground(_ application: UIApplication) {
        Logger.logProcess(fullDescription: "Application moved from <Inactive> to <Background>: \(#function)")
        // Use this method to release shared resources,
        // save user data, invalidate timers,
        // and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    // Подготовка к активному состоянию
    func applicationWillEnterForeground(_ application: UIApplication) {
        Logger.logProcess(fullDescription: "Application moved from <Background> to <Inactive>: \(#function)")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    // Подготовка к завершению
    func applicationWillTerminate(_ application: UIApplication) {
        Logger.logProcess(fullDescription: "Application moved from <Background> to <Not running>: \(#function)")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}
