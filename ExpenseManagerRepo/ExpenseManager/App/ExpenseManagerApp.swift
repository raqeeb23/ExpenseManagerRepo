import SwiftUI

@main
struct ExpenseManagerApp: App {
    private let container = AppContainer.live

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: container.makeExpenseListViewModel())
        }
    }
}
