//
// Created by shazhou on 2018/9/6.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import "WDUTThreadSafeMutableArray.h"
#import "WDUTMacro.h"
#import "WDUTUtils.h"
#import "WDUTConfig.h"
#import <os/lock.h>
#import <pthread/pthread.h>
#import <UIKit/UIKit.h>

@interface WDUTThreadSafeMutableArray()

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) NSMutableArray* array;

@end

@implementation WDUTThreadSafeMutableArray {
    pthread_mutex_t _safeThreadArrayMutex;
    pthread_mutexattr_t _safeThreadArrayMutexAttr;
    os_unfair_lock _osUnfairLock;
}

- (instancetype)initCommon
{
    self = [super init];
    if (self) {
        NSString* uuid = [NSString stringWithFormat:@"com.vdian.wdut.array_%p", self];
        _queue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);
        pthread_mutexattr_init(&(_safeThreadArrayMutexAttr));
        pthread_mutexattr_settype(&(_safeThreadArrayMutexAttr), PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&(_safeThreadArrayMutex), &(_safeThreadArrayMutexAttr));
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            _osUnfairLock = OS_UNFAIR_LOCK_INIT;
        }
    }
    return self;
}

- (instancetype)init
{
    self = [self initCommon];
    if (self) {
        _array = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems
{
    self = [self initCommon];
    if (self) {
        _array = [NSMutableArray arrayWithCapacity:numItems];
    }
    return self;
}

- (NSArray *)initWithContentsOfFile:(NSString *)path
{
    self = [self initCommon];
    if (self) {
        _array = [NSMutableArray arrayWithContentsOfFile:path];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self initCommon];
    if (self) {
        _array = [[NSMutableArray alloc] initWithCoder:aDecoder];
    }
    return self;
}

- (instancetype)initWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    self = [self initCommon];
    if (self) {
        _array = [NSMutableArray array];
        for (NSUInteger i = 0; i < cnt; ++i) {
            [_array addObject:objects[i]];
        }
    }
    return self;
}

- (NSUInteger)count
{
    __block NSUInteger count;
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_sync(_queue, ^{
            count = _array.count;
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            count = [_array count];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            count = [_array count];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
    return count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    __block id obj;
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_sync(_queue, ^{
            obj = _array[index];
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            obj = _array[index];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            obj = _array[index];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
    return obj;
}

- (id)firstObject {
    __block id obj;
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_sync(_queue, ^{
            obj = [_array firstObject];
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            obj = [_array firstObject];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            obj = [_array firstObject];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
    return obj;
}

- (NSArray *)popObjectsWithRange:(NSRange)range {
    __block NSArray *array = nil;
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_sync(_queue, ^{
            array = [_array subarrayWithRange:range];
            [_array removeObjectsInArray:array];
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            array = [_array subarrayWithRange:range];
            [_array removeObjectsInArray:array];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            array = [_array subarrayWithRange:range];
            [_array removeObjectsInArray:array];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
    return array;
}

- (NSEnumerator *)keyEnumerator
{
    __block NSEnumerator *enu;
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_sync(_queue, ^{
            enu = [_array objectEnumerator];
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            enu = [_array objectEnumerator];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            enu = [_array objectEnumerator];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
    return enu;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_barrier_async(_queue, ^{
            [_array insertObject:anObject atIndex:index];
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            [_array insertObject:anObject atIndex:index];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            [_array insertObject:anObject atIndex:index];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
}

- (void)addObject:(id)anObject;
{
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_barrier_async(_queue, ^{
            [_array addObject:anObject];
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            [_array addObject:anObject];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            [_array addObject:anObject];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
}

- (void)addObject:(id)anObject sortUsingComparator:(NSComparator)cmptr {
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_barrier_async(_queue, ^{
            [_array addObject:anObject];
            [_array sortUsingComparator:cmptr];
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            [_array addObject:anObject];
            [_array sortUsingComparator:cmptr];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            [_array addObject:anObject];
            [_array sortUsingComparator:cmptr];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_barrier_async(_queue, ^{
            [_array addObjectsFromArray:otherArray];
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            [_array addObjectsFromArray:otherArray];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            [_array addObjectsFromArray:otherArray];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
}

- (void)addObjectsFromArray:(NSArray *)otherArray sortUsingComparator:(NSComparator)cmptr {
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_barrier_async(_queue, ^{
            [_array addObjectsFromArray:otherArray];
            [_array sortUsingComparator:cmptr];
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            [_array addObjectsFromArray:otherArray];
            [_array sortUsingComparator:cmptr];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            [_array addObjectsFromArray:otherArray];
            [_array sortUsingComparator:cmptr];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
}

- (void)refillObjectsFromArray:(NSArray *)otherArray sortUsingComparator:(NSComparator)cmptr {
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_barrier_async(_queue, ^{
            [_array removeAllObjects];
            [_array addObjectsFromArray:otherArray];
            [_array sortUsingComparator:cmptr];
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            [_array removeAllObjects];
            [_array addObjectsFromArray:otherArray];
            [_array sortUsingComparator:cmptr];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            [_array removeAllObjects];
            [_array addObjectsFromArray:otherArray];
            [_array sortUsingComparator:cmptr];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_barrier_async(_queue, ^{
            [_array removeObjectAtIndex:index];
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            [_array removeObjectAtIndex:index];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            [_array removeObjectAtIndex:index];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
}

- (void)removeLastObject
{
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_barrier_async(_queue, ^{
            [_array removeLastObject];
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            [_array removeLastObject];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            [_array removeLastObject];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_barrier_async(_queue, ^{
            [_array replaceObjectAtIndex:index withObject:anObject];
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            [_array replaceObjectAtIndex:index withObject:anObject];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            [_array replaceObjectAtIndex:index withObject:anObject];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }
}

- (NSUInteger)indexOfObject:(id)anObject
{
    __block NSUInteger index = NSNotFound;
    if (![WDUTConfig instance].threadSafeUsingLock) {
        dispatch_sync(_queue, ^{
            for (int i = 0; i < [_array count]; i ++) {
                if ([_array objectAtIndex:i] == anObject) {
                    index = i;
                    break;
                }
            }
        });
    } else {
        if (WDUT_SYS_VERSION_GREATER_THAN(@"10.0")) {
            os_unfair_lock_lock(&_osUnfairLock);
            index = [_array indexOfObject:anObject];
            os_unfair_lock_unlock(&_osUnfairLock);
        } else {
            pthread_mutex_lock(&_safeThreadArrayMutex);
            index = [_array indexOfObject:anObject];
            pthread_mutex_unlock(&_safeThreadArrayMutex);
        }
    }

    return index;
}

- (void)dealloc
{
    if (_queue) {
        _queue = NULL;
    }
    pthread_mutex_destroy(&_safeThreadArrayMutex);
    pthread_mutexattr_destroy(&_safeThreadArrayMutexAttr);
}

@end
