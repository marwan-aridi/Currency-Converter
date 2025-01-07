//
//  ContentView.swift
//  ConvertEase
//
//  Created by Marwan Aridi on 7/19/23.
//

import SwiftUI

struct ContentView: View {
    @State private var itemSelected = 0
    @State private var itemSelected2 = 1
    @State private var amount: String = ""
    @State private var processingFeePercentage = 3 // Default processing fee percentage
    private let currencies = ["USD 🇺🇸", "EUR 🇪🇺", "GBP 🇬🇧", "AED 🇦🇪", "CAD 🇨🇦"]

    private let exchangeRates: [String: [String: Double]] = [
        "USD 🇺🇸": ["USD 🇺🇸": 1.0, "EUR 🇪🇺": 0.87, "GBP 🇬🇧": 0.73, "AED 🇦🇪": 3.67, "CAD 🇨🇦": 1.24],
        "EUR 🇪🇺": ["USD 🇺🇸": 1.15, "EUR 🇪🇺": 1.0, "GBP 🇬🇧": 0.84, "AED 🇦🇪": 4.25, "CAD 🇨🇦": 1.47],
        "GBP 🇬🇧": ["USD 🇺🇸": 1.37, "EUR 🇪🇺": 1.19, "GBP 🇬🇧": 1.0, "AED 🇦🇪": 4.29, "CAD 🇨🇦": 1.71],
        "AED 🇦🇪": ["USD 🇺🇸": 0.27, "EUR 🇪🇺": 0.24, "GBP 🇬🇧": 0.23, "AED 🇦🇪": 1.0, "CAD 🇨🇦": 0.95],
        "CAD 🇨🇦": ["USD 🇺🇸": 0.81, "EUR 🇪🇺": 0.68, "GBP 🇬🇧": 0.58, "AED 🇦🇪": 1.05, "CAD 🇨🇦": 1.0]
    ]

    func convert(_ convert: String, includeProcessingFee: Bool) -> String {
        var conversion: Double = 1.0
        guard let amount = Double(convert) else {
            return "Invalid amount"
        }
        
        let selectedCurrency = currencies[itemSelected]
        let to = currencies[itemSelected2]

        guard let rates = exchangeRates[selectedCurrency] else {
            return "Invalid currency"
        }

        if let rate = rates[to] {
            conversion = amount * rate
        } else {
            return "Exchange rate not found"
        }

        if includeProcessingFee {
            let processingFee = conversion * (1.0 + Double(processingFeePercentage) / 100.0)
            return String(format: "%.2f", processingFee)
        } else {
            return String(format: "%.2f", conversion)
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Convert a currency")) {
                    TextField("Enter an amount", text: $amount)
                        .keyboardType(.decimalPad)

                    Picker(selection: $itemSelected, label: Text("From")) {
                        ForEach(0 ..< currencies.count) { index in
                            HStack {
                                Text(self.currencies[index])
                            }
                            .tag(index)
                        }
                    }

                    Picker(selection: $itemSelected2, label: Text("To")) {
                        ForEach(0 ..< currencies.count) { index in
                            HStack {
                                Text(self.currencies[index])
                            }
                            .tag(index)
                        }
                    }
                }
                Section(header: Text("Conversion")) {
                    Text("\(convert(amount, includeProcessingFee: false)) \(currencies[itemSelected2])")
                }
                Section(header: Text("Conversion with Processing Fee (\(processingFeePercentage)%):")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Are you traveling internationally? 🌎")
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text("The average credit/debit card foreign transaction fee is \(processingFeePercentage)%.")
                            .foregroundColor(.blue)
                        Text("Here is the calculated conversion after foreign transaction fee:")
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical)
                    Text("\(convert(amount, includeProcessingFee: true)) \(currencies[itemSelected2])")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            // Navigate to the new view when tapped
                            self.showProcessedAmount()
                        }
                }
            }
            .navigationBarTitle("Currency Converter")

        }
    }
    
    func showProcessedAmount() {
        // Code to show the new view with the processed amount...
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
