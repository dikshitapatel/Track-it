//
//  SearchBarViewModel.swift
//  TrackIT
//
//  Created by Raj Shah on 5/1/24.
//

import Foundation
import SwiftUI
import Combine

class SearchBarViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var isEditing = false
}
