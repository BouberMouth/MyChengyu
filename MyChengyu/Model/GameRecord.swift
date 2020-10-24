//
//  GameRecord.swift
//  MyChengyu
//
//  Created by Antoine on 24/10/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import Foundation
import RealmSwift

class GameRecord: Object {
    @objc dynamic var id = 0
    @objc dynamic var date = Date()
    @objc dynamic var deckName = ""
    @objc dynamic var deckCount = 0
    @objc dynamic var goodAnswers = 0
    @objc dynamic var wrongAnswers = 0
    
    var score: Double {
        return round((Double(goodAnswers) / Double(goodAnswers + wrongAnswers))*1000) / 10
    }
    
    func initialize(deckName: String, deckCount: Int, goodAnswers: Int, wrongAnswers: Int) {
        let uniqueID = UserDefaults.standard.integer(forKey: UserDefaultsKeys.newRecordIDKey)
        self.id = uniqueID
        UserDefaults.standard.set(uniqueID + 1, forKey: UserDefaultsKeys.newRecordIDKey)
        
        self.deckName = deckName
        self.deckCount = deckCount
        self.goodAnswers = goodAnswers
        self.wrongAnswers = wrongAnswers
        
        print(self)
    }
}
