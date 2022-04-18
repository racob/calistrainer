//
//  SquatsTrackable.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 18/04/22.
//

import Foundation
import Combine
import Vision

final class SquatsTrackable: ExerciseTrackable {

	var moveCount = PassthroughSubject<Int, Never>()
	var currentExerciseStage: ExerciseStage = .neutral

	private var holdTimer: Timer?
	private var holdCount = 0

	private var feedbackTimer: Timer?
	private var feedbackCounter = 0

	let speechSynthesizer = SpeechSynthesizer()

	func countRepetition(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {

		startFeedbackTimer(bodyParts: bodyParts)

		// declare the needed body points
		let rightKnee = bodyParts[.rightKnee]!.location
		let rightHip = bodyParts[.rightHip]!.location
		let rightAnkle = bodyParts[.rightAnkle]!.location

		// calculate knees angles after standing from squat
		let firstAngle = atan2(rightHip.y - rightKnee.y, rightHip.x - rightKnee.x)
		let secondAngle = atan2(rightAnkle.y - rightKnee.y, rightAnkle.x - rightKnee.x)
		var angleDiffRadians = firstAngle - secondAngle
		while angleDiffRadians < 0 {
			angleDiffRadians += CGFloat(2 * Double.pi)
		}

		let angleDiffDegrees = Int(angleDiffRadians * 180 / .pi)
		if angleDiffDegrees > 150 {
			if currentExerciseStage == .returning {
				moveCount.send(1)
			}
			self.currentExerciseStage = .neutral
		}

		// detects when body is in lower position of a squat
		let hipHeight = rightHip.y
		let kneeHeight = rightKnee.y
		if hipHeight < kneeHeight {
			if self.currentExerciseStage == .neutral {
				self.currentExerciseStage = .contracting
			}
			countHoldPosition()
		}

	}

	func countHoldPosition() {
		guard holdTimer == nil else { return }
		holdTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
			if self.currentExerciseStage == .contracting {
				self.holdCount += 1
			} else {
				self.holdCount = 0
				timer.invalidate()
				self.holdTimer = nil
			}

			if self.holdCount > 1 {
				self.currentExerciseStage = .returning
				self.holdCount = 0
				timer.invalidate()
				self.holdTimer = nil
			}
		})
	}

	func startFeedbackTimer(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {
		guard feedbackTimer == nil else { return }

		feedbackTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
			self.feedbackCounter += 1
			if self.feedbackCounter > 4 {
				self.feedbackCounter = 0
				self.assertKneesForm(bodyParts: bodyParts)

				timer.invalidate()
				self.feedbackTimer = nil
			}
		})
	}

	private func assertKneesForm(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {
		guard currentExerciseStage == .neutral else { return }

		let rightKnee = bodyParts[.rightKnee]!.location
		let leftKnee = bodyParts[.leftKnee]!.location
		let rightAnkle = bodyParts[.rightAnkle]!.location
		let leftAnkle = bodyParts[.leftAnkle]!.location

		// detects good posture when knees are spread out further than the legs
		let kneeDistance = rightKnee.distance(to: leftKnee)
		let ankleDistance = rightAnkle.distance(to: leftAnkle)

		print("knees = \(kneeDistance), ankles = \(ankleDistance)")
		if ankleDistance > kneeDistance {
			speechSynthesizer.speak("Make sure your knees are in outward direction")
		}
	}
}

