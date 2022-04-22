//
//  ExerciseStage.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 18/04/22.
//

import Foundation

enum ExerciseStage {
	case neutral
	case contracting
	case returning
}

extension ExerciseStage {
	static func promptString(exercise: Exercise, stage: ExerciseStage) -> String {
		switch stage {
		case .neutral:
			switch exercise {
			case .squat: return "LOWER"
			}
		case .contracting:
			switch exercise {
			case .squat: return "HOLD"
			}
		case .returning:
			switch exercise {
			case .squat: return "RETURN"
			}
		}
	}
}
