import Foundation

struct AppContainer {
    let expenseStore: ExpenseStoreProtocol

    static let live = AppContainer(
        expenseStore: FileExpenseStore()
    )

    static let preview = AppContainer(
        expenseStore: MockExpenseStore.sample
    )

    func makeExpenseListViewModel() -> ExpenseListViewModel {
        ExpenseListViewModel(expenseStore: expenseStore)
    }
}
