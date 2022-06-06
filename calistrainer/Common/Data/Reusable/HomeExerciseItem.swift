//
//  HomeExerciseItem.swift
//  calistrainer
//
//  Created by Eibiel Sardjanto on 29/05/22.
//

import Foundation

struct HomeExerciseItem: Hashable {
	let exercise: Exercise
	let description: String
	let image: String
	let isSideFacing: Bool
}
