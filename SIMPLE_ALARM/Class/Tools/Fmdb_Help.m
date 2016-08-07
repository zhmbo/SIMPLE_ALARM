//
//  Fmdb_Help.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/24.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import "Fmdb_Help.h"
#import "FMDB.h"
#import "Alarm_Help_Model.h"
#import "JSONKit.h"

@interface Fmdb_Help()

@property (strong, nonatomic) FMDatabase *db;

@end

@implementation Fmdb_Help
{
    NSMutableArray *_alarms;
}

- (FMDatabase *)db {
    if (!_db) {
        self.db = [FMDatabase databaseWithPath:ALARMDOCUMENTPATH];
    }
    return _db;
}

+ (Fmdb_Help *)sharedFmdb
{
    static Fmdb_Help *fmdb_help;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmdb_help = [[self alloc] init];
    });
    return fmdb_help;
}

- (BOOL)open
{
    if (![self.db open]) {
        DLog(@"Could not open db.");
        return NO;
    }else {
        DLog(@"success open db.");
    }
    return YES;
}

- (BOOL)createTable
{
    //4.创表
    BOOL result = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_alarm (id integer PRIMARY KEY AUTOINCREMENT,weekDays text NOT NULL, hourString text NOT NULL, minString text NOT NULL, alertBody text NOT NULL, soundName text NOT NULL, userNotificationKey text NOT NULL, isOn integer NOT NULL);"];
    if (result) {
        DLog(@"success create table.");
        return YES;
    }else{
        DLog(@"Could not create table");
        return NO;
    }
}

- (BOOL)insertIntoWithWeekDays:(NSArray *)weekDays hour:(NSString *)hour min:(NSString *)min body:(NSString *)body soundName:(NSString *)soundName userNotificationKey:(NSString *)userNotificationKey isOn:(BOOL)isOn
{
    NSString *weekDaysString = [self stringWithArray:weekDays];
    
    NSString *insertString = [NSString stringWithFormat:@"INSERT INTO t_alarm (weekDays, hourString, minString, alertBody, soundName, userNotificationKey, isOn) VALUES ('%@','%@','%@','%@','%@','%@',%d);",weekDaysString, hour, min, body, soundName, userNotificationKey, isOn];
    BOOL result =[self.db executeUpdate:insertString];
    if (result) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:[userDefaults integerForKey:@"t_alarm_id"]+1 forKey:@"t_alarm_id"];
        DLog(@"success insert id = %lu", [userDefaults integerForKey:@"t_alarm_id"]);
        
        return YES;
    }else{
        DLog(@"could not insert");
        return NO;
    }
}

- (BOOL)deleteAlarmWithId:(int)Id
{
    NSString *deleteString = [NSString stringWithFormat:@"DELETE FROM t_alarm WHERE id = %d;", Id];
    BOOL result = [self.db executeUpdate:deleteString];
    if (result) {
        DLog(@"success delete where id = %d", Id);
        return YES;
    }else {
        DLog(@"could not delete where id = %d", Id);
        return NO;
    }
}

- (BOOL)upDataAlarmIsOn:(BOOL)ison id:(int)Id
{
    NSString *upDataString = [NSString stringWithFormat:@"UPDATE t_alarm SET isOn = %d WHERE id = %d", ison ,Id];
    BOOL result = [self.db executeUpdate:upDataString];
    if (result) {
        DLog(@"success update set ison = %d where id = %d", ison, Id);
        return YES;
    }else {
        DLog(@"could not update ison whrer id = %d", Id);
        return NO;
    }
}

- (BOOL)upDataAlarmAllDataWithModel:(Alarm_Help_Model *)model
{
    NSString *weekDaysString = [self stringWithArray:model.weekDays];
    
     NSString *upDataString = [NSString stringWithFormat:@"UPDATE t_alarm SET weekDays = '%@', hourString = '%@', minString = '%@', alertBody = '%@', soundName = '%@', userNotificationKey = '%@', isOn = %d WHERE id = %d", weekDaysString, model.hourString, model.minString, model.alertBody, model.soundName, model.userNotificationKey, model.isOn, model.Id];
    BOOL result = [self.db executeUpdate:upDataString];
    if (result) {
        DLog(@"success update all where id = %d", model.Id);
        return YES;
    }else {
        DLog(@"could not update all whrer id = %d", model.Id);
        return NO;
    }
    return YES;
}

- (int)maxId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int maxId = (int)[userDefaults integerForKey:@"t_alarm_id"];
    return maxId;
}

- (NSMutableArray *)alarms
{
    _alarms = nil;
    _alarms = [NSMutableArray array];
    FMResultSet *set = [self.db executeQuery:@"SELECT * FROM t_alarm"];
    // 遍历结果集
    while ([set next]) {
        Alarm_Help_Model *model = [[Alarm_Help_Model alloc] init];
        model.Id = [set intForColumn:@"id"];
        NSString *weekDaysString = [set stringForColumn:@"weekDays"];
        model.weekDays =(NSArray *)[weekDaysString objectFromJSONString];
        model.hourString = [set stringForColumn:@"hourString"];
        model.minString = [set stringForColumn:@"minString"];
        model.alertBody = [set stringForColumn:@"alertBody"];
        model.soundName = [set stringForColumn:@"soundName"];
        model.userNotificationKey = [set stringForColumn:@"userNotificationKey"];
        model.isOn = [set intForColumn:@"isOn"];
        [_alarms addObject:model];
    }
    return _alarms;
}

- (Alarm_Help_Model *)alarmModelWhere:(NSString *)where WithId:(id)Id
{
    Alarm_Help_Model *alarmModel = [[Alarm_Help_Model alloc] init];
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM t_alarm WHERE %@ = %@;", where, Id];
    FMResultSet *set = [self.db executeQuery:selectString];
    // 遍历结果集
    while ([set next]) {
        alarmModel.Id = [set intForColumn:@"id"];
        alarmModel.weekDays = [self arrayWithString:[set stringForColumn:@"weekDays"]];
        alarmModel.hourString = [set stringForColumn:@"hourString"];
        alarmModel.minString = [set stringForColumn:@"minString"];
        alarmModel.alertBody = [set stringForColumn:@"alertBody"];
        alarmModel.soundName = [set stringForColumn:@"soundName"];
        alarmModel.userNotificationKey = [set stringForColumn:@"userNotificationKey"];
        alarmModel.isOn = [set intForColumn:@"isOn"];
    }
    
    return alarmModel;
}

// 数组转字符串
- (NSString *)stringWithArray:(NSArray *)array
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        DLog(@"could not inser error = %@", error);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
// 字符串转数组
- (NSArray *)arrayWithString:(NSString *)string
{
    return (NSArray *)[string objectFromJSONString];
}

@end
