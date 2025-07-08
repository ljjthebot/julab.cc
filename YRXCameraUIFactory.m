//
//  YRXCameraUIFactory.m
//  YRXCamera
//
//  Created by Refactoring on 2024.
//  Copyright © 2024 JULAB. All rights reserved.
//

#import "YRXCameraUIFactory.h"

@implementation YRXCameraUIFactory

#pragma mark - Label Creation

+ (UILabel *)createTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = YRXCameraTitleFont();
    label.textColor = [UIColor labelColor];
    label.numberOfLines = 1;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

+ (UILabel *)createSubtitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = YRXCameraSubtitleFont();
    label.textColor = [UIColor secondaryLabelColor];
    label.numberOfLines = 1;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

+ (UILabel *)createDescriptionLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = YRXCameraDetailFont();
    label.textColor = [UIColor secondaryLabelColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

+ (UILabel *)createDetailLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = YRXCameraDetailFont();
    label.textColor = [UIColor tertiaryLabelColor];
    label.numberOfLines = 1;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

+ (UILabel *)createStatusLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = YRXCameraDetailFont();
    label.textColor = YRXCameraColorFromHex(YRXCameraSecondaryColorHex);
    label.numberOfLines = 1;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

#pragma mark - Button Creation

+ (UIButton *)createPrimaryButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = YRXCameraButtonFont();
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = YRXCameraColorFromHex(YRXCameraPrimaryColorHex);
    button.layer.cornerRadius = YRXCameraButtonCornerRadius;
    button.layer.masksToBounds = YES;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add touch effects
    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    
    return button;
}

+ (UIButton *)createSecondaryButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = YRXCameraButtonFont();
    [button setTitleColor:YRXCameraColorFromHex(YRXCameraPrimaryColorHex) forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.layer.cornerRadius = YRXCameraButtonCornerRadius;
    button.layer.borderWidth = YRXCameraButtonBorderWidth;
    button.layer.borderColor = YRXCameraColorFromHex(YRXCameraPrimaryColorHex).CGColor;
    button.layer.masksToBounds = YES;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add touch effects
    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    
    return button;
}

+ (UIButton *)createDetailButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button.tintColor = YRXCameraColorFromHex(YRXCameraPrimaryColorHex);
    button.translatesAutoresizingMaskIntoConstraints = NO;
    return button;
}

+ (UIButton *)createIconButtonWithSystemImage:(NSString *)systemImageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    if (@available(iOS 13.0, *)) {
        UIImage *image = [UIImage systemImageNamed:systemImageName];
        [button setImage:image forState:UIControlStateNormal];
    }
    
    button.tintColor = YRXCameraColorFromHex(YRXCameraPrimaryColorHex);
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    return button;
}

#pragma mark - Image View Creation

+ (UIImageView *)createCameraImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = YRXCameraImageViewCornerRadius;
    imageView.layer.masksToBounds = YES;
    imageView.backgroundColor = YRXCameraColorFromHex(YRXCameraBackgroundColorHex);
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add placeholder border
    imageView.layer.borderWidth = 1.0;
    imageView.layer.borderColor = YRXCameraColorFromHex(YRXCameraBorderColorHex).CGColor;
    
    return imageView;
}

+ (UIImageView *)createThumbnailImageView {
    UIImageView *imageView = [self createCameraImageView];
    imageView.layer.cornerRadius = 4.0; // Smaller radius for thumbnails
    return imageView;
}

+ (UIImageView *)createIconImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tintColor = YRXCameraColorFromHex(YRXCameraSecondaryColorHex);
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    return imageView;
}

#pragma mark - Container Views

+ (UIView *)createContentContainerView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    return containerView;
}

+ (UIView *)createCardContainerView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = YRXCameraColorFromHex(YRXCameraBackgroundColorHex);
    containerView.layer.cornerRadius = 12.0;
    containerView.layer.masksToBounds = YES;
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add subtle shadow
    [self applyShadowToView:containerView opacity:0.1];
    
    return containerView;
}

