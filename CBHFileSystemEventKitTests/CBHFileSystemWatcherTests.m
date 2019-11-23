//  CBHFileSystemWatcherTests.m
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

#import "CBHTestFileSystemCase.h"

#import "XCTestCase+Utilities.h"
#import "CBHTestAssert.h"
#import "CBHTestExpectation.h"


#define CBHObserverWatcher(dir, type, expectation) [CBHFileSystemWatcher watcherWithObserver:self andSelector:@selector(fulfillCallback:) ofPath:dir withType:type latency:kDefaultLatency andObject:expectation]

#define CBHBlockWatcher(dir, type, expectation) [CBHFileSystemWatcher watcherOfPath:dir withType:type latency:kDefaultTimeout andBlock:^(CBHFileSystemEvent *event) {\
	XCTAssertEqualObjects([[expectation context] stringByStandardizingPath], [[event path] stringByStandardizingPath], @"Paths should be the same in order to fulfill.");\
	[expectation fulfill];\
}];


CBHFileSystemWatcherType kDefaultDirWatcherType = CBHFileSystemWatcherType_default | CBHFileSystemWatcherType_noDefer;
CBHFileSystemWatcherType kDefaultFileWatcherType = CBHFileSystemWatcherType_default | CBHFileSystemWatcherType_fileEvents | CBHFileSystemWatcherType_noDefer;

CGFloat kDefaultTimeout = 0.5;
CGFloat kDefaultLatency = 0.01;


NS_ASSUME_NONNULL_BEGIN

@interface CBHFileSystemWatcherTests : CBHTestFileSystemCase
@end

NS_ASSUME_NONNULL_END


@implementation CBHFileSystemWatcherTests

#pragma mark - Directory Observer Tests

- (void)testDirectoryObserver_basicCreation
{
	/// Setup Directory to work in.
	NSString *dir = CBHTestDirectory_samplePath();

	/// Setup Expectation and Watcher
	CBHTestExpectation *expectation = [self expectationWithDescription:@"Watching for creation in a directory" context:dir andFulfillmentCount:1];
	CBHFileSystemWatcher *watcher = CBHObserverWatcher(dir, kDefaultDirWatcherType, expectation);

	/// Create new File in Dir
	CBHTestFile_sampleFile(@"Sample Data");

	/// Wait for callback and cleanup
	[self waitForExpectation:expectation timeout:kDefaultTimeout];
	[watcher stopWatching];
}

- (void)testDirectoryObserver_basicModify
{
	/// Setup Directory to work in and create new sample file
	NSString *dir = CBHTestDirectory_samplePath();
	NSString *path = CBHTestFile_sampleFile(@"Sample Data");

	/// Setup Expectation and Watcher
	CBHTestExpectation *expectation = [self expectationWithDescription:@"Watching for modification in a directory" context:dir andFulfillmentCount:1];
	CBHFileSystemWatcher *watcher = CBHObserverWatcher(dir, kDefaultDirWatcherType, expectation);

	/// Modify File
	CBHTestFile_writeAtPath(path, @"Sample Data Changes");

	/// Wait for callback and cleanup
	[self waitForExpectation:expectation timeout:kDefaultTimeout];
	[watcher stopWatching];
}


#pragma mark - Directory Block Tests

- (void)testDirectoryBlock_basicCreation
{
	/// Setup Directory to work in.
	NSString *dir = CBHTestDirectory_samplePath();

	/// Setup Expectation and Watcher
	CBHTestExpectation *expectation = [self expectationWithDescription:@"Watching for creation in a directory" context:dir andFulfillmentCount:1];
	CBHFileSystemWatcher *watcher = CBHBlockWatcher(dir, kDefaultDirWatcherType, expectation);

	/// Create new File in Dir
	CBHTestFile_sampleFile(@"Sample Data");

	/// Wait for callback and cleanup
	[self waitForExpectations:@[expectation] timeout:kDefaultTimeout];
	[watcher stopWatching];
}

- (void)testDirectoryBlock_basicModify
{
	/// Setup Directory to work in and create new sample file
	NSString *dir = CBHTestDirectory_samplePath();
	NSString *path = CBHTestFile_sampleFile(@"Sample Data");

	/// Setup Expectation and Watcher
	CBHTestExpectation *expectation = [self expectationWithDescription:@"Watching for modification in a directory" context:dir andFulfillmentCount:1];
	CBHFileSystemWatcher *watcher = CBHBlockWatcher(dir, kDefaultDirWatcherType, expectation);

	/// Modify File
	CBHTestFile_writeAtPath(path, @"Sample Data");

	/// Wait for callback and cleanup
	[self waitForExpectation:expectation timeout:kDefaultTimeout];
	[watcher stopWatching];
}

