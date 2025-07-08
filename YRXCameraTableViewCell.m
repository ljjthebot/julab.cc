//
//  YRXCameraTableViewCell.m
//  YRXCamera
//
//  Created by Refactoring on 2024.
//  Copyright © 2024 JULAB. All rights reserved.
//

#import "YRXCameraTableViewCell.h"
#import "YRXCameraViewModel.h"
#import "YRXCameraStateManager.h"
#import "YRXCameraUIFactory.h"
#import "YRXCameraFormatter.h"

@interface YRXCameraTableViewCell () <YRXCameraStateManagerDelegate>

#pragma mark - UI Components

// Main container views
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UIStackView *mainStackView;
@property (nonatomic, strong) UIStackView *textStackView;

// Image components
@property (nonatomic, strong) UIImageView *cameraImageView;
@property (nonatomic, strong) UIActivityIndicatorView *imageLoadingIndicator;

// Text components
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *statusLabel;

// Action components
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIView *separatorView;

// Loading components
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UIProgressView *progressView;

#pragma mark - Internal Properties

@property (nonatomic, strong, readwrite) YRXCameraViewModel *viewModel;
@property (nonatomic, strong) YRXCameraStateManager *stateManager;
@property (nonatomic, assign, readwrite) YRXCameraCellState currentState;

// Layout constraints for different modes
@property (nonatomic, strong) NSArray<NSLayoutConstraint *> *defaultConstraints;
@property (nonatomic, strong) NSArray<NSLayoutConstraint *> *compactConstraints;
@property (nonatomic, strong) NSArray<NSLayoutConstraint *> *expandedConstraints;
@property (nonatomic, strong) NSArray<NSLayoutConstraint *> *minimalConstraints;

// State tracking
@property (nonatomic, assign) BOOL isConfigured;
@property (nonatomic, assign) BOOL needsLayoutUpdate;

@end

@implementation YRXCameraTableViewCell

#pragma mark - Reuse Identifier

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - Initialization

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // Initialize properties
    _displayMode = YRXCameraDisplayModeDefault;
    _animationsEnabled = YES;
    _isConfigured = NO;
    _needsLayoutUpdate = YES;
    
    // Initialize state manager
    _stateManager = [[YRXCameraStateManager alloc] init];
    _stateManager.delegate = self;
    _stateManager.animateTransitions = YES;
    _currentState = _stateManager.currentState;
    
    // Setup UI
    [self setupUIComponents];
    [self setupConstraints];
    [self setupGestureRecognizers];
    
    // Configure initial appearance
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - UI Setup

- (void)setupUIComponents {
    // Create main container
    self.contentContainerView = [YRXCameraUIFactory createContentContainerView];
    [self.contentView addSubview:self.contentContainerView];
    
    // Create main stack view
    self.mainStackView = [YRXCameraUIFactory createHorizontalStackView];
    [self.contentContainerView addSubview:self.mainStackView];
    
    // Create image components
    [self setupImageComponents];
    
    // Create text components
    [self setupTextComponents];
    
    // Create action components
    [self setupActionComponents];
    
    // Create loading components
    [self setupLoadingComponents];
    
    // Add components to stack view
    [self.mainStackView addArrangedSubview:self.cameraImageView];
    [self.mainStackView addArrangedSubview:self.textStackView];
    [self.mainStackView addArrangedSubview:self.detailButton];
}

- (void)setupImageComponents {
    // Main camera image view
    self.cameraImageView = [YRXCameraUIFactory createCameraImageView];
    
    // Image loading indicator
    self.imageLoadingIndicator = [YRXCameraUIFactory createSmallLoadingIndicator];
    [self.cameraImageView addSubview:self.imageLoadingIndicator];
    
    // Center the loading indicator
    [NSLayoutConstraint activateConstraints:@[
        [self.imageLoadingIndicator.centerXAnchor constraintEqualToAnchor:self.cameraImageView.centerXAnchor],
        [self.imageLoadingIndicator.centerYAnchor constraintEqualToAnchor:self.cameraImageView.centerYAnchor]
    ]];
}

