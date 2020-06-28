//
//  NSString+LogCategory.h
//  YunShixun
//
//  Created by chen on 2020/5/20.
//  Copyright © 2020 ying. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LogCategory)
+ (NSString * (^)(id))append;

- (NSString * (^)(id))append;

- (NSString * (^)(const char *))appendC;

+ (NSString *)objArrayToJSON:(NSArray *)array;

+ (NSString *)convertToJsonData:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