#pragma mark - File Observer Tests

- (void)testFileObserver_basicCreation
{
	/// Setup Directory to work in and file to watch.
	NSString *file = CBHTestFile_samplePath();

	/// Setup Expectation and Watcher
	CBHTestExpectation *expectation = [self expectationWithDescription:@"Watching for creation of a file" context:file andFulfillmentCount:1];
	CBHFileSystemWatcher *watcher = CBHObserverWatcher(file, kDefaultFileWatcherType, expectation);

	/// Create File
	CBHTestFile_writeAtPath(file, @"Sample Data");

	/// Wait for callback and cleanup
	[self waitForExpectation:expectation timeout:kDefaultTimeout];
	[watcher stopWatching];
}

- (void)testFileObserver_basicModify
{
	/// Setup Sample File
	NSString *file = CBHTestFile_sampleFile(@"Sample Data");

	/// Setup Expectation and Watcher
	CBHTestExpectation *expectation = [self expectationWithDescription:@"Watching for modification of a file" context:file andFulfillmentCount:1];
	CBHFileSystemWatcher *watcher = CBHObserverWatcher(file, kDefaultFileWatcherType, expectation);

	/// Modify File
	CBHTestFile_writeAtPath(file, @"Sample Data Changes");

	/// Wait for callback and cleanup
	[self waitForExpectation:expectation timeout:kDefaultTimeout];
	[watcher stopWatching];
}


#pragma mark - File Block Tests

- (void)testFileBlock_basicCreation
{
	/// Setup Directory to work in and file to watch.
	NSString *file = CBHTestFile_samplePath();

	/// Setup Expectation and Watcher
	CBHTestExpectation *expectation = [self expectationWithDescription:@"Watching for creation of a file" context:file andFulfillmentCount:1];
	CBHFileSystemWatcher *watcher = CBHBlockWatcher(file, kDefaultFileWatcherType, expectation);

	/// Create File
	CBHTestFile_writeAtPath(file, @"Sample Data");

	/// Wait for callback and cleanup
	[self waitForExpectation:expectation timeout:kDefaultTimeout];
	[watcher stopWatching];
}

- (void)testFileBlock_basicModify
{
	/// Setup Directory to work in and file to watch.
	NSString *file = CBHTestFile_sampleFile(@"Sample Data");

	/// Setup Expectation and Watcher
	CBHTestExpectation *expectation = [self expectationWithDescription:@"Watching for modification of a file" context:file andFulfillmentCount:1];
	CBHFileSystemWatcher *watcher = CBHBlockWatcher(file, kDefaultFileWatcherType, expectation);

	/// Modify File
	CBHTestFile_writeAtPath(file, @"Sample Data Changes");

	/// Wait for callback and cleanup
	[self waitForExpectation:expectation timeout:kDefaultTimeout];
	[watcher stopWatching];
}


#pragma mark - Equality

- (void)testEquality_isEqual
{
	CBHFileSystemWatcher *watcher1 = [CBHFileSystemWatcher watcherOfPath:CBHTestFile_samplePath() withType:kDefaultDirWatcherType andBlock:^(CBHFileSystemEvent *event) {}];
	CBHFileSystemWatcher *watcher2 = [CBHFileSystemWatcher watcherWithObserver:self andSelector:@selector(fulfillCallback:) ofPath:CBHTestFile_samplePath() withType:kDefaultDirWatcherType];
	NSString *notAWatcher = @"";
	XCTAssertEqualObjects(watcher1, watcher1, @"Watchers should be equal.");
	XCTAssertNotEqualObjects(watcher1, watcher2, @"Watchers should not be equal.");
	XCTAssertNotEqualObjects(watcher1, notAWatcher, @"Watcher/String should not be equal.");

	[watcher1 stopWatching];
	[watcher2 stopWatching];
}

- (void)testEquality_hash
{
	CBHFileSystemWatcher *watcher1 = [CBHFileSystemWatcher watcherOfPath:CBHTestFile_samplePath() withType:kDefaultDirWatcherType andBlock:^(CBHFileSystemEvent *event) {}];
	CBHFileSystemWatcher *watcher2 = [CBHFileSystemWatcher watcherWithObserver:self andSelector:@selector(fulfillCallback:) ofPath:CBHTestFile_samplePath() withType:kDefaultDirWatcherType];

	XCTAssertEqual([watcher1 hash], [watcher1 hash], @"Watchers hash should be the same.");
	XCTAssertNotEqual([watcher1 hash], [watcher2 hash], @"Watchers hash should not be the same.");

	[watcher1 stopWatching];
	[watcher2 stopWatching];
}

