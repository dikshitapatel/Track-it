//
//  FilterCategoriesViewModel.swift
//  TrackIT
//
//  Created by Raj Shah on 5/1/24.
//
import SwiftUI
import Combine

class FilterCategoriesViewModel: ObservableObject {
    @Published var selectedCategories: Set<Category> = []
    let categories = Category.allCases
    
    func toggleCategory(_ category: Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}
