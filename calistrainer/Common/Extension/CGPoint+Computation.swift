//
//  CGPoint+Computation.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 18/04/22.
//

import Foundation
import UIKit

extension CGPoint {

	func distance(to point: CGPoint) -> CGFloat {
		return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
	}

	static func findDistance(from pointA: CGPoint, to pointB: CGPoint) -> CGFloat {
		return sqrt(pow(pointA.x - pointB.x, 2) + pow(pointA.y - pointB.y, 2))
	}

	static func findGradient(from pointA: CGPoint, to pointB: CGPoint) -> CGFloat {
		return (pointB.y - pointA.y) / (pointB.x - pointA.x)
	}

	static func findAngle(from pointA: CGPoint, to pointB: CGPoint) -> CGFloat {
		return atan2(pointB.y - pointA.y, pointB.x - pointA.x)
	}
	
}
