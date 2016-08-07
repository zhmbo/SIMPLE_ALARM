//
//  Home_Cell.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/19.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import "Home_Cell.h"
#import "Alarm_Help_Model.h"

@interface Home_Cell()
@property (weak, nonatomic) IBOutlet UILabel *alarm_title;
@property (weak, nonatomic) IBOutlet UILabel *alarm_describe;
@property (strong, nonatomic) UISwitch *alarm_switch;

@end

@implementation Home_Cell
{
//    BOOL _isON;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"Home_Cell" owner:nil options:0].firstObject;
    }
    return self;
}

#pragma mark - 共有方法
+ (Home_Cell *)cellWhithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"home_cell";
    Home_Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[Home_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setAlarm_help_model:(Alarm_Help_Model *)alarm_help_model
{
    _alarm_help_model = alarm_help_model;
    
    NSString *titleText = [NSString stringWithFormat:@"%@:%@", alarm_help_model.hourString, alarm_help_model.minString];
    self.alarm_title.text = titleText;
    self.alarm_describe.text = alarm_help_model.alertBody;
    
    self.alarm_switch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.alarm_switch addTarget:self action:@selector(alarmSwitchDidClicked:) forControlEvents:UIControlEventValueChanged];
    self.alarm_switch.on = alarm_help_model.isOn;
    self.alarm_switch.tag = alarm_help_model.Id + 100;
    self.alarm_switch.onTintColor = ALARMTHEMERED;
    self.accessoryView = self.alarm_switch;
    
    if (alarm_help_model.isOn == NO) {
        self.backgroundColor = ALARMBACKGROUDCOLOR;
        self.alarm_title.textColor = [UIColor whiteColor];
        self.alarm_describe.textColor = [UIColor whiteColor];
    }
}

- (void)alarmSwitchDidClicked:(UISwitch *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alarmSwitchDidClicked:)]) {
        [self.delegate alarmSwitchDidClicked:sender];
    }
}

@end
