#if DEBUG
    final class MockUserDefaults: UserDefaultsProtocol {
        var values: [String: Any] = [:]

        func set(_ value: Any?, forKey defaultName: String) {
            values[defaultName] = value
        }

        func stringArray(forKey defaultName: String) -> [String]? {
            values[defaultName] as? [String]
        }
    }
#endif
