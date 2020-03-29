//
//  ItemTableViewCell.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 04.03.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imageItemView: UIImageView!
    @IBOutlet weak var titleItemLable: UILabel!
    @IBOutlet weak var categoryItemLable: UILabel!
    @IBOutlet weak var priceItemLable: UILabel!
    @IBOutlet weak var amountItemLable: UILabel!
    @IBOutlet weak var detailsItemLable: UILabel!
    @IBOutlet weak var saleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        saleView.isHidden = true

        // Configure the view for the selected state
    }
    //Configure sale button
    @IBAction func saleButtonAction(_ sender: UIButton) {
        saleView.alpha = 0
        saleView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.saleView.alpha = 1
        }
    }
    
    
    @IBAction func cancelSaveViewButtonAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.saleView.alpha = 0
        }) { (finished) in
            self.saleView.isHidden = finished
        }
    }
}

