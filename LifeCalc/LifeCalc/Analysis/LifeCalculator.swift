//
//  LifeCalculator.swift
//  LifeCalc
//
//  Created by takashi on 2016/04/24.
//  Copyright © 2016年 Takashi Ikeda. All rights reserved.
//

import UIKit
import RealmSwift

class LifeCalculator: NSObject {
    
    // デフォルト計算機は、Realmをデータストアとする
    static let defaultCalculator = LifeCalculator()
    
    func calcLifeExperience() -> [(label : String, content : String)] {
        var results = [(label : String, content : String)]()
        
        results.append(self.calcLifeExperienceOfJobSeconds())
        results.append(self.calcLifeExperienceOfJobRate())
        results.append(self.calcLifeExpectencyOfJobSecondsInAWeek())
        results.append(self.calcLifeExperienceOfLeisureSeconds())
        results.append(self.calcLifeExperienceOfLeisureRate())
        results.append(self.calcLifeExpectencyOfLeisureSecondsInAWeek())
        results.append(self.calcLifeExperienceOfLearningSeconds())
        results.append(self.calcLifeExperienceOfLearningRate())
        results.append(self.calcLifeExpectencyOfLearningSecondsInAWeek())
        
        return results
    }
    
    private func calcLifeExperienceOfJobSeconds() -> (label : String, content : String) {
        
        let label = "\("Working".localized()) (\("sec.".localized()))"
        
        return (label : label, content: "\(self.secondsCalcLifeExperienceOfJob())")
    }
    
    private func calcLifeExperienceOfLeisureSeconds() -> (label : String, content : String) {
        
        let label = "\("Leisure".localized()) (\("sec.".localized()))"
        
        return (label : label, content: "\(self.secondsCalcLifeExperienceOfLeisure())")
    }

    private func calcLifeExperienceOfLearningSeconds() -> (label : String, content : String) {
        
        let label = "\("Learning".localized()) (\("sec.".localized()))"
        
        return (label : label, content: "\(self.secondsCalcLifeExperienceOfLearning())")
    }

    private func calcLifeExperienceOfJobRate() -> (label : String, content : String) {
        
        let label = "\("Working".localized()) \("rate".localized()) (\("%".localized()))"
        let total = self.secondsCalcLifeExperienceOfTotal()
        let partialTime = self.secondsCalcLifeExperienceOfJob()
        let rate = self.rateByRoundIn100Percent(partial: partialTime, total: total)
        
        return (label : label, content: "\(rate)")
    }
    
    private func calcLifeExperienceOfLeisureRate() -> (label : String, content : String) {
        
        let label = "\("Leisure".localized()) \("rate".localized()) (\("%".localized()))"
        let total = self.secondsCalcLifeExperienceOfTotal()
        let partialTime = self.secondsCalcLifeExperienceOfLeisure()
        let rate = self.rateByRoundIn100Percent(partial: partialTime, total: total)
        
        return (label : label, content: "\(rate)")
    }
    
    private func calcLifeExperienceOfLearningRate() -> (label : String, content : String) {
        
        let label = "\("Learning".localized()) \("rate".localized()) (\("%".localized()))"
        let total = self.secondsCalcLifeExperienceOfTotal()
        let partialTime = self.secondsCalcLifeExperienceOfLearning()
        let rate = self.rateByRoundIn100Percent(partial: partialTime, total: total)
        
        return (label : label, content: "\(rate)")
    }

    private func calcLifeExpectencyOfJobSecondsInAWeek() -> (label : String, content : String) {
        
        let label = "\("Working".localized()) \("forecast".localized()) \("in a week".localized()) (\("sec.".localized()))"
        
        return (label : label, content: "\(self.secondsCalcLifeExpectencyOfJob(7))")
    }
    
    private func calcLifeExpectencyOfLeisureSecondsInAWeek() -> (label : String, content : String) {
        
        let label = "\("Leisure".localized()) \("forecast".localized()) \("in a week".localized()) (\("sec.".localized()))"
        
        return (label : label, content: "\(self.secondsCalcLifeExpectencyOfLeisure(7))")
    }

