
import SwiftUI
import SwiftData

struct AddHoldingView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var type = "Stock"
    @State private var quantity = ""
    @State private var buyPrice = ""
    @State private var latestPrice = ""
    @State private var buyDate = Date()
    @State private var notes = ""
    @State private var errorMessage = ""

    private let viewModel = HoldingViewModel()

    private let types = [
        "Stock",
        "Mutual Fund",
        "Gold",
        "Fixed Deposit"
    ]

    var body: some View {
        Form {

            Section("Investment Information") {

                TextField("Investment Name", text: $name)
                    .keyboardType(.asciiCapable)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)

                Picker("Investment Type", selection: $type) {
                    ForEach(types, id: \.self) { item in
                        Text(item)
                    }
                }

                TextField("Quantity", text: $quantity)
                    .keyboardType(.decimalPad)
                    .environment(\.locale, Locale(identifier: "en_US"))
                    .onChange(of: quantity) { _, newValue in
                        let converted = convertToEnglishDigits(newValue)
                        if converted != newValue {
                            quantity = converted
                        }
                    }

                TextField("Purchase Price (₹)", text: $buyPrice)
                    .keyboardType(.decimalPad)
                    .environment(\.locale, Locale(identifier: "en_US"))
                    .onChange(of: buyPrice) { _, newValue in
                        let converted = convertToEnglishDigits(newValue)
                        if converted != newValue {
                            buyPrice = converted
                        }
                    }

                TextField("Latest Price (₹)", text: $latestPrice)
                    .keyboardType(.decimalPad)
                    .environment(\.locale, Locale(identifier: "en_US"))
                    .onChange(of: latestPrice) { _, newValue in
                        let converted = convertToEnglishDigits(newValue)
                        if converted != newValue {
                            latestPrice = converted
                        }
                    }

                DatePicker(
                    "Purchase Date",
                    selection: $buyDate,
                    displayedComponents: .date
                )
            }

            Section("Notes") {
                TextField(
                    "Additional notes",
                    text: $notes,
                    axis: .vertical
                )
                .lineLimit(3...5)
                .keyboardType(.asciiCapable)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
            }

            if !errorMessage.isEmpty {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button("Save Investment") {
                    saveHolding()
                }
                .frame(maxWidth: .infinity)
                .fontWeight(.bold)
            }
        }
        .navigationTitle("Add Investment")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Convert Hindi numerals into English numerals
    private func convertToEnglishDigits(_ value: String) -> String {

        let map: [Character: Character] = [
            "०": "0",
            "१": "1",
            "२": "2",
            "३": "3",
            "४": "4",
            "५": "5",
            "६": "6",
            "७": "7",
            "८": "8",
            "९": "9"
        ]

        return String(value.map { map[$0] ?? $0 })
    }

    // Save investment
    private func saveHolding() {

        let englishQuantity = convertToEnglishDigits(quantity)
        let englishBuyPrice = convertToEnglishDigits(buyPrice)
        let englishLatestPrice = convertToEnglishDigits(latestPrice)

        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter the investment name."
            return
        }

        guard
            let quantityValue = Double(englishQuantity),
            let buyPriceValue = Double(englishBuyPrice),
            let latestPriceValue = Double(englishLatestPrice),
            quantityValue > 0,
            buyPriceValue > 0,
            latestPriceValue >= 0
        else {
            errorMessage = "Enter a valid quantity and price."
            return
        }

        do {
            try viewModel.addHolding(
                context: context,
                name: name.trimmingCharacters(in: .whitespaces),
                type: type,
                quantity: quantityValue,
                buyPrice: buyPriceValue,
                latestPrice: latestPriceValue,
                buyDate: buyDate,
                notes: notes
            )

            dismiss()

        } catch {
            errorMessage = "Unable to save investment: \(error.localizedDescription)"
        }
    }
}

