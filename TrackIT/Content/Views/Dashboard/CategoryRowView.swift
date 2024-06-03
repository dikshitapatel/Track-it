//
//  CategoryRowView.swift
//  TrackIT
//
//  Created by Raj Shah on 4/18/24.
//

import SwiftUI

struct CategorySum: Identifiable, Equatable {
    let sum: Double
    let category: Category
    var id: String { "\(category)\(sum)" }
}

struct CategoryRowView: View {
    let category: Category
    let sum: Double
    
    var body: some View {
        HStack {
            CategoryImageView(category: category)
            Text(category.rawValue.capitalized)
            Spacer()
            Text(sum.formattedCurrencyText)
                .font(.headline)
                .padding(.trailing)
        }
    }
}