- (void)setupTextComponents {
    // Create text stack view
    self.textStackView = [YRXCameraUIFactory createVerticalStackView];
    
    // Create labels
    self.titleLabel = [YRXCameraUIFactory createTitleLabel];
    self.subtitleLabel = [YRXCameraUIFactory createSubtitleLabel];
    self.descriptionLabel = [YRXCameraUIFactory createDescriptionLabel];
    self.statusLabel = [YRXCameraUIFactory createStatusLabel];
    
    // Add labels to text stack
    [self.textStackView addArrangedSubview:self.titleLabel];
    [self.textStackView addArrangedSubview:self.subtitleLabel];
    [self.textStackView addArrangedSubview:self.descriptionLabel];
    [self.textStackView addArrangedSubview:self.statusLabel];
    
    // Initially hide status label
    self.statusLabel.hidden = YES;
}

- (void)setupActionComponents {
    // Detail button
    self.detailButton = [YRXCameraUIFactory createDetailButton];
    [self.detailButton addTarget:self action:@selector(detailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Separator view
    self.separatorView = [YRXCameraUIFactory createSeparatorView];
    [self.contentContainerView addSubview:self.separatorView];
}

- (void)setupLoadingComponents {
    // Main loading indicator
    self.loadingIndicator = [YRXCameraUIFactory createLoadingIndicator];
    [self.contentContainerView addSubview:self.loadingIndicator];
    
    // Progress view
    self.progressView = [YRXCameraUIFactory createProgressView];
    [self.contentContainerView addSubview:self.progressView];
    self.progressView.hidden = YES;
    
    // Center loading indicator
    [NSLayoutConstraint activateConstraints:@[
        [self.loadingIndicator.centerXAnchor constraintEqualToAnchor:self.contentContainerView.centerXAnchor],
        [self.loadingIndicator.centerYAnchor constraintEqualToAnchor:self.contentContainerView.centerYAnchor]
    ]];
}

- (void)setupConstraints {
    [self setupContainerConstraints];
    [self setupImageConstraints];
    [self setupLayoutConstraints];
}

- (void)setupContainerConstraints {
    // Content container constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.contentContainerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:YRXCameraCellVerticalMargin],
        [self.contentContainerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:YRXCameraCellHorizontalMargin],
        [self.contentContainerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-YRXCameraCellHorizontalMargin],
        [self.contentContainerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-YRXCameraCellVerticalMargin]
    ]];
    
    // Main stack view constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.mainStackView.topAnchor constraintEqualToAnchor:self.contentContainerView.topAnchor],
        [self.mainStackView.leadingAnchor constraintEqualToAnchor:self.contentContainerView.leadingAnchor],
        [self.mainStackView.trailingAnchor constraintEqualToAnchor:self.contentContainerView.trailingAnchor],
        [self.mainStackView.bottomAnchor constraintEqualToAnchor:self.separatorView.topAnchor]
    ]];
    
    // Separator constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.separatorView.leadingAnchor constraintEqualToAnchor:self.contentContainerView.leadingAnchor],
        [self.separatorView.trailingAnchor constraintEqualToAnchor:self.contentContainerView.trailingAnchor],
        [self.separatorView.bottomAnchor constraintEqualToAnchor:self.contentContainerView.bottomAnchor],
        [self.separatorView.heightAnchor constraintEqualToConstant:1.0]
    ]];
}

- (void)setupImageConstraints {
    // Camera image view constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.cameraImageView.widthAnchor constraintEqualToConstant:YRXCameraImageViewWidth],
        [self.cameraImageView.heightAnchor constraintEqualToConstant:YRXCameraImageViewHeight]
    ]];
}

- (void)setupLayoutConstraints {
    [self createDefaultConstraints];
    [self createCompactConstraints];
    [self createExpandedConstraints];
    [self createMinimalConstraints];
    
    // Activate default constraints initially
    [NSLayoutConstraint activateConstraints:self.defaultConstraints];
}

- (void)createDefaultConstraints {
    self.defaultConstraints = @[
        // Text stack view spacing
        [self.textStackView.topAnchor constraintEqualToAnchor:self.mainStackView.topAnchor],
        [self.textStackView.bottomAnchor constraintEqualToAnchor:self.mainStackView.bottomAnchor],
        
        // Detail button
        [self.detailButton.widthAnchor constraintEqualToConstant:44.0],
        [self.detailButton.heightAnchor constraintEqualToConstant:44.0]
    ];
}

