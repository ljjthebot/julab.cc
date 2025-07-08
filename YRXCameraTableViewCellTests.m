//
//  YRXCameraTableViewCellTests.m
//  YRXCamera Tests
//
//  Created by Refactoring on 2024.
//  Copyright © 2024 JULAB. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YRXCameraTableViewCell.h"
#import "YRXCameraViewModel.h"
#import "YRXCameraConstants.h"
#import "YRXCameraFormatter.h"

@interface YRXCameraTableViewCellTests : XCTestCase

@property (nonatomic, strong) YRXCameraTableViewCell *cell;
@property (nonatomic, strong) YRXCameraModel *testModel;

@end

@implementation YRXCameraTableViewCellTests

- (void)setUp {
    [super setUp];
    
    // Create test cell
    self.cell = [[YRXCameraTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                              reuseIdentifier:[YRXCameraTableViewCell reuseIdentifier]];
    
    // Create test model
    self.testModel = [[YRXCameraModel alloc] initWithTitle:@"Test Camera"
                                                  subtitle:@"Test Subtitle"
                                               description:@"Test Description"
                                                      type:YRXCameraTypePhoto];
    self.testModel.imageURLString = @"https://example.com/image.jpg";
    self.testModel.identifier = @"test-camera-001";
    self.testModel.isEnabled = YES;
}

- (void)tearDown {
    self.cell = nil;
    self.testModel = nil;
    [super tearDown];
}

#pragma mark - Basic Configuration Tests

- (void)testCellInitialization {
    XCTAssertNotNil(self.cell, @"Cell should be initialized");
    XCTAssertEqual(self.cell.displayMode, YRXCameraDisplayModeDefault, @"Default display mode should be set");
    XCTAssertEqual(self.cell.currentState, YRXCameraCellStateNormal, @"Initial state should be normal");
    XCTAssertTrue(self.cell.animationsEnabled, @"Animations should be enabled by default");
}

- (void)testModelConfiguration {
    [self.cell configureWithModel:self.testModel];
    
    XCTAssertNotNil(self.cell.viewModel, @"View model should be created");
    XCTAssertEqual(self.cell.viewModel.model, self.testModel, @"Model should be set correctly");
    XCTAssertTrue(self.cell.viewModel.isValid, @"View model should be valid");
}

- (void)testReuseIdentifier {
    NSString *expectedIdentifier = @"YRXCameraTableViewCell";
    XCTAssertEqualObjects([YRXCameraTableViewCell reuseIdentifier], expectedIdentifier, @"Reuse identifier should match class name");
}

#pragma mark - Display Mode Tests

- (void)testDisplayModeConfiguration {
    [self.cell configureWithModel:self.testModel displayMode:YRXCameraDisplayModeCompact];
    
    XCTAssertEqual(self.cell.displayMode, YRXCameraDisplayModeCompact, @"Display mode should be set correctly");
    XCTAssertEqual(self.cell.viewModel.displayMode, YRXCameraDisplayModeCompact, @"View model display mode should match");
}

- (void)testDisplayModeHeights {
    CGFloat defaultHeight = [YRXCameraTableViewCell defaultHeightForDisplayMode:YRXCameraDisplayModeDefault];
    CGFloat compactHeight = [YRXCameraTableViewCell defaultHeightForDisplayMode:YRXCameraDisplayModeCompact];
    CGFloat expandedHeight = [YRXCameraTableViewCell defaultHeightForDisplayMode:YRXCameraDisplayModeExpanded];
    CGFloat minimalHeight = [YRXCameraTableViewCell defaultHeightForDisplayMode:YRXCameraDisplayModeMinimal];
    
    XCTAssertEqual(defaultHeight, YRXCameraCellDefaultHeight, @"Default height should match constant");
    XCTAssertLessThan(compactHeight, defaultHeight, @"Compact height should be less than default");
    XCTAssertGreaterThan(expandedHeight, defaultHeight, @"Expanded height should be greater than default");
    XCTAssertEqual(minimalHeight, YRXCameraCellMinimumHeight, @"Minimal height should match minimum constant");
}

#pragma mark - State Management Tests

- (void)testStateTransitions {
    [self.cell configureWithModel:self.testModel];
    
    // Test loading state
    [self.cell beginLoading];
    XCTAssertEqual(self.cell.currentState, YRXCameraCellStateLoading, @"Should transition to loading state");
    
    // Test finish loading
    [self.cell finishLoading];
    XCTAssertEqual(self.cell.currentState, YRXCameraCellStateNormal, @"Should return to normal state");
    
    // Test error state
    NSError *testError = [NSError errorWithDomain:@"TestDomain" code:123 userInfo:@{NSLocalizedDescriptionKey: @"Test error"}];
    [self.cell showError:testError];
    XCTAssertEqual(self.cell.currentState, YRXCameraCellStateError, @"Should transition to error state");
    
    // Test clear error
    [self.cell clearError];
    XCTAssertEqual(self.cell.currentState, YRXCameraCellStateNormal, @"Should return to normal state");
}

- (void)testInteractionStates {
    [self.cell configureWithModel:self.testModel];
    
    // Test disable interaction
    [self.cell disableInteraction];
    XCTAssertEqual(self.cell.currentState, YRXCameraCellStateDisabled, @"Should transition to disabled state");
    
    // Test enable interaction
    [self.cell enableInteraction];
    XCTAssertEqual(self.cell.currentState, YRXCameraCellStateNormal, @"Should return to normal state");
}

#pragma mark - Prepare for Reuse Tests

- (void)testPrepareForReuse {
    [self.cell configureWithModel:self.testModel];
    [self.cell beginLoading];
    
    // Verify initial state
    XCTAssertNotNil(self.cell.viewModel, @"View model should be set");
    XCTAssertEqual(self.cell.currentState, YRXCameraCellStateLoading, @"Should be in loading state");
    
    // Prepare for reuse
    [self.cell prepareForReuse];
    
    // Verify reset state
    XCTAssertNil(self.cell.viewModel, @"View model should be cleared");
    XCTAssertEqual(self.cell.currentState, YRXCameraCellStateNormal, @"Should return to normal state");
    XCTAssertEqual(self.cell.displayMode, YRXCameraDisplayModeDefault, @"Should reset to default display mode");
}

#pragma mark - Accessibility Tests

- (void)testAccessibilityConfiguration {
    [self.cell configureWithModel:self.testModel];
    
    NSString *accessibilityDescription = [self.cell accessibilityDescription];
    XCTAssertTrue([accessibilityDescription containsString:self.testModel.title], @"Accessibility description should contain title");
    XCTAssertTrue([accessibilityDescription containsString:self.testModel.subtitle], @"Accessibility description should contain subtitle");
}

#pragma mark - Constants Validation Tests

- (void)testConstants {
    // Test layout constants
    XCTAssertGreaterThan(YRXCameraCellDefaultHeight, 0, @"Default height should be positive");
    XCTAssertGreaterThan(YRXCameraCellHorizontalMargin, 0, @"Horizontal margin should be positive");
    XCTAssertGreaterThan(YRXCameraImageViewWidth, 0, @"Image view width should be positive");
    
    // Test font constants
    XCTAssertGreaterThan(YRXCameraTitleFontSize, 0, @"Title font size should be positive");
    XCTAssertGreaterThan(YRXCameraSubtitleFontSize, 0, @"Subtitle font size should be positive");
    
    // Test color constants
    XCTAssertNotNil(YRXCameraPrimaryColorHex, @"Primary color hex should not be nil");
    XCTAssertNotNil(YRXCameraSecondaryColorHex, @"Secondary color hex should not be nil");
    
    // Test utility functions
    UIColor *primaryColor = YRXCameraColorFromHex(YRXCameraPrimaryColorHex);
    XCTAssertNotNil(primaryColor, @"Should create color from hex string");
    
    UIFont *titleFont = YRXCameraTitleFont();
    XCTAssertNotNil(titleFont, @"Should create title font");
    XCTAssertEqual(titleFont.pointSize, YRXCameraTitleFontSize, @"Font size should match constant");
}

#pragma mark - Formatter Tests

- (void)testTextFormatting {
    NSString *longTitle = @"This is a very long title that should be truncated according to the maximum length specified";
    NSString *truncated = [YRXCameraFormatter formatTitle:longTitle maxLength:20];
    XCTAssertLessThanOrEqual(truncated.length, 20, @"Title should be truncated to max length");
    XCTAssertTrue([truncated hasSuffix:@"..."], @"Truncated title should end with ellipsis");
}

- (void)testSubtitleFormatting {
    NSString *subtitle = [YRXCameraFormatter formatSubtitle:@"Test Subtitle" cameraType:YRXCameraTypePhoto];
    XCTAssertTrue([subtitle containsString:@"Photo"], @"Subtitle should contain camera type");
}

- (void)testDateFormatting {
    NSDate *testDate = [NSDate date];
    NSString *formattedDate = [YRXCameraFormatter formatDate:testDate];
    XCTAssertNotNil(formattedDate, @"Should format date");
    XCTAssertGreaterThan(formattedDate.length, 0, @"Formatted date should not be empty");
    
    NSString *relativeTime = [YRXCameraFormatter formatRelativeTime:testDate];
    XCTAssertEqualObjects(relativeTime, @"Just now", @"Current date should show as 'Just now'");
}

- (void)testStatusFormatting {
    NSString *loadingStatus = [YRXCameraFormatter formatCameraStatus:YRXCameraCellStateLoading cameraType:YRXCameraTypeVideo];
    XCTAssertTrue([loadingStatus containsString:@"Loading"], @"Loading status should contain 'Loading'");
    XCTAssertTrue([loadingStatus containsString:@"Video"], @"Loading status should contain camera type");
    
    NSString *errorStatus = [YRXCameraFormatter formatCameraStatus:YRXCameraCellStateError cameraType:YRXCameraTypePhoto];
    XCTAssertTrue([errorStatus containsString:@"Error"], @"Error status should contain 'Error'");
}

- (void)testTextValidation {
    XCTAssertTrue(YRXCameraIsValidString(@"Valid string"), @"Should validate valid string");
    XCTAssertFalse(YRXCameraIsValidString(@""), @"Should not validate empty string");
    XCTAssertFalse(YRXCameraIsValidString(nil), @"Should not validate nil string");
    
    NSString *sanitized = [YRXCameraFormatter validateAndSanitizeText:@"Test<script>alert('xss')</script>"];
    XCTAssertFalse([sanitized containsString:@"<"], @"Should remove potentially harmful characters");
    XCTAssertFalse([sanitized containsString:@">"], @"Should remove potentially harmful characters");
}

#pragma mark - Performance Tests

- (void)testPerformanceOfCellConfiguration {
    [self measureBlock:^{
        for (int i = 0; i < 100; i++) {
            YRXCameraModel *model = [[YRXCameraModel alloc] initWithTitle:[NSString stringWithFormat:@"Camera %d", i]
                                                                 subtitle:@"Test Subtitle"
                                                              description:@"Test Description"
                                                                     type:YRXCameraTypePhoto];
            [self.cell configureWithModel:model];
            [self.cell prepareForReuse];
        }
    }];
}

- (void)testPerformanceOfViewModelCreation {
    [self measureBlock:^{
        for (int i = 0; i < 1000; i++) {
            YRXCameraModel *model = [[YRXCameraModel alloc] initWithTitle:[NSString stringWithFormat:@"Camera %d", i]
                                                                 subtitle:@"Test Subtitle"
                                                              description:@"Test Description"
                                                                     type:YRXCameraTypePhoto];
            YRXCameraViewModel *viewModel = [YRXCameraViewModel viewModelWithModel:model];
            [viewModel validateModelData]; // Trigger lazy loading
        }
    }];
}

@end