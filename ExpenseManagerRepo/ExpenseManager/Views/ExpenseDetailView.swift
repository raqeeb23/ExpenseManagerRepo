import SwiftUI

struct ExpenseDetailView: View {
    let expense: Expense

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                detailCard(title: "Amount", value: expense.amount.currencyString)
                detailCard(title: "Category", value: expense.category.rawValue)
                detailCard(title: "Date", value: expense.date.shortDisplayString)

                if !expense.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                        Text(expense.notes)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                }

                Spacer(minLength: 0)
            }
            .padding()
        }
        .navigationTitle(expense.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: expense.category.systemImage)
                    .font(.title2)
                    .foregroundStyle(expense.category.tintColor)
                Text(expense.category.rawValue)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(expense.category.tintColor)
            }

            Text(expense.title)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.leading)

            Text(expense.amount.currencyString)
                .font(.title2.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func detailCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