- (void)createCompactConstraints {
    self.compactConstraints = @[
        // Reduced spacing for compact mode
        [self.textStackView.topAnchor constraintEqualToAnchor:self.mainStackView.topAnchor],
        [self.textStackView.bottomAnchor constraintEqualToAnchor:self.mainStackView.bottomAnchor],
        
        // Smaller detail button
        [self.detailButton.widthAnchor constraintEqualToConstant:32.0],
        [self.detailButton.heightAnchor constraintEqualToConstant:32.0]
    ];
}

- (void)createExpandedConstraints {
    self.expandedConstraints = @[
        // Expanded text area
        [self.textStackView.topAnchor constraintEqualToAnchor:self.mainStackView.topAnchor],
        [self.textStackView.bottomAnchor constraintEqualToAnchor:self.mainStackView.bottomAnchor],
        
        // Standard detail button
        [self.detailButton.widthAnchor constraintEqualToConstant:44.0],
        [self.detailButton.heightAnchor constraintEqualToConstant:44.0]
    ];
}

- (void)createMinimalConstraints {
    self.minimalConstraints = @[
        // Minimal text area
        [self.textStackView.centerYAnchor constraintEqualToAnchor:self.mainStackView.centerYAnchor],
        
        // No detail button in minimal mode
        [self.detailButton.widthAnchor constraintEqualToConstant:0.0]
    ];
}

- (void)setupGestureRecognizers {
    // Image tap gesture
    UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    [self.cameraImageView addGestureRecognizer:imageTapGesture];
    self.cameraImageView.userInteractionEnabled = YES;
}

#pragma mark - Configuration

- (void)configureWithModel:(YRXCameraModel *)model {
    [self configureWithModel:model displayMode:self.displayMode];
}

- (void)configureWithViewModel:(YRXCameraViewModel *)viewModel {
    self.viewModel = viewModel;
    [self updateUIWithViewModel];
    self.isConfigured = YES;
}

- (void)configureWithModel:(YRXCameraModel *)model displayMode:(YRXCameraDisplayMode)displayMode {
    // Create or update view model
    if (self.viewModel && self.viewModel.model == model) {
        [self.viewModel updateDisplayMode:displayMode];
    } else {
        self.viewModel = [[YRXCameraViewModel alloc] initWithModel:model displayMode:displayMode];
    }
    
    // Update display mode
    self.displayMode = displayMode;
    
    // Update UI
    [self updateUIWithViewModel];
    [self updateLayoutForDisplayMode];
    
    self.isConfigured = YES;
}

- (void)updateUIWithViewModel {
    if (!self.viewModel) {
        return;
    }
    
    // Update text content
    self.titleLabel.text = self.viewModel.displayTitle;
    self.subtitleLabel.text = self.viewModel.displaySubtitle;
    self.descriptionLabel.text = self.viewModel.displayDescription;
    
    // Update colors
    self.titleLabel.textColor = self.viewModel.titleColor;
    self.subtitleLabel.textColor = self.viewModel.subtitleColor;
    self.contentContainerView.backgroundColor = self.viewModel.backgroundColor;
    
    // Update image
    [self updateImageView];
    
    // Update visibility based on display mode
    [self updateComponentVisibility];
    
    // Update accessibility
    [self updateAccessibilityInformation];
}

- (void)updateImageView {
    if (!self.viewModel) {
        return;
    }
    
    // Set placeholder immediately
    self.cameraImageView.image = self.viewModel.placeholderImage;
    
    // Load actual image if URL is available
    if (self.viewModel.imageURL) {
        [self loadImageFromURL:self.viewModel.imageURL];
    }
}

- (void)loadImageFromURL:(NSURL *)imageURL {
    [self.imageLoadingIndicator startAnimating];
    
    // Simple image loading (in production, use a proper image loading library)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = imageData ? [UIImage imageWithData:imageData] : nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageLoadingIndicator stopAnimating];
            if (image) {
                self.cameraImageView.image = image;
            }
        });
    });
}

