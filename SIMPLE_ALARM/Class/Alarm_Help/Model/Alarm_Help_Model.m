//
//  Alarm_Help_Model.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/23.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import "Alarm_Help_Model.h"

@implementation Alarm_Help_Model

- (NSArray *)weekDays {
    if (!_weekDays) {
        self.weekDays = [[NSArray alloc] init];
    }
    return _weekDays;
}

@end
