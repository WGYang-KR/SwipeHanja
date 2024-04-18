//
//  CommonUtility.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 4/18/24.
//

import UIKit
import os.log


//MARK: - 로그
public func shLog(_ message: String?, file: String = #file, functionName: String = #function , line: UInt = #line) {
    
#if RELEASE
    return
#endif
    
    let className = (file as NSString).lastPathComponent
    os_log("%@",type:.default ,"<\(className)> \(functionName) [#\(line)] \(message ?? "")")
}


//MARK: - 화면 전환
extension UIViewController {
    
    func presentFull(_ vcToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        vcToPresent.modalPresentationStyle = .fullScreen
        self.present(vcToPresent, animated: animated, completion: completion)
    }
    
    ///popVC / dismiss 를 자동으로 결정하여 수행.
    func moveBackVC(animated: Bool, completion: (()-> Void)? = nil) {
        if let naviVC = self.navigationController,
           let rootVC = naviVC.viewControllers.first,
           rootVC != self {
                naviVC.popViewController(animated: animated, completion: completion)
        } else {
            dismiss(animated: animated, completion: completion)
        }
    }

    @objc func moveBackVC() {
        moveBackVC(animated: true)
    }
    
    func doAfterAnimatingTransition(animated: Bool,
                                    completion: (() -> Void)? ) {
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil, completion: { _ in
                completion?()
            })
        } else {
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
}

extension UINavigationController { //navigation controller completion 추가
    
    func pushViewController(viewController: UIViewController,
                                  animated: Bool,
                                  completion: (() -> Void)? ) {
        pushViewController(viewController, animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool, completion: (() -> Void)? = nil) {
        popViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popToRootViewController(animated: Bool, completion: (() -> Void)? = nil) {
        popToRootViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }

    func pushToTopRootViewController(viewController: UIViewController,
                                           animated: Bool,
                                           completion: (() -> Void)?)  {
        
        self.pushViewController(viewController: viewController, animated: animated, completion: {
            self.viewControllers = [viewController]
            completion?()
        })
    
    }
    
    
}

