//
//  MyCustomTransition.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 29.04.2021.
//

import UIKit

class MyCustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
    -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        containerView.addSubview(toView.view)
        toView.view.alpha = 0
        
        UIView.animate(withDuration: 1,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        toView.view.alpha = 1.0
                        toView.view.center = CGPoint(x: toView.view.center.x, y: toView.view.center.y)
                       }, completion: { _ in
                        transitionContext.completeTransition(true) })
    }
}

class MyCustomDismisser: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
    -> TimeInterval {
        return 1
    }
    
    func animateTransition(using
                            transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewController(forKey: .from)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        fromView.removeFromParent()
        fromView.view.alpha = 1.0
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        fromView.view.alpha = 0.0
                       },
                       completion: { _ in
                        transitionContext.completeTransition(true)
                       })
        
    }
}
