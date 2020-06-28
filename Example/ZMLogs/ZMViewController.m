//
//  ZMViewController.m
//  ZMLogs
//
//  Created by uxmaicai on 05/28/2020.
//  Copyright (c) 2020 uxmaicai. All rights reserved.
//

#import "ZMViewController.h"
#import <YSXLogs.h>
#import <NSString+LogCategory.h>
@interface ZMViewController ()

@end
static NSString *_name = nil;
@implementation ZMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    YSXLogs.logLevelInfo(@"日志来了".append(@"eeee"),YSXLogTag_Httpapi);
    YSXLogs.logLevelInfo(@"日志来了".append(@"aaaa"),YSXLogTag_Httpapi);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)setName:(NSString *)name{
    _name = name;
}

+ (NSString *)name {
    
    return _name;
}

@end
