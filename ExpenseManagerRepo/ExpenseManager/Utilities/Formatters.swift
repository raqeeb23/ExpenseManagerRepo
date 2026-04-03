import Foundation

enum Formatters {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Locale.current.currency?.identifier ?? "USD"
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    static let dayMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

extension Double {
    var currencyString: String {
        Formatters.currency.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

extension Date {
    var shortDisplayString: String {
        Formatters.dayMonthYear.string(from: self)
    }
}
