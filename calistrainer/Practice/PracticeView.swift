//
//  PracticeView.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 18/04/22.
//

import SwiftUI

struct PracticeView: View {
	@Environment(\.presentationMode) var presentationMode

	let exercise: Exercise
	@StateObject var viewModel: PracticeViewModel
	@State private var animationAmount = 1.0
	@State private var isShowingMenu = false

	let audioManager = AudioManager()

	var body: some View {

		ZStack {
			Group {
				Color("PrimaryGray").ignoresSafeArea()
				VStack {
					HStack {
						HStack {
							Text("Reps: ")
								.font(.title)
								.fontWeight(.semibold)
							Text(String(viewModel.exerciseTrackable.repetitionCount))
								.font(.title)
								.fontWeight(.bold)
						}
						.foregroundColor(Color("PrimaryLime"))
						Spacer()
						Button {
							withAnimation {
								isShowingMenu.toggle()
							}
						} label: {
							HStack {
								Text("Finish")
									.fontWeight(.semibold)
								Image(systemName: "checkmark")
							}
							.foregroundColor(Color("PrimaryGray"))
							.padding(.horizontal)
							.padding(.vertical, 10)
							.background(
								RoundedRectangle(cornerRadius: 4)
									.fill(Color("PrimaryLime"))
							)
						}

					}
					.padding(.horizontal)
					.padding(.vertical, 10)

					GeometryReader { geo in
						CameraViewWrapper(viewModel: viewModel)
							.clipShape(RoundedRectangle(cornerRadius: 20))
						StickFigureView(viewModel: viewModel, size: geo.size)
					}.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 1920/1080, alignment: .bottom)
				}
			}
			.blur(radius: isShowingMenu ? 30 : 0)
			if isShowingMenu {
				AlertView(
					title: "Are you done?",
					leftButtonLabel: "Continue exercise",
					rightButtonLabel: "Finish exercise") {
						withAnimation {
							isShowingMenu.toggle()
						}
					} rightButtonAction: {
						self.presentationMode.wrappedValue.dismiss()
					}
			}
			//			VStack {
			//				Spacer()
			//				switch viewModel.exerciseTrackable.currentExerciseStage {
			//				case .neutral:
			//					Text("LOWER")
			//						.font(.title)
			//						.fontWeight(.bold)
			//						.foregroundColor(.orange)
			//						.onAppear {
			//							audioManager.playSound(sound: "fail", type: "wav")
			//						}
			//				case .contracting:
			//					Text("HOLD")
			//						.font(.title2)
			//						.fontWeight(.bold)
			//						.foregroundColor(.orange)
			//						.scaleEffect(animationAmount)
			//						.animation(.easeOut(duration: 2), value: animationAmount)
			//						.onAppear {
			//							animationAmount += 1
			//							audioManager.playSound(sound: "buildup", type: "wav")
			//						}
			//						.onDisappear {
			//							animationAmount -= 1
			//						}
			//				case .returning:
			//					Text("RETURN")
			//						.font(.title)
			//						.fontWeight(.bold)
			//						.foregroundColor(.orange)
			//						.onAppear {
			//							audioManager.playSound(sound: "bell", type: "wav")
			//						}
			//						.onDisappear {
			//							audioManager.playSound(sound: "slap", type: "wav")
			//						}
			//				}
			//			}
		}

	}
}
