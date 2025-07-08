//
//  YRXCameraViewModel.m
//  YRXCamera
//
//  Created by Refactoring on 2024.
//  Copyright © 2024 JULAB. All rights reserved.
//

#import "YRXCameraViewModel.h"
#import "YRXCameraFormatter.h"

@interface YRXCameraViewModel ()

@property (nonatomic, strong, readwrite) YRXCameraModel *model;
@property (nonatomic, assign, readwrite) YRXCameraCellState cellState;
@property (nonatomic, assign, readwrite) YRXCameraDisplayMode displayMode;

// Cached computed properties
@property (nonatomic, strong) NSString *cachedDisplayTitle;
@property (nonatomic, strong) NSString *cachedDisplaySubtitle;
@property (nonatomic, strong) NSString *cachedDisplayDescription;
@property (nonatomic, strong) NSURL *cachedImageURL;
@property (nonatomic, strong) UIColor *cachedTitleColor;
@property (nonatomic, strong) UIColor *cachedSubtitleColor;
@property (nonatomic, strong) UIColor *cachedBackgroundColor;
@property (nonatomic, strong) UIColor *cachedBorderColor;
@property (nonatomic, assign) CGFloat cachedCalculatedHeight;
@property (nonatomic, assign) BOOL cacheValid;

@end

@implementation YRXCameraViewModel

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithModel:[[YRXCameraModel alloc] init]];
}

- (instancetype)initWithModel:(YRXCameraModel *)model {
    return [self initWithModel:model displayMode:YRXCameraDisplayModeDefault];
}

- (instancetype)initWithModel:(YRXCameraModel *)model displayMode:(YRXCameraDisplayMode)displayMode {
    self = [super init];
    if (self) {
        _model = model ?: [[YRXCameraModel alloc] init];
        _displayMode = displayMode;
        _cellState = YRXCameraCellStateNormal;
        _cacheValid = NO;
        [self refreshComputedProperties];
    }
    return self;
}

+ (instancetype)viewModelWithModel:(YRXCameraModel *)model {
    return [[self alloc] initWithModel:model];
}

#pragma mark - Computed Properties

- (NSString *)displayTitle {
    if (!self.cacheValid) {
        [self refreshComputedProperties];
    }
    return self.cachedDisplayTitle ?: @"";
}

- (NSString *)displaySubtitle {
    if (!self.cacheValid) {
        [self refreshComputedProperties];
    }
    return self.cachedDisplaySubtitle ?: @"";
}

- (NSString *)displayDescription {
    if (!self.cacheValid) {
        [self refreshComputedProperties];
    }
    return self.cachedDisplayDescription ?: @"";
}

- (NSURL *)imageURL {
    if (!self.cacheValid) {
        [self refreshComputedProperties];
    }
    return self.cachedImageURL;
}

