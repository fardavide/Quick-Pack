# Quick Pack Ui Tests

This directory contains UI tests for the Quick Pack application, with a focus on testing EditTrip functionality.

## Test Coverage

### EditTrip Functionality

The `EditTripUiTests` class provides comprehensive testing for various EditTrip screen features:

#### Automated Tests

1. **`testRenameItemCompleteFlow()`**
   - Tests the complete happy path for renaming an item
   - Verifies the rename sheet opens correctly
   - Confirms the item name is updated after saving

2. **`testRenameItemCancelFlow()`**
   - Tests the cancel functionality
   - Ensures changes are not saved when user cancels
   - Verifies original name remains unchanged

#### Test Flow

```
1. Launch app
2. Navigate to EditTrip screen
3. Long press on item → Context menu appears
4. Tap "Rename" → Rename sheet opens
5. Update name → Tap "Save"
6. Verify name updated in list
```

## Running Tests

### Via Xcode

1. Open `Quick Pack.xcodeproj`
2. Press `Cmd+U` to run all tests
3. Or press `Cmd+Shift+U` to run without building

### Via Command Line

```bash
# Run all UI tests
xcodebuild test -project "Quick Pack.xcodeproj" -scheme "Quick Pack" -destination "platform=iOS Simulator,name=iPhone 16"

# Run specific EditTrip tests
xcodebuild test -project "Quick Pack.xcodeproj" -scheme "Quick Pack" -destination "platform=iOS Simulator,name=iPhone 16" -only-testing:"Quick PackUITests/EditTripUiTests"

# Run specific rename test
xcodebuild test -project "Quick Pack.xcodeproj" -scheme "Quick Pack" -destination "platform=iOS Simulator,name=iPhone 16" -only-testing:"Quick PackUITests/EditTripUiTests/testRenameItemCompleteFlow"
```

## Manual Testing

When automated tests can't run, follow these manual verification steps:

### Rename Item Flow

1. **Launch the app**
2. **Navigate to a trip** with existing items
3. **Long press** on any item in the trip list
4. **Verify** context menu appears with "Rename" option
5. **Tap "Rename"** 
6. **Verify** rename sheet opens with current item name
7. **Change the name** to something different
8. **Tap "Save"**
9. **Verify** the sheet dismisses
10. **Verify** the item now shows the new name in the list
11. **Verify** the old name is no longer visible

### Cancel Rename Flow

1. Follow steps 1-6 above
2. **Change the name** to something different  
3. **Tap "Cancel"** instead of "Save"
4. **Verify** the sheet dismisses
5. **Verify** the item still shows the original name
6. **Verify** the modified name was not saved

## Test Structure

### Test Class: `EditTripUiTests`

**File**: `EditTripUiTests.swift`

**Purpose**: Tests all EditTrip screen functionality including:
- Item management (rename, etc.)
- Context menu interactions
- Bottom sheet presentations
- UI state updates

### Helper Methods

The test class includes several helper extensions:

- `XCUIElement.clearText()` - Clears text from input fields
- `XCUIElement.waitForNonExistence()` - Waits for elements to disappear

## Troubleshooting

### Common Issues

1. **Tests not running**: Ensure UI test target is included in test plan
2. **Simulator issues**: Try resetting the simulator
3. **Timing issues**: Increase timeout values in `waitForExistence()` calls
4. **Element not found**: Use Accessibility Inspector to verify element accessibility

### Debug Tips

1. **Add screenshots**: Use `XCTAttachment` to capture screenshots at key points
2. **Print element hierarchy**: Use `debugDescription` on XCUIApplication
3. **Check element accessibility**: Ensure UI elements have proper accessibility identifiers

## Dependencies

- XCTest framework (built-in)
- Quick Pack app target
- iOS Simulator (iPhone 16 recommended)

## Adding New Tests

To add new EditTrip UI tests:

1. Add new test methods to `EditTripUiTests` class
2. Follow naming convention: `testFeatureNameFlow()`
3. Include comprehensive assertions
4. Add corresponding manual test documentation above
5. Update this README with new test descriptions 