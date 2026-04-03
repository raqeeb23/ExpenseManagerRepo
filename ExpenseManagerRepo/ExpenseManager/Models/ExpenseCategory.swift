import Foundation
import SwiftUI

enum ExpenseCategory: String, CaseIterable, Codable, Identifiable, Equatable {
    case food = "Food"
    case transport = "Transport"
    case shopping = "Shopping"
    case bills = "Bills"
    case entertainment = "Entertainment"
    case health = "Health"
    case groceries = "Groceries"
    case travel = "Travel"
    case other = "Other"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .shopping: return "bag.fill"
        case .bills: return "doc.text.fill"
        case .entertainment: return "film.fill"
        case .health: return "cross.case.fill"
        case .groceries: return "cart.fill"
        case .travel: return "airplane"
        case .other: return "tag.fill"
        }
    }

    var tintColor: Color {
        switch self {
        case .food: return .orange
        case .transport: return .blue
        case .shopping: return .pink
        case .bills: return .red
        case .entertainment: return .purple
        case .health: return .green
        case .groceries: return .teal
        case .travel: return .indigo
        case .other: return .gray
        }
    }
}
