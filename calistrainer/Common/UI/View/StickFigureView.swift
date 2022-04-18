//
//  StickFigureView.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 18/04/22.
//

import SwiftUI

struct StickFigureView: View {

	@ObservedObject var viewModel: PracticeViewModel
	var size: CGSize

	var body: some View {
		if viewModel.bodyParts.isEmpty == false {
			ZStack {
				// Right leg
				Stick(
					points: [
						viewModel.bodyParts[.rightAnkle]!.location,
						viewModel.bodyParts[.rightKnee]!.location,
						viewModel.bodyParts[.rightHip]!.location,
						viewModel.bodyParts[.root]!.location
					],
					size: size
				)
					.stroke(lineWidth: 5.0)
					.fill(Color.green)

				// Left leg
				Stick(
					points: [
						viewModel.bodyParts[.leftAnkle]!.location,
						viewModel.bodyParts[.leftKnee]!.location,
						viewModel.bodyParts[.leftHip]!.location,
						viewModel.bodyParts[.root]!.location
					],
					size: size
				)
					.stroke(lineWidth: 5.0)
					.fill(Color.green)

				// Right arm
				Stick(
					points: [
						viewModel.bodyParts[.rightWrist]!.location,
						viewModel.bodyParts[.rightElbow]!.location,
						viewModel.bodyParts[.rightShoulder]!.location,
						viewModel.bodyParts[.neck]!.location
					],
					size: size
				)
					.stroke(lineWidth: 5.0)
					.fill(Color.green)

				// Left arm
				Stick(
					points: [
						viewModel.bodyParts[.leftWrist]!.location,
						viewModel.bodyParts[.leftElbow]!.location,
						viewModel.bodyParts[.leftShoulder]!.location,
						viewModel.bodyParts[.neck]!.location
					],
					size: size
				)
					.stroke(lineWidth: 5.0)
					.fill(Color.green)

				// Root to nose
				Stick(
					points: [
						viewModel.bodyParts[.root]!.location,
						viewModel.bodyParts[.neck]!.location,
						viewModel.bodyParts[.nose]!.location
					],
					size: size
				)
					.stroke(lineWidth: 5.0)
					.fill(Color.green)
			}
		}
	}
}
