//
//  FirstLaunchViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 08.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class FirstLaunchViewController: UIViewController {

    //create instance CRUDModelAppColor for save color in core date by first launch app
    let crudModelAppColor = CRUDModelAppColor()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemOrange
        // save color in core date by first launch app
        crudModelAppColor.saveColor(color: self.view.backgroundColor ?? .systemOrange)
    }
    
    // setup ModelFirstLaunch in FirstLaunchViewController
    func setupWhitModel(model: ModelFirstLaunch) {
        imageView.image = UIImage(named: model.imageName)
        titleLabel.text = model.title.localized
        subtitleLable.text = model.subtitle.localized
    }
}
