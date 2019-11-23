//  CBHFileSystemWatcher.h
//  CBHFileSystemEventKit
//
//  Created by Christian Huxtable <chris@huxtable.ca>, November 2019.
//  Copyright (c) 2019 Christian Huxtable. All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
//  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
//  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

@import Foundation;
@import CoreServices.FSEvents;

@class CBHFileSystemEvent;


NS_ASSUME_NONNULL_BEGIN

/// The type of block expected by a watcher.
typedef void (^CBHFileSystemWatcherBlock)(CBHFileSystemEvent *event);

/** Options that can be passed to the initialization and factory methods to modify the behaviour of the watcher being created.
 *
 *  Note: Built around `FSEventStreamCreateFlags`. `kFSEventStreamCreateFlagUseCFTypes` is *NOT* supported.
 */
typedef NS_OPTIONS(uint64_t, CBHFileSystemWatcherType) {
	CBHFileSystemWatcherType_default                                                               = kFSEventStreamCreateFlagNone,
//	CBHFileSystemWatcherType_useCFTypes                                                            = kFSEventStreamCreateFlagUseCFTypes, // Not supported
	CBHFileSystemWatcherType_noDefer                                                               = kFSEventStreamCreateFlagNoDefer,
	CBHFileSystemWatcherType_watchRoot                                                             = kFSEventStreamCreateFlagWatchRoot,
	CBHFileSystemWatcherType_ignoreSelf                                                            = kFSEventStreamCreateFlagIgnoreSelf,
	CBHFileSystemWatcherType_fileEvents                                                            = kFSEventStreamCreateFlagFileEvents,
	CBHFileSystemWatcherType_markSelf                                                              = kFSEventStreamCreateFlagMarkSelf,
	CBHFileSystemWatcherType_useExtendedData  __OSX_AVAILABLE_STARTING(__MAC_10_13, __IPHONE_11_0) = kFSEventStreamCreateFlagUseExtendedData
};



/** An event driven mechanism that enables the delivery of file system events to registered observers and blocks.
 *
 * @author              Christian Huxtable <chris@huxtable.ca>
 * @version             1.0
 */
@interface CBHFileSystemWatcher : NSObject

#pragma mark - Observer Factories

/**
 * @name Observer Factories
 */

/** Creates and returns a file system watcher.
 *
 * @param observer      The observer for the watcher, must implement `selector`.
 * @param selector      The selector to call on the `observer`.
 * @param path          The path to watch for events.
 * @param type          The type of events to watch for.
 *
 * @return              The watcher.
 */
