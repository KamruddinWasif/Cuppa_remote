import SwiftUI

struct InvestmentView: View {
    @State private var initialDeposit: String = ""
    @State private var periodicDeposit: String = ""
    @State private var depositFrequency: DepositFrequency = .monthly
    @State private var interestRate: String = ""
    @State private var compoundingFrequency: CompoundingFrequency = .annually
    @State private var timeHorizon: String = ""
    @State private var futureValue: String = ""
    @State private var isResultVisible: Bool = false
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Initial Deposit")
                    .accessibilityIdentifier("Initial Deposit")) {
                        TextField("Enter initial deposit", text: $initialDeposit)
                            .keyboardType(.decimalPad)
                            .accessibilityIdentifier("Enter initial deposit")
                            .dismissKeyboardOnTap()
                        
                    }
                
                Section(header: Text("Periodic Deposit")
                    .accessibilityIdentifier("Periodic Deposit")) {
                        TextField("Enter periodic deposit", text: $periodicDeposit)
                            .keyboardType(.decimalPad)
                            .accessibilityIdentifier("Enter periodic deposit")
                            .dismissKeyboardOnTap()
                        
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
                        .dismissKeyboardOnTap()
                    
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
                        .dismissKeyboardOnTap()
                    
                }
                
                HStack {
                    Spacer()
                    Button(action: calculateFutureValue) {
                        Text("Calculate Future Value")
                    }
                    .buttonStyle(CustomButtonStyle())
                    .accessibilityIdentifier("Calculate Future Value")
                    Spacer()
                }
                
                if !futureValue.isEmpty {
                    Section(header: Text("Result")) {
                        Text("Value: \(futureValue)")
                            .font(.headline)
                            .scaleEffect(isResultVisible ? 1.2 : 1)
                            .opacity(isResultVisible ? 1 : 0)
                            .animation(.easeInOut(duration: 0.1), value: isResultVisible)
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
        isResultVisible = false
        self.futureValue = "$" + formatNumberWithCommas(futureValue)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isResultVisible = true
        }
    }
}


struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(configuration.isPressed ? Color.blue.opacity(0.4) : Color.teal)
            )
            .scaleEffect(configuration.isPressed ? 2 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .foregroundColor(.white)
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboardToolbar())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InvestmentView()
    }
}

struct DismissKeyboardToolbar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button(action: dismissKeyboard) {
                        Text("Done")
                    }
                }
            }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
