//
//  YRXCameraStateManager.h
//  YRXCamera
//
//  Created by Refactoring on 2024.
//  Copyright © 2024 JULAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRXCameraConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class YRXCameraStateManager;

/**
 * YRXCameraStateManagerDelegate
 * 
 * Delegate protocol for state change notifications
 */
@protocol YRXCameraStateManagerDelegate <NSObject>

@optional

/**
 * Called when the cell state changes
 * @param stateManager The state manager instance
 * @param newState The new cell state
 * @param oldState The previous cell state
 */
- (void)stateManager:(YRXCameraStateManager *)stateManager 
      didChangeState:(YRXCameraCellState)newState 
           fromState:(YRXCameraCellState)oldState;

/**
 * Called when the display mode changes
 * @param stateManager The state manager instance
 * @param newMode The new display mode
 * @param oldMode The previous display mode
 */
- (void)stateManager:(YRXCameraStateManager *)stateManager 
   didChangeDisplayMode:(YRXCameraDisplayMode)newMode 
               fromMode:(YRXCameraDisplayMode)oldMode;

/**
 * Called when state transition begins
 * @param stateManager The state manager instance
 * @param targetState The target state
 */
- (void)stateManager:(YRXCameraStateManager *)stateManager 
willTransitionToState:(YRXCameraCellState)targetState;

/**
 * Called when state transition completes
 * @param stateManager The state manager instance
 * @param finalState The final state after transition
 */
- (void)stateManager:(YRXCameraStateManager *)stateManager 
didCompleteTransitionToState:(YRXCameraCellState)finalState;

@end

/**
 * YRXCameraStateManager
 * 
 * Manages state transitions and validation for YRXCameraTableViewCell
 * Centralizes all state-related logic and provides thread-safe state management
 */
@interface YRXCameraStateManager : NSObject

#pragma mark - Properties

/// Current cell state
@property (nonatomic, assign, readonly) YRXCameraCellState currentState;

/// Current display mode
@property (nonatomic, assign, readonly) YRXCameraDisplayMode currentDisplayMode;

/// State transition delegate
@property (nonatomic, weak) id<YRXCameraStateManagerDelegate> delegate;

/// Whether state transitions are animated
@property (nonatomic, assign) BOOL animateTransitions;

/// State transition duration
@property (nonatomic, assign) NSTimeInterval transitionDuration;

/// Whether the state manager is currently transitioning
@property (nonatomic, assign, readonly) BOOL isTransitioning;

#pragma mark - Initialization

/**
 * Initialize with default state
 * @return New state manager instance
 */
- (instancetype)init;

/**
 * Initialize with specific initial state
 * @param initialState The initial cell state
 * @param initialMode The initial display mode
 * @return New state manager instance
 */
- (instancetype)initWithState:(YRXCameraCellState)initialState 
                  displayMode:(YRXCameraDisplayMode)initialMode;

#pragma mark - State Management

/**
 * Transition to a new state
 * @param newState The target state
 * @return YES if transition was initiated, NO if invalid or already in that state
 */
- (BOOL)transitionToState:(YRXCameraCellState)newState;

/**
 * Transition to a new state with completion handler
 * @param newState The target state
 * @param completion Completion block called when transition finishes
 * @return YES if transition was initiated, NO if invalid or already in that state
 */
- (BOOL)transitionToState:(YRXCameraCellState)newState 
               completion:(void (^ _Nullable)(BOOL finished))completion;

/**
 * Change display mode
 * @param newMode The new display mode
 * @return YES if mode was changed, NO if already in that mode
 */
- (BOOL)changeDisplayMode:(YRXCameraDisplayMode)newMode;

/**
 * Reset to normal state
 */
- (void)reset;

/**
 * Reset to specific state and mode
 * @param state The state to reset to
 * @param mode The mode to reset to
 */
- (void)resetToState:(YRXCameraCellState)state displayMode:(YRXCameraDisplayMode)mode;

#pragma mark - State Validation

/**
 * Check if a state transition is valid
 * @param fromState The current state
 * @param toState The target state
 * @return YES if transition is valid, NO otherwise
 */
- (BOOL)isValidTransitionFromState:(YRXCameraCellState)fromState toState:(YRXCameraCellState)toState;

/**
 * Check if a state is valid for the current context
 * @param state The state to validate
 * @return YES if state is valid, NO otherwise
 */
- (BOOL)isValidState:(YRXCameraCellState)state;

/**
 * Get all valid next states from current state
 * @return Array of NSNumber objects representing valid YRXCameraCellState values
 */
- (NSArray<NSNumber *> *)validNextStates;

#pragma mark - State Information

/**
 * Get human-readable description of current state
 * @return State description string
 */
- (NSString *)currentStateDescription;

/**
 * Get human-readable description of current display mode
 * @return Display mode description string
 */
- (NSString *)currentDisplayModeDescription;

/**
 * Check if current state allows user interaction
 * @return YES if interactive, NO otherwise
 */
- (BOOL)isInteractive;

/**
 * Check if current state requires loading indicator
 * @return YES if loading indicator should be shown, NO otherwise
 */
- (BOOL)requiresLoadingIndicator;

/**
 * Check if current state indicates an error
 * @return YES if in error state, NO otherwise
 */
- (BOOL)isInErrorState;

#pragma mark - Convenience Methods

/**
 * Transition to loading state
 */
- (void)beginLoading;

/**
 * Transition from loading to normal state
 */
- (void)finishLoading;

/**
 * Transition to error state
 * @param error The error that occurred (optional)
 */
- (void)enterErrorState:(NSError * _Nullable)error;

/**
 * Select the cell (transition to selected state)
 */
- (void)selectCell;

/**
 * Deselect the cell (transition to normal state)
 */
- (void)deselectCell;

/**
 * Enable the cell (transition from disabled to normal)
 */
- (void)enableCell;

/**
 * Disable the cell (transition to disabled state)
 */
- (void)disableCell;

#pragma mark - Threading

/**
 * Perform state transition on main queue
 * @param block Block to execute on main queue
 */
- (void)performOnMainQueue:(void (^)(void))block;

/**
 * Perform state transition asynchronously
 * @param state The target state
 * @param completion Completion block
 */
- (void)asyncTransitionToState:(YRXCameraCellState)state 
                    completion:(void (^ _Nullable)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END