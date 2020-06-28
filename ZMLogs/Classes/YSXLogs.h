//
//  YSXLogs.h
//  YunShixun
//
//  Created by chen on 2020/5/19.
//  Copyright © 2020 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "NSString+LogCategory.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,YSXLogStatus) {
    YSXLogTag_Httpapi   = 1 << 0,
    YSXLogTag_Request   = 1 << 1,
    YSXLogTag_Response  = 1 << 2,
    YSXLogTag_Timeout   = 1 << 3,
    YSXLogTag_Params    = 1 << 4,
    YSXLogTag_Onclick   = 1 << 5,
    YSXLogTag_Config    = 1 << 6,
    YSXLogTag_Action    = 1 << 7,
    YSXLogTag_Event     = 1 << 8,
    YSXLogTag_Meeting   = 1 << 9,
    YSXLogTag_Contact   = 1 << 10,
    YSXLogTag_Im        = 1 << 11,
    YSXLogTag_Filehead  = 1 << 12,
};


#define YSXDebugLog(frmt,...) DDLogDebug(frmt, ##__VA_ARGS__)
#define YSXWarnLog(frmt,...) DDLogWarn(frmt, ##__VA_ARGS__)
#define YSXInfoLog(frmt,...) DDLogInfo(frmt, ##__VA_ARGS__)


typedef void(^LogBlock)(NSArray *logArray);

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

@interface YSXLogs : NSObject

@property (nonatomic,class,assign) BOOL logDebug;

@property (nonatomic,class,copy) LogBlock logBlock;

+ (void)LogsInfo:(void(^)(NSArray *))logBlock;

+ (void (^)(id,YSXLogStatus))logLevelError;

+ (void (^)(id,YSXLogStatus))logLevelInfo;

+ (void (^)(id,YSXLogStatus))logLevelWarning;

+ (void (^)(id,YSXLogStatus))logLevelVerbose;

+ (void (^)(id,YSXLogStatus))logLevelDebug;

+ (void (^)(id,YSXLogStatus ,DDLogLevel))Log;

+ (void (^)(id,NSString *,DDLogLevel))LogAll;

+ (void)log:(NSString *)msg tags:(NSString *)tagString level:(DDLogLevel)level;

+ (void)log:(NSString *)msg tagType:(YSXLogStatus )tags level:(DDLogLevel)level;

+ (void)logLevelError:(NSString *)msg tags:(NSString *)tagString;

+ (void)logLevelError:(NSString *)msg tagType:(YSXLogStatus)tags;

+ (void)logLevelInfo:(NSString *)msg tags:(NSString *)tagString;

+ (void)logLevelInfo:(NSString *)msg tagType:(YSXLogStatus)tags;

+ (void)logLevelDebug:(NSString *)msg tags:(NSString *)tagString;

+ (void)logLevelDebug:(NSString *)msg tagType:(YSXLogStatus)tags;

+ (void)logLevelWarning:(NSString *)msg tags:(NSString *)tagString;

+ (void)logLevelWarning:(NSString *)msg tagType:(YSXLogStatus)tags;

+ (void)logLevelVerbose:(NSString *)msg tags:(NSString *)tagString;

+ (void)logLevelVerbose:(NSString *)msg tagType:(YSXLogStatus)tags;

+ (void)log:(NSString *)msg tags:(NSString *)tagString levelString:(NSString *)levelStr;

@end

NS_ASSUME_NONNULL_END
