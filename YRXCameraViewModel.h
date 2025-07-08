//
//  YRXCameraViewModel.h
//  YRXCamera
//
//  Created by Refactoring on 2024.
//  Copyright © 2024 JULAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YRXCameraConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class YRXCameraModel;

/**
 * YRXCameraViewModel
 * 
 * Handles data transformation and business logic for YRXCameraTableViewCell
 * Separates data processing from UI concerns for better maintainability
 */

@interface YRXCameraViewModel : NSObject

#pragma mark - Properties

/// Original data model
@property (nonatomic, strong, readonly) YRXCameraModel *model;

/// Processed display properties
@property (nonatomic, strong, readonly) NSString *displayTitle;
@property (nonatomic, strong, readonly) NSString *displaySubtitle;
@property (nonatomic, strong, readonly) NSString *displayDescription;
@property (nonatomic, strong, readonly) NSURL * _Nullable imageURL;
@property (nonatomic, strong, readonly) UIImage * _Nullable placeholderImage;

/// State properties
@property (nonatomic, assign, readonly) YRXCameraCellState cellState;
@property (nonatomic, assign, readonly) YRXCameraDisplayMode displayMode;
@property (nonatomic, assign, readonly) YRXCameraType cameraType;

/// Computed properties
@property (nonatomic, assign, readonly) BOOL isValid;
@property (nonatomic, assign, readonly) BOOL showsDetailButton;
@property (nonatomic, assign, readonly) BOOL showsStatusIndicator;
@property (nonatomic, assign, readonly) CGFloat calculatedHeight;

/// Colors for current state
@property (nonatomic, strong, readonly) UIColor *titleColor;
@property (nonatomic, strong, readonly) UIColor *subtitleColor;
@property (nonatomic, strong, readonly) UIColor *backgroundColor;
@property (nonatomic, strong, readonly) UIColor *borderColor;

#pragma mark - Initialization

/**
 * Initialize with camera model
 * @param model The camera data model
 * @return Configured view model instance
 */
- (instancetype)initWithModel:(YRXCameraModel *)model;

/**
 * Initialize with model and display mode
 * @param model The camera data model
 * @param displayMode The desired display mode
 * @return Configured view model instance
 */
- (instancetype)initWithModel:(YRXCameraModel *)model displayMode:(YRXCameraDisplayMode)displayMode;

/**
 * Convenience initializer
 * @param model The camera data model
 * @return Configured view model instance
 */
+ (instancetype)viewModelWithModel:(YRXCameraModel *)model;

#pragma mark - Data Processing

/**
 * Update the underlying model and refresh computed properties
 * @param model The new camera data model
 */
- (void)updateWithModel:(YRXCameraModel *)model;

/**
 * Update display mode and refresh computed properties
 * @param displayMode The new display mode
 */
- (void)updateDisplayMode:(YRXCameraDisplayMode)displayMode;

/**
 * Update cell state and refresh computed properties
 * @param cellState The new cell state
 */
- (void)updateCellState:(YRXCameraCellState)cellState;

#pragma mark - Validation

/**
 * Validate the current model data
 * @return YES if the model data is valid, NO otherwise
 */
- (BOOL)validateModelData;

/**
 * Get validation error message if any
 * @return Error message string or nil if valid
 */
- (NSString * _Nullable)validationErrorMessage;

#pragma mark - Formatting

/**
 * Get formatted text for display
 * @param maxLength Maximum length for truncation
 * @return Formatted and truncated text
 */
- (NSString *)formattedTitleWithMaxLength:(NSInteger)maxLength;

/**
 * Get formatted subtitle with additional context
 * @return Formatted subtitle string
 */
- (NSString *)formattedSubtitleWithContext;

/**
 * Get formatted description for current display mode
 * @return Formatted description string
 */
- (NSString *)formattedDescriptionForDisplayMode;

#pragma mark - Cache Management

/**
 * Clear any cached computed values
 */
- (void)clearCache;

/**
 * Refresh all computed properties
 */
- (void)refreshComputedProperties;

@end

#pragma mark - Camera Model Protocol

/**
 * YRXCameraModel
 * 
 * Protocol defining the expected structure of camera data models
 * This allows the ViewModel to work with different model implementations
 */

@protocol YRXCameraModelProtocol <NSObject>

@required
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *cameraDescription;
@property (nonatomic, strong) NSString * _Nullable imageURLString;
@property (nonatomic, assign) YRXCameraType type;

@optional
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSDate * _Nullable createdDate;
@property (nonatomic, strong) NSDate * _Nullable modifiedDate;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) BOOL isFeatured;
@property (nonatomic, strong) NSDictionary * _Nullable metadata;

@end

/**
 * YRXCameraModel
 * 
 * Default implementation of camera data model
 */

@interface YRXCameraModel : NSObject <YRXCameraModelProtocol>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *cameraDescription;
@property (nonatomic, strong) NSString * _Nullable imageURLString;
@property (nonatomic, assign) YRXCameraType type;
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSDate * _Nullable createdDate;
@property (nonatomic, strong) NSDate * _Nullable modifiedDate;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) BOOL isFeatured;
@property (nonatomic, strong) NSDictionary * _Nullable metadata;

/**
 * Initialize with basic camera information
 */
- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                  description:(NSString *)description
                         type:(YRXCameraType)type;

/**
 * Create a copy of the model
 */
- (instancetype)copy;

@end

NS_ASSUME_NONNULL_END