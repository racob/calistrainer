//
//  testview.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 20/04/22.
//

import SwiftUI

struct PracticeButtons: View {

	let countText: String

	@State private var isShowingMenu = false

	var body: some View {
		ZStack {
			Text(countText)
				.font(.title)
				.fontWeight(.bold)
				.padding()
				.background(
					Capsule()
						.fill(.white)
						.shadow(radius: 4)
				)
				.padding()

			Button {
				isShowingMenu.toggle()
			} label: {
				Image(systemName: "checkmark.circle.fill")
					.foregroundColor(.white)
					.scaleEffect(2)
					.shadow(radius: 4)
			}
			.offset(x: 75)
		}
		.confirmationDialog("Are you done?", isPresented: $isShowingMenu, titleVisibility: .visible) {
			Button("Finish exercise") {}
		}
	}
}

struct PracticeButtons_Previews: PreviewProvider {
	static var previews: some View {
		PracticeButtons(countText: "45")
	}
}
