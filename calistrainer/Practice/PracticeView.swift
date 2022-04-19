//
//  PracticeView.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 18/04/22.
//

import SwiftUI

struct PracticeView: View {

	let exercise: Exercise
	@StateObject var viewModel: PracticeViewModel
	@State private var animationAmount = 1.0

	let audioManager = AudioManager()

	var body: some View {
		VStack {
			ZStack {
				GeometryReader { geo in
					CameraViewWrapper(viewModel: viewModel)
					StickFigureView(viewModel: viewModel, size: geo.size)
				}
				VStack {
					Spacer()
					switch viewModel.exerciseTrackable.currentExerciseStage {
					case .neutral:
						Text("LOWER")
							.font(.title)
							.fontWeight(.bold)
							.foregroundColor(.orange)
							.onAppear {
								audioManager.playSound(sound: "fail", type: "wav")
							}
					case .contracting:
						Text("HOLD")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundColor(.orange)
							.scaleEffect(animationAmount)
							.animation(.easeOut(duration: 2), value: animationAmount)
							.onAppear {
								animationAmount += 1
								audioManager.playSound(sound: "buildup", type: "wav")
							}
							.onDisappear {
								animationAmount -= 1
							}
					case .returning:
						Text("RETURN")
							.font(.title)
							.fontWeight(.bold)
							.foregroundColor(.orange)
							.onAppear {
								audioManager.playSound(sound: "bell", type: "wav")
							}
							.onDisappear {
								audioManager.playSound(sound: "slap", type: "wav")
							}
					}
				}
			}.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 1920 / 1080, alignment: .center)
			HStack {
				if viewModel.bodyInFrame {
					Text(viewModel.exerciseTrackable.currentExerciseStage.rawValue)
					Text("Squat counter:")
						.font(.title)
					Text(String(viewModel.exerciseTrackable.repetitionCount))
						.font(.title)
				} else {
					Text("Stand in front of camera. \(viewModel.bodyInFrameTimer)")
				}
			}
		}
	}
}
