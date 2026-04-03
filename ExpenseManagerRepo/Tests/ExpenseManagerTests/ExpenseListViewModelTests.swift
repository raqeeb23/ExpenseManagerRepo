import XCTest
@testable import ExpenseManager

@MainActor
final class ExpenseListViewModelTests: XCTestCase {

    func testFilteredExpensesBySearchText() async {
        let store = MockExpenseStore(expenses: [
            Expense(title: "Coffee", amount: 120, category: .food),
            Expense(title: "Cab", amount: 250, category: .transport)
        ])

        let viewModel = ExpenseListViewModel(expenseStore: store)
        viewModel.expenses = try! await store.loadExpenses()
        viewModel.searchText = "cof"

        let result = viewModel.filteredExpenses()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Coffee")
    }

    func testTotalsAreCalculatedCorrectly() async {
        let store = MockExpenseStore(expenses: [
            Expense(title: "Coffee", amount: 100, category: .food),
            Expense(title: "Lunch", amount: 200, category: .food),
            Expense(title: "Bus", amount: 50, category: .transport)
        ])

        let viewModel = ExpenseListViewModel(expenseStore: store)
        viewModel.expenses = try! await store.loadExpenses()

        XCTAssertEqual(viewModel.totalSpent, 350)
        XCTAssertEqual(viewModel.totalSpent(for: .food), 300)
        XCTAssertEqual(viewModel.count(for: .transport), 1)
    }

    func testAddExpenseInsertsAtTop() {
        let store = MockExpenseStore()
        let viewModel = ExpenseListViewModel(expenseStore: store)

        let expense = Expense(title: "Tea", amount: 30, category: .food)
        viewModel.addExpense(expense)

        XCTAssertEqual(viewModel.expenses.first, expense)
    }
}
