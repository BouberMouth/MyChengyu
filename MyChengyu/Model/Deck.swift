//
//  Deck.swift
//  MyChengyu
//
//  Created by Antoine on 24/10/2020.
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
