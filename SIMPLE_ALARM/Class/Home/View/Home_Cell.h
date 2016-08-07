//
//  Home_Cell.h
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/19.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Alarm_Help_Model;

@protocol Home_CellDelegate <NSObject>

- (void)alarmSwitchDidClicked:(UISwitch *)sender;

@end

@interface Home_Cell : UITableViewCell

#pragma mark - 共有方法
+ (Home_Cell *)cellWhithTableView:(UITableView *)tableView;

@property (strong, nonatomic) Alarm_Help_Model *alarm_help_model;

@property (assign, nonatomic) id <Home_CellDelegate> delegate;

@end
