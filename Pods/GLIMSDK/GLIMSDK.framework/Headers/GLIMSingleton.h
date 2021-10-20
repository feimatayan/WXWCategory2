//
//  GLIMSingleton.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/15.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#ifndef GLIMSingleton_h
#define GLIMSingleton_h

#define GLIMSINGLETON_HEADER(_classname_) \
+ (_Nonnull instancetype)sharedInstance;\

#if __has_feature(objc_arc)//ARC 不实现release、retainCount等方法


#define GLIMSINGLETON_IMPLEMENTATION(_classname_) \
\
static _classname_ *sharedInstance_ = nil; \
\
+ (_classname_ *)sharedInstance \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedInstance_ = [[self alloc] init]; \
}); \
\
return sharedInstance_; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (sharedInstance_ == nil) \
{ \
sharedInstance_ = [super allocWithZone:zone]; \
return sharedInstance_; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \

#else

#define GLIMSINGLETON_IMPLEMENTATION(_classname_) \
\
static _classname_ *sharedInstance_ = nil; \
\
+ (_classname_ *)sharedInstance \
{ \
@synchronized(self) \
{ \
if (sharedInstance_ == nil) \
{ \
sharedInstance_ = [[self alloc] init]; \
} \
} \
\
return sharedInstance_; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (sharedInstance_ == nil) \
{ \
sharedInstance_ = [super allocWithZone:zone]; \
return sharedInstance_; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\
- (id)retain \
{ \
return self; \
} \
\
- (NSUInteger)retainCount \
{ \
return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
return self; \
}\

#endif // __has_feature(objc_arc)

#endif /* GLIMSingleton_h */
