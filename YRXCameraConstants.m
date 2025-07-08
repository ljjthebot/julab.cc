//
//  YRXCameraConstants.m
//  YRXCamera
//
//  Created by Refactoring on 2024.
//  Copyright © 2024 JULAB. All rights reserved.
//

#import "YRXCameraConstants.h"

#pragma mark - Layout Constants

const CGFloat YRXCameraCellDefaultHeight = 120.0;
const CGFloat YRXCameraCellMinimumHeight = 80.0;
const CGFloat YRXCameraCellMaximumHeight = 200.0;

const CGFloat YRXCameraCellHorizontalMargin = 16.0;
const CGFloat YRXCameraCellVerticalMargin = 12.0;
const CGFloat YRXCameraCellInnerPadding = 8.0;
const CGFloat YRXCameraCellElementSpacing = 12.0;

const CGFloat YRXCameraImageViewWidth = 80.0;
const CGFloat YRXCameraImageViewHeight = 80.0;
const CGFloat YRXCameraImageViewCornerRadius = 8.0;

const CGFloat YRXCameraButtonHeight = 36.0;
const CGFloat YRXCameraButtonCornerRadius = 18.0;
const CGFloat YRXCameraButtonBorderWidth = 1.0;

#pragma mark - Font Constants

const CGFloat YRXCameraTitleFontSize = 16.0;
const CGFloat YRXCameraSubtitleFontSize = 14.0;
const CGFloat YRXCameraDetailFontSize = 12.0;
const CGFloat YRXCameraButtonFontSize = 14.0;

#pragma mark - Color Constants

NSString * const YRXCameraPrimaryColorHex = @"#007AFF";
NSString * const YRXCameraSecondaryColorHex = @"#8E8E93";
NSString * const YRXCameraBackgroundColorHex = @"#F2F2F7";
NSString * const YRXCameraBorderColorHex = @"#C7C7CC";

#pragma mark - Animation Constants

const NSTimeInterval YRXCameraDefaultAnimationDuration = 0.25;
const NSTimeInterval YRXCameraFastAnimationDuration = 0.15;
const NSTimeInterval YRXCameraSlowAnimationDuration = 0.5;

#pragma mark - Configuration Constants

const NSInteger YRXCameraMaxCacheSize = 100;
const NSTimeInterval YRXCameraCacheTimeout = 300.0; // 5 minutes

const NSInteger YRXCameraMaxTitleLength = 50;
const NSInteger YRXCameraMaxDescriptionLength = 200;

#pragma mark - Utility Functions

UIColor * YRXCameraColorFromHex(NSString *hexString) {
    if (!hexString || hexString.length == 0) {
        return [UIColor clearColor];
    }
    
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if (cleanString.length != 6) {
        return [UIColor clearColor];
    }
    
    unsigned int rgb = 0;
    NSScanner *scanner = [NSScanner scannerWithString:cleanString];
    if (![scanner scanHexInt:&rgb]) {
        return [UIColor clearColor];
    }
    
    return [UIColor colorWithRed:((rgb & 0xFF0000) >> 16) / 255.0
                           green:((rgb & 0x00FF00) >> 8) / 255.0
                            blue:(rgb & 0x0000FF) / 255.0
                           alpha:1.0];
}

UIFont * YRXCameraTitleFont(void) {
    return [UIFont systemFontOfSize:YRXCameraTitleFontSize weight:UIFontWeightMedium];
}

UIFont * YRXCameraSubtitleFont(void) {
    return [UIFont systemFontOfSize:YRXCameraSubtitleFontSize weight:UIFontWeightRegular];
}

UIFont * YRXCameraDetailFont(void) {
    return [UIFont systemFontOfSize:YRXCameraDetailFontSize weight:UIFontWeightLight];
}

UIFont * YRXCameraButtonFont(void) {
    return [UIFont systemFontOfSize:YRXCameraButtonFontSize weight:UIFontWeightMedium];
}

BOOL YRXCameraIsValidString(NSString * _Nullable string) {
    return string != nil && [string isKindOfClass:[NSString class]] && string.length > 0;
}

NSString * YRXCameraTruncateString(NSString *string, NSInteger maxLength) {
    if (!YRXCameraIsValidString(string)) {
        return @"";
    }
    
    if (string.length <= maxLength) {
        return string;
    }
    
    return [[string substringToIndex:maxLength - 3] stringByAppendingString:@"..."];
}

NSString * YRXCameraStringFromCellState(YRXCameraCellState state) {
    switch (state) {
        case YRXCameraCellStateNormal:
            return @"Normal";
        case YRXCameraCellStateSelected:
            return @"Selected";
        case YRXCameraCellStateLoading:
            return @"Loading";
        case YRXCameraCellStateError:
            return @"Error";
        case YRXCameraCellStateDisabled:
            return @"Disabled";
        default:
            return @"Unknown";
    }
}

NSString * YRXCameraStringFromDisplayMode(YRXCameraDisplayMode mode) {
    switch (mode) {
        case YRXCameraDisplayModeDefault:
            return @"Default";
        case YRXCameraDisplayModeCompact:
            return @"Compact";
        case YRXCameraDisplayModeExpanded:
            return @"Expanded";
        case YRXCameraDisplayModeMinimal:
            return @"Minimal";
        default:
            return @"Unknown";
    }
}

NSString * YRXCameraStringFromCameraType(YRXCameraType type) {
    switch (type) {
        case YRXCameraTypePhoto:
            return @"Photo";
        case YRXCameraTypeVideo:
            return @"Video";
        case YRXCameraTypePanorama:
            return @"Panorama";
        case YRXCameraTypePortrait:
            return @"Portrait";
        case YRXCameraTypeTimelapase:
            return @"Timelapse";
        case YRXCameraTypeUnknown:
        default:
            return @"Unknown";
    }
}