+ (nullable instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPath:(NSString *)path withType:(CBHFileSystemWatcherType)type;

/** Creates and returns a file system watcher.
 *
 * @param observer      The observer for the watcher, must implement `selector`.
 * @param selector      The selector to call on the `observer`.
 * @param path          The path to watch for events.
 * @param type          The type of events to watch for.
 * @param object        The object to pass along with an event.
 *
 * @return              The watcher.
 */
+ (nullable instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPath:(NSString *)path withType:(CBHFileSystemWatcherType)type andObject:(nullable id)object;

/** Creates and returns a file system watcher.
 *
 * @param observer      The observer for the watcher, must implement `selector`.
 * @param selector      The selector to call on the `observer`.
 * @param path          The path to watch for events.
 * @param type          The type of events to watch for.
 * @param latency       The number of seconds the watcher should wait before triggering its callback.
 *
 * @return              The watcher.
 */
+ (nullable instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPath:(NSString *)path withType:(CBHFileSystemWatcherType)type andLatency:(NSTimeInterval)latency;

/** Creates and returns a file system watcher.
 *
 * @param observer      The observer for the watcher, must implement `selector`.
 * @param selector      The selector to call on the `observer`.
 * @param path          The path to watch for events.
 * @param type          The type of events to watch for.
 * @param latency       The number of seconds the watcher should wait before triggering its callback.
 * @param object        The object to pass along with an event.
 *
 * @return              The watcher.
 */
+ (nullable instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPath:(NSString *)path withType:(CBHFileSystemWatcherType)type latency:(NSTimeInterval)latency andObject:(nullable id)object;


/** Creates and returns a file system watcher.
 *
 * @param observer      The observer for the watcher, must implement `selector`.
 * @param selector      The selector to call on the `observer`.
 * @param paths         The paths to watch for events.
 * @param type          The type of events to watch for.
 *
 * @return              The watcher.
 */
+ (nullable instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type;

/** Creates and returns a file system watcher.
 *
 * @param observer      The observer for the watcher, must implement `selector`.
 * @param selector      The selector to call on the `observer`.
 * @param paths         The paths to watch for events.
 * @param type          The type of events to watch for.
 * @param object        The object to pass along with an event.
 *
 * @return              The watcher.
 */
+ (nullable instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type andObject:(nullable id)object;

/** Creates and returns a file system watcher.
 *
 * @param observer      The observer for the watcher, must implement `selector`.
 * @param selector      The selector to call on the `observer`.
 * @param paths         The paths to watch for events.
 * @param type          The type of events to watch for.
 * @param latency       The number of seconds the watcher should wait before triggering its callback.
 *
 * @return              The watcher.
 */
+ (nullable instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type andLatency:(NSTimeInterval)latency;

/** Creates and returns a file system watcher.
 *
 * @param observer      The observer for the watcher, must implement `selector`.
 * @param selector      The selector to call on the `observer`.
 * @param paths         The paths to watch for events.
 * @param type          The type of events to watch for.
 * @param latency       The number of seconds the watcher should wait before triggering its callback.
 * @param object        The object to pass along with an event.
 *
 * @return              The watcher.
 */
+ (nullable instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type latency:(NSTimeInterval)latency andObject:(nullable id)object;


#pragma mark - Block Factories

/**
* @name Block Factories
*/

/** Creates and returns a file system watcher.
 *
 * @param path          The path to watch for events.
 * @param type          The type of events to watch for.
 * @param block         The callback that occurs when an event happens.
 *
 * @return              The watcher.
 */
+ (nullable instancetype)watcherOfPath:(NSString *)path withType:(CBHFileSystemWatcherType)type andBlock:(CBHFileSystemWatcherBlock)block;

/** Creates and returns a file system watcher.
 *
 * @param path          The path to watch for events.
 * @param type          The type of events to watch for.
 * @param latency       The number of seconds the watcher should wait before triggering its callback.
 * @param block         The callback that occurs when an event happens.
 *
 * @return              The watcher.
 */
+ (nullable instancetype)watcherOfPath:(NSString *)path withType:(CBHFileSystemWatcherType)type latency:(NSTimeInterval)latency andBlock:(CBHFileSystemWatcherBlock)block;

/** Creates and returns a file system watcher.
 *
 * @param paths         The paths to watch for events.
 * @param type          The type of events to watch for.
 * @param block         The callback that occurs when an event happens.
 *
 * @return              The watcher.
 */
+ (nullable instancetype)watcherOfPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type andBlock:(CBHFileSystemWatcherBlock)block;

/** Creates and returns a file system watcher.
 *
 * @param paths         The paths to watch for events.
 * @param type          The type of events to watch for.
 * @param latency       The number of seconds the watcher should wait before triggering its callback.
 * @param block         The callback that occurs when an event happens.
 *
 * @return              The watcher.
 */
+ (nullable instancetype)watcherOfPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type latency:(NSTimeInterval)latency andBlock:(CBHFileSystemWatcherBlock)block;


#pragma mark - Initializers

/** Initializes a newly allocated file system watcher.
 *
 * @param observer      The observer for the watcher, must implement `selector`.
 * @param selector      The selector to call on the `observer`.
 * @param paths         The paths to watch for events.
 * @param type          The type of events to watch for.
 * @param latency       The number of seconds the watcher should wait before triggering its callback.
 *
 * @return              The initialized watcher.
 */
- (nullable instancetype)initWithObserver:(id)observer andSelector:(SEL)selector ofPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type latency:(NSTimeInterval)latency andObject:(nullable id)object;

/** Initializes a newly allocated file system watcher.
 *
 * @param paths         The paths to watch for events.
 * @param type          The type of events to watch for.
 * @param latency       The number of seconds the watcher should wait before triggering its callback.
 * @param block         The callback that occurs when an event happens.
 *
 * @return              The initialized watcher.
 */
- (nullable instancetype)initWithPaths:(NSArray<NSString *> *)paths type:(CBHFileSystemWatcherType)type latency:(NSTimeInterval)latency andBlock:(CBHFileSystemWatcherBlock)block;


#pragma mark - Properties

/**
 * @name Properties
 */

/// The paths to watch for events.
@property (nonatomic, readonly) NSArray<NSString *> *paths;

/// The types of events to watch for.
@property (nonatomic, readonly) CBHFileSystemWatcherType type;

/// The number of seconds the watcher should wait before triggering its callback. Larger values may result in more effective temporal coalescing and overall efficiency.
@property (nonatomic, readonly) NSTimeInterval latency;

/// The object associated with the notification.
@property (nonatomic, readonly, nullable) id object;

/// Indicates if the watcher is currently watching.
@property (nonatomic, readonly) BOOL isWatching;


#pragma mark - Watching

/** Starts the receiver watching for file system events.
 *
 * @return              The receiver if successful, or `nil` if it fails.
 */
- (nullable instancetype)startWatching;

/// Stops the receiver from watching for file system events.
- (void)stopWatching;

/// Asynchronously flushes out any events that have occurred but have not yet been delivered due to the latency parameter.
- (void)flushEvents;


#pragma mark - Unavailable

/**
* @name Unavailable
*/

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
