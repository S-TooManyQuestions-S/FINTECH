//
//  MyCustomSegue.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 29.04.2021.
//

import UIKit

class MyCustomSegue: UIStoryboardSegue {
    private var selfRetainer: MyCustomSegue?
    
    override func perform() {
        destination.transitioningDelegate = self
        selfRetainer = self
        destination.modalPresentationStyle = .overCurrentContext
        source.present(destination, animated: true, completion: nil)
    }
}

extension MyCustomSegue: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyCustomTransition()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        selfRetainer = nil
        return MyCustomDismisser()
    }
}
