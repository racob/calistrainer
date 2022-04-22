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
	var bodyInFrame = false
	
	let sequenceHandler = VNSequenceRequestHandler()
	var subscriptions = Set<AnyCancellable>()
	var initTimer: Timer? = nil
	var bodyInFrameCount = 0.0
	var progressTimer: Timer? = nil
	var progressValue = 0.0
	
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
		let requiredParts = [
			bodyParts[.rightAnkle]?.location,
			bodyParts[.leftAnkle]?.location,
			bodyParts[.rightWrist]?.location,
			bodyParts[.leftWrist]?.location,
			bodyParts[.nose]?.location
		]
		if requiredParts.contains(CGPoint(x: 0.0, y: 1.0)) {
			self.bodyInFrameCount = 0
			self.initTimer?.invalidate()
			self.initTimer = nil
		} else {
			if bodyInFrameCount > 3 {
				subscriptions.removeAll()
				bodyInFrame = true
				self.initTimer?.invalidate()
				self.initTimer = nil
				startMoveCount()
			} else {
				if self.initTimer == nil {
					self.initTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
						self.bodyInFrameCount += 1
					})
				}
			}
		}
	}
	
	func startMoveCount() {
		$bodyParts
			.dropFirst()
			.sink(receiveValue: { bodyParts in
				self.exerciseTrackable.countRepetition(bodyParts: bodyParts)
				self.handleProgressView()
			})
			.store(in: &subscriptions)
	}
	
	func handleProgressView() {
		if exerciseTrackable.currentExerciseStage == .contracting && progressTimer == nil {
			progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
				if self.progressValue < 2.0 {
					self.progressValue += 0.1
				}
			})
		} else if exerciseTrackable.currentExerciseStage == .neutral {
			progressTimer?.invalidate()
			progressTimer = nil
			progressValue = 0
		}
	}
	
}
