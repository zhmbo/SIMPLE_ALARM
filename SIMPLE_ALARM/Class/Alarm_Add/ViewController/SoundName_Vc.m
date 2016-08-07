//
//  SoundName_Vc.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/26.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import "SoundName_Vc.h"
#import "Add_Alarm_Seting.h"
#import "PlaySoundManager.h"

@interface SoundName_Vc ()

@end

@implementation SoundName_Vc
{
    int _currentCheckmark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置uitableview为编译状态
    _currentCheckmark = [Add_Alarm_Seting sharedAddAlarmSeting].soundIndex;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ALARMSOUNDNAMES.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"weekdays_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    NSUInteger index = [ALARMSOUNDNAMES[indexPath.row] rangeOfString:@"."].location; //现获取要截取的字符串位置
    NSString *soundString = [ALARMSOUNDNAMES[indexPath.row] substringWithRange:NSMakeRange(0, index)]; //截取字符串
    cell.textLabel.text = soundString;
    if(_currentCheckmark == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType =  UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    _currentCheckmark = (int)indexPath.row;
    [Add_Alarm_Seting sharedAddAlarmSeting].soundIndex = _currentCheckmark;
    [[PlaySoundManager sharedPlaySoundManager] playSound:ALARMSOUNDNAMES[_currentCheckmark] repeat:NO];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[PlaySoundManager sharedPlaySoundManager] stopSound];
}

@end
