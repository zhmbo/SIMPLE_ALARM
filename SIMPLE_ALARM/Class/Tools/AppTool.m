//
//  AppTool.m
//  六点一刻
//
//  Created by apple on 16/7/31.
//  Copyright © 2016年 zhangbao. All rights reserved.
//

#import "AppTool.h"

@implementation AppTool

+ (void)reloadHomeData
{
    UITableViewController *vc = (UITableViewController *)NSClassFromString(@"Home_VC");
    if (vc) {
        [vc.tableView reloadData];
    }
}

@end
