import SwiftUI

struct InvestmentView: View {
    @State private var initialDeposit: String = ""
    @State private var periodicDeposit: String = ""
    @State private var depositFrequency: DepositFrequency = .monthly
    @State private var interestRate: String = ""
    @State private var compoundingFrequency: CompoundingFrequency = .annually
    @State private var timeHorizon: String = ""
    @State private var futureValue: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Initial Deposit")
                    .accessibilityIdentifier("Initial Deposit")) {
                    TextField("Enter initial deposit", text: $initialDeposit)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("Enter initial deposit")
                }
                
                Section(header: Text("Periodic Deposit")
                    .accessibilityIdentifier("Periodic Deposit")) {
                    TextField("Enter periodic deposit", text: $periodicDeposit)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("Enter periodic deposit")
                }
                
                Section(header: Text("Deposit Frequency")
                    .accessibilityIdentifier("Deposit Frequency")) {
                    Picker("Select deposit frequency", selection: $depositFrequency) {
                        ForEach(DepositFrequency.allCases) { frequency in
                            Text(frequency.rawValue.capitalized).tag(frequency)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .accessibilityLabel("Select deposit frequency")
                    .accessibilityIdentifier("Select deposit frequency")
                }
                
                Section(header: Text("Interest Rate (%)").accessibilityIdentifier("Interest Rate")) {
                    TextField("Enter interest rate", text: $interestRate)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("Enter interest rate")
                }
                
                Section(header: Text("Compounding Frequency").accessibilityIdentifier("Compounding Frequency")) {
                    Picker("Select compounding frequency", selection: $compoundingFrequency) {
                        ForEach(CompoundingFrequency.allCases) { frequency in
                            Text(frequency.rawValue.capitalized).tag(frequency)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .accessibilityLabel("Select compounding frequency")
                    .accessibilityIdentifier("Select compounding frequency")
                }
                
                Section(header: Text("Time Horizon (years)").accessibilityIdentifier("Time Horizon")) {
                    TextField("Enter time horizon", text: $timeHorizon)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("Enter time horizon")
                }
                
                Button(action: calculateFutureValue) {
                    Text("Calculate Future Value")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .accessibilityIdentifier("Calculate Future Value")
                
                if !futureValue.isEmpty {
                    Section(header: Text("Result")) {
                        Text("Future Value: \(futureValue)")
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Cuppa Calculator")
        }
    }
    
    func formatNumberWithCommas(_ value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: value)) ?? ""
    }

    func calculateFutureValue() {
        guard let initialDeposit = Double(initialDeposit),
              let periodicDeposit = Double(periodicDeposit),
              let interestRate = Double(interestRate),
              let timeHorizon = Double(timeHorizon) else {
            return
        }
        
        let futureValue = InvestmentCalculator.calculateFutureValue(
            initialDeposit: initialDeposit,
            periodicDeposit: periodicDeposit,
            depositFrequency: depositFrequency,
            interestRate: interestRate / 100,
            compoundingFrequency: compoundingFrequency,
            timeHorizon: timeHorizon
        )
        
        self.futureValue = "$" + formatNumberWithCommas(futureValue)
    }
    }

    struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
    InvestmentView()
    }
    }

enum DepositFrequency: String, CaseIterable, Identifiable {
    case daily
    case weekly
    case monthly
    case annually
    
    var id: String { self.rawValue }
    
}

enum CompoundingFrequency: String, CaseIterable, Identifiable {
    case daily
    case monthly
    case quarterly
    case annually
    
    var id: String { self.rawValue }
    
}
