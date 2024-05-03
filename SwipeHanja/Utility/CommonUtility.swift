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

//MARK: - JSON 로드

extension JSONSerialization {
    
    // JSON 파일을 번들에서 로드하는 함수
    static func loadJSONFromFile<T: Decodable>(filename: String, type: T.Type) throws -> T {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
            throw NSError(domain: "BundleError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to load JSON file from bundle."])
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw error // 내부 디코딩 오류를 그대로 전달
        }
    }
    
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
    
    //현재 보여지는 가장 Top VC를 찾아서 반환한다
    static func getTopViewController() -> UIViewController? {
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            if let presentedViewController = viewController.presentedViewController {
                // 현재 Modal로 표시되고 있는 뷰 컨트롤러
                print("Presented view controller: \(presentedViewController)")
                return presentedViewController
            } else if let navigationController = viewController as? UINavigationController {
                // Navigation Controller의 현재 뷰 컨트롤러
                print("Top view controller in navigation stack: \(String(describing: navigationController.topViewController))")
                return navigationController
            } else {
                // 현재 화면에 표시되고 있는 뷰 컨트롤러
                print("Visible view controller: \(viewController)")
                return viewController
            }
        } else {
            print("No Visible view controller")
            return nil
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
