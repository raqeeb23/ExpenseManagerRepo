import Foundation

final class MockExpenseStore: ExpenseStoreProtocol {
    var expenses: [Expense]

    init(expenses: [Expense] = []) {
        self.expenses = expenses
    }

    func loadExpenses() async throws -> [Expense] {
        expenses
    }

    func saveExpenses(_ expenses: [Expense]) async throws {
        self.expenses = expenses
    }

    static let sample = MockExpenseStore(expenses: [
        Expense(title: "Coffee", amount: 180, category: .food, date: Date().addingTimeInterval(-86400)),
        Expense(title: "Uber", amount: 260, category: .transport, date: Date().addingTimeInterval(-3600)),
        Expense(title: "Netflix", amount: 499, category: .entertainment, date: Date().addingTimeInterval(-172800))
    ])
}
