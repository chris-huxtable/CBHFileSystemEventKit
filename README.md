# CBHFileSystemEventKit

[![release](https://img.shields.io/github/release/chris-huxtable/CBHFileSystemEventKit.svg)](https://github.com/chris-huxtable/CBHFileSystemEventKit/releases)
[![pod](https://img.shields.io/cocoapods/v/CBHFileSystemEventKit.svg)](https://cocoapods.org/pods/CBHFileSystemEventKit)
[![licence](https://img.shields.io/badge/licence-ISC-lightgrey.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHFileSystemEventKit/blob/master/LICENSE)
[![coverage](https://img.shields.io/badge/coverage-98%25-brightgreen.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHFileSystemEventKit)

An easier way to watch for file system events.


## Use

The starting point of any use is `CBHFileSystemWatcher`. It is used to describe what kind of file system events you want to get and how/where you want to receive them. When an event matching the description occurs the callback is invoked and passed a `CBHFileSystemEvent` which describes where and what happened.

#### Examples:

Watch the contents of a directory with a block:
```objective-c
// [...]

NSString *path = @"/path/to/directory/to/watch";
CBHFileSystemWatcherType type = CBHFileSystemWatcherType_default;
id someContext = nil;

CBHFileSystemWatcher *watcher = [CBHFileSystemWatcher watcherOfPath:path withType:type andBlock:^(CBHFileSystemEvent *event) {
	// Do something with the event and someContext.
}];

// [...]
```

Watch the contents of a directory with an observer:
```objective-c
// [...]

- (void)watchPath
{
	NSString *path = @"/path/to/directory/to/watch";
	CBHFileSystemWatcherType type = CBHFileSystemWatcherType_default;
	SEL selector = @selector(_fileSystemEventOccurred:);
	id someContext = nil;

	_watcher = [CBHFileSystemWatcher watcherWithObserver:self andSelector:selector ofPath:path withType:type andObject:someContext];
}

- (void)_fileSystemEventOccurred:(CBHFileSystemEvent *)event
{
	id context = [event object];
	// Do something with the event.
}

// [...]
```

## Licence
CBHFileSystemEventKit is available under the [ISC license](https://github.com/chris-huxtable/CBHFileSystemEventKit/blob/master/LICENSE).