- (void)updateComponentVisibility {
    switch (self.displayMode) {
        case YRXCameraDisplayModeMinimal:
            self.descriptionLabel.hidden = YES;
            self.detailButton.hidden = YES;
            self.statusLabel.hidden = YES;
            break;
            
        case YRXCameraDisplayModeCompact:
            self.descriptionLabel.hidden = self.viewModel.displayDescription.length == 0;
            self.detailButton.hidden = !self.viewModel.showsDetailButton;
            self.statusLabel.hidden = !self.viewModel.showsStatusIndicator;
            break;
            
        case YRXCameraDisplayModeExpanded:
            self.descriptionLabel.hidden = NO;
            self.detailButton.hidden = !self.viewModel.showsDetailButton;
            self.statusLabel.hidden = !self.viewModel.showsStatusIndicator;
            break;
            
        case YRXCameraDisplayModeDefault:
        default:
            self.descriptionLabel.hidden = self.viewModel.displayDescription.length == 0;
            self.detailButton.hidden = !self.viewModel.showsDetailButton;
            self.statusLabel.hidden = !self.viewModel.showsStatusIndicator;
            break;
    }
}

- (void)updateLayoutForDisplayMode {
    // Deactivate all layout constraints
    [NSLayoutConstraint deactivateConstraints:self.defaultConstraints];
    [NSLayoutConstraint deactivateConstraints:self.compactConstraints];
    [NSLayoutConstraint deactivateConstraints:self.expandedConstraints];
    [NSLayoutConstraint deactivateConstraints:self.minimalConstraints];
    
    // Activate constraints for current display mode
    switch (self.displayMode) {
        case YRXCameraDisplayModeMinimal:
            [NSLayoutConstraint activateConstraints:self.minimalConstraints];
            break;
            
        case YRXCameraDisplayModeCompact:
            [NSLayoutConstraint activateConstraints:self.compactConstraints];
            break;
            
        case YRXCameraDisplayModeExpanded:
            [NSLayoutConstraint activateConstraints:self.expandedConstraints];
            break;
            
        case YRXCameraDisplayModeDefault:
        default:
            [NSLayoutConstraint activateConstraints:self.defaultConstraints];
            break;
    }
    
    // Configure labels for display mode
    [YRXCameraUIFactory configureLabel:self.titleLabel forDisplayMode:self.displayMode];
    [YRXCameraUIFactory configureLabel:self.subtitleLabel forDisplayMode:self.displayMode];
    [YRXCameraUIFactory configureLabel:self.descriptionLabel forDisplayMode:self.displayMode];
    
    self.needsLayoutUpdate = YES;
}

#pragma mark - State Management

- (void)beginLoading {
    [self.stateManager beginLoading];
}

- (void)finishLoading {
    [self.stateManager finishLoading];
}

- (void)showError:(NSError *)error {
    [self.stateManager enterErrorState:error];
}

- (void)clearError {
    if (self.stateManager.isInErrorState) {
        [self.stateManager transitionToState:YRXCameraCellStateNormal];
    }
}

- (void)enableInteraction {
    [self.stateManager enableCell];
}

- (void)disableInteraction {
    [self.stateManager disableCell];
}

#pragma mark - YRXCameraStateManagerDelegate

- (void)stateManager:(YRXCameraStateManager *)stateManager didChangeState:(YRXCameraCellState)newState fromState:(YRXCameraCellState)oldState {
    self.currentState = newState;
    
    // Update UI for new state
    [self updateUIForState:newState];
    
    // Notify delegate
    if ([self.delegate respondsToSelector:@selector(cameraTableViewCell:didChangeState:fromState:)]) {
        [self.delegate cameraTableViewCell:self didChangeState:newState fromState:oldState];
    }
}