- (void)testEquality_set
{
	NSMutableSet *set = [NSMutableSet setWithCapacity:2];

	CBHFileSystemWatcher *watcher1 = [CBHFileSystemWatcher watcherOfPath:CBHTestFile_samplePath() withType:kDefaultDirWatcherType andBlock:^(CBHFileSystemEvent *event) {}];
	CBHFileSystemWatcher *watcher2 = [CBHFileSystemWatcher watcherWithObserver:self andSelector:@selector(fulfillCallback:) ofPath:CBHTestFile_samplePath() withType:kDefaultDirWatcherType];

	[set addObject:watcher1];
	[set addObject:watcher1];
	[set addObject:watcher2];
	[set addObject:watcher1];
	[set addObject:watcher2];

	XCTAssertEqual([set count], 2, @"Set should only have 2 objects in it.");
	XCTAssertTrue([set containsObject:watcher1], @"Set should contain watcher1.");
	XCTAssertTrue([set containsObject:watcher2], @"Set should contain watcher1.");
}


#pragma mark - Coverage

- (void)testCoverage_doubleStart
{
	CBHFileSystemWatcher *watcher = CBHObserverWatcher(@"/var/empty", kDefaultDirWatcherType, nil);
	[watcher startWatching];
	XCTAssertTrue([watcher isWatching], @"Watcher should still be watching.");
	[watcher stopWatching];
	XCTAssertFalse([watcher isWatching], @"Watcher should not still be watching.");
}

- (void)testCoverage_flush
{
	CBHFileSystemWatcher *watcher = CBHObserverWatcher(@"/var/empty", kDefaultDirWatcherType, nil);
	[watcher flushEvents];
	XCTAssertTrue([watcher isWatching], @"Watcher should still be watching.");

	[watcher stopWatching];
}


- (void)testFactoryObserver_basic
{
	/// Setup Directory to work in.
	NSString *dir = CBHTestDirectory_samplePath();

	/// Setup Watcher
	CBHFileSystemWatcher *watcher = [CBHFileSystemWatcher watcherWithObserver:self andSelector:@selector(fulfillBasicCallback:) ofPath:dir withType:kDefaultDirWatcherType];

	/// Cannot test due to inability to pass expectation...

	/// Cleanup
	[watcher stopWatching];
}

- (void)testFactoryBlock_basic
{
	/// Setup Directory to work in.
	NSString *dir = CBHTestDirectory_samplePath();

	/// Setup Expectation and Watcher
	CBHTestExpectation *expectation = [self expectationWithDescription:@"Watching for creation in a directory" context:dir andFulfillmentCount:1];
	CBHFileSystemWatcher *watcher = [CBHFileSystemWatcher watcherOfPath:dir withType:kDefaultDirWatcherType andBlock:^(CBHFileSystemEvent *event) {
		[expectation fulfill];
	}];
	[watcher startWatching];

	/// Create new File in Dir
	CBHTestFile_sampleFile(@"Sample Data");

	/// Wait for callback and cleanup
	[self waitForExpectation:expectation timeout:kDefaultTimeout];
	[watcher stopWatching];
}

- (void)testFactoryObserver_withLatency
{
	/// Setup Directory to work in.
	NSString *dir = CBHTestDirectory_samplePath();

	/// Setup Watcher
	CBHFileSystemWatcher *watcher = [CBHFileSystemWatcher watcherWithObserver:self andSelector:@selector(fulfillBasicCallback:) ofPath:dir withType:kDefaultDirWatcherType andLatency:kDefaultLatency];

	/// Cannot test due to inability to pass expectation...

	/// Cleanup
	[watcher stopWatching];
}

- (void)testFactoryBlock_withLatency
{
	/// Setup Directory to work in.
	NSString *dir = CBHTestDirectory_samplePath();

	/// Setup Expectation and Watcher
	CBHTestExpectation *expectation = [self expectationWithDescription:@"Watching for creation in a directory" context:dir andFulfillmentCount:1];
	CBHFileSystemWatcher *watcher = [CBHFileSystemWatcher watcherOfPath:dir withType:kDefaultDirWatcherType latency:kDefaultLatency andBlock:^(CBHFileSystemEvent *event) {
		[expectation fulfill];
	}];
	[watcher startWatching];

	/// Create new File in Dir
	CBHTestFile_sampleFile(@"Sample Data");

	/// Wait for callback and cleanup
	[self waitForExpectation:expectation timeout:kDefaultTimeout];
	[watcher stopWatching];
}

