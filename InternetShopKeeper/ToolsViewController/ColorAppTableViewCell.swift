//
//  ColorAppTableViewCell.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 21.05.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class ColorAppTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet var colorButtonsOutletCollection: [UIButton]!
    
    //create instance CRUDModelAppColor for update color in core date
    let crudModelAppColor = CRUDModelAppColor()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    // configure action button to change color app
    @IBAction func colorButtonAction(_ sender: UIButton) {
        for colorButton in colorButtonsOutletCollection {
            colorButton.setImage(nil, for: .normal)
        }
        let checkMark = UIImage(systemName: "checkmark")
        sender.setImage(checkMark, for: .normal)
        // create notification to send other view changes color
        let userInfo : [AnyHashable:Any] = ["color" : sender.backgroundColor as Any]
        NotificationCenter.default.post(name: .colorNotificationKey, object: nil, userInfo: userInfo)
        // update color app in core data
        crudModelAppColor.updateColor(color: sender.backgroundColor ?? .systemOrange)
    }
    // configure view and setup it
    func setCell() {
        // configure text label
        colorLabel.text = "Вибери колір для додатку".localized
        //configure button
        for colorButton in colorButtonsOutletCollection {
            colorButton.layer.masksToBounds = true
            colorButton.layer.cornerRadius = colorButton.frame.size.height / 2
            colorButton.layer.borderWidth = 0.5
            switch colorButton.tag {
            case 0:
                colorButton.backgroundColor = .systemOrange
            case 1:
                colorButton.backgroundColor = .systemTeal
            case 2:
                colorButton.backgroundColor = .systemGreen
            case 3:
                colorButton.backgroundColor = .systemRed
            case 4:
                colorButton.backgroundColor = .systemGroupedBackground
            default:
                break
            }
        }
    }
}
// create name of notification
extension Notification.Name {
    public static let colorNotificationKey = Notification.Name(rawValue: "colorNotificationKey")
}
