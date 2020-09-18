//
//  YSXLogs.m
//  YunShixun
//
//  Created by chen on 2020/5/19.
//  Copyright © 2020 chen. All rights reserved.
//

#import "YSXLogs.h"
#import "NSString+LogCategory.h"
#import <objc/message.h>
#import <objc/runtime.h>

#define LOG_ASYNC_ERROR    ( NO && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_WARN     (YES && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_INFO     (YES && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_DEBUG    (YES && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_VERBOSE  (YES && LOG_ASYNC_ENABLED)

#define LOG_FLAG_ERROR    DDLogFlagError
#define LOG_FLAG_WARN     DDLogFlagWarning
#define LOG_FLAG_INFO     DDLogFlagInfo
#define LOG_FLAG_DEBUG    DDLogFlagDebug
#define LOG_FLAG_VERBOSE  DDLogFlagVerbose

static BOOL _logDebug = nil;
static NSString *_addPwdClassName = nil;
static NSString *_addPwdClasmethod = nil;
static LogBlock _logBlock = nil;
@implementation YSXLogs

//@dynamic LogLevelDebug;

+ (void)load {
    YSXLogs.logDebug = NO;
}

+ (void)setLogDebug:(BOOL)logDebug{
    _logDebug = logDebug;
}

+ (BOOL)logDebug {
    return _logDebug;
}

+ (LogBlock)logBlock {
    return _logBlock;
}

+ (void)setLogBlock:(LogBlock)logBlock {
    _logBlock = logBlock;
}

+ (void)setAddPwdClassName:(NSString *)addPwdClassName {
    _addPwdClassName = addPwdClassName;
}

+ (void)setAddPwdClasmethod:(NSString *)addPwdClasmethod {
    _addPwdClasmethod = addPwdClasmethod;
}

+ (NSString *)addPwdClassName {
    return _addPwdClassName;
}

+ (NSString *)addPwdClasmethod {
    return _addPwdClasmethod;
}

/**
 LOG_ASYNC_VERBOSE 是否异步
 LOG_LEVEL_DEF 级别
 LOG_FLAG_VERBOSE flg
 0  ctx
 frmt 内容
 */
+ (void (^)(id,YSXLogStatus ,DDLogLevel))Log{
    return ^(id msg,YSXLogStatus tagValue,DDLogLevel level){
    
    NSArray *tagsName = @[@"httpapi",@"request",@"response",@"timeout",@"params",@"onclick",@"config",@"action",@"event",@"meeting",@"contact",@"im",@"filehead",@"info",@"toH5",@"toApp",@"noencrypt"];
      NSArray *tags = [YSXLogs getTags:tagValue];
        
        NSMutableString *tagStr = [[NSMutableString alloc] init];
        if (tags != nil) {
            for (int i = 0; i<tags.count; i++) {
                if (![tags[i] isKindOfClass:[NSNumber class]]) {
                    return;
                }
                NSInteger index = [tags[i] integerValue];
                if (index == 1) {
                    [tagStr appendString:[tagsName objectAtIndex:i]];
                    if (i == tags.count - 1) break;
                    [tagStr appendString:@","];
                }
            }
        }
        
        YSXLogs.LogAll(msg,tagStr,level);
    };
    
}

+ (void (^)(id,NSString *,DDLogLevel))LogAll{
    return ^(id msg,NSString *tagStr,DDLogLevel level){
        NSString *message = msg;
        if ([msg isKindOfClass: [NSArray class]] || [msg isKindOfClass:[NSMutableArray class]]) {
           message = [NSString objArrayToJSON:msg];
        }else if ([msg isKindOfClass: [NSDictionary class]] || [msg isKindOfClass: [NSMutableDictionary class]] ){
            message = [NSString convertToJsonData:msg];
        }
     
        DDLogFlag flgValue = LOG_FLAG_INFO;
        NSString *ler = @"I";
        
        BOOL isAsynchronous = YES;
        switch (level) {
            case DDLogLevelError:{
                isAsynchronous = LOG_ASYNC_ERROR;
                flgValue = LOG_FLAG_ERROR;
                ler = @"E";
            }
                break;
            case DDLogLevelWarning:{
                isAsynchronous = LOG_ASYNC_WARN;
                flgValue = LOG_FLAG_WARN;
                ler = @"W";
            }
                break;
            case DDLogLevelInfo:{
                isAsynchronous = LOG_ASYNC_INFO;
                flgValue = LOG_FLAG_INFO;
                ler = @"I";
            }
                break;
            case DDLogLevelDebug:{
                isAsynchronous = LOG_ASYNC_DEBUG;
                flgValue = LOG_FLAG_DEBUG;
                 ler = @"D";
            }
                break;
            case DDLogLevelVerbose:{
                isAsynchronous = LOG_ASYNC_VERBOSE;
                flgValue = LOG_FLAG_VERBOSE;
                 ler = @"I";
            }
                break;
                
            default:{
                
            }
                break;
        }
    
        NSString*str;
        // 加密
        if (_addPwdClassName.length>0 && _addPwdClasmethod.length>0) {
            if ([tagStr containsString:@"noencrypt"]) {
                 str = [NSString stringWithFormat:@"|%@|%@|%@",ler,tagStr,message];
            }else{
                NSString *string1 = [NSString stringWithFormat:@"%@|%@",tagStr,message];
                str = [NSString stringWithFormat:@"|%@|$%@",ler,[self getEncry:string1]];
            }
        }else{
            str = [NSString stringWithFormat:@"|%@|%@|%@",ler,tagStr,message];
        }

        if (self.logBlock) {
            self.logBlock(@[ler,tagStr,msg]);
        }
        
        [DDLog log:isAsynchronous level:LOG_LEVEL_DEF flag:flgValue context:0 file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ tag:0 format:(str),nil];
    };
}

