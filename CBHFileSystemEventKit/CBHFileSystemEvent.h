//  CBHFileSystemEvent.h
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


/** Options that can be returned by a file system event indicating the kind of event that occurred.
*
*  Note: Built around `FSEventStreamEventFlags`.
*/
typedef NS_OPTIONS(uint64_t, CBHFileSystemEventType) {
	CBHFileSystemEventType_none                                                                    = kFSEventStreamEventFlagNone,
	CBHFileSystemEventType_mustScanSubDirs                                                         = kFSEventStreamEventFlagMustScanSubDirs,
	CBHFileSystemEventType_userDropped                                                             = kFSEventStreamEventFlagUserDropped,
	CBHFileSystemEventType_kernelDropped                                                           = kFSEventStreamEventFlagKernelDropped,
	CBHFileSystemEventType_eventIdsWrapped                                                         = kFSEventStreamEventFlagEventIdsWrapped,
	CBHFileSystemEventType_historyDone                                                             = kFSEventStreamEventFlagHistoryDone,
	CBHFileSystemEventType_rootChanged                                                             = kFSEventStreamEventFlagRootChanged,
	CBHFileSystemEventType_mount                                                                   = kFSEventStreamEventFlagMount,
	CBHFileSystemEventType_unmount                                                                 = kFSEventStreamEventFlagUnmount,
	CBHFileSystemEventType_itemCreated                                                             = kFSEventStreamEventFlagItemCreated,
	CBHFileSystemEventType_itemRemoved                                                             = kFSEventStreamEventFlagItemRemoved,
	CBHFileSystemEventType_itemInodeMetaMod                                                        = kFSEventStreamEventFlagItemInodeMetaMod,
	CBHFileSystemEventType_itemRenamed                                                             = kFSEventStreamEventFlagItemRenamed,
	CBHFileSystemEventType_itemModified                                                            = kFSEventStreamEventFlagItemModified,
	CBHFileSystemEventType_itemFinderInfoMod                                                       = kFSEventStreamEventFlagItemFinderInfoMod,
	CBHFileSystemEventType_itemChangeOwner                                                         = kFSEventStreamEventFlagItemChangeOwner,
	CBHFileSystemEventType_itemXattrMod                                                            = kFSEventStreamEventFlagItemXattrMod,
	CBHFileSystemEventType_itemIsFile                                                              = kFSEventStreamEventFlagItemIsFile,
	CBHFileSystemEventType_itemIsDir                                                               = kFSEventStreamEventFlagItemIsDir,
	CBHFileSystemEventType_itemIsSymlink                                                           = kFSEventStreamEventFlagItemIsSymlink,
	CBHFileSystemEventType_ownEvent                                                                = kFSEventStreamEventFlagOwnEvent,
	CBHFileSystemEventType_itemIsHardlink                                                          = kFSEventStreamEventFlagItemIsHardlink,
	CBHFileSystemEventType_itemIsLastHardlink                                                      = kFSEventStreamEventFlagItemIsLastHardlink,
	CBHFileSystemEventType_itemCloned __OSX_AVAILABLE_STARTING(__MAC_10_13, __IPHONE_11_0)         = kFSEventStreamEventFlagItemCloned
};


NS_ASSUME_NONNULL_BEGIN

/** Represents a File System Event
 *
 * @author              Christian Huxtable <chris@huxtable.ca>
 * @version             1.0
 */
@interface CBHFileSystemEvent: NSObject

#pragma mark - Factories

/**
 * @name Factories
 */

/** Creates and returns a file system event.
 *
 * @param path          The path where the event occurred.
 * @param type          The type of event.
 * @param eventId       The id of the event.
 * @param object        The context object for the event.
 *
 * @return              The event.
 */
+ (instancetype)eventWithPath:(NSString *)path type:(CBHFileSystemEventType)type eventId:(UInt64)eventId andObject:(nullable id)object;


#pragma mark - Initializers

/**
 * @name Initializers
 */

/** Initializes a newly allocated file system event.
 *
 * @param path          The path where the event occurred.
 * @param type          The type of event.
 * @param eventId       The id of the event.
 * @param object        The context object for the event.
 *
 * @return              The initialized event.
 */
- (instancetype)initWithPath:(NSString *)path type:(CBHFileSystemEventType)type eventId:(UInt64)eventId andObject:(nullable id)object;


#pragma mark - Properties

/**
 * @name Properties
 */

/// The path where the event occurred.
@property (nonatomic, readonly) NSString *path;

/// The type of event.
@property (nonatomic, readonly) CBHFileSystemEventType type;

/// The id fo the event.
@property (nonatomic, readonly) UInt64 eventId;

/// The context object for the event.
@property (nonatomic, readonly, nullable) id object;


#pragma mark - Unavailable

/**
* @name Unavailable
*/

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
