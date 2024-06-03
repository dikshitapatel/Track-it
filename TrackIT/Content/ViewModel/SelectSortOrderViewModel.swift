//
//  SelectSortOrderViewModel.swift
//  TrackIT
//
//  Created by Raj Shah on 5/1/24.
//

import SwiftUI
import Combine

class SelectSortOrderViewModel: ObservableObject {
    @Published var sortType: SortType = .date
    @Published var sortOrder: SortOrder = .ascending
}
