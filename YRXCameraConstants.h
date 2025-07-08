//
//  YRXCameraConstants.h
//  YRXCamera
//
//  Created by Refactoring on 2024.
//  Copyright © 2024 JULAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * YRXCameraConstants
 * 
 * Centralized constants management for YRXCameraTableViewCell
 * Replaces all magic numbers and hardcoded values with named constants
 */

#pragma mark - Layout Constants

/// Cell height and dimensions
FOUNDATION_EXPORT const CGFloat YRXCameraCellDefaultHeight;
FOUNDATION_EXPORT const CGFloat YRXCameraCellMinimumHeight;
FOUNDATION_EXPORT const CGFloat YRXCameraCellMaximumHeight;

/// Margins and padding
FOUNDATION_EXPORT const CGFloat YRXCameraCellHorizontalMargin;
FOUNDATION_EXPORT const CGFloat YRXCameraCellVerticalMargin;
FOUNDATION_EXPORT const CGFloat YRXCameraCellInnerPadding;
FOUNDATION_EXPORT const CGFloat YRXCameraCellElementSpacing;

/// Image view dimensions
FOUNDATION_EXPORT const CGFloat YRXCameraImageViewWidth;
FOUNDATION_EXPORT const CGFloat YRXCameraImageViewHeight;
FOUNDATION_EXPORT const CGFloat YRXCameraImageViewCornerRadius;

/// Button dimensions
FOUNDATION_EXPORT const CGFloat YRXCameraButtonHeight;
FOUNDATION_EXPORT const CGFloat YRXCameraButtonCornerRadius;
FOUNDATION_EXPORT const CGFloat YRXCameraButtonBorderWidth;

#pragma mark - Font Constants

/// Font sizes
FOUNDATION_EXPORT const CGFloat YRXCameraTitleFontSize;
FOUNDATION_EXPORT const CGFloat YRXCameraSubtitleFontSize;
FOUNDATION_EXPORT const CGFloat YRXCameraDetailFontSize;
FOUNDATION_EXPORT const CGFloat YRXCameraButtonFontSize;

#pragma mark - Color Constants

/// Color definitions
FOUNDATION_EXPORT NSString * const YRXCameraPrimaryColorHex;
FOUNDATION_EXPORT NSString * const YRXCameraSecondaryColorHex;
FOUNDATION_EXPORT NSString * const YRXCameraBackgroundColorHex;
FOUNDATION_EXPORT NSString * const YRXCameraBorderColorHex;

#pragma mark - Animation Constants

/// Animation durations
FOUNDATION_EXPORT const NSTimeInterval YRXCameraDefaultAnimationDuration;
FOUNDATION_EXPORT const NSTimeInterval YRXCameraFastAnimationDuration;
FOUNDATION_EXPORT const NSTimeInterval YRXCameraSlowAnimationDuration;

#pragma mark - Configuration Constants

/// Cache and performance
FOUNDATION_EXPORT const NSInteger YRXCameraMaxCacheSize;
FOUNDATION_EXPORT const NSTimeInterval YRXCameraCacheTimeout;

/// Limits
FOUNDATION_EXPORT const NSInteger YRXCameraMaxTitleLength;
FOUNDATION_EXPORT const NSInteger YRXCameraMaxDescriptionLength;

#pragma mark - State Constants

/// Cell states enumeration
typedef NS_ENUM(NSInteger, YRXCameraCellState) {
    YRXCameraCellStateNormal = 0,
    YRXCameraCellStateSelected,
    YRXCameraCellStateLoading,
    YRXCameraCellStateError,
    YRXCameraCellStateDisabled
};

/// Display modes enumeration
typedef NS_ENUM(NSInteger, YRXCameraDisplayMode) {
    YRXCameraDisplayModeDefault = 0,
    YRXCameraDisplayModeCompact,
    YRXCameraDisplayModeExpanded,
    YRXCameraDisplayModeMinimal
};

/// Camera types enumeration
typedef NS_ENUM(NSInteger, YRXCameraType) {
    YRXCameraTypeUnknown = 0,
    YRXCameraTypePhoto,
    YRXCameraTypeVideo,
    YRXCameraTypePanorama,
    YRXCameraTypePortrait,
    YRXCameraTypeTimelapase
};

#pragma mark - Utility Functions

/// Color creation from hex string
UIColor * YRXCameraColorFromHex(NSString *hexString);

/// Font creation helpers
UIFont * YRXCameraTitleFont(void);
UIFont * YRXCameraSubtitleFont(void);
UIFont * YRXCameraDetailFont(void);
UIFont * YRXCameraButtonFont(void);

/// String validation
BOOL YRXCameraIsValidString(NSString * _Nullable string);
NSString * YRXCameraTruncateString(NSString *string, NSInteger maxLength);

/// State conversion helpers
NSString * YRXCameraStringFromCellState(YRXCameraCellState state);
NSString * YRXCameraStringFromDisplayMode(YRXCameraDisplayMode mode);
NSString * YRXCameraStringFromCameraType(YRXCameraType type);

NS_ASSUME_NONNULL_END