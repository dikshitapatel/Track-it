//
//  FilterCategoriesView.swift
//  TrackIT
//
//  Created by Raj Shah on 4/18/24.
//

import SwiftUI

struct FilterCategoriesView: View {
    @ObservedObject var viewModel: FilterCategoriesViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.categories, id: \.self) { category in
                    FilterButtonView(
                        category: category,
                        isSelected: self.viewModel.selectedCategories.contains(category),
                        onTap: self.viewModel.toggleCategory
                    )
                    .id(category)
                    .padding(.leading, category == self.viewModel.categories.first ? 16 : 0)
                    .padding(.trailing, category == self.viewModel.categories.last ? 16 : 0)
                }
            }
        }
        .padding(.vertical)
    }
}
