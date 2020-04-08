//
//  FirstLaunchPageViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 08.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

protocol FirstLaunchPageViewControllerDelegate: class {
    func indexIsChanged(index: Int)
}


class FirstLaunchPageViewController: UIPageViewController {
        // create array UIViewController for view in OnboardingViewController
        var controllers: [UIViewController] = []

        weak var onboardingDelegate: FirstLaunchPageViewControllerDelegate?
        // function to set UIViewController in OnboardingViewController
        func setControllers(controllers: [UIViewController]) {
            self.controllers = controllers
            setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            delegate = self
            dataSource = self
        }
    }

    extension FirstLaunchPageViewController: UIPageViewControllerDelegate {
        func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            guard let controller = pendingViewControllers.first, let index = controllers.firstIndex(of: controller) else { return }
            onboardingDelegate?.indexIsChanged(index: index)
        }
    }

    extension FirstLaunchPageViewController: UIPageViewControllerDataSource {
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
            return controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController), index + 1 <= controllers.count - 1 else { return nil }
            return controllers[index + 1]
        }
}

extension FirstLaunchPageViewController: OnboardingViewControllerDelegate {
    func openPage(with index: Int) {
        let contoller = controllers[index]
        setViewControllers([contoller], direction: .forward, animated: false, completion: nil)
    }
}
