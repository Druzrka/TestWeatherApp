//
//  Utils.swift
//  WeatherApp
//
//  Created by Захар on 04.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import UIKit

typealias U = Utils
class Utils {
    // screen rect
    static let screen: CGRect                         = mainScreen.bounds
    // actual rect
    static let actualScreen: CGRect                   = {
        var rect = mainScreen.bounds
        rect.size.height -= statusAndNavigationBarsHeight
        return rect
    }()
    // ratio
    static let ratio: CGFloat                         = {
        return U.screen.width / U.actualScreen.height
    }()
    // current locale
    static let locale: Locale                         = .current
    // current device
    static let device: UIDevice                       = .current
    // main bundle
    static let mainBundle: Bundle                     = .main
    // main screen
    static let mainScreen: UIScreen                   = .main
    // user defaults
    static let defaults: UserDefaults                 = .standard
    // application delegate
    static let appDelegate: AppDelegate               = application.delegate as! AppDelegate
    // application
    static let application: UIApplication             = .shared
    // notification center
    static let notificationCenter: NotificationCenter = .default
    // status bar height
    static let statusBarHeight: CGFloat               = U.application.statusBarFrame.height
    // navigation bar height
    static let navigationBarHeight: CGFloat           = 44.0
    // navigation bar height with status bar height
    static let statusAndNavigationBarsHeight: CGFloat = statusBarHeight + navigationBarHeight
    // is current device ipad
    static let isIpad: Bool                           = UI_USER_INTERFACE_IDIOM() == .pad
    // is current device iphone 5
    static let isIphone5                              = U.mainScreen.bounds.size.height == 568
    
    static func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    // shows default alert with 'ok' btn
    static func showAlert(_ title: String? = nil, message: String? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: R.string.localizable.ok(), style: .default) { action in
            completion?()
        }
        alert.addAction(cancelAction)
        topController()?.present(alert, animated: true, completion: nil)
    }
    
    // shows alert with actions and 'cancel' btn
    static func showAlert(_ title: String? = nil, message: String? = nil, actions: [UIAlertAction] = [], completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .default) { action in
            completion?()
        }
        
        actions.forEach { (action) in
            alert.addAction(action)
        }
        alert.addAction(cancelAction)
        
        topController()?.present(alert, animated: true, completion: nil)
    }
    
    // shows network alert
    static func showNetworkAlert() {
        let alert = UIAlertController(title: R.string.localizable.error(), message: R.string.localizable.noConnection(), preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
        )
        alert.addAction(
            UIAlertAction(title: R.string.localizable.settings(), style: .default) { action in
                if #available(iOS 10.0, *) {
                    U.application.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    U.application.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                }
                
            }
        )
        topController()?.present(alert, animated: true, completion: nil)
    }
    
    static func BG(_ block: @escaping ()->Void) {
        DispatchQueue.global(qos: .utility).async(execute: block)
    }
    
    static func UI(_ block: @escaping ()->Void) {
        DispatchQueue.main.async(execute: block)
    }
}

// custom print function
func p(_ items: Any...,
    filepath: String = #file,
    function: String = #function,
    line: Int = #line,
    separator: String = " ",
    terminator: String = "\n") {
    struct Counter {
        static var value: Int = 0
    }
    Counter.value += 1
    let url = URL(fileURLWithPath: filepath)
    let fileName: String = url.lastPathComponent.isEmpty ? filepath : url.lastPathComponent
    let thread = Thread.current.isMainThread ? "On Main Thread" : (Thread.current.name ?? "On Unknown Thread")
    Swift.print("Output \(Counter.value)")
    Swift.print(thread)
    Swift.print("\(fileName): \(function) - line \(line)")
    for i in 0 ..< items.count {
        Swift.print(items[i], separator: separator, terminator: i == items.count - 1 ? terminator : separator)
    }
    Swift.print("//")
}

// check internet connection
func isConnectedToNetwork() -> Bool {
    guard let reachability = U.appDelegate.reachability else {
        return false
    }
    switch reachability.connection {
    case .wifi, .cellular:
        return true
    case .none:
        U.showNetworkAlert()
        return false
    }
}

// get visible viewController
func topController() -> UIViewController? {
    if var controller = Utils.application.keyWindow?.rootViewController {
        while let presentedViewController = controller.presentedViewController {
            controller = presentedViewController
        }
        return controller
    }
    return nil
}
