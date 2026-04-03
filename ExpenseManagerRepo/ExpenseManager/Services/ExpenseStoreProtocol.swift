import Foundation

protocol ExpenseStoreProtocol {
    func loadExpenses() async throws -> [Expense]
    func saveExpenses(_ expenses: [Expense]) async throws
}
