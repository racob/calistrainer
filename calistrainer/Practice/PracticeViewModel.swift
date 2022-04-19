//
//  PracticeViewModel.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 18/04/22.
//

import Foundation

import AVFoundation
import Vision
import Combine

class PracticeViewModel: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {

	@Published var bodyParts = [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]()
//	var moveCount = 0
	var bodyInFrame = false

	let sequenceHandler = VNSequenceRequestHandler()
	var subscriptions = Set<AnyCancellable>()
	var initTimer: Timer? = nil
	var bodyInFrameTimer = 0

	let exerciseTrackable: ExerciseTrackable

	init(exerciseTrackable: ExerciseTrackable) {
		self.exerciseTrackable = exerciseTrackable
		super.init()
		$bodyParts
			.dropFirst()
			.sink(receiveValue: { bodyParts in self.checkIfBodyInFrame(bodyParts: bodyParts)})
			.store(in: &subscriptions)
	}

	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		let humanBodyRequest = VNDetectHumanBodyPoseRequest(completionHandler: detectedBodyPose)
		do {
			try sequenceHandler.perform(
				[humanBodyRequest],
				on: sampleBuffer,
				orientation: .right)
		} catch {
			print(error.localizedDescription)
		}
	}

	func detectedBodyPose(request: VNRequest, error: Error?) {
		guard let bodyPoseResults = request.results as? [VNHumanBodyPoseObservation] else { return }
		guard let bodyParts = try? bodyPoseResults.first?.recognizedPoints(.all) else { return }
		DispatchQueue.main.async {
			self.bodyParts = bodyParts
		}
	}

	func checkIfBodyInFrame(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {
		if bodyParts.count < 15 {
			self.bodyInFrameTimer = 0
			self.initTimer?.invalidate()
		} else {
			if bodyInFrameTimer > 3 {
				subscriptions.removeAll()
				bodyInFrame = true
				startMoveCount()
			} else {
				if self.initTimer == nil {
					self.initTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
						self.bodyInFrameTimer += 1
					})
				}
			}
		}
	}

	func startMoveCount() {
		$bodyParts
			.dropFirst()
			.sink(receiveValue: { bodyParts in self.exerciseTrackable.countRepetition(bodyParts: bodyParts)})
			.store(in: &subscriptions)

//		self.exerciseTrackable.moveCount.sink { value in
//			self.squatCount += value
//		}.store(in: &subscriptions)
	}

}
