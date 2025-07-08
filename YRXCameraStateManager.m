//
//  YRXCameraStateManager.m
//  YRXCamera
//
//  Created by Refactoring on 2024.
//  Copyright © 2024 JULAB. All rights reserved.
//

#import "YRXCameraStateManager.h"

@interface YRXCameraStateManager ()

@property (nonatomic, assign, readwrite) YRXCameraCellState currentState;
@property (nonatomic, assign, readwrite) YRXCameraDisplayMode currentDisplayMode;
@property (nonatomic, assign, readwrite) BOOL isTransitioning;
@property (nonatomic, strong) NSError *lastError;

// Thread safety
@property (nonatomic, strong) dispatch_queue_t stateQueue;

@end

@implementation YRXCameraStateManager

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithState:YRXCameraCellStateNormal displayMode:YRXCameraDisplayModeDefault];
}

- (instancetype)initWithState:(YRXCameraCellState)initialState displayMode:(YRXCameraDisplayMode)initialMode {
    self = [super init];
    if (self) {
        _currentState = initialState;
        _currentDisplayMode = initialMode;
        _animateTransitions = YES;
        _transitionDuration = YRXCameraDefaultAnimationDuration;
        _isTransitioning = NO;
        
        // Create serial queue for thread safety
        _stateQueue = dispatch_queue_create("com.julab.yrxcamera.statemanager", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - State Management

- (BOOL)transitionToState:(YRXCameraCellState)newState {
    return [self transitionToState:newState completion:nil];
}

- (BOOL)transitionToState:(YRXCameraCellState)newState completion:(void (^)(BOOL))completion {
    __weak typeof(self) weakSelf = self;
    
    return [self performStateTransition:^BOOL{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return NO;
        
        // Check if already in target state
        if (strongSelf.currentState == newState) {
            return NO;
        }
        
        // Validate transition
        if (![strongSelf isValidTransitionFromState:strongSelf.currentState toState:newState]) {
            return NO;
        }
        
        // Check if already transitioning
        if (strongSelf.isTransitioning) {
            return NO;
        }
        
        YRXCameraCellState oldState = strongSelf.currentState;
        strongSelf.isTransitioning = YES;
        
        // Notify delegate of transition start
        [strongSelf performOnMainQueue:^{
            if ([strongSelf.delegate respondsToSelector:@selector(stateManager:willTransitionToState:)]) {
                [strongSelf.delegate stateManager:strongSelf willTransitionToState:newState];
            }
        }];
        
        // Perform transition with animation if enabled
        void (^transitionBlock)(void) = ^{
            strongSelf.currentState = newState;
            
            [strongSelf performOnMainQueue:^{
                if ([strongSelf.delegate respondsToSelector:@selector(stateManager:didChangeState:fromState:)]) {
                    [strongSelf.delegate stateManager:strongSelf didChangeState:newState fromState:oldState];
                }
            }];
        };
        
        void (^completionBlock)(BOOL) = ^(BOOL finished) {
            strongSelf.isTransitioning = NO;
            
            [strongSelf performOnMainQueue:^{
                if ([strongSelf.delegate respondsToSelector:@selector(stateManager:didCompleteTransitionToState:)]) {
                    [strongSelf.delegate stateManager:strongSelf didCompleteTransitionToState:newState];
                }
                
                if (completion) {
                    completion(finished);
                }
            }];
        };
        
        if (strongSelf.animateTransitions) {
            [strongSelf performOnMainQueue:^{
                [UIView animateWithDuration:strongSelf.transitionDuration
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:transitionBlock
                                 completion:completionBlock];
            }];
        } else {
            transitionBlock();
            completionBlock(YES);
        }
        
        return YES;
    }];
}

- (BOOL)changeDisplayMode:(YRXCameraDisplayMode)newMode {
    __weak typeof(self) weakSelf = self;
    
    return [self performStateTransition:^BOOL{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return NO;
        
        if (strongSelf.currentDisplayMode == newMode) {
            return NO;
        }
        
        YRXCameraDisplayMode oldMode = strongSelf.currentDisplayMode;
        strongSelf.currentDisplayMode = newMode;
        
        [strongSelf performOnMainQueue:^{
            if ([strongSelf.delegate respondsToSelector:@selector(stateManager:didChangeDisplayMode:fromMode:)]) {
                [strongSelf.delegate stateManager:strongSelf didChangeDisplayMode:newMode fromMode:oldMode];
            }
        }];
        
        return YES;
    }];
}

- (void)reset {
    [self resetToState:YRXCameraCellStateNormal displayMode:YRXCameraDisplayModeDefault];
}

- (void)resetToState:(YRXCameraCellState)state displayMode:(YRXCameraDisplayMode)mode {
    __weak typeof(self) weakSelf = self;
    
    [self performStateTransition:^BOOL{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return NO;
        
        YRXCameraCellState oldState = strongSelf.currentState;
        YRXCameraDisplayMode oldMode = strongSelf.currentDisplayMode;
        
        strongSelf.currentState = state;
        strongSelf.currentDisplayMode = mode;
        strongSelf.isTransitioning = NO;
        strongSelf.lastError = nil;
        
        [strongSelf performOnMainQueue:^{
            if (oldState != state && [strongSelf.delegate respondsToSelector:@selector(stateManager:didChangeState:fromState:)]) {
                [strongSelf.delegate stateManager:strongSelf didChangeState:state fromState:oldState];
            }
            
            if (oldMode != mode && [strongSelf.delegate respondsToSelector:@selector(stateManager:didChangeDisplayMode:fromMode:)]) {
                [strongSelf.delegate stateManager:strongSelf didChangeDisplayMode:mode fromMode:oldMode];
            }
        }];
        
        return YES;
    }];
}

#pragma mark - State Validation

- (BOOL)isValidTransitionFromState:(YRXCameraCellState)fromState toState:(YRXCameraCellState)toState {
    // Define valid state transitions
    switch (fromState) {
        case YRXCameraCellStateNormal:
            return (toState == YRXCameraCellStateSelected ||
                    toState == YRXCameraCellStateLoading ||
                    toState == YRXCameraCellStateDisabled);
            
        case YRXCameraCellStateSelected:
            return (toState == YRXCameraCellStateNormal ||
                    toState == YRXCameraCellStateLoading ||
                    toState == YRXCameraCellStateDisabled);
            
        case YRXCameraCellStateLoading:
            return (toState == YRXCameraCellStateNormal ||
                    toState == YRXCameraCellStateError ||
                    toState == YRXCameraCellStateDisabled);
            
        case YRXCameraCellStateError:
            return (toState == YRXCameraCellStateNormal ||
                    toState == YRXCameraCellStateLoading ||
                    toState == YRXCameraCellStateDisabled);
            
        case YRXCameraCellStateDisabled:
            return (toState == YRXCameraCellStateNormal);
            
        default:
            return NO;
    }
}

- (BOOL)isValidState:(YRXCameraCellState)state {
    return (state >= YRXCameraCellStateNormal && state <= YRXCameraCellStateDisabled);
}

- (NSArray<NSNumber *> *)validNextStates {
    NSMutableArray *validStates = [NSMutableArray array];
    
    for (NSInteger state = YRXCameraCellStateNormal; state <= YRXCameraCellStateDisabled; state++) {
        if ([self isValidTransitionFromState:self.currentState toState:(YRXCameraCellState)state]) {
            [validStates addObject:@(state)];
        }
    }
    
    return [validStates copy];
}

#pragma mark - State Information

- (NSString *)currentStateDescription {
    return YRXCameraStringFromCellState(self.currentState);
}

- (NSString *)currentDisplayModeDescription {
    return YRXCameraStringFromDisplayMode(self.currentDisplayMode);
}

- (BOOL)isInteractive {
    return (self.currentState != YRXCameraCellStateLoading &&
            self.currentState != YRXCameraCellStateDisabled);
}

- (BOOL)requiresLoadingIndicator {
    return (self.currentState == YRXCameraCellStateLoading);
}

- (BOOL)isInErrorState {
    return (self.currentState == YRXCameraCellStateError);
}

#pragma mark - Convenience Methods

- (void)beginLoading {
    [self transitionToState:YRXCameraCellStateLoading];
}

- (void)finishLoading {
    if (self.currentState == YRXCameraCellStateLoading) {
        [self transitionToState:YRXCameraCellStateNormal];
    }
}

- (void)enterErrorState:(NSError *)error {
    self.lastError = error;
    [self transitionToState:YRXCameraCellStateError];
}

- (void)selectCell {
    [self transitionToState:YRXCameraCellStateSelected];
}

- (void)deselectCell {
    if (self.currentState == YRXCameraCellStateSelected) {
        [self transitionToState:YRXCameraCellStateNormal];
    }
}

- (void)enableCell {
    if (self.currentState == YRXCameraCellStateDisabled) {
        [self transitionToState:YRXCameraCellStateNormal];
    }
}

- (void)disableCell {
    [self transitionToState:YRXCameraCellStateDisabled];
}

#pragma mark - Threading

- (void)performOnMainQueue:(void (^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (void)asyncTransitionToState:(YRXCameraCellState)state completion:(void (^)(BOOL))completion {
    dispatch_async(self.stateQueue, ^{
        BOOL success = [self transitionToState:state completion:completion];
        if (!success && completion) {
            completion(NO);
        }
    });
}

#pragma mark - Private Methods

- (BOOL)performStateTransition:(BOOL (^)(void))transitionBlock {
    if (!transitionBlock) {
        return NO;
    }
    
    __block BOOL result = NO;
    
    if ([NSThread isMainThread]) {
        dispatch_sync(self.stateQueue, ^{
            result = transitionBlock();
        });
    } else {
        result = transitionBlock();
    }
    
    return result;
}

@end