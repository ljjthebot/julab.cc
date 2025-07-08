//
//  YRXCameraFormatter.m
//  YRXCamera
//
//  Created by Refactoring on 2024.
//  Copyright © 2024 JULAB. All rights reserved.
//

#import "YRXCameraFormatter.h"

@implementation YRXCameraFormatter

#pragma mark - Text Formatting

+ (NSString *)formatTitle:(NSString *)title maxLength:(NSInteger)maxLength {
    NSString *sanitized = [self validateAndSanitizeText:title];
    return YRXCameraTruncateString(sanitized, maxLength);
}

+ (NSString *)formatSubtitle:(NSString *)subtitle cameraType:(YRXCameraType)cameraType {
    NSString *sanitized = [self validateAndSanitizeText:subtitle];
    NSString *typeString = YRXCameraStringFromCameraType(cameraType);
    
    if (sanitized.length == 0) {
        return typeString;
    }
    
    if (cameraType == YRXCameraTypeUnknown) {
        return sanitized;
    }
    
    return [NSString stringWithFormat:@"%@ • %@", sanitized, typeString];
}

+ (NSString *)formatDescription:(NSString *)description displayMode:(YRXCameraDisplayMode)displayMode {
    NSString *sanitized = [self validateAndSanitizeText:description];
    
    NSInteger maxLength;
    switch (displayMode) {
        case YRXCameraDisplayModeMinimal:
            return @""; // No description in minimal mode
        case YRXCameraDisplayModeCompact:
            maxLength = 50;
            break;
        case YRXCameraDisplayModeExpanded:
            maxLength = YRXCameraMaxDescriptionLength;
            break;
        case YRXCameraDisplayModeDefault:
        default:
            maxLength = 100;
            break;
    }
    
    return YRXCameraTruncateString(sanitized, maxLength);
}

+ (NSString *)formatAccessibilityText:(NSString *)text context:(NSString *)context {
    NSString *sanitized = [self validateAndSanitizeText:text];
    
    if (sanitized.length == 0) {
        return context ?: @"";
    }
    
    if (context.length == 0) {
        return sanitized;
    }
    
    return [NSString stringWithFormat:@"%@. %@", sanitized, context];
}

#pragma mark - Date Formatting

