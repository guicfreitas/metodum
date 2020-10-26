//
//  OnboardScreenViewController.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 26/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit

class OnboardScreenViewController: UIPageViewController, UIPageViewControllerDelegate {

    lazy var pagesViewControllers = [
        instanciateViewController(named: "view1"),
        instanciateViewController(named: "view2"),
        instanciateViewController(named: "view3"),
        instanciateViewController(named: "view4"),
        instanciateViewController(named: "view5"),
    ]
    
    var actualIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let viewController = pagesViewControllers.first {
            setViewControllers([viewController], direction: .forward, animated: false,completion: nil)
        }
    }
    
    private func instanciateViewController(named name : String) -> UIViewController {
        let childRef = storyboard!.instantiateViewController(withIdentifier: name)
        return childRef
    }
}

extension OnboardScreenViewController: UIPageViewControllerDataSource {
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
