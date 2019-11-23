//  _CBHFileSystemWatcherObserver.m
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

#import "_CBHFileSystemWatcherObserver.h"
#import "_CBHFileSystemWatcher.h"

#import "CBHFileSystemEvent.h"


NS_ASSUME_NONNULL_BEGIN

@interface _CBHFileSystemWatcherObserver ()
{
	id _observer;
	SEL _selector;
	id __nullable _object;
}

@end

NS_ASSUME_NONNULL_END


@implementation _CBHFileSystemWatcherObserver

#pragma mark - Initializers

- (instancetype)initWithObserver:(id)observer andSelector:(SEL)selector ofPaths:(NSArray<NSString *> *)paths withType:(CBHFileSystemWatcherType)type latency:(NSTimeInterval)latency andObject:(id)object
{
	if ( self = [super initWithPaths:paths type:type andLatency:latency] )
	{
		_observer = observer;
		_selector = selector;
		_object = object;
	}

	return self;
}


#pragma mark - Properties

- (id)object
{
	return _object;
}


#pragma mark - Event

- (void)triggerEvent:(CBHFileSystemEvent *)event
{
	if ( _observer && [_observer respondsToSelector:_selector] ) {
		_Pragma("clang diagnostic push")
		_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
		[_observer performSelector:_selector withObject:event];
		_Pragma("clang diagnostic pop")
	}
}

@end
