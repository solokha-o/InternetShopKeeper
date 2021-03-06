//
//  TabBarController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 13.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate{
    
    //add instance for color app
    var color = [AppColor]()
    //create instance CRUDModelAppColor for read color from core date
    let crudModelAppColor = CRUDModelAppColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // call setup and configure controller function
        setupColorApp()
        setupTitleTabBarItem()
        //To preload all view controllers
        self.viewControllers?.forEach { let _ = $0.view }
        // get notification center to receive
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: .colorNotificationKey, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitleTabBarItem()
    }
    // animate transition next controller by press tapbar
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let tabViewControllers = tabBarController.viewControllers, let toIndex = tabViewControllers.firstIndex(of: viewController) else {
            return false
        }
        // pass array between ItemTableViewController and StatisticViewController
        let navC0 = self.viewControllers?[0] as! UINavigationController
        let itemTVC = navC0.topViewController as! ItemTableViewController
        let navC3 = self.viewControllers?[3] as! UINavigationController
        let staticticTVC = navC3.topViewController as! StatisticTableViewController
        _ = staticticTVC.view
        staticticTVC.itemsStruct = itemTVC.itemStructStatistic
        let navC2 = self.viewControllers?[2] as! UINavigationController
        let salesTVC = navC2.topViewController as! SalesTableViewController
        staticticTVC.salesStruct = salesTVC.salesStruct
        
        animateToTab(toIndex: toIndex)
        return true
    }
    // animate transition view
    func animateToTab(toIndex: Int) {
        guard let tabViewControllers = viewControllers,
            let selectedVC = selectedViewController else { return }
        guard let fromView = selectedVC.view,
            let toView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.firstIndex(of: selectedVC),
            fromIndex != toIndex else { return }
        // Add the toView to the tab bar view
        fromView.superview?.addSubview(toView)
        // Position toView off screen (to the left/right of fromView)
        let screenWidth = UIScreen.main.bounds.size.width
        let scrollRight = toIndex > fromIndex
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)
        // Disable interaction during animation
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        // Slide the views by -offset
                        fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y)
                        toView.center = CGPoint(x: toView.center.x - offset, y: toView.center.y)
        }, completion: { finished in
            // Remove the old view from the tabbar view.
            fromView.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }
    // setup title to each viewControllers tabBarItem
    func setupTitleTabBarItem() {
        self.viewControllers?[0].tabBarItem.title = "Мій товар".localized
        self.viewControllers?[1].tabBarItem.title = "Категорії".localized
        self.viewControllers?[2].tabBarItem.title = "Мої продажі".localized
        self.viewControllers?[3].tabBarItem.title = "Статистика".localized
        self.viewControllers?[4].tabBarItem.title = "Параметри".localized
    }
    // function call to change color view
    @objc func notificationReceived(_ notification: Notification) {
        guard let color = notification.userInfo?["color"] as? UIColor else { return }
        self.tabBar.barTintColor = color
        self.tabBar.backgroundColor = color
    }
    // setup color app from core data
    func setupColorApp() {
        color = crudModelAppColor.fetchColor(color: color)
        let uiColor = UIColor.uiColorFromString(string: color[0].color ?? ".systemOrange")
        self.tabBar.barTintColor = uiColor
        self.tabBar.backgroundColor = uiColor
    }
}
