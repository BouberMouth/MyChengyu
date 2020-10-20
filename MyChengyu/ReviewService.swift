//
//  ReviewService.swift
//  MyChengyu
//
//  Created by Antoine on 01/07/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import Foundation
import StoreKit

struct UserDefaultsKeys {
    static let processCompletedCountKey = "processCompletedCount"
    static let lastVersionPromptedForReviewKey = "lastVersionPromptedForReview"
    static let newRecordIDKey = "newRecordID"
    static let characterPreferenceKey = "characterPreference"
}

class ReviewService {
    
    static let shared = ReviewService()
    
    let userDefaults = UserDefaults.standard
    let reviewTiming = [10, 20, 40]
    
    func increaseCompletedProcesses() {
        var count = userDefaults.integer(forKey: UserDefaultsKeys.processCompletedCountKey)
        count += 1
        userDefaults.set(count, forKey: UserDefaultsKeys.processCompletedCountKey)
        print("NUMBER OF PROCESS COMPLETED: \(count)")
        
        // Get the current bundle version for the app
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String else {
            fatalError("Expected to find a bundle version in the info dictionary")
        }
        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
        
        // Has the process been completed several times and the user has not already been prompted for this version?
        if reviewTiming.contains(count) && currentVersion != lastVersionPromptedForReview {
            let twoSecondsFromNow = DispatchTime.now() + 2.0
            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                SKStoreReviewController.requestReview()
                UserDefaults.standard.set(currentVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
            }
        }
    }
    
    func requestReview() {
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String else {
            fatalError("Expected to find a bundle version in the info dictionary")
        }
        SKStoreReviewController.requestReview()
        UserDefaults.standard.set(currentVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
    }
    
    func requestReviewManually() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL
        guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id1506568839?action=write-review")
            else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(
            writeReviewURL,
            options: [:]) { (success) in
                if success {
                    print("Success")
                } else {
                    print("Failure")
                }
        }
    }
}

