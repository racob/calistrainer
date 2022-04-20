//
//  HomeView.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 14/03/22.
//

import SwiftUI

struct HomeView: View {
	@State private var practiceIndex = 0
	@State private var showPracticeView = false

	var body: some View {
		ZStack {
			Color("PrimaryGray").ignoresSafeArea()
			VStack {
				VStack(alignment: .leading) {
					Text("Hello,")
						.font(.title2)
						.fontWeight(.bold)
						.opacity(0.3)
					Text("Eibiel Sardjanto")
						.font(.title)
						.fontWeight(.bold)
						.foregroundColor(.accentColor)
					Text("Let's practice your calisthenics")
						.fontWeight(.semibold)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding()

				Spacer()

				TabView(selection: $practiceIndex) {
					ForEach((0..<3), id: \.self) { index in
						PracticeItem()
					}
				}
				.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

				PrimaryButton(label: "Start", fullWidth: true) {
					showPracticeView = true
				}
				.padding([.horizontal, .bottom])
				.fullScreenCover(isPresented: $showPracticeView) {
					PracticeView(
						exercise: .squat,
						viewModel: PracticeViewModel(exerciseTrackable: SquatsTrackable())
					)
				}

				Spacer()
			}
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView().preferredColorScheme(.dark)
	}
}
