//
//  ZBTableViewController.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/19.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import "ZBTableViewController.h"

@interface ZBTableViewController ()

@end

@implementation ZBTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = ALARMBACKGROUDCOLOR;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
@end