+ (UIView *)createSeparatorView {
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = YRXCameraColorFromHex(YRXCameraBorderColorHex);
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    return separatorView;
}

#pragma mark - Activity Indicators

+ (UIActivityIndicatorView *)createLoadingIndicator {
    UIActivityIndicatorView *indicator;
    if (@available(iOS 13.0, *)) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    } else {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    indicator.color = YRXCameraColorFromHex(YRXCameraPrimaryColorHex);
    indicator.hidesWhenStopped = YES;
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    return indicator;
}

+ (UIActivityIndicatorView *)createSmallLoadingIndicator {
    UIActivityIndicatorView *indicator;
    if (@available(iOS 13.0, *)) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleSmall];
    } else {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    
    indicator.color = YRXCameraColorFromHex(YRXCameraSecondaryColorHex);
    indicator.hidesWhenStopped = YES;
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    return indicator;
}

#pragma mark - Progress Views

+ (UIProgressView *)createProgressView {
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.progressTintColor = YRXCameraColorFromHex(YRXCameraPrimaryColorHex);
    progressView.trackTintColor = YRXCameraColorFromHex(YRXCameraBorderColorHex);
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    return progressView;
}

#pragma mark - Stack Views

+ (UIStackView *)createVerticalStackView {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = YRXCameraCellElementSpacing;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    return stackView;
}

+ (UIStackView *)createHorizontalStackView {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = YRXCameraCellElementSpacing;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    return stackView;
}

+ (UIStackView *)createCompactStackView {
    UIStackView *stackView = [self createVerticalStackView];
    stackView.spacing = YRXCameraCellInnerPadding;
    return stackView;
}

#pragma mark - Configuration Methods

+ (void)configureView:(UIView *)view forState:(YRXCameraCellState)state {
    switch (state) {
        case YRXCameraCellStateNormal:
            view.alpha = 1.0;
            view.userInteractionEnabled = YES;
            break;
            
        case YRXCameraCellStateSelected:
            view.alpha = 1.0;
            view.userInteractionEnabled = YES;
            view.backgroundColor = [YRXCameraColorFromHex(YRXCameraPrimaryColorHex) colorWithAlphaComponent:0.1];
            break;
            
        case YRXCameraCellStateLoading:
            view.alpha = 0.8;
            view.userInteractionEnabled = NO;
            break;
            
        case YRXCameraCellStateError:
            view.alpha = 1.0;
            view.userInteractionEnabled = YES;
            view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
            break;
            
        case YRXCameraCellStateDisabled:
            view.alpha = 0.5;
            view.userInteractionEnabled = NO;
            break;
    }
}

+ (void)configureLabel:(UILabel *)label forDisplayMode:(YRXCameraDisplayMode)mode {
    switch (mode) {
        case YRXCameraDisplayModeMinimal:
            label.numberOfLines = 1;
            label.font = [UIFont systemFontOfSize:YRXCameraDetailFontSize];
            break;
            
        case YRXCameraDisplayModeCompact:
            label.numberOfLines = 1;
            break;
            
        case YRXCameraDisplayModeExpanded:
            label.numberOfLines = 0;
            break;
            
        case YRXCameraDisplayModeDefault:
        default:
            label.numberOfLines = 2;
            break;
    }
}

+ (void)configureButton:(UIButton *)button forState:(YRXCameraCellState)state enabled:(BOOL)enabled {
    button.enabled = enabled && (state != YRXCameraCellStateLoading && state != YRXCameraCellStateDisabled);
    
    switch (state) {
        case YRXCameraCellStateLoading:
            button.alpha = 0.5;
            break;
            
        case YRXCameraCellStateDisabled:
            button.alpha = 0.3;
            break;
            
        case YRXCameraCellStateError:
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            break;
            
        default:
            button.alpha = 1.0;
            break;
    }
}

