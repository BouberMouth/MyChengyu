//
//  Model.swift
//  MyChengyu
//
//  Created by Antoine on 01/07/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import Foundation
import RealmSwift

class Deck: Object {
    
    //MARK: - Properties
    @objc dynamic var name: String = ""
    var chengyuIndexes = List<Int>()
    
    
    //MARK: - Methods
    func setupDeck(name: String, chengyuIndexes: [Int]) {
        self.name = name
        for i in chengyuIndexes {
            self.chengyuIndexes.append(i)
        }
    }
    
    func addChengyuIndex(_ index: Int?) {
        if let index = index {
            if !chengyuIndexes.contains(index) {
                chengyuIndexes.append(index)
            }
        }
    }
    
    //MARK: - Static Methods
    static func createDeckWith(_ chengyus: [Chengyu]) -> Deck {
        let newDeck = Deck()
        newDeck.name = String.localize(forKey: "GAME_SETTINGS.ALL_CHENGYUS")
        chengyus.forEach {
            newDeck.addChengyuIndex($0.index)
        }
        return newDeck
    }
}


struct Chengyu: CustomStringConvertible {
    
    //MARK: - Properties
    let index: Int
    let chengyu: String
    let pinyin: String
    let definitions: [String]
    var isFavorite: Bool {
        return try! Realm().objects(Deck.self).first!.chengyuIndexes.contains(index)
    }
    var description: String {
        return "\(index). \(chengyu) \(pinyin)\n\(definitions.joined(separator: "; "))\n\(isFavorite ? "Favorite" : "Not Favorite")"
    }
    
    //MARK: - Static methods
    
    static func decodeChengyuFromTxtFile(_ fileNameWithoutExtension: String) -> [Chengyu] {
        guard let url = Bundle.main.url(forResource: fileNameWithoutExtension, withExtension: "txt") else {
            fatalError("Unable to get the URL for this file: \(fileNameWithoutExtension + ".txt")")
        }
        guard let fileContent = try? String(contentsOf: url) else {
            fatalError("Unable to read the content of \(fileNameWithoutExtension + ".txt")")
        }
        guard let content = fileContent.components(separatedBy: "\n{{ENDOFFILE}}").first else {
            fatalError("Unable to find ENDOFFILE buffer")
        }
        let chengyuStrings = content.components(separatedBy: "\n\n")
        
        var decodedChengyus = [Chengyu]()
        chengyuStrings.forEach { chengyuString in
            let components = chengyuString.components(separatedBy: "\n")
            let newChengyu = Chengyu(index: Int(components[0])!,
                                     chengyu: components[1],
                                     pinyin: components[3],
                                     definitions: components[2].components(separatedBy: "; "))
            decodedChengyus.append(newChengyu)
        }
        return decodedChengyus
    }
    
    static func chengyuOfTheDayIn(_ chengyus: [Chengyu]) -> Chengyu {
        let cal = Calendar.current
        if let day = cal.ordinality(of: .day, in: .year, for: Date()) {
            return chengyus[day % chengyus.count]
        } else {
            return chengyus[0]
        }
        
    }
}


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

