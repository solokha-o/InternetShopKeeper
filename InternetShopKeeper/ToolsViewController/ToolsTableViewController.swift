//
//  ToolsTableViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 04.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import MessageUI

class ToolsTableViewController: UITableViewController {

    //add instance for color app
    var color = [AppColor]()
    //create instance CRUDModelAppColor for read color from core date
    let crudModelAppColor = CRUDModelAppColor()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupColorApp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Параметри".localized
        navigationItem.title = "Параметри".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
        //register cell from nib file
        let nib = UINib(nibName: "ColorAppTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ColorAppTableViewCell")
        // get notification center to receive
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: .colorNotificationKey, object: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    // configure cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToolCell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToolCell", for: indexPath)
            cell.textLabel?.text = "Написати нам!".localized
            cell.detailTextLabel?.text = "Задати питання через e-mail".localized
            return cell
        case 1:
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            cell.textLabel?.text = "Версія додатку:".localized
            cell.detailTextLabel?.text = appVersion
            cell.accessoryType = .none
            return cell
        case 2:
            guard let colorCell = tableView.dequeueReusableCell(withIdentifier: "ColorAppTableViewCell", for: indexPath) as? ColorAppTableViewCell else { return UITableViewCell() }
            colorCell.setCell()
            return colorCell
        default:
            break
        }
        return cell
    }
    //configure select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //create MFMailComposeViewController
            let composerVC = MFMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                composerVC.mailComposeDelegate = self
                // Configure the fields of the interface.
                composerVC.setToRecipients(["oleksandr.solokha@gmail.com"])
                composerVC.setSubject("")
                composerVC.setMessageBody("", isHTML: true)
                // Present the view controller modally
                self.present(composerVC, animated: true, completion: nil)
            } else {
                // if mail on device is not available
                print("Mail services are not available")
                let alert = UIAlertController(title: "Помилка!".localized, message: "У Вас відсутній додаток  Mail! Відправте пошту на адресу: oleksandr.solokha@gmail.com.".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    // function call to change color view
    @objc func notificationReceived(_ notification: Notification) {
        guard let color = notification.userInfo?["color"] as? UIColor else { return }
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.backgroundColor = color
    }
    // setup color app from core data
    func setupColorApp() {
        color = crudModelAppColor.fetchColor(color: color)
        let uiColor = UIColor.uiColorFromString(string: color[0].color ?? ".systemOrange")
        navigationController?.navigationBar.barTintColor = uiColor
        navigationController?.navigationBar.backgroundColor = uiColor
    }
}
// extention for mail message
extension ToolsTableViewController: MFMailComposeViewControllerDelegate {
    private func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
