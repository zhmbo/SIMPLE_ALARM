
//
//  AlertBody_Vc.m
//  SIMPLE_ALARM
//
//  Created by 张宝 on 15/11/26.
//  Copyright © 2015年 zhangbao. All rights reserved.
//

#import "AlertBody_Vc.h"
#import "Add_Alarm_Seting.h"

@interface AlertBody_Vc ()
@property (weak, nonatomic) IBOutlet UITextField *alertBodyTextField;

@end

@implementation AlertBody_Vc

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.alertBodyTextField.text = [Add_Alarm_Seting sharedAddAlarmSeting].alertBody;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [Add_Alarm_Seting sharedAddAlarmSeting].alertBody = textField.text;
}

@end
