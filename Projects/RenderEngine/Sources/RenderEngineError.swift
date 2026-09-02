//
//  RenderEngineError.swift
//  RenderEngine
//
//  Created by AtenB on 9/2/26.
//

public enum RenderEngineError: Error {
    case fontNotFound(name: String)
    case gradientCreationFailed
    case imageConversionFailed
}
