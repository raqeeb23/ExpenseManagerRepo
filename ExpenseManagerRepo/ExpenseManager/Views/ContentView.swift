import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ExpenseListViewModel
    @State private var showingAddExpense = false

    init(viewModel: ExpenseListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                summarySection

                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading expenses...")
                    Spacer()
                } else {
                    expenseList
                }
            }
            .padding()
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add expense")
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
            .sheet(isPresented: $showingAddExpense) {
                ExpenseFormView { draft in
                    viewModel.addExpense(draft.toExpense())
                }
            }
            .task {
                if viewModel.expenses.isEmpty {
                    viewModel.loadExpenses()
                }
            }
            .alert("Something went wrong", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SummaryCard(title: "Total", value: viewModel.totalSpent.currencyString, icon: "indianrupeesign.circle.fill")
                SummaryCard(title: "Count", value: "\(viewModel.expenses.count)", icon: "list.bullet.rectangle")
            }

            HStack {
                SummaryCard(title: "Average", value: viewModel.averageExpense.currencyString, icon: "chart.bar.fill")
                SummaryCard(title: "Food", value: viewModel.totalSpent(for: .food).currencyString, icon: "fork.knife")
            }

            categoryFilter
        }
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: "All",
                    isSelected: viewModel.selectedCategory == nil
                ) {
                    viewModel.selectedCategory = nil
                }

                ForEach(ExpenseCategory.allCases) { category in
                    FilterChip(
                        title: category.rawValue,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectedCategory = category
                    }
                }
            }
        }
    }

    private var expenseList: some View {
        Group {
            let items = viewModel.filteredExpenses()

            if items.isEmpty {
                EmptyStateView(
                    title: "No expenses yet",
                    message: "Tap the plus button to add your first expense."
                )
            } else {
                List {
                    ForEach(items) { expense in
                        NavigationLink {
                            ExpenseDetailView(expense: expense)
                        } label: {
                            ExpenseRowView(expense: expense)
                        }
                    }
                    .onDelete(perform: viewModel.deleteExpense)
                }
                .listStyle(.plain)
            }
        }
    }
}

private struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(isSelected ? Color.accentColor.opacity(0.18) : Color.secondary.opacity(0.12), in: Capsule())
        }
        .buttonStyle(.plain)
        .foregroundStyle(isSelected ? Color.accentColor : .primary)
    }
}

#Preview {
    ContentView(viewModel: AppContainer.preview.makeExpenseListViewModel())
}
