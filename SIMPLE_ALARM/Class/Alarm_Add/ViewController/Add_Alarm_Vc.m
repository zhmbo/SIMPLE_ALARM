//
//  Add_Alarm_Vc.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/20.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

typedef enum : NSUInteger {
    AddAlarmWeekDays,
    AddAlarmAlertBody,
    AddAlarmSound,
} AddAlarmIndex;

#import "Add_Alarm_Vc.h"
#import "Alarm_Help.h"
#import "Add_Alarm_Seting.h"
#import "WeekDays_Vc.h"
#import "AlertBody_Vc.h"
#import "SoundName_Vc.h"
#import "Alarm_Help_Model.h"

@interface Add_Alarm_Vc ()

@property (weak, nonatomic) IBOutlet UIPickerView *timePickerView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSArray *detailTextLabels;

@end

@implementation Add_Alarm_Vc
{
    NSMutableArray *arrayHour;
    NSMutableArray *arrayMin;
    
    int _hour;
    int _min;
    
    NSArray *_textLabels;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpDataSource];
    
    [self setUpUI];
}

#pragma mark - 初始化

- (void)setUpDataSource
{
    arrayHour = [[NSMutableArray alloc] init];
    for (int i = 0; i < 24; i++) {
        NSString *tempString = nil;
        if (i < 10) tempString = [NSString stringWithFormat:@"0%i", i];
        else tempString = [NSString stringWithFormat:@"%i", i];
        [arrayHour addObject:tempString];
    }
    
    arrayMin = [[NSMutableArray alloc] init];
    for (int i = 0; i < 60; i++) {
        NSString *tempString = nil;
        if (i < 10) tempString = [NSString stringWithFormat:@"0%i", i];
        else tempString = [NSString stringWithFormat:@"%i", i];
        [arrayMin addObject:tempString];
    }
    
    _textLabels = @[@"重复", @"标签", @"铃声"];
}

- (NSArray *)detailTextLabels
{
    // 排序
    NSMutableArray *weekDays = [Add_Alarm_Seting sharedAddAlarmSeting].weekDays;
    weekDays = [[weekDays sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    [Add_Alarm_Seting sharedAddAlarmSeting].weekDays = weekDays;
    
    // 重复
    NSString *weekDay = @"";
    
    for (int i = 0; i < weekDays.count; i++) {
        
        int index = [weekDays[i] intValue] - 1;
        weekDay = [weekDay stringByAppendingString:WEEKDAYS[index]];
        
    }
    
    if (weekDays.count == 0) {
        
        weekDay = @"永不";
        
    }else if (weekDays.count == 2) {
        
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@) AND NOT (SELF IN %@) AND NOT (SELF IN %@) AND NOT (SELF IN %@) AND NOT (SELF IN %@)",@[@2],@[@3],@[@4],@[@5],@[@6]];
        //过滤数组
        NSArray * reslutFilteredArray = [[Add_Alarm_Seting sharedAddAlarmSeting].weekDays filteredArrayUsingPredicate:filterPredicate];
        if (reslutFilteredArray.count == 2) {
            weekDay = @"周末";
        }
        
    }else if (weekDays.count == 5) {
        
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@) AND NOT (SELF IN %@)",@[@1],@[@7]];
        //过滤数组
        NSArray * reslutFilteredArray = [[Add_Alarm_Seting sharedAddAlarmSeting].weekDays filteredArrayUsingPredicate:filterPredicate];
        if (reslutFilteredArray.count == 5) {
            weekDay = @"工作日";
        }
        
    }else if(weekDays.count == 7) {
        
        weekDay = @"每天";
        
    }
    
    // 铃声
    int soundIndex = [Add_Alarm_Seting sharedAddAlarmSeting].soundIndex;
    
    NSUInteger index = [ALARMSOUNDNAMES[soundIndex] rangeOfString:@"."].location; //现获取要截取的字符串位置
    NSString *soundString = [ALARMSOUNDNAMES[soundIndex] substringWithRange:NSMakeRange(0, index)]; //截取字符串
    
    _detailTextLabels = @[weekDay, [Add_Alarm_Seting sharedAddAlarmSeting].alertBody, soundString];
    
    return _detailTextLabels;
}

