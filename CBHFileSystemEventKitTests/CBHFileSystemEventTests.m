//  CBHFileSystemEventTests.m
//  CBHFileSystemEventKitTests
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

@import XCTest;
@import CBHFileSystemEventKit;

#import "CBHTestAssert.h"


NS_ASSUME_NONNULL_BEGIN

@interface CBHTestFileSystemEventClass : XCTestCase
@end

NS_ASSUME_NONNULL_END


@implementation CBHTestFileSystemEventClass

- (void)testEquality_isEqual
{
	CBHFileSystemEvent *event1 = [CBHFileSystemEvent eventWithPath:@"/this/is/a/path" type:CBHFileSystemEventType_none eventId:1 andObject:nil];
	CBHFileSystemEvent *event2 = [CBHFileSystemEvent eventWithPath:@"/this/is/b/path" type:CBHFileSystemEventType_none eventId:1 andObject:nil];
	CBHFileSystemEvent *event3 = [CBHFileSystemEvent eventWithPath:@"/this/is/b/path" type:CBHFileSystemEventType_none eventId:2 andObject:nil];
	NSString *notAnEvent = @"";


	XCTAssertEqualObjects(event1, event1, @"Events should be equal.");
	XCTAssertEqualObjects(event1, event2, @"Events should be equal.");

	XCTAssertNotEqualObjects(event1, event3, @"Events should not be equal.");
	XCTAssertNotEqualObjects(event2, event3, @"Events should not be equal.");
	XCTAssertNotEqualObjects(event1, notAnEvent, @"Event/String should not be equal.");
}

- (void)testEquality_hash
{
	CBHFileSystemEvent *event1 = [CBHFileSystemEvent eventWithPath:@"/this/is/a/path" type:CBHFileSystemEventType_none eventId:1 andObject:nil];
	CBHFileSystemEvent *event2 = [CBHFileSystemEvent eventWithPath:@"/this/is/b/path" type:CBHFileSystemEventType_none eventId:1 andObject:nil];
	CBHFileSystemEvent *event3 = [CBHFileSystemEvent eventWithPath:@"/this/is/b/path" type:CBHFileSystemEventType_none eventId:2 andObject:nil];

	XCTAssertEqual([event1 hash], [event1 hash], @"Objects should be equal.");
	XCTAssertEqual([event1 hash], [event2 hash], @"Objects should be equal.");

	XCTAssertNotEqual([event1 hash], [event3 hash], @"Objects should not be equal.");
	XCTAssertNotEqual([event2 hash], [event3 hash], @"Objects should not be equal.");
}


- (void)testDescription
{
	NSString *path = @"/this/is/a/path";
	CBHFileSystemEventType type = CBHFileSystemEventType_none;
	UInt64 eventId = 1;

	CBHFileSystemEvent *event = [CBHFileSystemEvent eventWithPath:path type:type eventId:eventId andObject:nil];

	NSString *description = [NSString stringWithFormat:@"{\n\tPaths:    %@\n\tTypes:    %llx\n\tEvent ID: %llx\n\tObject:   (null)\n}", path, type, eventId];

	XCTAssertEqualObjects([event description], description, @"Description is wrong.");
}

- (void)testDescription_debug
{
	NSString *path = @"/this/is/a/path";
	CBHFileSystemEventType type = CBHFileSystemEventType_none;
	UInt64 eventId = 1;

	CBHFileSystemEvent *event = [CBHFileSystemEvent eventWithPath:path type:type eventId:eventId andObject:nil];

	NSString *description = [NSString stringWithFormat:@"{\n\tPaths:    %@\n\tTypes:    %llx\n\tEvent ID: %llx\n\tObject:   (null)\n}", path, type, eventId];
	description = [NSString stringWithFormat:@"<CBHFileSystemEvent: %p, %@>", (void *)event, description];

	XCTAssertEqualObjects([event debugDescription], description, @"Description is wrong.");
}

@end