+ (void)configureImageView:(UIImageView *)imageView loading:(BOOL)isLoading {
    if (isLoading) {
        imageView.alpha = 0.5;
        
        // Add shimmer effect for loading
        CAGradientLayer *shimmerLayer = [CAGradientLayer layer];
        shimmerLayer.colors = @[
            (id)[UIColor clearColor].CGColor,
            (id)[[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor,
            (id)[UIColor clearColor].CGColor
        ];
        shimmerLayer.locations = @[@0.0, @0.5, @1.0];
        shimmerLayer.startPoint = CGPointMake(0.0, 0.5);
        shimmerLayer.endPoint = CGPointMake(1.0, 0.5);
        shimmerLayer.frame = imageView.bounds;
        
        [imageView.layer addSublayer:shimmerLayer];
        
        // Animate shimmer
        CABasicAnimation *shimmerAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
        shimmerAnimation.fromValue = @[@(-0.5), @0.0, @0.5];
        shimmerAnimation.toValue = @[@0.5, @1.0, @1.5];
        shimmerAnimation.duration = 1.5;
        shimmerAnimation.repeatCount = INFINITY;
        [shimmerLayer addAnimation:shimmerAnimation forKey:@"shimmer"];
    } else {
        imageView.alpha = 1.0;
        
        // Remove shimmer layers
        NSArray *sublayers = [imageView.layer.sublayers copy];
        for (CALayer *layer in sublayers) {
            if ([layer isKindOfClass:[CAGradientLayer class]]) {
                [layer removeFromSuperlayer];
            }
        }
    }
}

#pragma mark - Styling Utilities

+ (void)applyShadowToView:(UIView *)view opacity:(CGFloat)opacity {
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.layer.shadowRadius = 4.0;
    view.layer.shadowOpacity = opacity;
    view.layer.masksToBounds = NO;
}

+ (void)applyCornerRadius:(CGFloat)radius toView:(UIView *)view {
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

+ (void)applyBorderToView:(UIView *)view width:(CGFloat)width color:(UIColor *)color {
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
}

+ (void)applyGradientToView:(UIView *)view colors:(NSArray<UIColor *> *)colors {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColors addObject:(id)color.CGColor];
    }
    gradientLayer.colors = cgColors;
    
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

#pragma mark - Animation Utilities

+ (void)animateViewAppearance:(UIView *)view completion:(void (^)(BOOL))completion {
    view.alpha = 0.0;
    view.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    [UIView animateWithDuration:YRXCameraDefaultAnimationDuration
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         view.alpha = 1.0;
                         view.transform = CGAffineTransformIdentity;
                     }
                     completion:completion];
}

+ (void)animateViewDisappearance:(UIView *)view completion:(void (^)(BOOL))completion {
    [UIView animateWithDuration:YRXCameraFastAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         view.alpha = 0.0;
                         view.transform = CGAffineTransformMakeScale(0.9, 0.9);
                     }
                     completion:completion];
}

+ (void)animateView:(UIView *)view fromState:(YRXCameraCellState)fromState toState:(YRXCameraCellState)toState completion:(void (^)(BOOL))completion {
    [UIView animateWithDuration:YRXCameraDefaultAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self configureView:view forState:toState];
                     }
                     completion:completion];
}

#pragma mark - Accessibility

+ (void)configureAccessibilityForView:(UIView *)view label:(NSString *)label hint:(NSString *)hint traits:(UIAccessibilityTraits)traits {
    view.isAccessibilityElement = YES;
    view.accessibilityLabel = label;
    view.accessibilityHint = hint;
    view.accessibilityTraits = traits;
}

#pragma mark - Button Touch Effects

+ (void)buttonTouchDown:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
        button.alpha = 0.8;
    }];
}

+ (void)buttonTouchUp:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformIdentity;
        button.alpha = 1.0;
    }];
}

@end