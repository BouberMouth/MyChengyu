//
//  GameVC.swift
//  I Learn Chengyus
//
//  Created by Antoine on 10/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit
import MessageUI
import RealmSwift

final class GameVC: UIViewController {
    
    //MARK: - Properties
    let realm = try! Realm()
    var gameView: GameView! { didSet { setupGameView() }}
    var selectedDeckName: String = ""
    var chengyus: [Chengyu]? {
        return game?.currentChengyus
    }
    var game: Game?
    var goodAnswer: Int = 0 { didSet { updateScoreLabel() }}
    var wrongAnswer: Int = 0
    var itemSize: CGSize = .zero
    var focusedCellID: Int = 0
    
    var currentAnswer: String = "" {
        didSet {
            if currentAnswer.count == 4 {
                submitAnswer()
            }
        }
    }
    var selectedButtons = [GameButton]()
    
    //MARK: - Public methods
    
    override func loadView() {
        super.loadView()
        gameView = GameView(frame: view.frame)
        view = gameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
    
    //MARK: - Private methods
    
    private func setupGameView() {
        if game != nil {
            gameView.carousselView.delegate = self
            gameView.carousselView.dataSource = self
            gameView.carousselView.register(CarousselCell.self, forCellWithReuseIdentifier: "cellID")
            gameView.exitButton.addTarget(self, action: #selector(exitButtonAction), for: .touchUpInside)
            setupButtons()
            updateScoreLabel()
        }
    }
    
    private func setupButtons() {
        gameView.buttonsView.model = ButtonViewModel(forLevel: game!.level)
        for i in gameView.buttons.indices {
            gameView.buttons[i].addTarget(self, action: #selector(gameButtonAction(_:)), for: .touchUpInside)
        }
        updateButtons()
    }
    
    private func updateButtons() {
        if game == nil { return }
                
        for i in gameView.buttons.indices {
            let title = String(game!.answerComponents![i])
            gameView.buttons[i].setTitle(title, for: .normal)
            gameView.buttons[i].isEnabled = true
            gameView.buttons[i].alpha = 1
            gameView.buttons[i].hasBeenSelected = false
        }
    }
    
    private func updateView() {
        updateButtons()
        gameView.carousselView.reloadData()
    }
    
    @objc private func gameButtonAction(_ sender: UIButton) {
        guard let sender = sender as? GameButton else {return}
        guard let title = sender.titleLabel?.text else {return}
        
        if let btnIndex = selectedButtons.firstIndex(of: sender) {
            if let lastIndex = currentAnswer.lastIndex(of: Character(title)) {
                currentAnswer.remove(at: lastIndex)
                selectedButtons.remove(at: btnIndex)
                
                sender.hasBeenSelected = false
            }
        } else {
            sender.hasBeenSelected = true
            selectedButtons.append(sender)
            currentAnswer += title
        }
    }
    
    private func submitAnswer() {
        if game == nil { return }
        
        if game!.submitAnswer(currentAnswer, forChengyuAtIndex: focusedCellID) {
            //Submitted a right answer :
            goodAnswer += 1
            selectedButtons.forEach { btn in
                btn.isEnabled = false
                UIView.animate(withDuration: 0.5) {
                    btn.alpha = 0
                }
            }
            gameView.carousselView.reloadData()
            
            if game!.currentChengyus!.count == 0 {
                //Did answered the last question :
                if game!.prepareNextChengyus() {
                    UIView.animate(withDuration: 0.5) {
                        self.updateButtons()
                    }
                } else {
                    if game!.isGameOver {
                        finishGame()
                    } else {
                        UIView.animate(withDuration: 0.5) {
                            self.setupButtons()
                        }
                    }
                }
            } else {
                //There are still questions to be answered :
                if focusedCellID >= game!.currentChengyus!.count {
                    focusedCellID -= 1
                }
            }
        } else {
            //Submitted a wrong answer :
            wrongAnswer += 1
            selectedButtons.forEach {
                $0.hasBeenSelected = false
            }
        }
        currentAnswer = ""
        selectedButtons.removeAll()
    }

    
    private func updateScoreLabel() {
        gameView.scoreLabel.text = "\(goodAnswer) / \(game!.numberOfChengyus)"
    }
    
    @objc private func exitButtonAction() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let continueAction = UIAlertAction(
            title: String.localize(forKey: "GAME.EXIT_ALERT_CONTINUE"),
            style: .cancel,
            handler: nil
        )
        ac.addAction(continueAction)
        
        let reportAction = UIAlertAction(
            title: String.localize(forKey: "GAME.EXIT_ALERT_REPORT"),
            style: .default,
            handler: { (action) in
                self.sendReportEmail()
                ac.dismiss(animated: true, completion: nil)
        })
        ac.addAction(reportAction)
        
        let exitAction = UIAlertAction(
            title: String.localize(forKey: "GAME.EXIT_ALERT_EXIT"),
            style: .destructive,
            handler: { (action) in
                ac.dismiss(animated: true) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
        })
        ac.addAction(exitAction)
        ac.setTheme()
        present(ac, animated: true)
    }
    
    private func finishGame() {
        let newRecord = GameRecord()
        newRecord.initialize(deckName: selectedDeckName, deckCount: game!.numberOfChengyus, goodAnswers: goodAnswer, wrongAnswers: wrongAnswer)
        
        try! realm.write {
            realm.add(newRecord)
        }

        let nextVC = GameRecordsVC()
        nextVC.newRecordID = newRecord.id
        navigationController?.pushViewController(nextVC, animated: true)
    }
}



//MARK: - GameVC conformation to UICollectionView protocols

extension GameVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chengyus?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as? CarousselCell else {
            return UICollectionViewCell()
        }
        cell.label.text = (chengyus?[indexPath.item].definitions.map({"• " + $0}).joined(separator: "\n"))!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        itemSize = CGSize(width: collectionView.frame.width * 0.7,
        height: collectionView.frame.height)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset = (collectionView.frame.width * 0.3) / 2
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
}


//MARK: - GameVC conformation to UIScrollViewDelegate

extension GameVC: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = gameView.carousselView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let cellWidthAndSpacing = itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthAndSpacing
        let roundedIndex = round(index)
        offset = CGPoint(x: roundedIndex * cellWidthAndSpacing - scrollView.contentInset.left,
                         y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset

        focusedCellID = Int(roundedIndex)
    }
}


extension GameVC: MFMailComposeViewControllerDelegate  {
    
    func sendReportEmail() {
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            let content = String.localize(forKey: "CONTACT.REPORT_ISSUE.CONTENT")
            mail.setMessageBody(content, isHTML: true)
            
            mail.setToRecipients(["mychengyu.app@gmail.com"])
            
            let version = UIDevice.current.systemVersion
            let reason = MoreVC.ContactCase.reportIssue.rawValue
            mail.setSubject(
                String.localize(forKey: "CONTACT.\(reason).SUBJECT")
                .replacingOccurrences(of: "%version%", with: version)
                .replacingOccurrences(of: "%location%", with: "Game")
            )

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
