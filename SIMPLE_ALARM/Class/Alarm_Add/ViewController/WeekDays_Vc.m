//
//  WeekDays_Vc.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/25.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import "WeekDays_Vc.h"
#import "Add_Alarm_Seting.h"

@interface WeekDays_Vc ()

@end

@implementation WeekDays_Vc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置uitableview为编译状态
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES];
    
    for (int i = 0; i < [Add_Alarm_Seting sharedAddAlarmSeting].weekDays.count; i++) {
        int index = [[Add_Alarm_Seting sharedAddAlarmSeting].weekDays[i] intValue] - 1;
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"weekdays_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = WEEKDAYS[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[Add_Alarm_Seting sharedAddAlarmSeting].weekDays addObject:@(indexPath.row + 1)];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[Add_Alarm_Seting sharedAddAlarmSeting].weekDays removeObject:@(indexPath.row + 1)];
}

@end
