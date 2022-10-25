import Combine
import Foundation
import UIKit

class UserSavingsService {
    static var shared = UserSavingsService()
    
    var money: Int {
        get {
            return UserDefaults.standard.integer(forKey: "money")
        }
        
        set {
            guard newValue >= 0 else { return }
            UserDefaults.standard.set(newValue, forKey: "money")
        }
    }
    
    var exp: Double {
        get {
            return UserDefaults.standard.double(forKey: "exp")
        }
        
        set {
            guard newValue >= 0 else { return }
            UserDefaults.standard.set(newValue, forKey: "exp")
        }
    }
    
    var sound: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "sound")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "sound")
        }
    }
    
    var bet: Int {
        get {
            return UserDefaults.standard.integer(forKey: "bet")
        }
        
        set {
            guard newValue >= 10_000 else { return }
            UserDefaults.standard.set(newValue, forKey: "bet")
        }
    }
    
    var lastTimeGetBonus: Date? {
        get {
            return UserDefaults.standard.object(forKey: "lastTimeGetBonus") as? Date
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "lastTimeGetBonus")
        }
    }
    
    var canGetBonus: Bool {
        guard let lastTimeGetBonus = lastTimeGetBonus else { return true }
        
        if let timeToGetBonus = Calendar.current.date(byAdding: .day, value: 1, to: lastTimeGetBonus) {
            return Date() >= timeToGetBonus
        }
        
        return false
    }
    
    init () {
        
        UserDefaults.standard.register(defaults: ["money": 1000000])
        UserDefaults.standard.register(defaults: ["exp": 0])
        UserDefaults.standard.register(defaults: ["sound": false])
        UserDefaults.standard.register(defaults: ["bet": 10000])
        
        UserDefaults.standard.register(defaults: ["lastTimeGetBonus": Date(timeIntervalSince1970: 0)])
    }
}
