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
    if ([NSStringFromClass([[AppTool getCurrentVC] class]) isEqualToString:@"HOME_VC"]) {
        UITableViewController *tvc = (UITableViewController *)[AppTool getCurrentVC];
        [tvc.tableView reloadData];
    }
}
+ (UIViewController *)getCurrentVC {
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    if (!window) {
        return nil;
    }
    UIView *tempView;
    for (UIView *subview in window.subviews) {
        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
            tempView = subview;
            break;
        }
    }
    if (!tempView) {
        tempView = [window.subviews lastObject];
    }
    
    id nextResponder = [tempView nextResponder];
    while (![nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UITabBarController class]]) {
        tempView =  [tempView.subviews firstObject];
        
        if (!tempView) {
            return nil;
        }
        nextResponder = [tempView nextResponder];
    }
    return  (UIViewController *)nextResponder;
}

@end
