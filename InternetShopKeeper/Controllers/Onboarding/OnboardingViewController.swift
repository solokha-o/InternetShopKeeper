//
//  OnboardingViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 08.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate: class {
    func openPage(with index: Int)
}

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipTutorialButton: UIButton!

    weak var delegate: OnboardingViewControllerDelegate?
    //create array of ModelFirstLaunch
    let modelFirstLaunch: [ModelFirstLaunch] = [
        ModelFirstLaunch(imageName: "onBoardingImage1", title: "Облік товарів магазину!", subtitle: "Слідкуй за наявністю товарів в своєму магазині та веди облік."),
        ModelFirstLaunch(imageName: "onBoardingImage2", title: "Доходи видно тут!", subtitle: "Не потрібен тобі калькулятор, всі доходи та видатки рахуються тут."),
        ModelFirstLaunch(imageName: "onBoardingImage3", title: "Завжди під рукою!", subtitle: "Все що тобі потрібно для твого магазину в одному додатку.")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = modelFirstLaunch.count
        skipTutorialButton.setTitle("Пропустити".localized, for: .normal)
    }
    // configure segue to FirstLaunchPageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ToPageVC":
            guard let controller = segue.destination as? FirstLaunchPageViewController else { return }
            delegate = controller
            controller.onboardingDelegate = self
            let controllers = modelFirstLaunch.compactMap { model -> UIViewController? in
                guard let controller = storyboard?.instantiateViewController(withIdentifier: "FirstLaunchViewController") as? FirstLaunchViewController else { return nil }
                _ = controller.view
                controller.setupWhitModel(model: model)
                return controller
            }
            controller.setControllers(controllers: controllers)
        default: break
        }
    }
    // configure button skip
    @IBAction func skipTutorialAction(_ sender: UIButton) {
        // configure button to skip tutorial
        UserDefaults.standard.set(true, forKey: "onboarding")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let VC = storyboard?.instantiateViewController(identifier: "HomeViewController")
        appDelegate.window?.rootViewController = VC
    }
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){

    }
    // configure UIPageControl
    @IBAction func pageControllerAction(_ sender: UIPageControl) {
        delegate?.openPage(with: sender.currentPage)
    }
}

extension OnboardingViewController: FirstLaunchPageViewControllerDelegate {
    func indexIsChanged(index: Int) {
        pageControl.currentPage = index
    }
}
