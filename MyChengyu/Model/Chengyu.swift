//
//  Model.swift
//  MyChengyu
//
//  Created by Antoine on 01/07/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import Foundation
import RealmSwift


struct Chengyu: CustomStringConvertible {
    
    //MARK: - Properties
    let index: Int
    let simpChengyu: String
    let tradChengyu: String
    let pinyin: String
    let definitions: [String]
    var isFavorite: Bool {
        return try! Realm().objects(Deck.self).first!.chengyuIndexes.contains(index)
    }
    var description: String {
        return "\(index). \(preferredForm()) \(pinyin)\n\(definitions.joined(separator: "; "))\n\(isFavorite ? "Favorite" : "Not Favorite")"
    }
    
    func preferredForm() -> String {
        if UserDefaults.standard.string(forKey: UserDefaultsKeys.characterPreferenceKey) == "SIMP" {
            return simpChengyu
        } else {
            return tradChengyu
        }
            
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
                                     simpChengyu: components[1],
                                     tradChengyu: components[2],
                                     pinyin: components[4],
                                     definitions: components[3].components(separatedBy: "; "))
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
