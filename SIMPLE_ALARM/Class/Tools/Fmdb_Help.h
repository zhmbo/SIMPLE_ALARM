//
//  Fmdb_Help.h
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/24.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Alarm_Help_Model;
@interface Fmdb_Help : NSObject

+ (Fmdb_Help *)sharedFmdb;

- (BOOL)open;

- (BOOL)createTable;

- (BOOL)insertIntoWithWeekDays:(NSArray *)weekDays hour:(NSString *)hour min:(NSString *)min body:(NSString *)body soundName:(NSString *)soundName userNotificationKey:(NSString *)userNotificationKey isOn:(BOOL)isOn;

- (int)maxId;

- (NSMutableArray *)alarms;

- (BOOL)deleteAlarmWithId:(int)Id;

- (BOOL)upDataAlarmIsOn:(BOOL)ison id:(int)Id;

- (BOOL)upDataAlarmAllDataWithModel:(Alarm_Help_Model *)model;

- (Alarm_Help_Model *)alarmModelWhere:(NSString *)where WithId:(id)Id;
@end
