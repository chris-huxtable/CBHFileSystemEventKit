//  CBHFileSystemEvent.m
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

#import "CBHFileSystemEvent.h"


NS_ASSUME_NONNULL_BEGIN

@interface CBHFileSystemEvent ()
{
	NSString *_path;
	CBHFileSystemEventType _type;
	UInt64 _eventId;
	id __nullable _object;
}

@end

NS_ASSUME_NONNULL_END


@implementation CBHFileSystemEvent

#pragma mark - Factories

+ (instancetype)eventWithPath:(NSString *)path type:(CBHFileSystemEventType)type eventId:(UInt64)eventId andObject:(nullable id)object
{
	return [[[self class] alloc] initWithPath:path type:type eventId:eventId andObject:object];
}


#pragma mark - Initializers

- (instancetype)initWithPath:(NSString *)path type:(CBHFileSystemEventType)type eventId:(UInt64)eventId andObject:(nullable id)object
{
	if ( (self = [super init]) )
	{
		_path = [path copy];
		_type = type;
		_eventId = eventId;
		_object = object;
	}

	return self;
}


#pragma mark - Properties

@synthesize path = _path;
@synthesize type = _type;
@synthesize eventId = _eventId;
@synthesize object = _object;


#pragma mark - Equality

- (BOOL)isEqual:(id)other
{
	if ( self == other ) return YES; /// FIXME: Test for this codepath does not work...
	if ( ![other isKindOfClass:[self class]] ) return NO;

	return [self isEqualToEvent:(CBHFileSystemEvent *)other];
}

- (BOOL)isEqualToEvent:(CBHFileSystemEvent *)other
{
	return ( _eventId == other->_eventId);
}

- (NSUInteger)hash
{
	return (NSUInteger)_eventId;
}


#pragma mark - Description

- (NSString *)description
{
	NSMutableString *string = [NSMutableString stringWithString:@"{\n"];
	[string appendFormat:@"\tPaths:    %@\n", [_path description]];
	[string appendFormat:@"\tTypes:    %llx\n", _type];
	[string appendFormat:@"\tEvent ID: %llx\n", _eventId];
	[string appendFormat:@"\tObject:   %@\n", [_object description]];
	[string appendString:@"}"];

	return string;
}

- (NSString *)debugDescription
{
	return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (void *)self, [self description]];
}

@end
