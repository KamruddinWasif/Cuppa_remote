import Foundation

struct InvestmentCalculator {
    static func calculateFutureValue(initialDeposit: Double, periodicDeposit: Double, depositFrequency: DepositFrequency, interestRate: Double, compoundingFrequency: CompoundingFrequency, timeHorizon: Double) -> Double {
        
        let periodicInterestRate = interestRate / compoundingFrequency.periodsPerYear()
        let numPeriods = timeHorizon * compoundingFrequency.periodsPerYear()
        let depositToCompoundingRatio = depositFrequency.periodsPerYear() / compoundingFrequency.periodsPerYear()
        
        let futureValueOfPrincipal = initialDeposit * pow(1 + periodicInterestRate, numPeriods)
        
        let futureValueOfDeposits: Double
        if interestRate == 0 {
            futureValueOfDeposits = periodicDeposit * depositToCompoundingRatio * numPeriods
        } else {
            futureValueOfDeposits = periodicDeposit * depositToCompoundingRatio * (pow(1 + periodicInterestRate, numPeriods) - 1) / periodicInterestRate
        }
        
        return futureValueOfPrincipal + futureValueOfDeposits
    }
}

extension DepositFrequency {
    func periodsPerYear() -> Double {
        switch self {
        case .daily:
            return 365
        case .weekly:
            return 52
        case .monthly:
            return 12
        case .annually:
            return 1
        }
    }
}

extension CompoundingFrequency {
    func periodsPerYear() -> Double {
        switch self {
        case .daily:
            return 365
        case .monthly:
            return 12
        case .quarterly:
            return 4
        case .annually:
            return 1
        }
    }
}
