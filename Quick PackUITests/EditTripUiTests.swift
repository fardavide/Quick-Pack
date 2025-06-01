import XCTest

/**
 * UI Tests for EditTrip Functionality
 * 
 * These tests verify the complete user flows for various EditTrip screen features:
 * - Item renaming workflow
 * - Context menu interactions  
 * - Bottom sheet presentations
 * - UI state updates
 * - Bottom sheet behavior validation (no reopening after save)
 * 
 * Manual Test Instructions:
 * 1. Launch the app
 * 2. Navigate to or create a trip with items
 * 3. Follow the specific test scenarios below
 * 
 * Manual Test Instructions for Rename Flow:
 * 1. Long press on any item in the trip
 * 2. Tap "Rename" from the context menu
 * 3. Verify the rename sheet opens with the current name
 * 4. Change the name and tap "Save"
 * 5. Verify the item shows the new name in the list
 * 6. Verify the rename sheet dismisses automatically
 * 
 * Manual Test Instructions for Bottom Sheet Fix Validation:
 * 1. Follow steps 1-4 above for rename flow
 * 2. After tapping "Save", watch carefully for 2-3 seconds
 * 3. The sheet should close and STAY closed (not reopen)
 * 4. If the sheet reopens after closing, the bug is still present
 * 5. The testRenameSheetDoesNotReopen() test automates this validation
 * 
 * To run the specific bottom sheet test:
 * - In Xcode: Navigate to EditTripUiTests.swift and run testRenameSheetDoesNotReopen()
 * - This test specifically validates that the rename sheet doesn't exhibit
 *   the "close → open → close" behavior that was the original bug
 */

