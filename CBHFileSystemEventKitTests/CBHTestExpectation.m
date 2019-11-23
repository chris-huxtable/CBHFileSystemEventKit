//  CBHTestExpectation.m
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

#import "CBHTestExpectation.h"


NS_ASSUME_NONNULL_BEGIN

@interface CBHTestExpectation ()
{
	id _context;
}

@end

NS_ASSUME_NONNULL_END


@implementation CBHTestExpectation

#pragma mark - Factories

+ (instancetype)expectationWithDescription:(NSString *)description
{
	return [[[self class] alloc] initWithDescription:description];
}

+ (instancetype)expectationWithDescription:(NSString *)description andContext:(nullable id)context
{
	return [[[self class] alloc] initWithDescription:description andContext:context];
}

+ (instancetype)expectationWithDescription:(NSString *)description andFulfillmentCount:(NSUInteger)count
{
	return [[[self class] alloc] initWithDescription:description andFulfillmentCount:count];
}

+ (instancetype)expectationWithDescription:(NSString *)description context:(nullable id)context andFulfillmentCount:(NSUInteger)count
{
	return [[[self class] alloc] initWithDescription:description context:context andFulfillmentCount:count];
}


#pragma mark - Initialization

- (instancetype)initWithDescription:(NSString *)description
{
	return [self initWithDescription:description andContext:nil];
}

- (instancetype)initWithDescription:(NSString *)description andFulfillmentCount:(NSUInteger)count
{
	return [self initWithDescription:description context:nil andFulfillmentCount:count];
}

- (instancetype)initWithDescription:(NSString *)description andContext:(nullable id)context
{
	if ( (self = [super initWithDescription:description]) )
	{
		_context = context;
	}

	return self;
}

- (instancetype)initWithDescription:(NSString *)description context:(nullable id)context andFulfillmentCount:(NSUInteger)count
{
	if ( (self = [super initWithDescription:description]) )
	{
		_context = context;

		[self setExpectedFulfillmentCount:count];
		[self setAssertForOverFulfill:YES];
	}

	return self;
}


#pragma mark - Properties

@synthesize context = _context;

@end
