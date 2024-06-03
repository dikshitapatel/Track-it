import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ExpenseLogViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var logs = [ExpenseLog]()
    let firebaseManager = FirebaseManager.shared


    func fetchData() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let userID = currentUser.uid
        db.collection("expenseLogs").document(userID).collection("expenses")
            .order(by: "date", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.logs = documents.compactMap { document in
                    try? document.data(as: ExpenseLog.self)
                }
            }
    }
    
    func addLog(log: ExpenseLog, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(NSError(domain: "ExpenseLogViewModel", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        let userID = currentUser.uid
        let userDocumentRef = db.collection("expenseLogs").document(userID)
        let documeref = userDocumentRef.collection("expenses")
        
        do {
            try documeref.addDocument(from: log) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        } catch {
            completion(error)
        }
    }
    
    func deleteLog(_ log: ExpenseLog) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let userID = currentUser.uid
        let userDocumentRef = db.collection("expenseLogs").document(userID)
        let documeref = userDocumentRef.collection("expenses")
        
        if let logID = log.id {
            documeref.document(logID).delete { error in
                    if let error = error {
                        print("Error deleting log: \(error)")
                    }
                }
            }
        }
    
    func deleteLogs(at offsets: IndexSet) {
            let logIDsToDelete = offsets.compactMap { logs[$0].id }
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let userID = currentUser.uid
        let userDocumentRef = db.collection("expenseLogs").document(userID)
        let documeref = userDocumentRef.collection("expenses")
        
        logIDsToDelete.forEach { logID in
            documeref.document(logID).delete { error in
                    if let error = error {
                        print("Error deleting log: \(error)")
                    }
                }
            }
        }
    
    func editLog(logId: String, log: ExpenseLog, completion: @escaping (Error?) -> Void) {
        let logData: [String: Any] = [
            "name": log.name,
            "amount": log.amount,
            "category": log.category.rawValue,
            "date": log.date
        ]
        
        guard let currentUser = Auth.auth().currentUser else {
            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Current user is nil"]))
            return
        }
        
        let userID = currentUser.uid
        let logDocumentRef = db.collection("expenseLogs").document(userID).collection("expenses").document(logId)
        
        logDocumentRef.setData(logData, merge: true) { error in
            if let error = error {
                print("Error updating log: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Log updated successfully")
                completion(nil)
            }
        }
    }
}
extension Timestamp: Comparable {
    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.dateValue() < rhs.dateValue()
    }
}
    
extension Timestamp {
        func toDate() -> Date? {
            return self.dateValue()
        }
}


