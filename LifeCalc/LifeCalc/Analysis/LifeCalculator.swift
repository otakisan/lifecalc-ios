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
        
        if let realm = try? Realm() {
            let exps = realm.objects(LifeExperience).filter("action CONTAINS %@", "job").reduce(0, combine: { (prev, exp) -> Int in
                
                return prev + Int(exp.endsAt.timeIntervalSinceDate(exp.startsAt))
            })
            
            results.append((label : "Working (sec.)", content: "\(exps)"))
        }
        
        return results
    }

}
