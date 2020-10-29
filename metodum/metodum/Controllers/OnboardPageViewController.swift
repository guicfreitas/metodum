//
//  OnboardScreenViewController.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 26/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit
import Firebase

class OnboardPageViewController: UIPageViewController, UIPageViewControllerDelegate, MessagingDelegate {

    lazy var pagesViewControllers = [
        instanciateViewController(named: "view1"),
        instanciateViewController(named: "view2"),
        instanciateViewController(named: "view3"),
        instanciateViewController(named: "view4"),
        instanciateViewController(named: "view5"),
    ]
    
    var actualIndex = 0
    var callback : (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        self.view.backgroundColor = UIColor(named:"Blue")
        
        if let viewController = pagesViewControllers.first {
            setViewControllers([viewController], direction: .forward, animated: false,completion: nil)
        }
    }
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()

            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async{
                        UIApplication.shared.registerForRemoteNotifications()
                        Messaging.messaging().delegate = self
                    }
                    
                }
            }

        }
        else {
            DispatchQueue.main.async{
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
                UIApplication.shared.registerForRemoteNotifications()
                Messaging.messaging().delegate = self
            }
        }
    }
    private func instanciateViewController(named name : String) -> UIViewController {
        if name == "view5" {
            let childRef = storyboard!.instantiateViewController(withIdentifier: name) as! PoliticsViewController
            childRef.callback = callback
            return childRef
        }
        
        let childRef = storyboard!.instantiateViewController(withIdentifier: name)
        return childRef
    }
}

extension OnboardPageViewController: UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pagesViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return actualIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = pagesViewControllers.firstIndex(of: viewController)!
        let pagesCount = pagesViewControllers.count
        
        if index == 0 {
            return nil
        }
        
        actualIndex = (index - 1).mod(pagesCount)
        
        return pagesViewControllers[actualIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = pagesViewControllers.firstIndex(of: viewController)!
        let pagesCount = pagesViewControllers.count
        
        if index == pagesCount - 1 {
            return nil
        }
        
        if index == 3{
            registerForRemoteNotification() 
        }
        
        actualIndex = (index + 1).mod(pagesCount)

        return pagesViewControllers[actualIndex]
    }
}

extension Int {
    func mod(_ number : Int) -> Int{
        let result = self % number
        return (result < 0) ? result + number : result
    }
}