- (void)testFactoryObserver_withObject
{
	/// Setup Directory to work in.
	NSString *dir = CBHTestDirectory_samplePath();

	/// Setup Expectation and Watcher
	CBHTestExpectation *expectation = [self expectationWithDescription:@"Watching for creation in a directory" context:dir andFulfillmentCount:1];
	CBHFileSystemWatcher *watcher = [CBHFileSystemWatcher watcherWithObserver:self andSelector:@selector(fulfillBasicCallback:) ofPath:dir withType:kDefaultDirWatcherType andObject:expectation];

	/// Create new File in Dir
	CBHTestFile_sampleFile(@"Sample Data");

	/// Wait for callback and cleanup
	[self waitForExpectation:expectation timeout:kDefaultTimeout];
	[watcher stopWatching];
}

- (void)testInit_allObserver
{
	/// Setup Directory to work in.
	NSString *dir = CBHTestDirectory_samplePath();

	/// Setup Expectation and Watcher
	CBHTestExpectation *expectation = [self expectationWithDescription:@"Watching for creation in a directory" context:dir andFulfillmentCount:1];
	CBHFileSystemWatcher *watcher = [[CBHFileSystemWatcher alloc] initWithObserver:self andSelector:@selector(fulfillBasicCallback:) ofPaths:@[dir] withType:kDefaultDirWatcherType latency:kDefaultLatency andObject:expectation];
	[watcher startWatching];

	/// Create new File in Dir
	CBHTestFile_sampleFile(@"Sample Data");

	/// Wait for callback and cleanup
	[self waitForExpectation:expectation timeout:kDefaultTimeout];
	[watcher stopWatching];
}

- (void)testInit_allBlock
{
	/// Setup Directory to work in.
	NSString *dir = CBHTestDirectory_samplePath();

	/// Setup Expectation and Watcher
	CBHTestExpectation *expectation = [self expectationWithDescription:@"Watching for creation in a directory" context:dir andFulfillmentCount:1];
	CBHFileSystemWatcher *watcher = [[CBHFileSystemWatcher alloc] initWithPaths:@[dir] type:kDefaultDirWatcherType latency:kDefaultLatency andBlock:^(CBHFileSystemEvent *event) {
		[expectation fulfill];
	}];
	[watcher startWatching];

	/// Create new File in Dir
	CBHTestFile_sampleFile(@"Sample Data");

	/// Wait for callback and cleanup
	[self waitForExpectation:expectation timeout:kDefaultTimeout];
	[watcher stopWatching];
}


- (void)testDescription_observer
{
	/// Setup Directory to work in.
	NSString *dir = CBHTestDirectory_samplePath();

	/// Setup Observer Watcher
	CBHFileSystemWatcher *watcher = [CBHFileSystemWatcher watcherWithObserver:self andSelector:@selector(fulfillBasicCallback:) ofPath:dir withType:kDefaultDirWatcherType andLatency:kDefaultLatency];

	/// TODO: Improve description
	XCTAssertNotNil([watcher description], @"Expected a description.");

	NSString *description = [NSString stringWithFormat:@"<_CBHFileSystemWatcherObserver: %p, %@>", (void *)watcher, [watcher description]];
	XCTAssertEqualObjects([watcher debugDescription], description, @"Description is wrong.");

	/// Cleanup
	[watcher stopWatching];
}

- (void)testDescription_block
{
	/// Setup Directory to work in.
	NSString *dir = CBHTestDirectory_samplePath();

	/// Setup Observer Watcher
	CBHFileSystemWatcher *watcher = [CBHFileSystemWatcher watcherOfPath:dir withType:kDefaultDirWatcherType latency:kDefaultLatency andBlock:^(CBHFileSystemEvent *event) { }];

	/// TODO: Improve description
	XCTAssertNotNil([watcher description], @"Expected a description.");

	NSString *description = [NSString stringWithFormat:@"<_CBHFileSystemWatcherBlock: %p, %@>", (void *)watcher, [watcher description]];
	XCTAssertEqualObjects([watcher debugDescription], description, @"Description is wrong.");

	/// Cleanup
	[watcher stopWatching];
}


#pragma mark - Callbacks

- (void)fulfillCallback:(CBHFileSystemEvent *)event
{
	CBHTestExpectation *expectation = [event object];

	NSString *path = [expectation context];
	NSString *eventPath = [event path];

	XCTAssertEqualObjects([eventPath stringByStandardizingPath], [path stringByStandardizingPath], @"Paths should be the same in order to fulfill.");

	[expectation fulfill];
}

- (void)fulfillBasicCallback:(CBHFileSystemEvent *)event
{
	CBHTestExpectation *expectation = [event object];
	[expectation fulfill];
}

@end
