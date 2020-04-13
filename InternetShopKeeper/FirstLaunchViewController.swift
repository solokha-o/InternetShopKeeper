//
//  FirstLaunchViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 08.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class FirstLaunchViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLable: UILabel!
    // setup ModelFirstLaunch in FirstLaunchViewController
    func setupWhitModel(model: ModelFirstLaunch) {
        imageView.image = UIImage(named: model.imageName)
        titleLabel.text = model.title.localized
        subtitleLable.text = model.subtitle.localized
    }
}
