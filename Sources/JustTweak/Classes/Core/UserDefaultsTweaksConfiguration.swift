//
//  UserDefaultsTweaksConfiguration.swift
//  Copyright (c) 2016 Just Eat Holding Ltd. All rights reserved.
//

import Foundation

final public class UserDefaultsTweaksConfiguration: NSObject, MutableTweaksConfiguration {
    
    private let userDefaults: UserDefaults
    
    private static let userDefaultsKeyPrefix = "lib.fragments.userDefaultsKey"
    
    public var logClosure: TweaksLogClosure?
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    public func isFeatureEnabled(_ feature: String) -> Bool {
        let userDefaultsKey = userDefaultsKeyForTweakWithIdentifier(feature)
        return userDefaults.bool(forKey: userDefaultsKey)
    }

    public func tweakWith(feature: String, variable: String) -> Tweak? {
        let userDefaultsKey = userDefaultsKeyForTweakWithIdentifier(variable)
        let userDefaultsValue = userDefaults.object(forKey: userDefaultsKey)
        guard let value = tweakValueFromUserDefaultsObject(userDefaultsValue as AnyObject?) else { return nil }
        return Tweak(feature: feature,
                     variable: variable,
                     value: value,
                     title: nil,
                     group: nil)
    }
    
    public func activeVariation(for experiment: String) -> String? {
        return nil
    }

    public func deleteValue(feature: String, variable: String) {
        userDefaults.removeObject(forKey: userDefaultsKeyForTweakWithIdentifier(variable))
    }
    
    public func set(_ value: Bool, feature: String, variable: String) {
        updateUserDefaultsWith(value: value, feature: feature, variable: variable)
    }
    
    public func set(_ value: String, feature: String, variable: String) {
        updateUserDefaultsWith(value: value, feature: feature, variable: variable)
    }
    
    public func set(_ value: NSNumber, feature: String, variable: String) {
        updateUserDefaultsWith(value: value, feature: feature, variable: variable)
    }
    
    private func updateUserDefaultsWith(value: Any, feature: String, variable: String) {
        userDefaults.set(value, forKey: userDefaultsKeyForTweakWithIdentifier(variable))
        userDefaults.synchronize()
        let notificationCenter = NotificationCenter.default
        let userInfo = [TweaksConfigurationDidChangeNotificationTweakIdentifierKey: variable]
        notificationCenter.post(name: TweaksConfigurationDidChangeNotification,
                                object: self,
                                userInfo: userInfo)
    }
    
    private func userDefaultsKeyForTweakWithIdentifier(_ identifier: String) -> String {
        return "\(UserDefaultsTweaksConfiguration.userDefaultsKeyPrefix).\(identifier)"
    }
    
    private func tweakValueFromUserDefaultsObject(_ object: AnyObject?) -> TweakValue? {
        if let object = object as? String {
            return object
        }
        else if let object = object as? NSNumber {
            return object.tweakValue
        }
        return nil
    }
}
