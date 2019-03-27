//
//  LPtestDateViewController.m
//  BlueHired
//
//  Created by iMac on 2019/3/13.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPtestDateViewController.h"

@interface LPtestDateViewController ()

@end

@implementation LPtestDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)datetouch:(UIDatePicker *)sender {
    _Label.text = [NSString stringWithFormat:@"%ld",(long)[LPTools calculationChinaCalendarWithDate:sender.date].integerValue];
}


@end
