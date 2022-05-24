//
//  MainTabView.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 15/03/22.
//

import SwiftUI

struct MainTabView: View {
	var body: some View {
		TabView {
			HomeView()
				.tabItem {
					Label("Practice", systemImage: "figure.walk")
				}
			ExerciseLogsView()
				.tabItem {
					Label("Exercise Log", systemImage: "heart.text.square.fill")
				}
		}
	}
}

struct MainTabView_Previews: PreviewProvider {
	static var previews: some View {
		MainTabView()
			.preferredColorScheme(.dark)
	}
}
