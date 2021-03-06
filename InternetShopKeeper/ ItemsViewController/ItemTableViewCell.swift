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
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var inStockLable: UILabel!
    @IBOutlet weak var pieceLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        inStockLable.text = "В наявності".localized
        pieceLable.text = "Шт".localized
        imageItemView.layer.masksToBounds = true
        imageItemView.layer.cornerRadius = 35.0
    }
}

