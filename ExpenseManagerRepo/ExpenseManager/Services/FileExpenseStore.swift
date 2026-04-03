import Foundation

final class FileExpenseStore: ExpenseStoreProtocol {
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(fileName: String = "expenses.json", fileManager: FileManager = .default) {
        let baseURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? fileManager.temporaryDirectory

        let appFolder = baseURL.appendingPathComponent("ExpenseManager", isDirectory: true)
        self.fileURL = appFolder.appendingPathComponent(fileName)

        self.encoder = JSONEncoder()
        self.encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder.dateEncodingStrategy = .iso8601

        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601

        if !fileManager.fileExists(atPath: appFolder.path) {
            try? fileManager.createDirectory(at: appFolder, withIntermediateDirectories: true)
        }
    }

    init(fileURL: URL) {
        self.fileURL = fileURL

        self.encoder = JSONEncoder()
        self.encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder.dateEncodingStrategy = .iso8601

        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func loadExpenses() async throws -> [Expense] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }

        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([Expense].self, from: data)
    }

    func saveExpenses(_ expenses: [Expense]) async throws {
        let data = try encoder.encode(expenses)
        try data.write(to: fileURL, options: [.atomic])
    }
}
