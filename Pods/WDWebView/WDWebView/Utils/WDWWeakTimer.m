//
// Created by 石恒智 on 2018/09/24.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//


#import "WDWWeakTimer.h"

#import <libkern/OSAtomic.h>

@interface WDWWeakTimer ()
{
    struct
    {
        uint32_t timerIsInvalidated;
    } _timerFlags;
}

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, assign) BOOL repeats;

@property (nonatomic, strong) dispatch_queue_t privateSerialQueue;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation WDWWeakTimer

@synthesize tolerance = _tolerance;

- (id)initWithTimeInterval:(NSTimeInterval)timeInterval
                    target:(id)target
                  selector:(SEL)selector
                  userInfo:(id)userInfo
                   repeats:(BOOL)repeats
             dispatchQueue:(dispatch_queue_t)dispatchQueue
{
    NSParameterAssert(target);
    NSParameterAssert(selector);
    NSParameterAssert(dispatchQueue);

    if ((self = [super init]))
    {
        self.timeInterval = timeInterval;
        self.target = target;
        self.selector = selector;
        self.userInfo = userInfo;
        self.repeats = repeats;

        NSString *privateQueueName = [NSString stringWithFormat:@"com.weidian.wdwweaktimer.%p", self];
        self.privateSerialQueue = dispatch_queue_create([privateQueueName cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(self.privateSerialQueue, dispatchQueue);

        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                            0,
                                            0,
                                            self.privateSerialQueue);
    }

    return self;
}

- (id)init
{
    return [self initWithTimeInterval:0
                               target:nil
                             selector:NULL
                             userInfo:nil
                              repeats:NO
                        dispatchQueue:nil];
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        target:(id)target
                                      selector:(SEL)selector
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)repeats
                                 dispatchQueue:(dispatch_queue_t)dispatchQueue
{
    WDWWeakTimer *timer = [[self alloc] initWithTimeInterval:timeInterval
                                                     target:target
                                                   selector:selector
                                                   userInfo:userInfo
                                                    repeats:repeats
                                              dispatchQueue:dispatchQueue];

    [timer schedule];

    return timer;
}

- (void)dealloc
{
    [self invalidate];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p> time_interval=%f target=%@ selector=%@ userInfo=%@ repeats=%d timer=%@",
            NSStringFromClass([self class]),
            self,
            self.timeInterval,
            self.target,
            NSStringFromSelector(self.selector),
            self.userInfo,
            self.repeats,
            self.timer];
}

#pragma mark -

- (void)setTolerance:(NSTimeInterval)tolerance
{
    @synchronized(self)
    {
        if (tolerance != _tolerance)
        {
            _tolerance = tolerance;

            [self resetTimerProperties];
        }
    }
}

- (NSTimeInterval)tolerance
{
    @synchronized(self)
    {
        return _tolerance;
    }
}

- (void)resetTimerProperties
{
    int64_t intervalInNanoseconds = (int64_t)(self.timeInterval * NSEC_PER_SEC);
    int64_t toleranceInNanoseconds = (int64_t)(self.tolerance * NSEC_PER_SEC);

    dispatch_source_set_timer(self.timer,
                              dispatch_time(DISPATCH_TIME_NOW, intervalInNanoseconds),
                              (uint64_t)intervalInNanoseconds,
                              toleranceInNanoseconds
                              );
}

- (void)schedule
{
    [self resetTimerProperties];

    __weak WDWWeakTimer *weakSelf = self;

    dispatch_source_set_event_handler(self.timer, ^{
        [weakSelf timerFired];
    });

    dispatch_resume(self.timer);
}

- (void)fire
{
    [self timerFired];
}

- (void)invalidate
{
    // We check with an atomic operation if it has already been invalidated. Ideally we would synchronize this on the private queue,
    // but since we can't know the context from which this method will be called, dispatch_sync might cause a deadlock.
    if (!OSAtomicTestAndSetBarrier(7, &_timerFlags.timerIsInvalidated))
    {
        dispatch_source_t timer = self.timer;
        dispatch_async(self.privateSerialQueue, ^{
            dispatch_source_cancel(timer);
        });
    }
}

- (void)timerFired
{
    // Checking attomatically if the timer has already been invalidated.
    if (OSAtomicAnd32OrigBarrier(1, &_timerFlags.timerIsInvalidated))
    {
        return;
    }

    // We're not worried about this warning because the selector we're calling doesn't return a +1 object.
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self];
    #pragma clang diagnostic pop

    if (!self.repeats)
    {
        [self invalidate];
    }
}

@end