- (void)updateUIForState:(YRXCameraCellState)state {
    // Update main container
    [YRXCameraUIFactory configureView:self.contentContainerView forState:state];
    
    // Update buttons
    [YRXCameraUIFactory configureButton:self.detailButton forState:state enabled:YES];
    
    // Update loading indicators
    switch (state) {
        case YRXCameraCellStateLoading:
            [self.loadingIndicator startAnimating];
            self.statusLabel.text = [YRXCameraFormatter formatLoadingMessage:self.viewModel.cameraType];
            self.statusLabel.hidden = NO;
            break;
            
        case YRXCameraCellStateError:
            [self.loadingIndicator stopAnimating];
            self.statusLabel.text = @"Error loading camera";
            self.statusLabel.textColor = [UIColor redColor];
            self.statusLabel.hidden = NO;
            break;
            
        case YRXCameraCellStateNormal:
        case YRXCameraCellStateSelected:
        case YRXCameraCellStateDisabled:
        default:
            [self.loadingIndicator stopAnimating];
            self.statusLabel.hidden = !self.viewModel.showsStatusIndicator;
            break;
    }
    
    // Update accessibility
    [self updateAccessibilityInformation];
}

#pragma mark - Actions

- (void)detailButtonTapped:(UIButton *)sender {
    if (self.viewModel && [self.delegate respondsToSelector:@selector(cameraTableViewCell:didTapDetailWithModel:)]) {
        [self.delegate cameraTableViewCell:self didTapDetailWithModel:self.viewModel.model];
    }
}

- (void)imageViewTapped:(UITapGestureRecognizer *)gesture {
    if (self.viewModel && [self.delegate respondsToSelector:@selector(cameraTableViewCell:didTapImageWithModel:)]) {
        [self.delegate cameraTableViewCell:self didTapImageWithModel:self.viewModel.model];
    }
}

#pragma mark - Cell Lifecycle

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // Reset state
    [self.stateManager reset];
    
    // Clear content
    self.viewModel = nil;
    self.titleLabel.text = @"";
    self.subtitleLabel.text = @"";
    self.descriptionLabel.text = @"";
    self.statusLabel.text = @"";
    self.cameraImageView.image = nil;
    
    // Stop animations
    [self.loadingIndicator stopAnimating];
    [self.imageLoadingIndicator stopAnimating];
    
    // Reset properties
    self.isConfigured = NO;
    self.needsLayoutUpdate = YES;
    self.displayMode = YRXCameraDisplayModeDefault;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.needsLayoutUpdate) {
        [self updateLayoutForDisplayMode];
        self.needsLayoutUpdate = NO;
    }
}

#pragma mark - Sizing

+ (CGFloat)heightForModel:(YRXCameraModel *)model displayMode:(YRXCameraDisplayMode)displayMode width:(CGFloat)width {
    // Calculate height based on content and display mode
    CGFloat baseHeight = [self defaultHeightForDisplayMode:displayMode];
    
    // Add dynamic height calculation if needed
    // This would involve measuring text content, etc.
    
    return baseHeight;
}

+ (CGFloat)defaultHeightForDisplayMode:(YRXCameraDisplayMode)displayMode {
    switch (displayMode) {
        case YRXCameraDisplayModeMinimal:
            return YRXCameraCellMinimumHeight;
        case YRXCameraDisplayModeCompact:
            return YRXCameraCellDefaultHeight - 20.0;
        case YRXCameraDisplayModeExpanded:
            return YRXCameraCellMaximumHeight;
        case YRXCameraDisplayModeDefault:
        default:
            return YRXCameraCellDefaultHeight;
    }
}

#pragma mark - Accessibility

- (void)updateAccessibilityInformation {
    NSString *accessibilityLabel = [self accessibilityDescription];
    NSString *hint = @"Double tap to view details";
    
    [YRXCameraUIFactory configureAccessibilityForView:self
                                                 label:accessibilityLabel
                                                  hint:hint
                                                traits:UIAccessibilityTraitButton];
}

- (NSString *)accessibilityDescription {
    if (!self.viewModel) {
        return @"Camera cell";
    }
    
    NSMutableArray *components = [NSMutableArray array];
    
    if (self.viewModel.displayTitle.length > 0) {
        [components addObject:self.viewModel.displayTitle];
    }
    
    if (self.viewModel.displaySubtitle.length > 0) {
        [components addObject:self.viewModel.displaySubtitle];
    }
    
    NSString *stateDescription = [YRXCameraFormatter formatCameraStatus:self.currentState cameraType:self.viewModel.cameraType];
    [components addObject:stateDescription];
    
    return [components componentsJoinedByString:@". "];
}

@end