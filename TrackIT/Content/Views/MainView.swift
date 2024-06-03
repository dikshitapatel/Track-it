import SwiftUI
import Firebase

struct MainView: View {
    @StateObject var viewModel: ExpenseLogViewModel = ExpenseLogViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
            TabView {
                LogsTabView()
                    .tabItem {
                        VStack {
                            Text("Expense Logs")
                            Image(systemName: "tray")
                        }
                    }.tag(0)
                Dashboard()
                    .tabItem {
                        VStack {
                            Text("Dashboard")
                            Image(systemName: "chart.pie")
                        }
                    }
                    .tag(1)
                
                FinanceNewsView().tabItem {
                    VStack {
                        Text("Financial News")
                        Image(systemName: "newspaper")
                    }
                }
                .tag(2)
                ExpenseVideo().tabItem {
                    VStack {
                        Text("Expense Video")
                        Image(systemName: "video")
                    }
                }
                .tag(3)
                
            }
            .environmentObject(viewModel)
            .navigationBarItems(trailing: NavigationLink(destination: ProfileMenuView()) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 24, height: 24)
            }
            )
            .edgesIgnoringSafeArea(.bottom)
        

    }
}