    private func calcLifeExpectencyOfLearningSecondsInAWeek() -> (label : String, content : String) {
        
        let label = "\("Learning".localized()) \("forecast".localized()) \("in a week".localized()) (\("sec.".localized()))"
        
        return (label : label, content: "\(self.secondsCalcLifeExpectencyOfLearning(7))")
    }
    
    private func secondsCalcLifeExperienceOfJob() -> Int {
        return self.secondsCalcLifeExperience(self.filterWordsForJob())
    }
    
    private func secondsCalcLifeExperienceOfLeisure() -> Int {
        return self.secondsCalcLifeExperience(self.filterWordsForLeisure())
    }
    
    private func secondsCalcLifeExperienceOfLearning() -> Int {
        return self.secondsCalcLifeExperience(self.filterWordsForLearning())
    }
    
    private func secondsCalcLifeExpectencyOfJob(days : Int) -> Int {
        
        let partialTime = self.secondsCalcLifeExperienceOfJob()
        
        return self.secondsCalcLifeExpectency(partialTime: partialTime, forcastDays: days)
    }
    
    private func secondsCalcLifeExpectencyOfLeisure(days : Int) -> Int {
        
        let partialTime = self.secondsCalcLifeExperienceOfLeisure()
        
        return self.secondsCalcLifeExpectency(partialTime: partialTime, forcastDays: days)
    }
    
    private func secondsCalcLifeExpectencyOfLearning(days : Int) -> Int {
        
        let partialTime = self.secondsCalcLifeExperienceOfLearning()
        
        return self.secondsCalcLifeExpectency(partialTime: partialTime, forcastDays: days)
    }

    private func secondsCalcLifeExpectency(partialTime partialTime :Int, forcastDays : Int) -> Int {
        let total = self.secondsCalcLifeExperienceOfTotal()
        
        let secondsInAWeek = self.secondsActiveTime(forcastDays)
        
        return total == 0 ? 0 : Int((Double(partialTime) / Double(total)) * Double(secondsInAWeek))
    }
    
    func filterWordsForJob() -> [String] {
        return ["job".localized(), "work".localized(), "task".localized(), "business".localized(), "duty".localized(), "report".localized(), "shift".localized(), "overtime".localized(), "part-time".localized()]
    }
    
    func filterWordsForLeisure() -> [String] {
        return ["Leisure".localized(), "holiday".localized(), "play".localized(), "movie".localized(), "music".localized(), "drive".localized(), "walk".localized(), "sport".localized(), "food".localized(), "restaurants".localized(), "cafe".localized(), "rest".localized(), "drink".localized()]
    }
    
    func filterWordsForLearning() -> [String] {
        return ["learn".localized(), "study".localized(), "test".localized(), "exam".localized(), "school".localized(), "cram".localized(), "research".localized()]
    }
    
    private func secondsCalcLifeExperienceOfTotal() -> Int {
        if let realm = try? Realm() {
            let exps = realm.objects(LifeExperience).reduce(0, combine: { (prev, exp) -> Int in
                
                return prev + Int(exp.endsAt.timeIntervalSinceDate(exp.startsAt))
            })
            
            return exps
        }

        return 0
    }
    
    private func secondsCalcLifeExperience(filterWords : [String]) -> Int {
        
        if let realm = try? Realm() {
            
            let exps = realm.objects(LifeExperience).filter(self.orPredicateForAction(filterWords))
                .reduce(0, combine: { (prev, exp) -> Int in
                    return prev + Int(exp.endsAt.timeIntervalSinceDate(exp.startsAt))
                })
            
            return exps
        }
        
        return 0
    }
    
    private func orPredicateForAction(filterWords : [String]) -> NSPredicate {
        var predicates : [NSPredicate] = []
        for filterWord in filterWords {
            predicates.append(NSPredicate(format: "action CONTAINS[c] %@", filterWord))
        }
        
        return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
    }
    
    private func secondsActiveTime(days : Int) -> Int {
        let activeHoursPerDay = 18
        let activeSecondsPerDay = 3600 * activeHoursPerDay
        return activeSecondsPerDay * days
    }
    
    private func rateByRoundIn100Percent(partial partial : Int, total : Int) -> Double {
        // 四捨五入の仕方が微妙ではあるが、暫定的に下記とする
        return total == 0 ? 0.0 : abs(round((Double(partial) / Double(total)) * 1000.0) / 10.0)
    }
}
