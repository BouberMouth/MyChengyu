//
//  MoreVC.swift
//  I Learn Chengyus
//
//  Created by Antoine on 03/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

protocol MoreVCDelegate {
    func reloadView()
}

final class MoreVC: UIViewController {
    
    var moreView: MoreView!
    
    var delegate: MoreVCDelegate?
    
    let sectionNames = [
        String.localize(forKey: "MORE.PREFERENCES_SECTION.TITLE"),
        String.localize(forKey: "MORE.GAME_SECTION.TITLE"),
        String.localize(forKey: "MORE.CONTACT_SECTION.TITLE"),
        String.localize(forKey: "MORE.REVIEW_SECTION.TITLE")
    ]
    
    let sections = [
        [
            String.localize(forKey: "MORE.PREFERENCES_SECTION.CHARACTERS")
        ],
        [
            String.localize(forKey: "MORE.GAME_SECTION.RESULTS")
        ],
        [
            String.localize(forKey: "MORE.CONTACT_SECTION.REPORT_ISSUE"),
            String.localize(forKey: "MORE.CONTACT_SECTION.MISSING_ENTRY"),
            String.localize(forKey: "MORE.CONTACT_SECTION.INCORRECT_ENTRY"),
            String.localize(forKey: "MORE.CONTACT_SECTION.FEEDBACK")
        ],
        [
            String.localize(forKey: "MORE.REVIEW_SECTION.RATE")
        ]
    ]
    
    override func loadView() {
        super.loadView()
        moreView = MoreView(frame: view.frame)
        view = moreView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moreView.tableView.backgroundColor = UIColor(named: "ChengyuBackground")
        title = String.localize(forKey: "MORE.TITLE")
        moreView.tableView.separatorColor = UIColor.chengyuWhite.withAlphaComponent(0.25)
        moreView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        moreView.tableView.delegate = self
        moreView.tableView.dataSource = self
        moreView.setFoldButtonAction(target: self, action: #selector(fold))
    }
    
    @objc func fold() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MoreVC: MFMailComposeViewControllerDelegate  {
    
    enum ContactCase: String {
        case reportIssue = "REPORT_ISSUE"
        case reportMissingEntry = "REPORT_MISSING_ENTRY"
        case reportIncorrectEntry = "REPORT_INCORRECT_ENTRY"
        case sendFeedBack = "SEND_FEEDBACK"
        
        static func allCases() -> [ContactCase] {
            return [.reportIssue, .reportMissingEntry, .reportIncorrectEntry, .sendFeedBack]
        }
    }

    func sendReportEmail(reason: ContactCase) {
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            let content = String.localize(forKey: "CONTACT.\(reason.rawValue).CONTENT")
            mail.setMessageBody(content, isHTML: true)
            
            mail.setToRecipients(["mychengyu.app@gmail.com"])
            
            let version = UIDevice.current.systemVersion
            let subject = String.localize(forKey: "CONTACT.\(reason.rawValue).SUBJECT")
                .replacingOccurrences(of: "%version%", with: version)
                .replacingOccurrences(of: "%location%", with: "Contact")
            mail.setSubject(subject)

            present(mail, animated: true)
        } else {
            print("Unable to send emails...")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if result == .sent {
                let title = String.localize(forKey: "CONTACT.SUCCESS_ALERT.TITLE")
                let message = String.localize(forKey: "CONTACT.SUCCESS_ALERT.MESSAGE")
                let ok = String.localize(forKey: "DEFAULT.OK")
                let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: ok, style: .cancel, handler: nil))
                ac.setTheme()
                self.present(ac, animated: true)
            }
        }
    }
}


extension MoreVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]
        cell.textLabel?.textColor = .chengyuWhite
        cell.textLabel?.font = UIFont.roundedFont(ofSize: 24, weight: .regular)
        cell.backgroundColor = UIColor(named: "ChengyuBackground")
        cell.selectionStyle = .none
        
        if indexPath.section == 0, indexPath.row == 0 {
            
            let segmented = UISegmentedControl(items: [
                                                String.localize(forKey: "DEFAULT.SIMPLIFIED_SH"),
                                                String.localize(forKey: "DEFAULT.TRADITIONAL_SH")])
            segmented.selectedSegmentIndex = UserDefaults.standard.string(forKey: UserDefaultsKeys.characterPreferenceKey) == "TRAD" ? 1 : 0
            segmented.addTarget(self, action: #selector(charPrefDidChange(_:)), for: .valueChanged)
            cell.accessoryView = segmented
        }
        return cell
    }
}

extension MoreVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 32))
        let label = UILabel(frame: CGRect(x: 8, y: 8, width: tableView.frame.width - 16, height: 24))
        label.textColor = .chengyuWhite
        label.font = UIFont.roundedFont(ofSize: 17, weight: .regular)
        label.layer.borderColor = UIColor.chengyuWhite.cgColor
        label.layer.borderWidth = 1
        label.textAlignment = .center
        label.layer.cornerRadius = label.frame.height / 2
        label.text = sectionNames[section]
        
        view.addSubview(label)
        view.backgroundColor = UIColor(named: "ChengyuBackground")
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        return footer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Do Nothing
        } else if indexPath.section == 1 {
            let nextVC = GameRecordsVC()
            nextVC.hideNavbar = true
            navigationController?.pushViewController(nextVC, animated: true)
        } else if indexPath.section == 2 {
            let contactCases = ContactCase.allCases()
            sendReportEmail(reason: contactCases[indexPath.row])
        } else if indexPath.section == 3 {
            ReviewService.shared.requestReviewManually()
        }
    }
}

extension MoreVC {
    
    @objc private func charPrefDidChange(_ sender: UISegmentedControl) {
        let newValue = sender.selectedSegmentIndex == 1 ? "TRAD" : "SIMP"
        UserDefaults.standard.setValue(newValue,
                                       forKey: UserDefaultsKeys.characterPreferenceKey)
        delegate?.reloadView()
    }
}
