//
//  ExerciseLogsViewModel.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 24/05/22.
//

import Foundation
import CoreData

final class ExerciseLogsViewModel: ObservableObject {

	@Published var sessions: [NSManagedObject] = []

	let persistenceManager = PersistenceManager.shared

	func fetchRecordedSessions() {
		let managedContext = persistenceManager.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PracticeSession")
		do {
			sessions = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}

	func castIntAsString(value: Int16) -> String {
		return String(value)
	}
}
