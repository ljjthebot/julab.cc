//
//  YRXCameraUIFactory.h
//  YRXCamera
//
//  Created by Refactoring on 2024.
//  Copyright © 2024 JULAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRXCameraConstants.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * YRXCameraUIFactory
 * 
 * Factory class for creating and configuring UI components
 * Centralizes UI creation logic and ensures consistent styling
 */

@interface YRXCameraUIFactory : NSObject

#pragma mark - Label Creation

/**
 * Create a title label with predefined styling
 * @return Configured UILabel for title display
 */
+ (UILabel *)createTitleLabel;

/**
 * Create a subtitle label with predefined styling
 * @return Configured UILabel for subtitle display
 */
+ (UILabel *)createSubtitleLabel;

/**
 * Create a description label with predefined styling
 * @return Configured UILabel for description display
 */
+ (UILabel *)createDescriptionLabel;

/**
 * Create a detail label with predefined styling
 * @return Configured UILabel for detail information
 */
+ (UILabel *)createDetailLabel;

/**
 * Create a status label with predefined styling
 * @return Configured UILabel for status display
 */
+ (UILabel *)createStatusLabel;

#pragma mark - Button Creation

/**
 * Create a primary action button
 * @param title The button title
 * @return Configured UIButton for primary actions
 */
+ (UIButton *)createPrimaryButtonWithTitle:(NSString *)title;

/**
 * Create a secondary action button
 * @param title The button title
 * @return Configured UIButton for secondary actions
 */
+ (UIButton *)createSecondaryButtonWithTitle:(NSString *)title;

/**
 * Create a detail disclosure button
 * @return Configured UIButton for detail disclosure
 */
+ (UIButton *)createDetailButton;

/**
 * Create an icon button with system image
 * @param systemImageName The SF Symbols name
 * @return Configured UIButton with icon
 */
+ (UIButton *)createIconButtonWithSystemImage:(NSString *)systemImageName;

#pragma mark - Image View Creation

/**
 * Create a camera image view with predefined styling
 * @return Configured UIImageView for camera images
 */
+ (UIImageView *)createCameraImageView;

/**
 * Create a thumbnail image view
 * @return Configured UIImageView for thumbnails
 */
+ (UIImageView *)createThumbnailImageView;

/**
 * Create an icon image view
 * @return Configured UIImageView for icons
 */
+ (UIImageView *)createIconImageView;

#pragma mark - Container Views

/**
 * Create a content container view
 * @return Configured UIView for content layout
 */
+ (UIView *)createContentContainerView;

/**
 * Create a card-style container view
 * @return Configured UIView with card styling
 */
+ (UIView *)createCardContainerView;

/**
 * Create a separator view
 * @return Configured UIView for visual separation
 */
+ (UIView *)createSeparatorView;

#pragma mark - Activity Indicators

/**
 * Create a loading activity indicator
 * @return Configured UIActivityIndicatorView
 */
+ (UIActivityIndicatorView *)createLoadingIndicator;

/**
 * Create a small activity indicator
 * @return Configured small UIActivityIndicatorView
 */
+ (UIActivityIndicatorView *)createSmallLoadingIndicator;

#pragma mark - Progress Views

/**
 * Create a progress view for loading states
 * @return Configured UIProgressView
 */
+ (UIProgressView *)createProgressView;

#pragma mark - Stack Views

/**
 * Create a vertical stack view with default spacing
 * @return Configured UIStackView for vertical layout
 */
+ (UIStackView *)createVerticalStackView;

/**
 * Create a horizontal stack view with default spacing
 * @return Configured UIStackView for horizontal layout
 */
+ (UIStackView *)createHorizontalStackView;

/**
 * Create a compact stack view with minimal spacing
 * @return Configured UIStackView for compact layout
 */
+ (UIStackView *)createCompactStackView;

#pragma mark - Configuration Methods

/**
 * Configure view for specific cell state
 * @param view The view to configure
 * @param state The cell state
 */
+ (void)configureView:(UIView *)view forState:(YRXCameraCellState)state;

/**
 * Configure label for specific display mode
 * @param label The label to configure
 * @param mode The display mode
 */
+ (void)configureLabel:(UILabel *)label forDisplayMode:(YRXCameraDisplayMode)mode;

/**
 * Configure button for specific state
 * @param button The button to configure
 * @param state The cell state
 * @param enabled Whether the button should be enabled
 */
+ (void)configureButton:(UIButton *)button forState:(YRXCameraCellState)state enabled:(BOOL)enabled;

/**
 * Configure image view for loading state
 * @param imageView The image view to configure
 * @param isLoading Whether to show loading state
 */
+ (void)configureImageView:(UIImageView *)imageView loading:(BOOL)isLoading;

#pragma mark - Styling Utilities

/**
 * Apply shadow to view
 * @param view The view to add shadow to
 * @param opacity Shadow opacity (0.0 - 1.0)
 */
+ (void)applyShadowToView:(UIView *)view opacity:(CGFloat)opacity;

/**
 * Apply corner radius to view
 * @param view The view to round corners
 * @param radius The corner radius
 */
+ (void)applyCornerRadius:(CGFloat)radius toView:(UIView *)view;

/**
 * Apply border to view
 * @param view The view to add border to
 * @param width Border width
 * @param color Border color
 */
+ (void)applyBorderToView:(UIView *)view width:(CGFloat)width color:(UIColor *)color;

/**
 * Apply gradient background to view
 * @param view The view to add gradient to
 * @param colors Array of UIColor objects for gradient
 */
+ (void)applyGradientToView:(UIView *)view colors:(NSArray<UIColor *> *)colors;

#pragma mark - Animation Utilities

/**
 * Animate view appearance
 * @param view The view to animate
 * @param completion Completion block
 */
+ (void)animateViewAppearance:(UIView *)view completion:(void (^ _Nullable)(BOOL finished))completion;

/**
 * Animate view disappearance
 * @param view The view to animate
 * @param completion Completion block
 */
+ (void)animateViewDisappearance:(UIView *)view completion:(void (^ _Nullable)(BOOL finished))completion;

/**
 * Animate state transition for view
 * @param view The view to animate
 * @param fromState Previous state
 * @param toState New state
 * @param completion Completion block
 */
+ (void)animateView:(UIView *)view 
          fromState:(YRXCameraCellState)fromState 
            toState:(YRXCameraCellState)toState 
         completion:(void (^ _Nullable)(BOOL finished))completion;

#pragma mark - Accessibility

/**
 * Configure accessibility for view
 * @param view The view to configure
 * @param label Accessibility label
 * @param hint Accessibility hint
 * @param traits Accessibility traits
 */
+ (void)configureAccessibilityForView:(UIView *)view 
                                label:(NSString * _Nullable)label 
                                 hint:(NSString * _Nullable)hint 
                               traits:(UIAccessibilityTraits)traits;

@end

NS_ASSUME_NONNULL_END