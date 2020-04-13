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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Параметри".localized
        navigationItem.title = "Параметри".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    // configure cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToolCell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Написати нам!".localized
            cell.detailTextLabel?.text = "Задати питання через e-mail".localized
        case 1:
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            cell.textLabel?.text = "Версія додатку:".localized
            cell.detailTextLabel?.text = appVersion
            cell.accessoryType = .none
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
}
// extention for mail message
extension ToolsTableViewController: MFMailComposeViewControllerDelegate {
    private func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
