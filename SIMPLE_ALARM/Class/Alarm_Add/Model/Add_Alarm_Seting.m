//
//  Add_Alarm_Seting.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/26.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import "Add_Alarm_Seting.h"
#import "Alarm_Help_Model.h"

@interface Add_Alarm_Seting()

@property (assign, nonatomic) NSInteger unitFlags;

@end

@implementation Add_Alarm_Seting

+ (Add_Alarm_Seting *)sharedAddAlarmSeting
{
    static Add_Alarm_Seting *add_alarm_seting = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        add_alarm_seting = [[self alloc] init];
    });
    return add_alarm_seting;
}

- (NSMutableArray *)weekDays {
    if (!_weekDays) {
        self.weekDays = [[NSMutableArray alloc] init];
    }
    return _weekDays;
}

- (NSString *)hour {
    
    if (!_hour) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [gregorian components:self.unitFlags fromDate:[NSDate date]];
        
        NSString  *tempString = nil;
        if ([comps hour] < 10) tempString = [NSString stringWithFormat:@"0%d", (int)[comps hour]];
        else tempString = [NSString stringWithFormat:@"%d", (int)[comps hour]];
        
        self.hour = tempString;
    }
    
    return _hour;
}

- (NSString *)minute
{
    if (!_minute) {
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [gregorian components:self.unitFlags fromDate:[NSDate date]];
        
        NSString  *tempString = nil;
        if ([comps minute] < 10) tempString = [NSString stringWithFormat:@"0%d", (int)[comps minute]];
        else tempString = [NSString stringWithFormat:@"%d", (int)[comps minute]];
        
        self.minute = tempString;
    }
    
    return _minute;
}

- (NSString *)alertBody {
    if (!_alertBody) {
        self.alertBody = @"闹铃";
    }
    return _alertBody;
}

- (NSInteger)unitFlags {
    if (!_unitFlags) {
        self.unitFlags = NSCalendarUnitEra |
        NSCalendarUnitYear |
        NSCalendarUnitMonth |
        NSCalendarUnitDay |
        NSCalendarUnitHour |
        NSCalendarUnitMinute |
        NSCalendarUnitSecond |
        NSWeekCalendarUnit |
        NSCalendarUnitWeekday |
        NSCalendarUnitWeekdayOrdinal |
        NSCalendarUnitQuarter;
    }
    return _unitFlags;
}

- (void)setModel:(Alarm_Help_Model *)model
{
    _model = model;
    [Add_Alarm_Seting sharedAddAlarmSeting].Id = model.Id;
    [Add_Alarm_Seting sharedAddAlarmSeting].hour = model.hourString;
    [Add_Alarm_Seting sharedAddAlarmSeting].minute = model.minString;
    [Add_Alarm_Seting sharedAddAlarmSeting].weekDays =  [[NSMutableArray alloc] initWithArray:model.weekDays];
    [Add_Alarm_Seting sharedAddAlarmSeting].alertBody = model.alertBody;
    [Add_Alarm_Seting sharedAddAlarmSeting].soundIndex = (int)[ALARMSOUNDNAMES indexOfObject:model.soundName];
}

+ (void)destroyDealloc
{
    [Add_Alarm_Seting sharedAddAlarmSeting].Id = -1;
    [[Add_Alarm_Seting sharedAddAlarmSeting].weekDays removeAllObjects];
    [Add_Alarm_Seting sharedAddAlarmSeting].hour = nil;
    [Add_Alarm_Seting sharedAddAlarmSeting].minute = nil;
    [Add_Alarm_Seting sharedAddAlarmSeting].alertBody = nil;
    [Add_Alarm_Seting sharedAddAlarmSeting].soundIndex = 0;
}

@end