#pragma mark - 初始化视图
- (void)setUpUI
{
    int currentHour = [[Add_Alarm_Seting sharedAddAlarmSeting].hour intValue];
    int currentMin = [[Add_Alarm_Seting sharedAddAlarmSeting].minute intValue];
    
    self.timePickerView.showsSelectionIndicator = YES;
    [self.timePickerView selectRow:12000 + currentHour inComponent:0 animated:NO];
    [self.timePickerView selectRow:30000 + currentMin inComponent:1 animated:NO];
    
    _hour = (int)[self.timePickerView selectedRowInComponent:0]%24;
    _min = (int)[self.timePickerView selectedRowInComponent:1]%60;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _textLabels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"add_alarm_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    cell.textLabel.text = _textLabels[indexPath.row];
    cell.detailTextLabel.text = self.detailTextLabels[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case AddAlarmWeekDays:
        {
            [self pushViewControlleridentifier:@"weekdays_vc"];
            break;
        }
        case AddAlarmAlertBody:
        {
            [self pushViewControlleridentifier:@"alertbody_vc"];
            break;
        }
        case AddAlarmSound:
        {
            [self pushViewControlleridentifier:@"soundname_vc"];
            break;
        }
        default:
            break;
    }
}

- (void)pushViewControlleridentifier:(NSString *)identifier
{
    id vc = [[self storyboard] instantiateViewControllerWithIdentifier:identifier];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int rows = 0;
    if (component == 0)rows = 24000;
    if (component == 1)rows = 60000;
    return rows;
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row forComponent:(NSInteger)component
           reusingView:(nullable UIView *)view
{
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 32)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = ALARMTHEMERED;
    textLabel.font = [UIFont systemFontOfSize:26];
    
    if (component == 0) {
        textLabel.text = arrayHour[row%24];
    }
    if (component == 1) {
        textLabel.text = arrayMin[row%60];
    }
    return textLabel;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (component == 0) {
        _hour = [arrayHour[row%24] intValue];
    }
    if (component == 1) {
        _min = [arrayMin[row%60] intValue];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 32.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100;
}

#pragma mark - 点击事件
- (IBAction)cancelButtonItemDidSelected:(UIBarButtonItem *)sender {
    [self dismiss];
}

- (IBAction)saveButtonItemDidSelected:(UIBarButtonItem *)sender {
    
    // 储存
    // 双位数显示
    NSString *tempHour = nil;
    if (_hour < 10) tempHour = [NSString stringWithFormat:@"0%i", _hour];
    else tempHour = [NSString stringWithFormat:@"%i", _hour];
    
    NSString *tempMin = nil;
    if (_min < 10) tempMin = [NSString stringWithFormat:@"0%i", _min];
    else tempMin = [NSString stringWithFormat:@"%i", _min];
    
    Alarm_Help_Model *model = [[Alarm_Help_Model alloc] init];
    model.Id = [Add_Alarm_Seting sharedAddAlarmSeting].Id;
    model.weekDays = [Add_Alarm_Seting sharedAddAlarmSeting].weekDays;
    model.hourString = tempHour;
    model.minString = tempMin;
    model.alertBody = [Add_Alarm_Seting sharedAddAlarmSeting].alertBody;
    model.soundName = ALARMSOUNDNAMES[[Add_Alarm_Seting sharedAddAlarmSeting].soundIndex];
    model.isOn = YES;
    model.userNotificationKey = [Add_Alarm_Seting sharedAddAlarmSeting].model.userNotificationKey;
    
    if ([Add_Alarm_Seting sharedAddAlarmSeting].Id > 0) { // 编辑
        
        [[Alarm_Help sharedAlarm] editAlarmWithModel:model];
        
    }else { // 创建
        
        [[Alarm_Help sharedAlarm] createAlarmWithModel:model];
    }
    [self dismiss];
}

#pragma mark - 私有方法
/** dismiss */
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mainTableView reloadData];
}

@end