//加密
+ (NSString *)getEncry:(NSString *)string{
    id class = NSClassFromString(self.addPwdClassName);
    SEL selector = NSSelectorFromString(self.addPwdClasmethod);
    IMP imp = [class methodForSelector:selector];
    id(*func)(id,SEL,NSString *) = (void *)imp;
    NSString * ret = func(class, @selector(encryptString:),string);
    return ret;
}

+ (NSString *)encryptString:(NSString *)string{
    return @"";
}

+ (void)LogsInfo:(void(^)(NSArray *))logBlock {
    self.logBlock = logBlock;
}

+ (NSArray *)getTags:(NSInteger)value{
    
    NSMutableArray *arr = [NSMutableArray array];
        while (value>0) {
            if ((value&1) == 1) {
                [arr addObject:@1];
            }else{
                 [arr addObject:@0];
            }
             value>>=1;
        }
    return arr;
}

+ (void)log:(NSString *)msg tags:(NSString *)tagString level:(DDLogLevel)level{
    YSXLogs.LogAll(msg,tagString,level);
}

+ (void)log:(NSString *)msg tagType:(YSXLogStatus )tags level:(DDLogLevel)level{
    YSXLogs.Log(msg,tags,level);
}

+ (void)logLevelError:(NSString *)msg tags:(NSString *)tagString {
    YSXLogs.LogAll(msg,tagString,DDLogLevelError);
}

+ (void)logLevelError:(NSString *)msg tagType:(YSXLogStatus)tags {
    YSXLogs.Log(msg,tags,DDLogLevelError);
}

+ (void)logLevelInfo:(NSString *)msg tags:(NSString *)tagString {
    YSXLogs.LogAll(msg,tagString,DDLogLevelInfo);
}

+ (void)logLevelInfo:(NSString *)msg tagType:(YSXLogStatus)tags {
    YSXLogs.Log(msg,tags,DDLogLevelInfo);
}

+ (void)logLevelDebug:(NSString *)msg tags:(NSString *)tagString {
    YSXLogs.LogAll(msg,tagString,DDLogLevelDebug);
}

+ (void)logLevelDebug:(NSString *)msg tagType:(YSXLogStatus)tags {
    YSXLogs.Log(msg,tags,DDLogLevelDebug);
}

+ (void)logLevelWarning:(NSString *)msg tags:(NSString *)tagString {
    YSXLogs.LogAll(msg,tagString,DDLogLevelWarning);
}

+ (void)logLevelWarning:(NSString *)msg tagType:(YSXLogStatus)tags {
    YSXLogs.Log(msg,tags,DDLogLevelWarning);
}

+ (void)logLevelVerbose:(NSString *)msg tags:(NSString *)tagString {
    YSXLogs.LogAll(msg,tagString,DDLogLevelVerbose);
}

+ (void)logLevelVerbose:(NSString *)msg tagType:(YSXLogStatus)tags {
    YSXLogs.Log(msg,tags,DDLogLevelVerbose);
}

+ (void (^)(id,YSXLogStatus))logLevelError{
    return ^(id msg,YSXLogStatus tagValue){
        YSXLogs.Log(msg,tagValue,DDLogLevelError);
    };
}

+ (void (^)(id,YSXLogStatus))logLevelInfo{
    return ^(id msg,YSXLogStatus tagValue){
        YSXLogs.Log(msg,tagValue,DDLogLevelInfo);
    };
}

+ (void (^)(id,YSXLogStatus))logLevelWarning{
    return ^(id msg,YSXLogStatus tagValue){
        YSXLogs.Log(msg,tagValue,DDLogLevelWarning);
    };
}

+ (void (^)(id,YSXLogStatus))logLevelVerbose{
    return ^(id msg,YSXLogStatus tagValue){
        YSXLogs.Log(msg,tagValue,DDLogLevelVerbose);
    };
}

+ (void (^)(id,YSXLogStatus))logLevelDebug{
    return ^(id msg,YSXLogStatus tagValue){
        YSXLogs.Log(msg,tagValue,DDLogLevelDebug);
    };
}

+ (void)log:(NSString *)msg tags:(NSString *)tagString levelString:(NSString *)levelStr{
    NSArray *tagsNames = @[@"I",@"E",@"W",@"I",@"D",@"I"];
    NSAssert([tagsNames containsObject:levelStr], @"levelStr is not level");
    NSInteger index = 0;
    if (![levelStr isEqualToString:@"I"]) {
        index = [tagsNames indexOfObject:levelStr];
    }
    [YSXLogs log:msg tags:tagString level:index];
}

@end
