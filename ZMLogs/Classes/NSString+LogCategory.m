//
//  NSString+LogCategory.m
//  YunShixun
//
//  Created by chen on 2020/5/20.
//  Copyright © 2020 ying. All rights reserved.
//

#import "NSString+LogCategory.h"

@implementation NSString (LogCategory)

+ (NSString * (^)(id))append {
    return ^(id msg){
        NSString *message = msg;
        if ([msg isKindOfClass: [NSArray class]] || [msg isKindOfClass:[NSMutableArray class]]) {
           message = [self objArrayToJSON:msg];
        }else if ([msg isKindOfClass: [NSDictionary class]] || [msg isKindOfClass: [NSMutableDictionary class]] ){
            message = [self convertToJsonData:msg];
        }
        
        return [NSString stringWithFormat:@"%@%@",self,message];
    };
}


CG_INLINE NSString *appendByC(const char *content){
    NSLog(@"%s",content);
    return [NSString stringWithFormat:@"%s",content];
}

- (NSString * (^)(const char *))appendC {
    return ^(const char *msg){
        NSString *message = appendByC(msg);
        return [NSString stringWithFormat:@"%@%@",self,message];
    };
}

- (NSString * (^)(id))append {
    return ^(id msg){
        NSString *message = msg;
        if ([msg isKindOfClass: [NSArray class]] || [msg isKindOfClass:[NSMutableArray class]]) {
           message = [NSString objArrayToJSON:msg];
        }else if ([msg isKindOfClass: [NSDictionary class]] || [msg isKindOfClass: [NSMutableDictionary class]] ){
            message = [ NSString convertToJsonData:msg];
        }
        
        return [NSString stringWithFormat:@"%@%@",self,message];
    };
}


+ (NSString *)objArrayToJSON:(NSArray *)array {

    NSString *jsonStr = @"[";
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:array[i]];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    return jsonStr;
}

+ (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
        if (!jsonData) {
            NSLog(@"%@",error);
        }else{
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
return mutStr;

}
@end
