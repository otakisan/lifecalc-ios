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
        // 四捨五入の仕方が微妙ではあるが、暫定的に下記とする
        let rate = self.rateByRoundIn100Percent(partial: partialTime, total: total)
        
        return (label : label, content: "\(rate)")
    }
    
    private func calcLifeExperienceOfLeisureRate() -> (label : String, content : String) {
        
        let label = "\("Leisure".localized()) \("rate".localized()) (\("%".localized()))"
        let total = self.secondsCalcLifeExperienceOfTotal()
        let partialTime = self.secondsCalcLifeExperienceOfLeisure()
        // 四捨五入の仕方が微妙ではあるが、暫定的に下記とする
        let rate = self.rateByRoundIn100Percent(partial: partialTime, total: total)
        
        return (label : label, content: "\(rate)")
    }
    
    private func calcLifeExperienceOfLearningRate() -> (label : String, content : String) {
        
        let label = "\("Learning".localized()) \("rate".localized()) (\("%".localized()))"
        let total = self.secondsCalcLifeExperienceOfTotal()
        let partialTime = self.secondsCalcLifeExperienceOfLearning()
        // 四捨五入の仕方が微妙ではあるが、暫定的に下記とする
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
        
        if let realm = try? Realm() {
            let exps = realm.objects(LifeExperience).filter("action CONTAINS[c] %@ OR action CONTAINS[c] %@", "job".localized(), "work".localized()).reduce(0, combine: { (prev, exp) -> Int in
                
                return prev + Int(exp.endsAt.timeIntervalSinceDate(exp.startsAt))
            })
            
            return exps
        }
        
        return 0
    }
    
    private func secondsCalcLifeExperienceOfLeisure() -> Int {
        
        if let realm = try? Realm() {
            let exps = realm.objects(LifeExperience).filter("action CONTAINS[c] %@ OR action CONTAINS[c] %@", "Leisure".localized(), "holiday".localized()).reduce(0, combine: { (prev, exp) -> Int in
                
                return prev + Int(exp.endsAt.timeIntervalSinceDate(exp.startsAt))
            })
            
            return exps
        }
        
        return 0
    }
    
    private func secondsCalcLifeExperienceOfLearning() -> Int {
        
        if let realm = try? Realm() {
            let exps = realm.objects(LifeExperience).filter("action CONTAINS[c] %@ OR action CONTAINS[c] %@", "learn".localized(), "study".localized()).reduce(0, combine: { (prev, exp) -> Int in
                
                return prev + Int(exp.endsAt.timeIntervalSinceDate(exp.startsAt))
            })
            
            return exps
        }
        
        return 0
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
    
    private func secondsCalcLifeExperienceOfTotal() -> Int {
        if let realm = try? Realm() {
            let exps = realm.objects(LifeExperience).reduce(0, combine: { (prev, exp) -> Int in
                
                return prev + Int(exp.endsAt.timeIntervalSinceDate(exp.startsAt))
            })
            
            return exps
        }

        return 0
    }
    
    private func secondsActiveTime(days : Int) -> Int {
        let activeHoursPerDay = 18
        let activeSecondsPerDay = 3600 * activeHoursPerDay
        return activeSecondsPerDay * days
    }
    
    private func rateByRoundIn100Percent(partial partial : Int, total : Int) -> Double {
        return total == 0 ? 0.0 : abs(round((Double(partial) / Double(total)) * 1000.0) / 10.0)
    }
}
