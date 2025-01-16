//
//  DI.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Foundation

struct DependencyInjector {
    private static var dependencyList: [String: Any] = [:]
    private static let lock = NSLock()
    
    static func inject<T>() -> T {
        lock.lock()
        defer { lock.unlock() }
        
        guard let t = dependencyList[String(describing: T.self)] as? T else {
            fatalError("No provider registered for type: \(T.self)")
        }
        return t
    }
    
    static func singleton<T>(dependency: T) {
        lock.lock()
        defer { lock.unlock() }
        
        dependencyList[String(describing: T.self)] = dependency
    }
}

@propertyWrapper struct Inject<T> {
    var wrappedValue: T
    
    init() {
        self.wrappedValue = DependencyInjector.inject()
        print("Injected dependency of type \(T.self): \(wrappedValue)")
    }
}

@propertyWrapper struct Singleton<T> {
    var wrappedValue: T
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        DependencyInjector.singleton(dependency: wrappedValue)
        print("Created singleton of type \(T.self): \(wrappedValue)")
    }
}

class Singletons {
    init() {
        @Singleton var serviceable: Serviceable = Service() as Serviceable
        // ...
    }
}
