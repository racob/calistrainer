//
//  PracticeItem.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 15/03/22.
//

import SwiftUI

struct PracticeItem: View {
    var body: some View {
		VStack {
			Spacer()
			Image("Squat")
				.resizable()
				.scaledToFit()
				.clipShape(RoundedRectangle(cornerRadius: 20))
				.mask {
					LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .center, endPoint: .bottom)
				}

			VStack(spacing: 10) {
				Text("The Squats")
					.font(.title)
					.fontWeight(.bold)
				Text("Train your legs")
			}.padding()
			Spacer()
			
		}
    }
}

struct PracticeItem_Previews: PreviewProvider {
    static var previews: some View {
        PracticeItem()
    }
}
