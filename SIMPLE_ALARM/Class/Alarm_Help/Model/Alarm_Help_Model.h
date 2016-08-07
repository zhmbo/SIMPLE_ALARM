//
//  Alarm_Help_Model.h
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/23.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm_Help_Model : NSObject

@property (assign, nonatomic) int Id;
@property (strong, nonatomic) NSArray *weekDays;
@property (strong, nonatomic) NSString *hourString;
@property (strong, nonatomic) NSString *minString;
@property (strong, nonatomic) NSString *alertBody;
@property (strong, nonatomic) NSString *soundName;
@property (strong, nonatomic) NSString *userNotificationKey;
@property (assign, nonatomic) BOOL isOn;

@end
