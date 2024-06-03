import SwiftUI
import SwiftUICharts

struct Dashboard: View {
    @EnvironmentObject var viewModel: ExpenseLogViewModel
    @State private var totalExpenses: Double = 0
    @State private var categoriesSum: [CategorySum] = []
    @State private var orientation = UIDevice.current.orientation
    
    var body: some View {
        Group {
            if orientation.isLandscape {
                landscapeView
            } 
            else {
                portraitView
            }
        }
        .padding(.top)
        .onAppear {
            fetchData()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    // Avoid navigation changes on orientation change
                    if let currentView = UIApplication.shared.windows.first?.rootViewController {
                        currentView.dismiss(animated: false, completion: nil)
                    }
                    self.orientation = UIDevice.current.orientation
                }


    }
    
    private var landscapeView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 4) {
                Text("Total expenses   ")
                    .font(.headline)
                Text(totalExpenses.formattedCurrencyText)
                    .font(.headline)
            }
            HStack(spacing: 20) {
                if totalExpenses > 0 {
                    PieChartView(
                        data: categoriesSum.map { ($0.sum, $0.category.color) },
                        style: Styles.pieChartStyleOne,
                        form: CGSize(width: 300, height: 240),
                        dropShadow: false
                    )
                    ScrollView{
                        VStack {
                            Text("Breakdown").font(.headline)
                            ForEach(categoriesSum) { categorySum in
                                CategoryRowView(category: categorySum.category, sum: categorySum.sum)
                            }
                        }
                    }
                }
                else
                {
                    Text("No expenses data\nPlease add your expenses from the logs tab")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
        }
    }
    
    private var portraitView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                Text("Total expenses")
                    .font(.headline)
                Text(totalExpenses.formattedCurrencyText)
                    .font(.largeTitle)
            }
            
            if totalExpenses > 0 {
                PieChartView(
                    data: categoriesSum.map { ($0.sum, $0.category.color) },
                    style: Styles.pieChartStyleOne,
                    form: CGSize(width: 300, height: 240),
                    dropShadow: false
                )
                Divider()
                List {
                    Text("Breakdown").font(.headline)
                    ForEach(categoriesSum) { categorySum in
                        CategoryRowView(category: categorySum.category, sum: categorySum.sum)
                    }
                }
            } else {
                Text("No expenses data\nPlease add your expenses from the logs tab")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding(.horizontal)
            }
        }
        .padding(.top)
    }
    
    private func fetchData() {
        guard !viewModel.logs.isEmpty else { return }
        
        totalExpenses = viewModel.logs.map { $0.amount }.reduce(0, +)
        categoriesSum = viewModel.logs.reduce(into: [Category: Double]()) { dict, log in
            dict[log.category, default: 0] += log.amount
        }.map { CategorySum(sum: $0.value, category: $0.key) }
    }
}

