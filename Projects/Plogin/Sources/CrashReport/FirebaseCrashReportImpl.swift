//
//  FirebaseCrashReportImpl.swift
//  Plogin
//
//  Created by AtenB on 9/1/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import FirebaseCrashlytics
import CoreDomain

public class FirebaseCrashReportImpl {
    public init(
        
    ) {
        
    }
}

extension FirebaseCrashReportImpl: CrashReport {
    public func log(_ message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    public func error(_ error: any Error) {
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func setValue(_ key: String, _ value: Any) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    
    /// - Parameters:
    ///    - title: Class / Struct 이름
    ///    - function: 함수명
    ///    - key: value 식별자(value 타입 등)
    ///    - value: Report시 참고할 수 있는 값
    ///    - error: 에러
    public func send(title: String, function: String, key: String, value: Any, error: any Error) {
        self.log("[\(title)] \(function): \(error)")
        self.setValue("\(key)", value)
        self.error(error)
    }
}
