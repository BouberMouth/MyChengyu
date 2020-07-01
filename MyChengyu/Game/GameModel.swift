//
//  GameModel.swift
//  I Learn Chengyus
//
//  Created by Antoine on 12/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import Foundation

struct Game {
    //MARK: - Properties
    
    var answerComponents: [Character]?
    var answeredChengyus = [Chengyu]()
    var chengyus: [Chengyu]
    var currentChengyus: [Chengyu]?
    var isGameOver = false
    var level: Level
    var numberOfChengyus: Int
    
    //MARK: - Methods
    
    init(chengyus: [Chengyu], level: Level) {
        self.chengyus = chengyus
        self.level = level
        self.numberOfChengyus = chengyus.count
        _ = prepareNextChengyus()
    }
    
    /**
     
     */
    mutating func prepareNextChengyus() -> Bool {
        var didPrepareNormally = true

        if chengyus.count == 0 {
            //Doesn't prepare, end the game
            isGameOver = true
            return false
        }
        if chengyus.count < level.intValue() {
            //Will prepare, but adjusts the level -> did not prepare normally
            switch chengyus.count {
            case 1, 2:
                level = .oneByOne
            case 3, 4:
                level = .threeByThree
            default:
                break
            }
            didPrepareNormally = false
        }
        
        currentChengyus = [Chengyu]()
        for _ in 0..<level.intValue() {
            currentChengyus?.append(chengyus.remove(at: Int.random(in: 0..<chengyus.count)))
        }
        answerComponents = Array(currentChengyus!.map({$0.chengyu}).joined()).shuffled()
        return didPrepareNormally
    }
    
    /**
     
     */
    mutating func submitAnswer(_ answer: String, forChengyuAtIndex index: Int) -> Bool {
        if currentChengyus![index].chengyu == answer {
            answeredChengyus.append(currentChengyus!.remove(at: index))
            return true
        } else {
            return false
        }
    }
}


enum Level: String, CaseIterable {
    case oneByOne = "1 by 1"
    case threeByThree = "3 by 3"
    case fiveByFive = "5 by 5"
    
    func intValue() -> Int {
        switch self {
        case .oneByOne:
            return 1
        case .threeByThree:
            return 3
        case .fiveByFive:
            return 5
        }
    }
    
    func stringValue() -> String {
        switch self {
        case .oneByOne:
            return String.localize(forKey: "GAME.1BY1")
        case .threeByThree:
            return String.localize(forKey: "GAME.3BY3")
        case .fiveByFive:
            return String.localize(forKey: "GAME.5BY5")
        }
    }
}
