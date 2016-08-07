//
//  PlaySoundManager.h
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/12/2.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaySoundManager : NSObject

/** 单例对象 */
+ (PlaySoundManager *)sharedPlaySoundManager;

- (void)playSound:(NSString *)sound repeat:(BOOL)repeat;

- (void)stopSound;
@end
