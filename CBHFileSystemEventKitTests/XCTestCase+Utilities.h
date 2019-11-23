//  XCTestCase+Utilities.h
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


@class CBHTestExpectation;


NS_ASSUME_NONNULL_BEGIN

@interface XCTestCase (Utilities)

#pragma mark - Expectations

- (CBHTestExpectation *)expectationWithDescription:(NSString *)description andFulfillmentCount:(NSUInteger)count;
- (CBHTestExpectation *)expectationWithDescription:(NSString *)description andContext:(nullable id)context;

- (CBHTestExpectation *)expectationWithDescription:(NSString *)description context:(nullable id)context andFulfillmentCount:(NSUInteger)count;


#pragma mark - Waiting for Expectations

- (void)waitForExpectation:(XCTestExpectation *)expectation timeout:(NSTimeInterval)seconds;
@end

NS_ASSUME_NONNULL_END
