# ExpenseManager

A clean and testable SwiftUI expense manager sample app.

## What it demonstrates

- SwiftUI UI with MVVM
- Repository-backed persistence
- Dependency injection through a small container
- Search, category filters, totals, and detail view
- Unit tests for the view model and persistence layer

## Project structure

```text
ExpenseManager/
├── App/
├── Models/
├── Services/
├── ViewModels/
├── Views/
└── Utilities/
Tests/
└── ExpenseManagerTests/
```

## How to use

1. Create a new **iOS App** project in Xcode.
2. Name it `ExpenseManager`.
3. Set **Interface** to SwiftUI.
4. Add the files from the `ExpenseManager/` folder into your project.
5. Add the test files into your test target.
6. Build and run on iOS 15 or later.

## Highlights for interviews

This project separates responsibilities clearly:

- **Models** hold app data and domain rules.
- **Services** handle persistence through a protocol so implementations can be swapped easily.
- **ViewModels** expose screen state and actions.
- **Views** stay focused on rendering and user interaction.

That makes the code easier to test, change, and scale.

## Screens

- Expense list
- Add expense form
- Expense detail view
- Empty state
- Summary cards

## Persistence

Expenses are stored locally in a JSON file inside the app's Application Support folder. This keeps the sample lightweight and fully offline.

## Testing

Run the test target to verify:
- expense creation and filtering
- totals calculation
- JSON save/load behavior using a temporary file location
