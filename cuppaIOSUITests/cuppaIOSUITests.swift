import XCTest

class InvestmentCalculatorUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func inputValues(initialDeposit: String, periodicDeposit: String, depositFrequency: String, interestRate: String, compoundingFrequency: String, timeHorizon: String) {
        app.textFields["Enter initial deposit"].tap()
        app.textFields["Enter initial deposit"].typeText(initialDeposit)
        
        app.textFields["Enter periodic deposit"].tap()
        app.textFields["Enter periodic deposit"].typeText(periodicDeposit)
        
        let depositFrequencyPickerWheel = app.pickerWheels.element(boundBy: 0)
        depositFrequencyPickerWheel.adjust(toPickerWheelValue: depositFrequency)
        
        app.textFields["Enter interest rate"].tap()
        app.textFields["Enter interest rate"].typeText(interestRate)
        
        let compoundingFrequencyPickerWheel = app.pickerWheels.element(boundBy: 1)
        compoundingFrequencyPickerWheel.adjust(toPickerWheelValue: compoundingFrequency)
        
        app.textFields["Enter time horizon"].tap()
        app.textFields["Enter time horizon"].typeText(timeHorizon)
        
        app.buttons["Calculate Future Value"].tap()
    }
    
    func testValidPositiveInputs() {
        inputValues(initialDeposit: "1000", periodicDeposit: "100", depositFrequency: "Monthly", interestRate: "5", compoundingFrequency: "Annually", timeHorizon: "5")
        
        XCTAssertEqual(app.staticTexts["Future Value: $7,907.04"].label, "Future Value: $7,907.04")
    }
    
    func testZeroInitialDeposit() {
        inputValues(initialDeposit: "0", periodicDeposit: "100", depositFrequency: "Monthly", interestRate: "5", compoundingFrequency: "Annually", timeHorizon: "5")
        
        XCTAssertEqual(app.staticTexts["Future Value: $6,630.76"].label, "Future Value: $6,630.76")
    }
    
    func testZeroPeriodicDeposit() {
        inputValues(initialDeposit: "1000", periodicDeposit: "0", depositFrequency: "Monthly", interestRate: "5", compoundingFrequency: "Annually", timeHorizon: "5")
        
        XCTAssertEqual(app.staticTexts["Future Value: $1,276.28"].label, "Future Value: $1,276.28")
    }
    
    func testNegativeInputs() {
        inputValues(initialDeposit: "-1000", periodicDeposit: "-100", depositFrequency: "Weekly", interestRate: "-5", compoundingFrequency: "Annually", timeHorizon: "-5")
        
        XCTAssertFalse(app.staticTexts["Result"].exists)
    }
    
    func testMixedValidAndInvalidInputs() {
        inputValues(initialDeposit: "1000", periodicDeposit: "-100", depositFrequency: "Monthly", interestRate: "5", compoundingFrequency: "Daily", timeHorizon: "5")
        
        XCTAssertFalse(app.staticTexts["Result"].exists)
    }
}
