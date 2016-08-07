//
//  Add_Alarm_Seting.h
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/26.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Alarm_Help_Model;
@interface Add_Alarm_Seting : NSObject

@property (assign, nonatomic) int Id;
@property (strong, nonatomic) NSMutableArray *weekDays;
@property (strong, nonatomic) NSString *hour;
@property (strong, nonatomic) NSString *minute;
@property (strong, nonatomic) NSString *alertBody;
@property (assign, nonatomic) int soundIndex;
@property (nonatomic, strong) Alarm_Help_Model *model;

+ (Add_Alarm_Seting *)sharedAddAlarmSeting;

+ (void)destroyDealloc;

@end
