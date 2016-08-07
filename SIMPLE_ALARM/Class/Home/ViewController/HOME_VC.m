//
//  HOME_VC.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/19.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import "HOME_VC.h"
#import "Home_Cell.h"
#import "Add_Alarm_Vc.h"
#import "Fmdb_Help.h"
#import "Alarm_Help_Model.h"
#import "Alarm_Help.h"
#import "Add_Alarm_Seting.h"

@interface HOME_VC ()<Home_CellDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *Edit_ButtonItem;
@property (strong, nonatomic) NSMutableArray *alarmListMutArr;
;
@end

@implementation HOME_VC
{
    UILabel *_point_text;
}

- (NSMutableArray *)alarmListMutArr {
    self.alarmListMutArr = [[Fmdb_Help sharedFmdb] alarms];
    return _alarmListMutArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

- (void)setUpUI
{
    CGRect rectValue;
    rectValue.size.width = 150;
    rectValue.size.height = 50;
    rectValue.origin.x = (SCREEN_WIDTH - 150) * 0.5;
    rectValue.origin.y = (SCREEN_HEIGHT - 150) * 0.5;
    _point_text = [[UILabel alloc] initWithFrame:rectValue];
    _point_text.textColor = ALARMTHEMERED;
    _point_text.alpha = 0.6;
    _point_text.text = @"闹铃未设置";
    _point_text.textAlignment = NSTextAlignmentCenter;
    _point_text.font = [UIFont systemFontOfSize:30];
    _point_text.hidden = YES;
    [self.tableView addSubview:_point_text];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alarmListMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Home_Cell *cell = [Home_Cell cellWhithTableView:tableView];
    cell.alarm_help_model = self.alarmListMutArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (IBAction)editDidSelecte:(UIBarButtonItem *)sender
{
    [self tableViewEditing];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Alarm_Help_Model *model = self.alarmListMutArr[indexPath.row];
        
        [[Alarm_Help sharedAlarm] deleteAlarmWithId:model.Id];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self alarmListCounts];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        UINavigationController *add_alarm_nvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"add_alarm_nvc"];
        
        [self presentViewController:add_alarm_nvc animated:YES completion:nil];
        
        [Add_Alarm_Seting sharedAddAlarmSeting].model = self.alarmListMutArr[indexPath.row];
        
        [self tableViewEditing];
    }
}

// 修改删除按钮的文字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue_add"]) {
        [Add_Alarm_Seting destroyDealloc] ;
    }
}

#pragma mark - HomeCellDelegate

- (void)alarmSwitchDidClicked:(UISwitch *)sender
{
    if (sender.isOn == YES) {
        
        [[Alarm_Help sharedAlarm] openAlarmWithId:(int)(sender.tag - 100)];
        
    }else {
        
        [[Alarm_Help sharedAlarm] closeAlarmWithId:(int)(sender.tag - 100)];
        
    }
    
    [self performSelector:@selector(reloadTableViewData) withObject:nil afterDelay:0.3f];
}

- (void)reloadTableViewData
{
    [self.tableView reloadData];
}

#pragma mark - 私有方法
- (void)tableViewEditing
{
    if (self.tableView.editing == YES) {
        [self.tableView setEditing:NO animated:YES];
         self.Edit_ButtonItem.title = @"编辑";
    }
    else {
        [self.tableView setEditing:YES animated:YES];
        self.Edit_ButtonItem.title = @"完成";
    }
}

- (void)alarmListCounts
{
    if (self.alarmListMutArr.count == 0) {
        _point_text.hidden = NO;
        self.tableView.bounces = NO;
        self.Edit_ButtonItem.title = @"";
    }else {
        _point_text.hidden = YES;
        self.tableView.bounces = YES;
        self.Edit_ButtonItem.title = @"编辑";
    }
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self alarmListCounts];
    
    if (self.tableView.editing == YES) {
        
        [self tableViewEditing];
        
    }
    
    [self.tableView reloadData];
}

@end
