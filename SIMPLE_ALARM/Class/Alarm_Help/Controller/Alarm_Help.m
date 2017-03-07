//
//  Alarm_Help.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/23.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import "Alarm_Help.h"
#import "Alarm_Help_Model.h"
#import "Fmdb_Help.h"

@interface Alarm_Help()
@property (strong, nonatomic) NSCalendar *gregorian;
@end

@implementation Alarm_Help
- (NSCalendar *)gregorian {
    if (!_gregorian) {
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _gregorian;
}

#pragma mark - 公共方法
+ (Alarm_Help *)sharedAlarm
{
    static Alarm_Help *alarm_help = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alarm_help = [[self alloc] init];
    });
    return alarm_help;
}

// 创建闹铃(计算处理时间)
- (void)createAlarmWithModel:(Alarm_Help_Model *)model
{
    NSArray *weekDays = model.weekDays;
    int hour = [model.hourString intValue];
    int min = [model.minString intValue];
    NSString *body = model.alertBody;
    NSString *soundName = model.soundName;
    
    // 当前星期几
    NSDateComponents *comps = [self componentsWithDate:[NSDate date]];
    int currentWeekDay = (int)comps.weekday;
    int currentHour = (int)comps.hour;
    int currentMin = (int)comps.minute;
    [comps setHour:hour];
    [comps setMinute:min];
    [comps setSecond:0];
    
    int tempDay = 0;
    int day = 0;
    
    int currentTotal = currentHour * 3600 + currentMin * 60;
    int alarmTotal = hour * 3600 + min * 60;
    
    // 通知标示(拼接id)
    NSString *userNotificationKey = nil;
    NSDate *fireDate = nil;
    
    if (weekDays.count > 0 && weekDays.count < 7) {
        
        userNotificationKey = [NSString stringWithFormat:@"%@%d", KAlarmLocalNotificationKey, [[Fmdb_Help sharedFmdb] maxId] + 1];
        
        for (int i = 0; i < weekDays.count; i++) {
            
            if ([weekDays[i] intValue] == currentWeekDay && alarmTotal > currentTotal) {
                
                tempDay = [weekDays[i] intValue];
                break;
                
            }else if([weekDays[i] integerValue] > currentWeekDay) {
                
                tempDay = [weekDays[i] intValue];
                break;
                
            }
            
        }
        
        if (tempDay == 0) {
            
            tempDay = [weekDays[0] intValue];
            
        }
        
        tempDay = tempDay - currentWeekDay;
        day = (tempDay > 0 ? tempDay : tempDay + 7);
        
        if (tempDay == 0) {
            
            if (alarmTotal - currentTotal >= 0) {
                
                day = 0;
                
            }else {
                
                day = 7;
                
            }
            
        }
        
    } else if (weekDays.count == 7) {
        
        userNotificationKey = [NSString stringWithFormat:@"%@%d", KAlarmLocalNotificationKeyEveryDay, [[Fmdb_Help sharedFmdb] maxId] + 1];
        day = alarmTotal > currentTotal ? 0 : 1;
        
    } else if(weekDays.count == 0) {
        
        userNotificationKey = [NSString stringWithFormat:@"%@%d",KAlarmLocalNotificationKeyNotRepeat,[[Fmdb_Help sharedFmdb] maxId] + 1];
        day = alarmTotal > currentTotal ? 0 : 1;
        
    }
    
    fireDate = [[self.gregorian dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * day];
    [self setNitficationWithFireDate:fireDate
                                Body:body
                          soundName:soundName
                 userNotificationKey:userNotificationKey];
    
    
    // 储存
    // 双位数显示
    NSString *tempHour = nil;
    if (hour < 10) tempHour = [NSString stringWithFormat:@"0%i", hour];
    else tempHour = [NSString stringWithFormat:@"%i", hour];
    
    NSString *tempMin = nil;
    if (min < 10) tempMin = [NSString stringWithFormat:@"0%i", min];
    else tempMin = [NSString stringWithFormat:@"%i", min];
    
    [[Fmdb_Help sharedFmdb] insertIntoWithWeekDays:weekDays
                                              hour:tempHour
                                               min:tempMin
                                              body:body
                                         soundName:soundName
                               userNotificationKey:userNotificationKey
                                              isOn:YES];
    
}

// 删除
- (BOOL)deleteAlarmWithId:(int)Id
{
    Alarm_Help_Model *model = [[Fmdb_Help sharedFmdb] alarmModelWhere:@"id" WithId:@(Id)];
    [self cancelAlarmWithUserNotificationKey:model.userNotificationKey];
    BOOL result = [[Fmdb_Help sharedFmdb] deleteAlarmWithId:Id];
    return result;
}

// 暂停当前通知
- (void)suspendAlarmWithNotification:(UILocalNotification *)notification
{
    [self cancelAlarmWithUserNotificationKey:notification.userInfo[@"key"]];
    
    int day = 0;
    if (([notification.userInfo[@"key"] rangeOfString:KAlarmLocalNotificationKeyNotRepeat].location != NSNotFound)) { // 不重复
        
        int Id = [self idWithNotificationKey:KAlarmLocalNotificationKeyNotRepeat notification:notification];
        [[Fmdb_Help sharedFmdb] upDataAlarmIsOn:NO id:Id];
        return;
        
    } else if ([notification.userInfo[@"key"] isEqualToString:KAlarmLocalNotificationKeyOfSmallSleep]) { // 小睡
        
        return;
        
    } else if (([notification.userInfo[@"key"] rangeOfString:KAlarmLocalNotificationKeyEveryDay].location != NSNotFound)) { // 每天
        
        day = 1;
        
    } else { // 0 < week < 7
        
        int Id = [self idWithNotificationKey:KAlarmLocalNotificationKey notification:notification];
        Alarm_Help_Model *model = [[Fmdb_Help sharedFmdb] alarmModelWhere:@"id" WithId:@(Id)];
        
        NSDateComponents *comps = [self componentsWithDate:notification.fireDate];
        int currentWeekDay = (int)comps.weekday;
        
        int index = (int)[model.weekDays indexOfObject:@(currentWeekDay)];
        
        int tempDay = [[model.weekDays objectAtIndex:((index + 1) % model.weekDays.count)] intValue];
        
        tempDay = tempDay - currentWeekDay;
        day = (tempDay >= 0 ? tempDay : tempDay + 7);
        
        if (model.weekDays.count == 1) {
            
            day = 7;
            
        }
    }
    
    NSDate *fireDate = [notification.fireDate dateByAddingTimeInterval:3600 * 24 * day];
    [self setNitficationWithFireDate:fireDate
                                Body:notification.alertBody
                          soundName:notification.soundName
                 userNotificationKey:notification.userInfo[@"key"]];
}

// 关闭当前通知
- (void)closeAlarmWithId:(int)Id
{
    [[Fmdb_Help sharedFmdb] upDataAlarmIsOn:NO id:Id];
    
    Alarm_Help_Model *model = [[Fmdb_Help sharedFmdb] alarmModelWhere:@"id" WithId:@(Id)];
    [self cancelAlarmWithUserNotificationKey:model.userNotificationKey];
}

// 打开当前已关闭的通知
- (void)openAlarmWithId:(int)Id
{
    [[Fmdb_Help sharedFmdb] upDataAlarmIsOn:YES id:Id];
    
    Alarm_Help_Model *model = [[Fmdb_Help sharedFmdb] alarmModelWhere:@"id" WithId:@(Id)];
    
    [self sendNotification:model];
}

// 编辑已经创建的通知
- (void)editAlarmWithModel:(Alarm_Help_Model *)model
{
    [self cancelAlarmWithUserNotificationKey:model.userNotificationKey];
    
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    int remainSecond =[[model.userNotificationKey stringByTrimmingCharactersInSet:nonDigits] intValue];

    NSString *userNotificationKey = nil;
    
    if (model.weekDays.count > 0 && model.weekDays.count < 7) {
        
        userNotificationKey = [NSString stringWithFormat:@"%@%d", KAlarmLocalNotificationKey, remainSecond];
        
    } else if (model.weekDays.count == 7) {
        
        userNotificationKey = [NSString stringWithFormat:@"%@%d", KAlarmLocalNotificationKeyEveryDay, remainSecond];
        
    } else if(model.weekDays.count == 0) {
        
        userNotificationKey = [NSString stringWithFormat:@"%@%d",KAlarmLocalNotificationKeyNotRepeat, remainSecond];
        
    }
    
    model.userNotificationKey = userNotificationKey;
    
    [[Fmdb_Help sharedFmdb] upDataAlarmAllDataWithModel:model];
    
    [self sendNotification:model];
}

// 创建小睡
- (void)createAlarmSmallSleepMinute:(int)min Notification:(UILocalNotification *)notification
{
    [self suspendAlarmWithNotification:notification];
    
    NSDateComponents *comps = [self componentsWithDate:[NSDate date]];
    NSDate *fireDate = [[self.gregorian dateFromComponents:comps] dateByAddingTimeInterval:60*min];
    
    [self setNitficationWithFireDate:fireDate
                                Body:notification.alertBody
                           soundName:notification.soundName
                 userNotificationKey:KAlarmLocalNotificationKeyOfSmallSleep];
}

#pragma mark - 私有方法
// 设置本地通知
/** 初始化本地通知对象 */
- (void)setNitficationWithFireDate:(NSDate *)fireDate
                              Body:(NSString *)body
                         soundName:(NSString *)soundName
               userNotificationKey:(NSString *)userNotificationKey
{
    NSDate *_30sfireDate = [fireDate dateByAddingTimeInterval:30];
    
    UILocalNotification *_MainNotification = [[UILocalNotification alloc] init];
    UILocalNotification *_30sNotification = [[UILocalNotification alloc] init];
    
//    NSDateComponents *comps = [self componentsWithDate:fireDate];
//    int hour = (int)comps.hour;
//    int min = (int)comps.minute;
    
    // 响应时间
    _MainNotification.fireDate = fireDate;
    _30sNotification.fireDate = _30sfireDate;
    // 时区
    _MainNotification.timeZone = _30sNotification.timeZone = [NSTimeZone defaultTimeZone];
    // 通知内容(30s的notification不设置，不让他弹窗)
    _MainNotification.alertBody = _30sNotification.alertBody = body;
    _MainNotification.alertAction = _30sNotification.alertAction = NSLocalizedString(body, nil);
    //    notification.hasAction = YES;
//    _MainNotification.alertTitle = _30sNotification.alertTitle = @"简单闹铃";
    // 通知被触发时播放的声音
    _MainNotification.soundName = _30sNotification.soundName = soundName;
    // 设置重复的间隔
    _MainNotification.repeatInterval = _30sNotification.repeatInterval = NSCalendarUnitMinute;
//    _MainNotification.applicationIconBadgeNumber = _30sNotification.applicationIconBadgeNumber = hour*100 + min;
    _MainNotification.applicationIconBadgeNumber = _30sNotification.applicationIconBadgeNumber = 1;
    // 通知参数
    _MainNotification.userInfo = _30sNotification.userInfo = @{@"key":userNotificationKey};
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:_MainNotification];
    [[UIApplication sharedApplication] scheduleLocalNotification:_30sNotification];
}

