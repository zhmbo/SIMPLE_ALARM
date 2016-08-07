//
//  Alarm_Help.h
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/23.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Alarm_Help_Model;
@interface Alarm_Help : NSObject
/** 单例对象 */
+ (Alarm_Help *)sharedAlarm;

/** 创建闹铃 */
- (void)createAlarmWithModel:(Alarm_Help_Model *)model;

/** 删除 */
- (BOOL)deleteAlarmWithId:(int)Id;

/** 暂停 
 * KAlarmLocalNotificationKeyNotRepeat    不重复  关闭当前通知 不发起下次通知
 * KAlarmLocalNotificationKeyOfSmallSleep 小睡   关闭当前通知  不发起下次通知
 * KAlarmLocalNotificationKeyEveryDay     每天   关闭当前通知  发起下次通知
 * KAlarmLocalNotificationKey             重复   关闭当前通知  发起下次通知
 *
 * 根据 notification 判断当前的通知类型，判断是否重复或发下一次通知（根据 weekDays 判断）
 **/
- (void)suspendAlarmWithNotification:(UILocalNotification *)notification;

/** 关闭当前通知 */
- (void)closeAlarmWithId:(int)Id;

/** 打开当前已关闭的通知 */
- (void)openAlarmWithId:(int)Id;

/** 编辑已经创建的通知 */
- (void)editAlarmWithModel:(Alarm_Help_Model *)model;

/** 创建小睡 */
- (void)createAlarmSmallSleepMinute:(int)min Notification:(UILocalNotification *)notification;
@end
