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
	
}
