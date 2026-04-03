import XCTest
@testable import ExpenseManager

final class FileExpenseStoreTests: XCTestCase {

    func testSaveAndLoadExpensesRoundTrip() async throws {
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")

        let store = FileExpenseStore(fileURL: fileURL)
        let expenses = [
            Expense(title: "Milk", amount: 60, category: .groceries, date: Date(timeIntervalSince1970: 1_700_000_000)),
            Expense(title: "Movie", amount: 300, category: .entertainment, date: Date(timeIntervalSince1970: 1_700_000_100))
        ]

        try await store.saveExpenses(expenses)
        let loaded = try await store.loadExpenses()

        XCTAssertEqual(loaded.count, 2)
        XCTAssertEqual(loaded, expenses)

        try? FileManager.default.removeItem(at: fileURL)
    }

    func testLoadReturnsEmptyArrayWhenFileDoesNotExist() async throws {
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")

        let store = FileExpenseStore(fileURL: fileURL)
        let loaded = try await store.loadExpenses()

        XCTAssertTrue(loaded.isEmpty)
    }
}
