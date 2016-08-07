//
//  AppDelegate.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/19.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import "AppDelegate.h"
#import "Alarm_Help.h"
#import "Fmdb_Help.h"
#import "Alarm_Help_Model.h"
#import "HOME_VC.h"
#import "PlaySoundManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AppDelegate ()<UIAlertViewDelegate>

@property (strong, nonatomic) UIAlertView *AlarmAlert;

@end

@implementation AppDelegate
{
    UILocalNotification *_notification;
}

- (UIAlertView *)AlarmAlert {
    
    if (!_AlarmAlert) {
        
        self.AlarmAlert = [[UIAlertView alloc] initWithTitle:@"闹铃"
                                                    message:_notification.alertBody
                                                   delegate:self
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:@"小睡5分钟",@"小睡10分钟",nil];
    }
    return _AlarmAlert;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    for (UILocalNotification *notification in [UIApplication sharedApplication].scheduledLocalNotifications) {
        DLog(@"%@", notification);
    }
    
    DLog(@"current version == %f old version == %f", BUNDLEVERSIONKEYCURRENT, BUNDLEVERSIONKEYOLD);
    
    INITALARM
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    // 设置为 YES 保持屏幕常亮.
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // 调节亮度
    //    [[UIScreen mainScreen] setBrightness:0.0f];
    
    // 设置音量
//    [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.85f]; // 系统音量 非铃声

    // 打开
    [[Fmdb_Help sharedFmdb] open];
    
    // 建表
    [[Fmdb_Help sharedFmdb] createTable];
    
    // 当前通知
//    _notification = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    
//    if (_notification) {
//        [[PlaySoundManager sharedPlaySoundManager] playSound:_notification.soundName repeat:YES];
//        [self.AlarmAlert show];
//    }
    
    // 发送通知
    [self sendNotification];
    
    return YES;
   
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    // 将要进入后台
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // 已经进入后台
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    // 将要进入前台
    
    [self sendNotification];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 已经进入前台
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user inerface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    
    _notification = notification;
    
    [[PlaySoundManager sharedPlaySoundManager] playSound:_notification.soundName repeat:YES];
    
    [self.AlarmAlert show];
    
}

/** alert click */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            
            [[Alarm_Help sharedAlarm] suspendAlarmWithNotification:[self stopSoundNotification]];
            
//            [[(UITableViewController *)self.window.rootViewController.childViewControllers.firstObject tableView] reloadData];
            
            [AppTool reloadHomeData];
            
            break;
            
        }
        case 1:{
            
            [self stopSoundNotification];
            
            [[Alarm_Help sharedAlarm] createAlarmSmallSleepMinute:5 Notification:_notification];
            
            break;
            
        }
        case 2:{
            
            [self stopSoundNotification];
            
            [[Alarm_Help sharedAlarm] createAlarmSmallSleepMinute:10 Notification:_notification];
            
            break;
            
        }
        default:
            break;
    }
}

/** send */
- (void)sendNotification
{
    NSInteger badge = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    
    if (badge > 0) {
        
        NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
        
        if (localNotifications.count > 0) {
            
            _notification = localNotifications[0];
            
            [[PlaySoundManager sharedPlaySoundManager] playSound:_notification.soundName repeat:YES];
            
            [self.AlarmAlert show];
            
        }
        
    }
}

/** stop */
- (UILocalNotification *)stopSoundNotification
{
    UILocalNotification *localNotification = [UIApplication sharedApplication].scheduledLocalNotifications.firstObject;
    
    if ([localNotification.userInfo[@"key"] isEqualToString:_notification.userInfo[@"key"]]) {
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        [[PlaySoundManager sharedPlaySoundManager] stopSound];
        
    }
    
    return localNotification;
}

@end
