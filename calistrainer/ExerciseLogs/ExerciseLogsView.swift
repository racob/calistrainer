//
//  ExerciseLogsView.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 24/05/22.
//

import SwiftUI

struct ExerciseLogsView: View {

	@StateObject var viewModel = ExerciseLogsViewModel()
	
    var body: some View {
		ScrollView {
			Text(String(viewModel.sessions.count))
			VStack {
				ForEach(viewModel.sessions, id: \.self) { session in
					HStack {
						Text(session.value(forKey: "exercise") as! String)
						Spacer()
						Text(viewModel.castIntAsString(value: session.value(forKey: "repetitionCount") as! Int16))
					}
					.foregroundColor(.white)
					.padding()

				}
			}
		}
		.onAppear {
			viewModel.fetchRecordedSessions()
		}
    }
}

struct ExerciseLogsView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseLogsView()
    }
}
