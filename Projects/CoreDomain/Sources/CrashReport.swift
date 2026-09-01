//
//  CrashReport.swift
//  CoreDomain
//
//  Created by AtenB on 9/1/26.
//

public protocol CrashReport {
    func error(_ error: Error)
    func log(_ message: String)
    func setValue(_ key: String, _ value: Any)
    func send(title: String, function: String, key: String, value: Any, error: any Error)
}