+ (NSString *)formatDate:(NSDate *)date {
    if (!date) {
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    return [formatter stringFromDate:date];
}

+ (NSString *)formatRelativeTime:(NSDate *)date {
    if (!date) {
        return @"";
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    
    if (timeInterval < 60) {
        return @"Just now";
    } else if (timeInterval < 3600) {
        NSInteger minutes = (NSInteger)(timeInterval / 60);
        return [NSString stringWithFormat:@"%ld minute%@ ago", (long)minutes, minutes == 1 ? @"" : @"s"];
    } else if (timeInterval < 86400) {
        NSInteger hours = (NSInteger)(timeInterval / 3600);
        return [NSString stringWithFormat:@"%ld hour%@ ago", (long)hours, hours == 1 ? @"" : @"s"];
    } else if (timeInterval < 604800) {
        NSInteger days = (NSInteger)(timeInterval / 86400);
        return [NSString stringWithFormat:@"%ld day%@ ago", (long)days, days == 1 ? @"" : @"s"];
    } else {
        return [self formatDate:date];
    }
}

+ (NSString *)formatDetailedTimestamp:(NSDate *)date {
    if (!date) {
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterFullStyle;
    formatter.timeStyle = NSDateFormatterMediumStyle;
    return [formatter stringFromDate:date];
}

#pragma mark - Status Formatting

+ (NSString *)formatCameraStatus:(YRXCameraCellState)state cameraType:(YRXCameraType)cameraType {
    NSString *stateString = YRXCameraStringFromCellState(state);
    NSString *typeString = YRXCameraStringFromCameraType(cameraType);
    
    switch (state) {
        case YRXCameraCellStateLoading:
            return [NSString stringWithFormat:@"Loading %@...", typeString];
        case YRXCameraCellStateError:
            return [NSString stringWithFormat:@"Error loading %@", typeString];
        case YRXCameraCellStateDisabled:
            return [NSString stringWithFormat:@"%@ unavailable", typeString];
        case YRXCameraCellStateSelected:
            return [NSString stringWithFormat:@"%@ selected", typeString];
        case YRXCameraCellStateNormal:
        default:
            return [NSString stringWithFormat:@"%@ ready", typeString];
    }
}

+ (NSString *)formatErrorMessage:(NSError *)error {
    if (!error) {
        return @"Unknown error occurred";
    }
    
    // Map common error codes to user-friendly messages
    switch (error.code) {
        case NSURLErrorNotConnectedToInternet:
            return @"No internet connection";
        case NSURLErrorTimedOut:
            return @"Request timed out";
        case NSURLErrorCannotFindHost:
            return @"Server not found";
        case NSURLErrorBadURL:
            return @"Invalid URL";
        default:
            return error.localizedDescription ?: @"An error occurred";
    }
}

+ (NSString *)formatLoadingMessage:(YRXCameraType)cameraType {
    NSString *typeString = YRXCameraStringFromCameraType(cameraType);
    return [NSString stringWithFormat:@"Loading %@...", typeString.lowercaseString];
}

#pragma mark - Metadata Formatting

+ (NSString *)formatMetadata:(NSDictionary *)metadata {
    if (!metadata || metadata.count == 0) {
        return @"";
    }
    
    NSMutableArray *parts = [NSMutableArray array];
    
    // Format common metadata fields
    if (metadata[@"resolution"]) {
        [parts addObject:[NSString stringWithFormat:@"Resolution: %@", metadata[@"resolution"]]];
    }
    
    if (metadata[@"fileSize"]) {
        NSNumber *size = metadata[@"fileSize"];
        [parts addObject:[NSString stringWithFormat:@"Size: %@", [self formatFileSize:size.unsignedIntegerValue]]];
    }
    
    if (metadata[@"duration"]) {
        NSNumber *duration = metadata[@"duration"];
        [parts addObject:[NSString stringWithFormat:@"Duration: %.1fs", duration.doubleValue]];
    }
    
    if (metadata[@"format"]) {
        [parts addObject:[NSString stringWithFormat:@"Format: %@", metadata[@"format"]]];
    }
    
    return [parts componentsJoinedByString:@" • "];
}

+ (NSString *)formatFileSize:(NSUInteger)bytes {
    if (bytes < 1024) {
        return [NSString stringWithFormat:@"%lu B", (unsigned long)bytes];
    } else if (bytes < 1024 * 1024) {
        double kb = bytes / 1024.0;
        return [NSString stringWithFormat:@"%.1f KB", kb];
    } else if (bytes < 1024 * 1024 * 1024) {
        double mb = bytes / (1024.0 * 1024.0);
        return [NSString stringWithFormat:@"%.1f MB", mb];
    } else {
        double gb = bytes / (1024.0 * 1024.0 * 1024.0);
        return [NSString stringWithFormat:@"%.2f GB", gb];
    }
}

+ (NSString *)formatResolution:(NSUInteger)width height:(NSUInteger)height {
    return [NSString stringWithFormat:@"%lu × %lu", (unsigned long)width, (unsigned long)height];
}

#pragma mark - Validation

+ (NSString *)validateAndSanitizeText:(NSString *)text {
    if (!text || ![text isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    NSString *trimmed = [self trimText:text];
    return [self sanitizeText:trimmed];
}

+ (BOOL)isTextSafeForDisplay:(NSString *)text {
    if (!text || ![text isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    // Check for potentially harmful characters
    NSCharacterSet *unsafeCharacters = [NSCharacterSet characterSetWithCharactersInString:@"<>\"'&"];
    return [text rangeOfCharacterFromSet:unsafeCharacters].location == NSNotFound;
}

+ (NSString *)sanitizeText:(NSString *)text {
    if (!text || ![text isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    // Remove potentially harmful characters
    NSMutableString *sanitized = [text mutableCopy];
    [sanitized replaceOccurrencesOfString:@"<" withString:@"" options:0 range:NSMakeRange(0, sanitized.length)];
    [sanitized replaceOccurrencesOfString:@">" withString:@"" options:0 range:NSMakeRange(0, sanitized.length)];
    [sanitized replaceOccurrencesOfString:@"\"" withString:@"'" options:0 range:NSMakeRange(0, sanitized.length)];
    [sanitized replaceOccurrencesOfString:@"&" withString:@"and" options:0 range:NSMakeRange(0, sanitized.length)];
    
    return [sanitized copy];
}

#pragma mark - Utility Methods

+ (NSString *)titleCaseText:(NSString *)text {
    if (!YRXCameraIsValidString(text)) {
        return @"";
    }
    
    return [text capitalizedString];
}

+ (NSString *)sentenceCaseText:(NSString *)text {
    if (!YRXCameraIsValidString(text)) {
        return @"";
    }
    
    NSMutableString *result = [text.lowercaseString mutableCopy];
    if (result.length > 0) {
        [result replaceCharactersInRange:NSMakeRange(0, 1) 
                              withString:[[result substringToIndex:1] uppercaseString]];
    }
    return [result copy];
}

+ (NSString *)trimText:(NSString *)text {
    if (!text || ![text isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end