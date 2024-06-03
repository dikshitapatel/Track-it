import SwiftUI

struct LogsTabView: View {
    
    @EnvironmentObject var viewModel: ExpenseLogViewModel
    @StateObject var searchBarViewModel = SearchBarViewModel()
    @StateObject var filterCategoriesViewModel = FilterCategoriesViewModel()
    @StateObject var selectSortOrderViewModel = SelectSortOrderViewModel()
    @State private var orientation = UIDevice.current.orientation
    
    @State private var showingEditSheet = false
    @State private var selectedLog: ExpenseLog? = nil
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        Group {
            if orientation.isLandscape && horizontalSizeClass == .regular {
                ipadlandscapeView
            } else if orientation.isLandscape && horizontalSizeClass != .regular {
                landscapeView
            }
            else {
                portraitView
            }
        }
        .padding(.top)
        .onAppear {
            self.viewModel.fetchData()
        }
        .sheet(item: $selectedLog) { log in
            Spacer()
            LogsFormView(log: log).environmentObject(viewModel)

        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            self.orientation = UIDevice.current.orientation
        }
    }
    
    @ViewBuilder
    private var ipadlandscapeView: some View {
            content
    }
    
    @ViewBuilder
    private var landscapeView: some View {
        ScrollView {
            NavigationView{
                content
            }
        }
    }
    
    
    @ViewBuilder
    private var portraitView: some View {
            content
    }
    
    
    private var content: some View {
        VStack(spacing: 0) {
            HStack(spacing: 4) {
                Text("Expense Logs")
                    .font(.headline)
            }
            HStack{
                Spacer()
                NavigationLink(destination: LogsFormView(log: nil).environmentObject(viewModel)) {
                    Image(systemName: "plus")
                }.padding(.trailing, 20)
            }
            SearchBar(viewModel: searchBarViewModel, placeholder: "Search...")
            FilterCategoriesView(viewModel: filterCategoriesViewModel)
            Divider()
            SelectSortOrderView(viewModel: selectSortOrderViewModel)
            Divider()
            List {
                if viewModel.logs.isEmpty {
                    VStack {
                        Text("No expense added")
                            .font(.headline)
                    }
                } else {
                    ForEach(filteredLogs) { log in
                        HStack(spacing: 16) {
                            CategoryImageView(category: log.category)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(log.name).font(.headline)
                                Text(self.dateFormatter.string(from: log.date.dateValue())).font(.subheadline)
                            }
                            Spacer()
                            Text("\(log.amount.formattedCurrencyText)").font(.headline)
                        }
                        .padding(.vertical, 4)
                        .onTapGesture {
                            self.selectedLog = log
                            self.showingEditSheet = true
                        }
                        
                    }
                    .onDelete(perform: viewModel.deleteLogs)
                }
            }
        }
    }
    
    private var filteredLogs: [ExpenseLog] {
        var logs = viewModel.logs
        if !searchBarViewModel.searchText.isEmpty {
            logs = logs.filter { $0.name.lowercased().contains(searchBarViewModel.searchText.lowercased()) }
        }
        if !filterCategoriesViewModel.selectedCategories.isEmpty {
            logs = logs.filter { filterCategoriesViewModel.selectedCategories.contains($0.category) }
        }
        switch selectSortOrderViewModel.sortType {
        case .date:
            logs.sort(by: { selectSortOrderViewModel.sortOrder == .ascending ? $0.date < $1.date : $0.date > $1.date })
        case .amount:
            logs.sort(by: { selectSortOrderViewModel.sortOrder == .ascending ? $0.amount < $1.amount : $0.amount > $1.amount })
        }
        return logs
    }
    
    private func fetchData() {
        self.viewModel.fetchData()
    }
}
