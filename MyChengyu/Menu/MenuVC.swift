//
//  ViewController.swift
//  I Learn Chengyus
//
//  Created by Antoine on 26/02/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit
import MessageUI

final class MenuVC: UIViewController {
    
    //MARK: - Properties
    
    let allChengyus = Chengyu.decodeChengyuFromTxtFile("ChengyuList-EN")
    lazy var cotd = Chengyu.chengyuOfTheDayIn(allChengyus)
    let menuTitles = [
        String.localize(forKey: "MENU.BROWSE"),
        String.localize(forKey: "MENU.DECKS"),
        String.localize(forKey: "MENU.LEARN"),
        String.localize(forKey: "MENU.MORE")
    ]
    var menuView: MenuView!
    
    //MARK: - Public methods

    override func loadView() {
        super.loadView()
        menuView = MenuView(frame: view.frame)
        view = menuView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.setModel(cotd)
        menuView.buttonsNames = menuTitles
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .chengyuWhite
        navigationController?.navigationBar.barTintColor = UIColor(named: "ChengyuBackground")
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.chengyuWhite,
            NSAttributedString.Key.font: UIFont.roundedFont(ofSize: 30, weight: .bold)
        ]
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    //MARK: - Private methods
    
    @objc private func cotdTapAction(_ sender: UITapGestureRecognizer) {
        let nextVC = ChengyuDetailsVC()
        nextVC.chengyu = cotd
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func didTapBrowseChengyus() {
        let nextVC = DictionnaryVC()
        nextVC.allChengyus = allChengyus
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func didTapMyChengyus() {
        let nextVC = DeckSelectionVC()
        nextVC.allChengyus = allChengyus
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func didTapLearn() {
        let nextVC = GameSettingsVC()
        nextVC.allChengyus = allChengyus
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func didTapMore() {
        let nextVC = MoreVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func setupGestureRecognizers() {
        let cotdTapGesture = UITapGestureRecognizer(target: self, action: #selector(cotdTapAction))
        menuView.cotdView.addGestureRecognizer(cotdTapGesture)
        
        let browseTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBrowseChengyus))
        menuView.menuButtons[0].addGestureRecognizer(browseTapGesture)
        
        let myChengyuTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMyChengyus))
        menuView.menuButtons[1].addGestureRecognizer(myChengyuTapGesture)
        
        let learnTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLearn))
        menuView.menuButtons[2].addGestureRecognizer(learnTapGesture)
        
        let moreTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMore))
        menuView.menuButtons[3].addGestureRecognizer(moreTapGesture)
    }
}

extension MenuVC: MFMailComposeViewControllerDelegate  {
    
    func sendReportEmail() {
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            let content = "<b>What issue would you like to report ?</b>"
            mail.setMessageBody(content, isHTML: true)
            
            mail.setToRecipients(["a.bouberbouche@gmail.com"])
            
            let version = UIDevice.current.systemVersion
            mail.setSubject("REPORT: MyChengyu - iOS\(version)")

            present(mail, animated: true)
        } else {
            print("Unable to send emails...")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if result == .sent {
                let ac = UIAlertController(title: "Thank you !", message: "Your message has been sent and we will read it very soon. Thank you for your help. 😊", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(ac, animated: true)
            }
        }
    }
}

extension MenuVC: MoreVCDelegate {
    func reloadView() {
        menuView = MenuView(frame: menuView.frame)
    }
    
    
}
