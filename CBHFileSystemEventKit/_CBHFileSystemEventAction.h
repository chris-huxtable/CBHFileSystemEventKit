//  CBHFileSystemEventAction.m
//  CBHFileSystemEventKit
//
//  Created by Christian Huxtable <chris@huxtable.ca>, November 2019.
//  Copyright (c) 2019 Christian Huxtable. All rights reserved.


@protocol _CBHFileSystemEventAction <NSObject>

@required

@property (nonatomic, readonly) NSString *path;

- (void)signalWithPath:(NSString *)path  ;

@end
