//
//  PlaySoundManager.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/12/2.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import "PlaySoundManager.h"
#import <AudioToolbox/AudioToolbox.h>

@interface PlaySoundManager()

@end

@implementation PlaySoundManager
{
    SystemSoundID sameViewSoundID;
    NSURL *soundUrl;
}

+ (PlaySoundManager *)sharedPlaySoundManager
{
    static PlaySoundManager *mng = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mng = [[self alloc] init];
    });
    return mng;
}

- (void)playSound:(NSString *)sound repeat:(BOOL)repeat {
    
    [self stopSound];
    
    NSUInteger index = [sound rangeOfString:@"."].location; //现获取要截取的字符串位置
    NSString *soundString = [sound substringWithRange:NSMakeRange(0, index)]; //截取字符串
    NSString *typeString = [sound substringWithRange:NSMakeRange(index, sound.length - index)];
    
    //变量SoundID与URL对应 //音乐文件路径
    NSString *thesoundFilePath = [[NSBundle mainBundle] pathForResource:soundString ofType:typeString];
    soundUrl = [NSURL fileURLWithPath:thesoundFilePath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, &sameViewSoundID);
    
    if (repeat) {
        /*添加音频结束时的回调*/
        AudioServicesAddSystemSoundCompletion(sameViewSoundID, NULL, NULL, SoundFinished,NULL);
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, vibrateFinished, NULL);
    }
    
    //播放SoundID声音
    AudioServicesPlaySystemSound(sameViewSoundID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //    CFRunLoopRun();
    
}

- (void)stopSound {
    
    //        CFRelease((__bridge CFTypeRef)(thesoundURL));
    //        CFRunLoopStop(CFRunLoopGetCurrent());
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(vibrateFinished)  object:nil];
    
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(sameViewSoundID);
    
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    AudioServicesRemoveSystemSoundCompletion(sameViewSoundID);
}


#pragma mark - 私有方法
//当音频播放完毕会调用这个函数
static void SoundFinished(SystemSoundID soundID,void* sample){
    /*播放全部结束，因此释放所有资源 */
    AudioServicesPlaySystemSound(soundID);
}

static void vibrateFinished()
{
    [[PlaySoundManager sharedPlaySoundManager]  performSelector:@selector(vibrateFinished) withObject:nil afterDelay:1];
}

- (void)vibrateFinished
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
