import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
struct LogsFormView: View {
    let categories: [Category] = Category.allCases
    @EnvironmentObject var viewModel: ExpenseLogViewModel
    @State private var name = ""
    @State private var amount = ""
    @State private var selectedCategory = Category.food
    @State private var date = Date()
    @Environment(\.presentationMode) var presentationMode
    var logToEdit: ExpenseLog?
    
    init(log: ExpenseLog? = nil) {
        self.logToEdit = log
        if let logToEdit = log {
            _name = State(initialValue: logToEdit.name)
            _amount = State(initialValue: "\(logToEdit.amount)")
            _selectedCategory = State(initialValue: logToEdit.category)
            _date = State(initialValue: logToEdit.date.dateValue())
        }
    }
    var body: some View {
        Text(logToEdit == nil ? "Create Expense Log" : "Edit Expense Log")
            .font(.headline).padding(.bottom)
        Form {
            TextField("Name", text: $name)
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
            Picker("Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category.rawValue.capitalized)
                }
            }
            .pickerStyle(MenuPickerStyle())
            DatePicker("Date", selection: $date, displayedComponents: .date)
                .datePickerStyle(DefaultDatePickerStyle())
            
            VStack {
                Spacer()
                Button(action: {
                    saveExpenseLog()
                }) {
                    Text(logToEdit == nil ? "Save" : "Update")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .padding([.leading, .trailing], 10)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .alignmentGuide(HorizontalAlignment.center) { dimension in
                dimension[HorizontalAlignment.center]
            }
        }
    }

    private func saveExpenseLog() {
        guard !name.isEmpty, !amount.isEmpty else {
            print("Please fill out all fields")
            return
        }
        let updatedLog = ExpenseLog(
            id: logToEdit?.id ?? "",
            name: name,
            amount: Double(amount) ?? 0,
            category: selectedCategory,
            date: Timestamp(date: date)
        )
        
        if let logToEdit = logToEdit {
            viewModel.editLog(logId: logToEdit.id!, log: updatedLog) { error in
                if let error = error {
                    print("Error saving expense log:", error.localizedDescription)
                } else {
                    print("Expense log saved successfully")
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        } else {
            let newLog = ExpenseLog(name: name, amount: Double(amount) ?? 0, category: selectedCategory, date: Timestamp(date: date))
            viewModel.addLog(log: newLog) { error in
                if let error = error {
                    print("Error saving expense log:", error.localizedDescription)
                } else {
                    print("Expense log saved successfully")
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
