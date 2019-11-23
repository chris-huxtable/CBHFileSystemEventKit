//  CBHTestFileSystemCase.m
//  CBHFileSystemTestCase
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

#import "CBHTestFileSystemCase.h"

@import XCTest;
@import CBHFileSystemEventKit;

#import "CBHTestAssert.h"


NS_ASSUME_NONNULL_BEGIN

NSString *kTempPath = @"/private/tmp";
NSString *kBundleID = nil;


@interface CBHTestFileSystemCase ()
{
	NSString *_bundleID;
	NSMutableSet<NSString *> *_openPaths;
}
@end

NS_ASSUME_NONNULL_END


@implementation CBHTestFileSystemCase


#pragma mark - Set Up and Tear Down

+ (void)setUp
{
	kBundleID = [[NSBundle bundleForClass:[self class]] bundleIdentifier];

	[super setUp];
}

- (void)setUp
{
	_openPaths = [NSMutableSet set];
	_bundleID = kBundleID;

	[super setUp];
}

- (void)tearDown
{
	[super tearDown];

	for (NSString *path in _openPaths)
	{
		[self cleanupFileAtPath:path];
	}
}

+ (void)tearDown
{
	NSError *error = nil;
	[[NSFileManager defaultManager] removeItemAtPath:[kTempPath stringByAppendingPathComponent:kBundleID] error:&error];

}


#pragma mark - Files and Paths

- (NSString *)sampleDirectory:(nullable NSString *)subpath
{
	NSString *path = [self sampleDirectoryPath:subpath];

	NSError *error = nil;
	[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
	CBHAssertNoError(error, @"Directory file failed to be created at %@", path);

	[_openPaths addObject:path];

	return path;
}

- (NSString *)sampleDirectoryPath:(nullable NSString *)subpath
{
	NSString *path;
	if ( subpath ) { path = [NSString stringWithFormat:@"%@/%@/", _bundleID, subpath]; }
	else { path = [NSString stringWithFormat:@"%@/", _bundleID]; }

	path = [kTempPath stringByAppendingPathComponent:path];
	[_openPaths addObject:path];

	return path;
}


- (NSString *)randomPath
{
	return [self randomPath:nil];
}

- (NSString *)randomPath:(nullable NSString *)subpath
{
	/// Acquire a unique path.
	NSString *path = [self _genPath:subpath];
	while ( [_openPaths containsObject:path] ) { path = [self _genPath:subpath]; }

	return path;
}

- (NSString *)_genPath:(nullable NSString *)subpath
{
	uint64_t identifier;
	arc4random_buf(&identifier, sizeof(uint64_t));
	NSString *tmpPath;

	if ( subpath ) { tmpPath = [NSString stringWithFormat:@"%@/%@/%llx.sample", _bundleID, subpath, identifier]; }
	else { tmpPath = [NSString stringWithFormat:@"%@/%llx.sample",_bundleID, identifier]; }

	return [[kTempPath stringByAppendingPathComponent:tmpPath] stringByStandardizingPath];
}

- (NSString *)sampleFileContainingString:(NSString *)string
{
	return [self sampleFileContainingString:string atSubpath:nil];
}

- (NSString *)sampleFileContainingString:(NSString *)string atSubpath:(nullable NSString *)subpath
{
	return [self sampleFileAtPath:[self randomPath:subpath] containingString:string];
}

- (NSString *)sampleFileAtPath:(NSString *)path containingString:(NSString *)string
{
	NSString *dir = [path stringByDeletingLastPathComponent];

	/// Create a new directory if necessary
	if ( ![[NSFileManager defaultManager] fileExistsAtPath:dir] )
	{
		NSError *error = nil;
		[[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
		CBHAssertNoError(error, @"Directory file failed to be created at %@", dir);
		[_openPaths addObject:dir];
	}

	/// Write String to new file.
	NSError *error = nil;
	[string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
	CBHAssertNoError(error, @"Sample file failed to be create/write at %@", path);

	// Add path to open paths
	[_openPaths addObject:path];

	// Return the path
	return path;
}

- (void)cleanupFileAtPath:(NSString *)path
{
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}


#pragma mark - Assert Tests

- (void)testAssert_error
{
	uint64_t identifier;
	arc4random_buf(&identifier, sizeof(uint64_t));
	NSString *path = [NSString stringWithFormat:@"/var/empty/%llx", identifier];

	NSError *error = nil;
	[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

	CBHAssertError(error, @"There should be an error and this will never display.");
	CBHAssertError(error, @"There should be an error %@", @"and this will never display.");
}

- (void)testAssert_noError
{
	NSString *path = @"/usr/bin/cd";

	NSError *error = nil;
	[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

	CBHAssertNoError(error, @"There should be an error and this will never display.");
	CBHAssertNoError(error, @"There should be an error %@", @"and this will never display.");
}


#pragma mark - File and Directory tests

- (void)testSample_dir
{
	NSString *dirPath = CBHTestDirectory_samplePath();

	BOOL isDirectory = NO;
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDirectory];

	XCTAssertTrue(exists, @"The directory is expected to exist.");
	XCTAssertTrue(isDirectory, @"The thing at the path is expected to be a directory, it is not.");
}

- (void)testSample_file
{
	NSString *sampleData = @"Sample Data";
	NSString *path = CBHTestFile_sampleFile(sampleData);

	BOOL isDirectory = YES;
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];

	XCTAssertTrue(exists, @"The file is expected to exist.");
	XCTAssertFalse(isDirectory, @"The thing at the path is expected to be a file, it is not.");

	NSError *error = nil;
	NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	CBHAssertNoError(error, @"File read failed");

	XCTAssertEqualObjects(contents, sampleData, @"String read from file was incorrect.");
}

- (void)testSample_fileWithContents
{
	NSString *sampleData = @"Sample Data";
	NSString *path = [self sampleFileContainingString:sampleData];

	BOOL isDirectory = YES;
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];

	XCTAssertTrue(exists, @"The file is expected to exist.");
	XCTAssertFalse(isDirectory, @"The thing at the path is expected to be a file, it is not.");

	NSError *error = nil;
	NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	CBHAssertNoError(error, @"File read failed");

	XCTAssertEqualObjects(contents, sampleData, @"String read from file was incorrect.");
}

@end