// 取消
- (void)cancelAlarmWithUserNotificationKey:(NSString *)userNotificationKey {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[@"key"];
            // 如果找到需要取消的通知，则取消
            if ([info isEqualToString:userNotificationKey]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
}

// 发送以创建的通知(暂停丶编辑)
- (void)sendNotification:(Alarm_Help_Model *)model
{
    int hour = [model.hourString intValue];
    int min = [model.minString intValue];
    NSArray *weekDays = model.weekDays;
    NSString *body = model.alertBody;
    NSString *soundName = model.soundName;
    NSString *userNotificationKey = model.userNotificationKey;
    
    // 当前星期几
    NSDateComponents *comps = [self componentsWithDate:[NSDate date]];
    int currentWeekDay = (int)comps.weekday;
    int currentHour = (int)comps.hour;
    int currentMin = (int)comps.minute;
    [comps setHour:hour];
    [comps setMinute:min];
    [comps setSecond:0];
    
    int tempDay = 0;
    int day = 0;
    
    int currentTotal = currentHour * 3600 + currentMin * 60;
    int alarmTotal = hour * 3600 + min * 60;
    
    if (weekDays.count > 0 && weekDays.count < 7) {
        
        for (int i = 0; i < weekDays.count; i++) {
            
            if ([weekDays[i] intValue] == currentWeekDay && alarmTotal > currentTotal) {
                
                tempDay = [weekDays[i] intValue];
                break;
                
            }else if([weekDays[i] integerValue] > currentWeekDay) {
                
                tempDay = [weekDays[i] intValue];
                break;
                
            }
        }
        
        if (tempDay == 0) {
            tempDay = [weekDays[0] intValue];
        }
        tempDay = tempDay - currentWeekDay;
        day = (tempDay > 0 ? tempDay : tempDay + 7);
        
        if (tempDay == 0) {
            if (alarmTotal - currentTotal >= 0) {
                
                day = 0;
                
            }else {
                
                day = 7;
                
            }
        }
        
        NSDate *fireDate = [[self.gregorian dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * day];
        
        // 初始化本地通知对象
        [self setNitficationWithFireDate:fireDate
                                    Body:body
                               soundName:soundName
                     userNotificationKey:userNotificationKey];
        
        
    } else {
        
        day = alarmTotal > currentTotal ? 0 : 1;
        NSDate *fireDate = [[self.gregorian dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * day];
        [self setNitficationWithFireDate:fireDate
                                    Body:body
                               soundName:soundName
                     userNotificationKey:userNotificationKey];
    }

}

- (NSDateComponents *)componentsWithDate:(NSDate *)date
{
    NSInteger unitFlags = NSCalendarUnitEra |
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
    
    NSDateComponents *comps = [self.gregorian components:unitFlags fromDate:date];
    
    return comps;
}

- (int)idWithNotificationKey:(NSString *)key notification:(UILocalNotification *)notification
{
    NSUInteger keyLength = key.length;
    NSString *keyString = notification.userInfo[@"key"];
    NSString *idString = [keyString substringWithRange:NSMakeRange(keyLength, keyString.length - keyLength)];
    return [idString intValue];
}

@end
