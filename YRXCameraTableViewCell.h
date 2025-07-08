//
//  YRXCameraTableViewCell.h
//  YRXCamera
//
//  Created by Refactoring on 2024.
//  Copyright © 2024 JULAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRXCameraConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class YRXCameraModel, YRXCameraViewModel, YRXCameraTableViewCell;

/**
 * YRXCameraTableViewCellDelegate
 * 
 * Delegate protocol for handling user interactions with the camera cell
 */
@protocol YRXCameraTableViewCellDelegate <NSObject>

@optional

/**
 * Called when the detail button is tapped
 * @param cell The camera table view cell
 * @param model The camera model associated with the cell
 */
- (void)cameraTableViewCell:(YRXCameraTableViewCell *)cell didTapDetailWithModel:(YRXCameraModel *)model;

/**
 * Called when the camera image is tapped
 * @param cell The camera table view cell
 * @param model The camera model associated with the cell
 */
- (void)cameraTableViewCell:(YRXCameraTableViewCell *)cell didTapImageWithModel:(YRXCameraModel *)model;

/**
 * Called when the cell state changes
 * @param cell The camera table view cell
 * @param newState The new cell state
 * @param oldState The previous cell state
 */
- (void)cameraTableViewCell:(YRXCameraTableViewCell *)cell 
             didChangeState:(YRXCameraCellState)newState 
                  fromState:(YRXCameraCellState)oldState;

/**
 * Called when an error occurs in the cell
 * @param cell The camera table view cell
 * @param error The error that occurred
 */
- (void)cameraTableViewCell:(YRXCameraTableViewCell *)cell didEncounterError:(NSError *)error;

@end

/**
 * YRXCameraTableViewCell
 * 
 * Refactored table view cell for displaying camera information
 * Features:
 * - Clean separation of concerns with ViewModel pattern
 * - Lazy loading for optimal performance
 * - State management for different display modes
 * - Consistent styling through UI factory
 * - Comprehensive error handling
 * - Accessibility support
 */
@interface YRXCameraTableViewCell : UITableViewCell

#pragma mark - Properties

/// Cell delegate for handling interactions
@property (nonatomic, weak) id<YRXCameraTableViewCellDelegate> delegate;

/// Current display mode
@property (nonatomic, assign) YRXCameraDisplayMode displayMode;

/// Current cell state (read-only, use state management methods to change)
@property (nonatomic, assign, readonly) YRXCameraCellState currentState;

/// Current view model (read-only)
@property (nonatomic, strong, readonly) YRXCameraViewModel * _Nullable viewModel;

/// Whether animations are enabled
@property (nonatomic, assign) BOOL animationsEnabled;

#pragma mark - Configuration

/**
 * Configure the cell with a camera model
 * @param model The camera model to display
 */
- (void)configureWithModel:(YRXCameraModel *)model;

/**
 * Configure the cell with a view model
 * @param viewModel The view model to use
 */
- (void)configureWithViewModel:(YRXCameraViewModel *)viewModel;

/**
 * Configure the cell with model and display mode
 * @param model The camera model to display
 * @param displayMode The display mode to use
 */
- (void)configureWithModel:(YRXCameraModel *)model displayMode:(YRXCameraDisplayMode)displayMode;

#pragma mark - State Management

/**
 * Transition to loading state
 */
- (void)beginLoading;

/**
 * Finish loading and return to normal state
 */
- (void)finishLoading;

/**
 * Enter error state with optional error information
 * @param error The error that occurred (optional)
 */
- (void)showError:(NSError * _Nullable)error;

/**
 * Clear error state and return to normal
 */
- (void)clearError;

/**
 * Enable user interaction
 */
- (void)enableInteraction;

/**
 * Disable user interaction
 */
- (void)disableInteraction;

#pragma mark - Cell Lifecycle

/**
 * Prepare the cell for reuse
 * Called automatically by UITableView
 */
- (void)prepareForReuse;

/**
 * Layout subviews with current configuration
 * Called automatically during layout process
 */
- (void)layoutSubviews;

#pragma mark - Sizing

/**
 * Calculate the height needed for the cell with given model and display mode
 * @param model The camera model
 * @param displayMode The display mode
 * @param width The available width
 * @return The calculated height
 */
+ (CGFloat)heightForModel:(YRXCameraModel *)model 
              displayMode:(YRXCameraDisplayMode)displayMode 
                    width:(CGFloat)width;

/**
 * Get the default height for the current display mode
 * @param displayMode The display mode
 * @return The default height
 */
+ (CGFloat)defaultHeightForDisplayMode:(YRXCameraDisplayMode)displayMode;

#pragma mark - Accessibility

/**
 * Update accessibility information based on current state
 */
- (void)updateAccessibilityInformation;

/**
 * Get accessibility description for current state
 * @return Accessibility description string
 */
- (NSString *)accessibilityDescription;

#pragma mark - Reuse Identifier

/**
 * Get the reuse identifier for this cell type
 * @return The reuse identifier string
 */
+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END