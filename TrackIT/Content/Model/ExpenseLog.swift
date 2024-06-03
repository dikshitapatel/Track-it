//
//  ExpenseLog.swift
//  TrackIT
//
//  Created by Vrushali Shah on 4/17/24.
//
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ExpenseLog: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var amount: Double
    var category: Category 
    var date: Timestamp
}
