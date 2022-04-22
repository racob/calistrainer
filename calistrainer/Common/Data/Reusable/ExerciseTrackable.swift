//
//  ExerciseTrackable.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 18/04/22.
//

import Foundation
import Vision
import Combine

protocol ExerciseTrackable {
	var repetitionCount: Int { get }
	func countRepetition(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint])
	var currentExerciseStage: ExerciseStage { get }
	var previousExerciseStage: ExerciseStage? { get }
}
