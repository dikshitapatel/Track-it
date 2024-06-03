//
//  SelectSortOrderView.swift
//  TrackIT
//
//  Created by Raj Shah on 4/18/24.
//

import SwiftUI
struct SelectSortOrderView: View {
    @ObservedObject var viewModel: SelectSortOrderViewModel
    
    private let sortTypes = SortType.allCases
    private let sortOrders = SortOrder.allCases
    
    var body: some View {
        HStack {
            Text("Sort by")
            Picker(selection: $viewModel.sortType, label: Text("Sort by")) {
                ForEach(SortType.allCases) { type in
                    Image(systemName: type == .date ? "calendar" : "dollarsign.circle")
                        .tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Text("Order by")
            Picker(selection: $viewModel.sortOrder, label: Text("Order")) {
                ForEach(sortOrders) { order in
                    Image(systemName: order == .ascending ? "arrow.up" : "arrow.down")
                        .tag(order)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding(.all)
        .frame(height: 64)
    }
}
