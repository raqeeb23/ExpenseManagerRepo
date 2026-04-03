import Foundation

struct ExpenseDraft {
    var title: String = ""
    var amount: String = ""
    var category: ExpenseCategory = .food
    var date: Date = Date()
    var notes: String = ""

    var validatedAmount: Double? {
        Double(amount)
    }

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (validatedAmount ?? 0) > 0
    }

    func toExpense() -> Expense {
        Expense(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            amount: validatedAmount ?? 0,
            category: category,
            date: date,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
}
