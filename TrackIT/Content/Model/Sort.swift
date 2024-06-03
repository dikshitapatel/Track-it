//
//  Sort.swift
//  TrackIT
//
//  Created by Raj Shah on 4/18/24.
//

import Foundation

enum SortType: String, CaseIterable {
    case date
    case amount
}

enum SortOrder: String, CaseIterable {
    case ascending
    case descending
}

extension SortType: Identifiable {
    var id: String {rawValue}
}

extension SortOrder: Identifiable {
    var id: String {rawValue}
}
