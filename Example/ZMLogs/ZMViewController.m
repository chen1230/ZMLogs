//
//  ZMViewController.m
//  ZMLogs
//
//  Created by uxmaicai on 05/28/2020.
//  Copyright (c) 2020 uxmaicai. All rights reserved.
//

#import "ZMViewController.h"

@interface ZMViewController ()

@end

@implementation ZMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    YSXLogs.logLevelInfo(@"日志来了",YSXLogTag_Httpapi);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
