//
//  FeaturesConfig.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/6/23.
//

import Foundation

// MARK: - Feature Toggles

enum FeatureToggles: String, CaseIterable {
    case mockAPI
}

struct FeatureToggleValue {
    let isEnabled: Bool
}

protocol FeatureTogglesService: AnyObject {
    func getValue(for feature: FeatureToggles) -> FeatureToggleValue
    func overrideLocal(value: Bool?, for feature: FeatureToggles)
}


public struct FeatureTogglesFactory {
    static var sharedService: FeatureTogglesService = {
        return service
    }()

    private static var service: FeatureTogglesServiceImpl = {
        #if !RELEASE
        let store = UserDefaults(suiteName: "FeatureToggles")
        #else
        let store: UserDefaults? = nil
        #endif

        return FeatureTogglesServiceImpl(localStore: store)
    }()

}

private final class FeatureTogglesServiceImpl: FeatureTogglesService {

    func getValue(for feature: FeatureToggles) -> FeatureToggleValue {
        assertMainThread()
        return localValue(for: feature.rawValue, defaultValue: feature.defaultValue)
    }

    func overrideLocal(value: Bool?, for feature: FeatureToggles) {
        assertMainThread()
        if let value = value {
            store?.set(value, forKey: feature.rawValue)
        } else {
            store?.removeObject(forKey: feature.rawValue)
        }
    }

    init(localStore: UserDefaults?) {
        assertMainThread()
        self.store = localStore
    }

    private let store: UserDefaults?

    private func localValue(for key: String, defaultValue: Bool) -> FeatureToggleValue {
        let localValue: Bool? = store?.bool(forKey: key)
        let value = localValue ?? defaultValue
        return FeatureToggleValue(isEnabled: value)
    }
}

struct FeatureTogglesState {
    static let isMockAPIEnabled: Bool = getValue(for: .mockAPI)

    private static func getValue(for toggle: FeatureToggles) -> Bool {
        return threadCheck { FeatureTogglesFactory.sharedService.getValue(for: toggle).isEnabled }
    }

    private static func threadCheck(_ action: @escaping () -> Bool) -> Bool {
        if Thread.isMainThread {
            return action()
        } else {
            assertionFailure()

            var res: Bool = false

            let group = DispatchGroup()
            DispatchQueue.main.async(group: group) {
                res = action()
            }
            group.wait()

            return res
        }
    }
}

extension FeatureToggles {
    var defaultValue: Bool {
        switch self {
        case .mockAPI:
            return false
        }
    }

    /// Описание для чего флаг заведен и на что он влияет. Описание должно быть максимально подробным
    var desc: String {
        switch self {
        case .mockAPI:
            return """
                    Enables mocking request (local JSON)
                   """
        }
    }

    /// Какую задачу имплементирует
    var task: String {
        switch self {
        case .mockAPI:
            return "Task 1"
        }
    }

    /// Емейл автора, т.е. тот кто ФТ заводит
    var author: String {
        switch self {
        case .mockAPI:
            return "Andrew K"
        }
    }
}