- (UIImage *)placeholderImage {
    NSString *imageName = @"camera_placeholder";
    switch (self.cameraType) {
        case YRXCameraTypePhoto:
            imageName = @"camera_photo_placeholder";
            break;
        case YRXCameraTypeVideo:
            imageName = @"camera_video_placeholder";
            break;
        case YRXCameraTypePanorama:
            imageName = @"camera_panorama_placeholder";
            break;
        case YRXCameraTypePortrait:
            imageName = @"camera_portrait_placeholder";
            break;
        case YRXCameraTypeTimelapase:
            imageName = @"camera_timelapse_placeholder";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}

- (YRXCameraType)cameraType {
    return self.model.type;
}

- (BOOL)isValid {
    return [self validateModelData];
}

- (BOOL)showsDetailButton {
    switch (self.displayMode) {
        case YRXCameraDisplayModeMinimal:
            return NO;
        case YRXCameraDisplayModeCompact:
            return self.cellState != YRXCameraCellStateLoading;
        case YRXCameraDisplayModeExpanded:
        case YRXCameraDisplayModeDefault:
        default:
            return YES;
    }
}

- (BOOL)showsStatusIndicator {
    return self.cellState == YRXCameraCellStateLoading || 
           self.cellState == YRXCameraCellStateError;
}

- (CGFloat)calculatedHeight {
    if (!self.cacheValid) {
        [self refreshComputedProperties];
    }
    return self.cachedCalculatedHeight;
}

- (UIColor *)titleColor {
    if (!self.cacheValid) {
        [self refreshComputedProperties];
    }
    return self.cachedTitleColor;
}

- (UIColor *)subtitleColor {
    if (!self.cacheValid) {
        [self refreshComputedProperties];
    }
    return self.cachedSubtitleColor;
}

- (UIColor *)backgroundColor {
    if (!self.cacheValid) {
        [self refreshComputedProperties];
    }
    return self.cachedBackgroundColor;
}

- (UIColor *)borderColor {
    if (!self.cacheValid) {
        [self refreshComputedProperties];
    }
    return self.cachedBorderColor;
}

#pragma mark - Data Processing

- (void)updateWithModel:(YRXCameraModel *)model {
    if (model != self.model) {
        self.model = model;
        [self clearCache];
    }
}

- (void)updateDisplayMode:(YRXCameraDisplayMode)displayMode {
    if (displayMode != self.displayMode) {
        self.displayMode = displayMode;
        [self clearCache];
    }
}

- (void)updateCellState:(YRXCameraCellState)cellState {
    if (cellState != self.cellState) {
        self.cellState = cellState;
        [self clearCache];
    }
}

#pragma mark - Validation

- (BOOL)validateModelData {
    if (!self.model) {
        return NO;
    }
    
    // Check required fields
    if (!YRXCameraIsValidString(self.model.title)) {
        return NO;
    }
    
    if (!YRXCameraIsValidString(self.model.subtitle)) {
        return NO;
    }
    
    return YES;
}

- (NSString *)validationErrorMessage {
    if (!self.model) {
        return @"Model is required";
    }
    
    if (!YRXCameraIsValidString(self.model.title)) {
        return @"Title is required";
    }
    
    if (!YRXCameraIsValidString(self.model.subtitle)) {
        return @"Subtitle is required";
    }
    
    return nil;
}

#pragma mark - Formatting

- (NSString *)formattedTitleWithMaxLength:(NSInteger)maxLength {
    return [YRXCameraFormatter formatTitle:self.model.title maxLength:maxLength];
}

- (NSString *)formattedSubtitleWithContext {
    return [YRXCameraFormatter formatSubtitle:self.model.subtitle 
                                   cameraType:self.cameraType];
}

- (NSString *)formattedDescriptionForDisplayMode {
    return [YRXCameraFormatter formatDescription:self.model.cameraDescription 
                                      displayMode:self.displayMode];
}

#pragma mark - Cache Management

- (void)clearCache {
    self.cacheValid = NO;
    self.cachedDisplayTitle = nil;
    self.cachedDisplaySubtitle = nil;
    self.cachedDisplayDescription = nil;
    self.cachedImageURL = nil;
    self.cachedTitleColor = nil;
    self.cachedSubtitleColor = nil;
    self.cachedBackgroundColor = nil;
    self.cachedBorderColor = nil;
    self.cachedCalculatedHeight = 0;
}

- (void)refreshComputedProperties {
    // Refresh display strings
    self.cachedDisplayTitle = [self computeDisplayTitle];
    self.cachedDisplaySubtitle = [self computeDisplaySubtitle];
    self.cachedDisplayDescription = [self computeDisplayDescription];
    
    // Refresh image URL
    self.cachedImageURL = [self computeImageURL];
    
    // Refresh colors
    self.cachedTitleColor = [self computeTitleColor];
    self.cachedSubtitleColor = [self computeSubtitleColor];
    self.cachedBackgroundColor = [self computeBackgroundColor];
    self.cachedBorderColor = [self computeBorderColor];
    
    // Refresh height
    self.cachedCalculatedHeight = [self computeCalculatedHeight];
    
    self.cacheValid = YES;
}

#pragma mark - Private Computation Methods

- (NSString *)computeDisplayTitle {
    NSInteger maxLength = (self.displayMode == YRXCameraDisplayModeCompact) ? 20 : YRXCameraMaxTitleLength;
    return YRXCameraTruncateString(self.model.title, maxLength);
}

- (NSString *)computeDisplaySubtitle {
    return [self formattedSubtitleWithContext];
}

- (NSString *)computeDisplayDescription {
    return [self formattedDescriptionForDisplayMode];
}

- (NSURL *)computeImageURL {
    if (YRXCameraIsValidString(self.model.imageURLString)) {
        return [NSURL URLWithString:self.model.imageURLString];
    }
    return nil;
}

- (UIColor *)computeTitleColor {
    switch (self.cellState) {
        case YRXCameraCellStateDisabled:
            return YRXCameraColorFromHex(YRXCameraSecondaryColorHex);
        case YRXCameraCellStateError:
            return [UIColor redColor];
        case YRXCameraCellStateSelected:
            return YRXCameraColorFromHex(YRXCameraPrimaryColorHex);
        case YRXCameraCellStateLoading:
        case YRXCameraCellStateNormal:
        default:
            return [UIColor labelColor];
    }
}

- (UIColor *)computeSubtitleColor {
    switch (self.cellState) {
        case YRXCameraCellStateDisabled:
            return YRXCameraColorFromHex(YRXCameraSecondaryColorHex);
        case YRXCameraCellStateError:
            return [UIColor redColor];
        case YRXCameraCellStateSelected:
            return YRXCameraColorFromHex(YRXCameraPrimaryColorHex);
        case YRXCameraCellStateLoading:
        case YRXCameraCellStateNormal:
        default:
            return [UIColor secondaryLabelColor];
    }
}

- (UIColor *)computeBackgroundColor {
    switch (self.cellState) {
        case YRXCameraCellStateSelected:
            return [YRXCameraColorFromHex(YRXCameraPrimaryColorHex) colorWithAlphaComponent:0.1];
        case YRXCameraCellStateError:
            return [[UIColor redColor] colorWithAlphaComponent:0.1];
        case YRXCameraCellStateDisabled:
        case YRXCameraCellStateLoading:
        case YRXCameraCellStateNormal:
        default:
            return YRXCameraColorFromHex(YRXCameraBackgroundColorHex);
    }
}

- (UIColor *)computeBorderColor {
    switch (self.cellState) {
        case YRXCameraCellStateSelected:
            return YRXCameraColorFromHex(YRXCameraPrimaryColorHex);
        case YRXCameraCellStateError:
            return [UIColor redColor];
        case YRXCameraCellStateDisabled:
        case YRXCameraCellStateLoading:
        case YRXCameraCellStateNormal:
        default:
            return YRXCameraColorFromHex(YRXCameraBorderColorHex);
    }
}

- (CGFloat)computeCalculatedHeight {
    switch (self.displayMode) {
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

@end

#pragma mark - YRXCameraModel Implementation

@implementation YRXCameraModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _title = @"";
        _subtitle = @"";
        _cameraDescription = @"";
        _type = YRXCameraTypeUnknown;
        _isEnabled = YES;
        _isFeatured = NO;
        _createdDate = [NSDate date];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                  description:(NSString *)description
                         type:(YRXCameraType)type {
    self = [self init];
    if (self) {
        _title = [title copy];
        _subtitle = [subtitle copy];
        _cameraDescription = [description copy];
        _type = type;
    }
    return self;
}

- (instancetype)copy {
    YRXCameraModel *copy = [[YRXCameraModel alloc] init];
    copy.title = [self.title copy];
    copy.subtitle = [self.subtitle copy];
    copy.cameraDescription = [self.cameraDescription copy];
    copy.imageURLString = [self.imageURLString copy];
    copy.type = self.type;
    copy.identifier = [self.identifier copy];
    copy.createdDate = [self.createdDate copy];
    copy.modifiedDate = [self.modifiedDate copy];
    copy.isEnabled = self.isEnabled;
    copy.isFeatured = self.isFeatured;
    copy.metadata = [self.metadata copy];
    return copy;
}

@end