//
//  UserSettings.swift
//  Timer
//
//  Created by Sergey Savinkov on 29.06.2023.
//

import UIKit

class UserSettings: ObservableObject {
    
    static let shared = UserSettings()
    
    @Published var minInt: Int {
        didSet {
            UserDefaults.standard.set(minInt, forKey: "minInt")
        }
    }
    
    @Published var secInt: Int {
        didSet {
            UserDefaults.standard.set(secInt, forKey: "secInt")
        }
    }
    
    @Published var setInt: Int {
        didSet {
            UserDefaults.standard.set(setInt, forKey: "setInt")
        }
    }
    
    init() {
        self.minInt = UserDefaults.standard.object(forKey: "minInt") as? Int ?? 0
        self.secInt = UserDefaults.standard.object(forKey: "secInt") as? Int ?? 0
        self.setInt = UserDefaults.standard.object(forKey: "setInt") as? Int ?? 0
    }
    
    func updateTimer(model: UserSettings, sets: Int, min: Int, sec: Int) {
        model.setInt = sets
        model.secInt = sec
        model.minInt = min
    }
}
