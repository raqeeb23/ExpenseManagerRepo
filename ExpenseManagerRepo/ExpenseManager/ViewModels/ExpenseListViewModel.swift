import Foundation
import SwiftUI

@MainActor
final class ExpenseListViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: ExpenseCategory? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let expenseStore: ExpenseStoreProtocol

    init(expenseStore: ExpenseStoreProtocol) {
        self.expenseStore = expenseStore
    }

    func loadExpenses() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let loadedExpenses = try await expenseStore.loadExpenses()
                await MainActor.run {
                    self.expenses = loadedExpenses.sorted(by: { $0.date > $1.date })
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    func addExpense(_ expense: Expense) {
        expenses.insert(expense, at: 0)
        save()
    }

    func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
        save()
    }

    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
        save()
    }

    func filteredExpenses() -> [Expense] {
        expenses.filter { expense in
            let matchesCategory = selectedCategory == nil || expense.category == selectedCategory
            let search = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let matchesSearch = search.isEmpty || expense.title.localizedCaseInsensitiveContains(search) || expense.notes.localizedCaseInsensitiveContains(search)
            return matchesCategory && matchesSearch
        }
    }

    var totalSpent: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    func totalSpent(for category: ExpenseCategory?) -> Double {
        guard let category else {
            return totalSpent
        }
        return expenses
            .filter { $0.category == category }
            .reduce(0) { $0 + $1.amount }
    }

    func count(for category: ExpenseCategory?) -> Int {
        guard let category else {
            return expenses.count
        }
        return expenses.filter { $0.category == category }.count
    }

    var averageExpense: Double {
        guard !expenses.isEmpty else { return 0 }
        return totalSpent / Double(expenses.count)
    }

    private func save() {
        let snapshot = expenses
        Task {
            do {
                try await expenseStore.saveExpenses(snapshot)
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