final class EditTripUiTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Rename Item Tests
    
    func testRenameItemCompleteFlow() throws {
        // MARK: - Navigate to a trip with items
        
        // Wait for the main trip list to load
        let tripsList = app.collectionViews.firstMatch
        XCTAssertTrue(tripsList.waitForExistence(timeout: 5), "Trips list should be visible")
        
        // Look for an existing trip or create one if none exists
        var tripCell: XCUIElement
        if app.staticTexts["No trip found"].exists {
            // Create a new trip for testing
            let addButton = app.buttons["Add Trip"]
            XCTAssertTrue(addButton.waitForExistence(timeout: 3), "Add trip button should exist")
            addButton.tap()
            
            // Fill in trip details (this would need to be adjusted based on actual UI)
            let nameField = app.textFields.firstMatch
            nameField.tap()
            nameField.typeText("Test Trip")
            
            let saveButton = app.buttons["Save"]
            saveButton.tap()
            
            tripCell = app.cells.containing(.staticText, identifier: "Test Trip").firstMatch
        } else {
            // Use the first available trip
            tripCell = tripsList.cells.firstMatch
        }
        
        XCTAssertTrue(tripCell.waitForExistence(timeout: 3), "Trip cell should exist")
        tripCell.tap()
        
        // MARK: - Verify EditTrip screen appears
        
        // Wait for the EditTrip screen to load
        // Look for elements that indicate we're on the EditTrip screen
        let editTripIndicator = app.navigationBars.firstMatch
        XCTAssertTrue(editTripIndicator.waitForExistence(timeout: 5), "EditTrip screen should appear")
        
        // MARK: - Find an item to rename
        
        // Look for the first item in the trip
        let itemsList = app.collectionViews.firstMatch
        XCTAssertTrue(itemsList.waitForExistence(timeout: 3), "Items list should be visible")
        
        let firstItem = itemsList.cells.firstMatch
        XCTAssertTrue(firstItem.waitForExistence(timeout: 3), "At least one item should exist")
        
        // Get the original name for verification later
        let originalName = firstItem.staticTexts.firstMatch.label
        
        // MARK: - Perform rename action
        
        // Long press on the item to open context menu
        firstItem.press(forDuration: 1.0)
        
        // Wait for context menu to appear and tap "Rename"
        let renameButton = app.buttons["Rename"]
        XCTAssertTrue(renameButton.waitForExistence(timeout: 3), "Rename button should appear in context menu")
        renameButton.tap()
        
        // MARK: - Interact with rename sheet
        
        // Wait for the rename sheet to appear
        let renameSheet = app.sheets.firstMatch
        XCTAssertTrue(renameSheet.waitForExistence(timeout: 3), "Rename sheet should appear")
        
        // Find the text field and verify it contains the current name
        let textField = renameSheet.textFields.firstMatch
        XCTAssertTrue(textField.waitForExistence(timeout: 2), "Text field should exist in rename sheet")
        XCTAssertEqual(textField.value as? String, originalName, "Text field should contain original name")
        
        // Clear the text field and enter new name
        textField.tap()
        textField.clearText()
        let newName = "Updated Test Item"
        textField.typeText(newName)
        
        // Tap Save button
        let saveButton = renameSheet.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()
        
        // MARK: - Verify the rename was successful
        
        // Wait for sheet to dismiss
        XCTAssertFalse(renameSheet.waitForNonExistence(timeout: 3), "Rename sheet should dismiss")
        
        // Verify the item now shows the new name
        let updatedItem = itemsList.cells.containing(.staticText, identifier: newName).firstMatch
        XCTAssertTrue(updatedItem.waitForExistence(timeout: 3), "Item should show updated name: \(newName)")
        
        // Verify the old name is no longer visible (if it was unique)
        if originalName != newName {
            let oldItem = itemsList.cells.containing(.staticText, identifier: originalName).firstMatch
            XCTAssertFalse(oldItem.exists, "Item with old name should no longer exist")
        }
    }
    
    func testRenameItemCancelFlow() throws {
        // MARK: - Navigate to EditTrip screen (similar to above)
        
        let tripsList = app.collectionViews.firstMatch
        XCTAssertTrue(tripsList.waitForExistence(timeout: 5), "Trips list should be visible")
        
        let tripCell = tripsList.cells.firstMatch
        XCTAssertTrue(tripCell.waitForExistence(timeout: 3), "Trip cell should exist")
        tripCell.tap()
        
        // MARK: - Find item and open rename sheet
        
        let itemsList = app.collectionViews.firstMatch
        let firstItem = itemsList.cells.firstMatch
        XCTAssertTrue(firstItem.waitForExistence(timeout: 3), "Item should exist")
        
        let originalName = firstItem.staticTexts.firstMatch.label
        
        firstItem.press(forDuration: 1.0)
        
        let renameButton = app.buttons["Rename"]
        XCTAssertTrue(renameButton.waitForExistence(timeout: 3), "Rename button should appear")
        renameButton.tap()
        
        // MARK: - Cancel the rename operation
        
        let renameSheet = app.sheets.firstMatch
        XCTAssertTrue(renameSheet.waitForExistence(timeout: 3), "Rename sheet should appear")
        
        let textField = renameSheet.textFields.firstMatch
        textField.tap()
        textField.clearText()
        textField.typeText("This Should Not Save")
        
        // Tap Cancel button instead of Save
        let cancelButton = renameSheet.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Cancel button should exist")
        cancelButton.tap()
        
        // MARK: - Verify the rename was cancelled
        
        XCTAssertFalse(renameSheet.waitForNonExistence(timeout: 3), "Rename sheet should dismiss")
        
        // Verify the item still shows the original name
        let unchangedItem = itemsList.cells.containing(.staticText, identifier: originalName).firstMatch
        XCTAssertTrue(
            unchangedItem.waitForExistence(timeout: 3),
            "Item should still show original name: \(originalName)"
        )
    }
    
    func testRenameSheetDoesNotReopen() throws {
        // MARK: - Navigate to EditTrip screen
        
        let tripsList = app.collectionViews.firstMatch
        XCTAssertTrue(tripsList.waitForExistence(timeout: 5), "Trips list should be visible")
        
        let tripCell = tripsList.cells.firstMatch
        XCTAssertTrue(tripCell.waitForExistence(timeout: 3), "Trip cell should exist")
        tripCell.tap()
        
        // MARK: - Open rename sheet
        
        let itemsList = app.collectionViews.firstMatch
        let firstItem = itemsList.cells.firstMatch
        XCTAssertTrue(firstItem.waitForExistence(timeout: 3), "Item should exist")
        
        // Long press to open context menu
        firstItem.press(forDuration: 1.0)
        
        let renameButton = app.buttons["Rename"]
        XCTAssertTrue(renameButton.waitForExistence(timeout: 3), "Rename button should appear")
        renameButton.tap()
        
        // MARK: - Verify sheet opens
        
        let renameSheet = app.sheets.firstMatch
        XCTAssertTrue(renameSheet.waitForExistence(timeout: 3), "Rename sheet should appear")
        
        // MARK: - Save and verify sheet behavior
        
        let textField = renameSheet.textFields.firstMatch
        textField.tap()
        textField.clearText()
        textField.typeText("Test Sheet Behavior")
        
        let saveButton = renameSheet.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()
        
        // MARK: - Critical test: Verify sheet closes and stays closed
        
        // First, verify the sheet dismisses
        XCTAssertFalse(
            renameSheet.waitForNonExistence(timeout: 3),
            "Rename sheet should dismiss after Save"
        )
        
        // Wait a bit to ensure no reopening occurs (this is the key test)
        // The bug we're testing for would cause the sheet to reopen within ~1-2 seconds
        sleep(2)
        
        // Verify the sheet is still not present
        XCTAssertFalse(
            renameSheet.exists,
            "Rename sheet should NOT reopen after being dismissed"
        )
        
        // Double-check by looking for any sheet at all
        let anySheet = app.sheets.firstMatch
        XCTAssertFalse(
            anySheet.exists,
            "No sheets should be visible after successful save"
        )
        
        // MARK: - Verify the rename actually worked
        
        let updatedItem = itemsList.cells.containing(.staticText, identifier: "Test Sheet Behavior").firstMatch
        XCTAssertTrue(
            updatedItem.waitForExistence(timeout: 3),
            "Item should show updated name, confirming the save worked"
        )
    }
}

// MARK: - Helper Extensions

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
    
    func waitForNonExistence(timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
} 
