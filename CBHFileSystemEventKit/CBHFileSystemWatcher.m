//  CBHFileSystemWatcher.m
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

#import "CBHFileSystemWatcher.h"
#import "_CBHFileSystemWatcher.h"

#import "CBHFileSystemEvent.h"

#import "_CBHFileSystemWatcherObserver.h"
#import "_CBHFileSystemWatcherBlock.h"

@import CoreServices.FSEvents;


#define CBHFileSystemWatcher_defaultLatency 3.0


void fsEventCallback(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[]);


@implementation CBHFileSystemWatcher

#pragma mark - Observer Factories

+ (instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPath:(NSString *)path withType:(CBHFileSystemWatcherType)type
{
	return [self watcherWithObserver:observer andSelector:selector ofPaths:@[path] withType:type];
}

+ (instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPath:(NSString *)path withType:(CBHFileSystemWatcherType)type andObject:(nullable id)object
{
	return [self watcherWithObserver:observer andSelector:selector ofPaths:@[path] withType:type andObject:object];
}

+ (instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPath:(NSString *)path withType:(CBHFileSystemWatcherType)type andLatency:(NSTimeInterval)latency
{
	return [self watcherWithObserver:observer andSelector:selector ofPaths:@[path] withType:type andLatency:latency];
}

+ (instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPath:(NSString *)path withType:(CBHFileSystemWatcherType)type latency:(NSTimeInterval)latency andObject:(nullable id)object
{
	return [self watcherWithObserver:observer andSelector:selector ofPaths:@[path] withType:type latency:latency andObject:object];
}


+ (instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type
{
	return [self watcherWithObserver:observer andSelector:selector ofPaths:paths withType:type latency:CBHFileSystemWatcher_defaultLatency andObject:nil];
}

+ (instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type andObject:(id)object
{
	return [self watcherWithObserver:observer andSelector:selector ofPaths:paths withType:type latency:CBHFileSystemWatcher_defaultLatency andObject:object];
}

+ (instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type andLatency:(NSTimeInterval)latency
{
	return [self watcherWithObserver:observer andSelector:selector ofPaths:paths withType:type latency:latency andObject:nil];
}

+ (instancetype)watcherWithObserver:(id)observer andSelector:(SEL)selector ofPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type latency:(NSTimeInterval)latency andObject:(id)object
{
	return [[[_CBHFileSystemWatcherObserver alloc] initWithObserver:observer andSelector:selector ofPaths:paths withType:type latency:latency andObject:object] startWatching];
}


#pragma mark - Block Factories

+ (instancetype)watcherOfPath:(NSString *)path withType:(CBHFileSystemWatcherType)type andBlock:(CBHFileSystemWatcherBlock)block
{
	return [self watcherOfPaths:@[path] withType:type andBlock:block];
}

+ (instancetype)watcherOfPath:(NSString *)path withType:(CBHFileSystemWatcherType)type latency:(NSTimeInterval)latency andBlock:(CBHFileSystemWatcherBlock)block
{
	return [self watcherOfPaths:@[path] withType:type latency:latency andBlock:block];
}


+ (instancetype)watcherOfPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type andBlock:(CBHFileSystemWatcherBlock)block
{
	return [self watcherOfPaths:paths withType:type latency:CBHFileSystemWatcher_defaultLatency andBlock:block];
}

+ (instancetype)watcherOfPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type latency:(NSTimeInterval)latency andBlock:(CBHFileSystemWatcherBlock)block
{
	return [[[_CBHFileSystemWatcherBlock alloc] initWithPaths:paths type:type latency:latency andBlock:block] startWatching];
}


#pragma mark - Initializers

- (instancetype)initWithObserver:(id)observer andSelector:(SEL)selector ofPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type latency:(NSTimeInterval)latency andObject:(id)object
{
	self = nil;
	return [[_CBHFileSystemWatcherObserver alloc] initWithObserver:observer andSelector:selector ofPaths:paths withType:type latency:latency andObject:object];
}

- (instancetype)initWithPaths:(NSArray<NSString *> *)paths type:(CBHFileSystemWatcherType)type latency:(NSTimeInterval)latency andBlock:(CBHFileSystemWatcherBlock)block
{
	self = nil;
	return [[_CBHFileSystemWatcherBlock alloc] initWithPaths:paths type:type latency:latency andBlock:block];
}


#pragma mark - Private Initializer

- (instancetype)initWithPaths:(NSArray<NSString *> *)paths type:(CBHFileSystemWatcherType)type andLatency:(NSTimeInterval)latency
{
	if ( self = [super init] )
	{
		_paths = [paths copy];
		_type = type;
		_latency = latency;

		_stream = nil;
	}

	return self;
}


#pragma mark - Destructor

- (void)dealloc
{
	[self stopWatching];
}


#pragma mark - Properties

@synthesize paths = _paths;
@synthesize type = _type;
@synthesize latency = _latency;

- (id)object
{
	return nil;
}


#pragma mark - Watching

- (instancetype)startWatching
{
	if ( _stream ) { return self; }

	CFArrayRef cfPaths = (__bridge CFArrayRef)_paths;
	FSEventStreamContext context = {0, (__bridge void *)self, NULL, NULL, NULL};

	_stream = FSEventStreamCreate(NULL, &fsEventCallback, &context, cfPaths, kFSEventStreamEventIdSinceNow, (CFAbsoluteTime)_latency, (FSEventStreamCreateFlags)_type);

	FSEventStreamScheduleWithRunLoop(_stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	if ( !FSEventStreamStart(_stream) ) { return nil; } /// TODO: Force this to fail for testing. Now?

	return self;
}

- (void)stopWatching
{
	if ( !_stream ) { return; }

	FSEventStreamFlushSync(_stream);
	FSEventStreamStop(_stream);
	FSEventStreamInvalidate(_stream);
	FSEventStreamRelease(_stream);
	
	_stream = nil;
}

- (void)flushEvents
{
	FSEventStreamFlushAsync(_stream);
}

- (BOOL)isWatching
{
	return !!_stream;
}


#pragma mark - Equality

- (BOOL)isEqual:(id)other
{
	return ( self == other );
}

- (NSUInteger)hash
{
	return [super hash];
}


#pragma mark - Description

- (NSString *)description
{
	/// TODO: Improve description
	return (__bridge NSString *)CFAutorelease(FSEventStreamCopyDescription(_stream));
}

- (NSString *)debugDescription
{
	return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (void *)self, [self description]];
}


#pragma mark - Event

- (void)triggerEvent:(CBHFileSystemEvent *)event
{
	NSAssert(NO, @"The method `triggerEvent:` must be overridden by all subclasses and should never be called.");
}

@end


#pragma mark - Callback

void fsEventCallback(ConstFSEventStreamRef streamRef, void *info, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[])
{
	CBHFileSystemWatcher *watcher = (__bridge CBHFileSystemWatcher *)info;
	char **paths = eventPaths;

	for (uint64_t i = 0; i < numEvents; ++i)
	{
		[watcher triggerEvent:[CBHFileSystemEvent eventWithPath:[NSString stringWithCString: paths[i] encoding:NSUTF8StringEncoding] type:eventFlags[i] eventId:eventIds[i] andObject:[watcher object]]];
	}
}
