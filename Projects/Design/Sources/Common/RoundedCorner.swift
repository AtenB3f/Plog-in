//
//  RoundedCorner.swift
//  Design
//
//  Created by AtenB on 4/8/25.
//

//import SwiftUI
//
//public struct RoundedCorner: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//    public func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}
import SwiftUI

public struct Corner: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let topLeft = Corner(rawValue: 1 << 0)
    public static let topRight = Corner(rawValue: 1 << 1)
    public static let bottomLeft = Corner(rawValue: 1 << 2)
    public static let bottomRight = Corner(rawValue: 1 << 3)
    public static let top: Corner = [.topLeft, .topRight]
    public static let bottom: Corner = [.bottomLeft, .bottomRight]
    public static let all: Corner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}

@available(iOS 13.0, *)
public struct RoundedCorner: Shape {
    var radius: CGFloat
    var corner: Corner

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let tl = (corner.contains(.topLeft) || corner.contains(.all)) ? radius : 0
        let tr = (corner.contains(.topRight) || corner.contains(.all)) ? radius : 0
        let bl = (corner.contains(.bottomLeft) || corner.contains(.all)) ? radius : 0
        let br = (corner.contains(.bottomRight) || corner.contains(.all)) ? radius : 0

        path.move(to: CGPoint(x: rect.minX + tl, y: rect.minY))

        // top line
        path.addLine(to: CGPoint(x: rect.maxX - tr, y: rect.minY))
        // top-right corner
        path.addArc(center: CGPoint(x: rect.maxX - tr, y: rect.minY + tr),
                    radius: tr,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)

        // right line
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))
        // bottom-right corner
        path.addArc(center: CGPoint(x: rect.maxX - br, y: rect.maxY - br),
                    radius: br,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)

        // bottom line
        path.addLine(to: CGPoint(x: rect.minX + bl, y: rect.maxY))
        // bottom-left corner
        path.addArc(center: CGPoint(x: rect.minX + bl, y: rect.maxY - bl),
                    radius: bl,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)

        // left line
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + tl))
        // top-left corner
        path.addArc(center: CGPoint(x: rect.minX + tl, y: rect.minY + tl),
                    radius: tl,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)

        return path
    }
}
