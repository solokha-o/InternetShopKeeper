//
//  SalesTableViewCell.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 20.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class SalesTableViewCell: UITableViewCell {

    @IBOutlet weak var imageSaleItem: UIImageView!
    @IBOutlet weak var titleSaleItemLable: UILabel!
    @IBOutlet weak var categorySaleItemLable: UILabel!
    @IBOutlet weak var priceSaleItemLable: UILabel!
    @IBOutlet weak var amountSaleItemLable: UILabel!
    @IBOutlet weak var dateSaleItemLable: UILabel!
    @IBOutlet weak var saleLable: UILabel!
    @IBOutlet weak var pcsSaleItemLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
