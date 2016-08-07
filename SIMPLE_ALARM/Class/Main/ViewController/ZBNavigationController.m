//
//  ZBNavigationController.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/19.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import "ZBNavigationController.h"

@interface ZBNavigationController ()

@end

@implementation ZBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.tintColor = ALARMTHEMERED;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
}


@end
