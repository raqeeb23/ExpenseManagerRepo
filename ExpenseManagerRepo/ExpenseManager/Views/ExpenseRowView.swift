import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(expense.category.tintColor.opacity(0.16))
                    .frame(width: 44, height: 44)

                Image(systemName: expense.category.systemImage)
                    .foregroundStyle(expense.category.tintColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(expense.category.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(expense.amount.currencyString)
                    .font(.headline)

                Text(expense.date.shortDisplayString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
