//
//  YRXCameraFormatter.h
//  YRXCamera
//
//  Created by Refactoring on 2024.
//  Copyright © 2024 JULAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRXCameraConstants.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * YRXCameraFormatter
 * 
 * Centralized formatting utilities for YRXCamera components
 * Handles all text formatting, date formatting, and display string generation
 */

@interface YRXCameraFormatter : NSObject

#pragma mark - Text Formatting

/**
 * Format title text with truncation and validation
 * @param title The original title string
 * @param maxLength Maximum allowed length
 * @return Formatted and validated title string
 */
+ (NSString *)formatTitle:(NSString * _Nullable)title maxLength:(NSInteger)maxLength;

/**
 * Format subtitle with camera type context
 * @param subtitle The original subtitle string
 * @param cameraType The camera type for additional context
 * @return Formatted subtitle string with type information
 */
+ (NSString *)formatSubtitle:(NSString * _Nullable)subtitle cameraType:(YRXCameraType)cameraType;

/**
 * Format description based on display mode
 * @param description The original description string
 * @param displayMode The current display mode
 * @return Formatted description appropriate for the display mode
 */
+ (NSString *)formatDescription:(NSString * _Nullable)description displayMode:(YRXCameraDisplayMode)displayMode;

/**
 * Format text for accessibility
 * @param text The original text
 * @param context Additional context for screen readers
 * @return Accessibility-friendly text
 */
+ (NSString *)formatAccessibilityText:(NSString * _Nullable)text context:(NSString * _Nullable)context;

#pragma mark - Date Formatting

/**
 * Format date for display in cell
 * @param date The date to format
 * @return Human-readable date string
 */
+ (NSString *)formatDate:(NSDate * _Nullable)date;

/**
 * Format relative time (e.g., "2 hours ago")
 * @param date The date to format
 * @return Relative time string
 */
+ (NSString *)formatRelativeTime:(NSDate * _Nullable)date;

/**
 * Format timestamp for detailed view
 * @param date The date to format
 * @return Detailed timestamp string
 */
+ (NSString *)formatDetailedTimestamp:(NSDate * _Nullable)date;

#pragma mark - Status Formatting

/**
 * Format camera status for display
 * @param state The current cell state
 * @param cameraType The camera type
 * @return Formatted status string
 */
+ (NSString *)formatCameraStatus:(YRXCameraCellState)state cameraType:(YRXCameraType)cameraType;

/**
 * Format error message for display
 * @param error The error object
 * @return User-friendly error message
 */
+ (NSString *)formatErrorMessage:(NSError * _Nullable)error;

/**
 * Format loading message
 * @param cameraType The camera type being loaded
 * @return Loading message string
 */
+ (NSString *)formatLoadingMessage:(YRXCameraType)cameraType;

#pragma mark - Metadata Formatting

/**
 * Format metadata dictionary for display
 * @param metadata The metadata dictionary
 * @return Formatted metadata string
 */
+ (NSString *)formatMetadata:(NSDictionary * _Nullable)metadata;

/**
 * Format file size for display
 * @param bytes The size in bytes
 * @return Human-readable file size string
 */
+ (NSString *)formatFileSize:(NSUInteger)bytes;

/**
 * Format resolution for display
 * @param width The width in pixels
 * @param height The height in pixels
 * @return Formatted resolution string
 */
+ (NSString *)formatResolution:(NSUInteger)width height:(NSUInteger)height;

#pragma mark - Validation

/**
 * Validate and sanitize input text
 * @param text The input text to validate
 * @return Sanitized text or empty string if invalid
 */
+ (NSString *)validateAndSanitizeText:(NSString * _Nullable)text;

/**
 * Check if text is safe for display
 * @param text The text to check
 * @return YES if safe for display, NO otherwise
 */
+ (BOOL)isTextSafeForDisplay:(NSString * _Nullable)text;

/**
 * Remove potentially harmful characters
 * @param text The text to sanitize
 * @return Sanitized text
 */
+ (NSString *)sanitizeText:(NSString * _Nullable)text;

#pragma mark - Utility Methods

/**
 * Capitalize first letter of each word
 * @param text The text to capitalize
 * @return Title-cased text
 */
+ (NSString *)titleCaseText:(NSString * _Nullable)text;

/**
 * Convert text to sentence case
 * @param text The text to convert
 * @return Sentence-cased text
 */
+ (NSString *)sentenceCaseText:(NSString * _Nullable)text;

/**
 * Trim whitespace and newlines
 * @param text The text to trim
 * @return Trimmed text
 */
+ (NSString *)trimText:(NSString * _Nullable)text;

@end

NS_ASSUME_NONNULL_END