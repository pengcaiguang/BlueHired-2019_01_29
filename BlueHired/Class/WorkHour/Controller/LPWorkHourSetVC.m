//
//  LPWorkHourSetVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/7.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkHourSetVC.h"
#import "LPWorkHourSetCell.h"
#import "LPWorkHourBaseSalaryVC.h"
#import "LPWorkHourBaseSalary2VC.h"
#import "LPWorkHourKQWeekVC.h"
#import "LPConsumeTypeVC.h"
#import "LPWorkdaySetVC.h"
#import "LPHoursNumderVC.h"
#import "LPLabourCostSetVC.h"

#import "LPtestDateViewController.h"
static NSString *LPWorkHourSetCellID = @"LPWorkHourSetCell";


@interface LPWorkHourSetVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@end

@implementation LPWorkHourSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"工时设置";
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.WorkHourType == 3) {
        return 3;
    }
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPWorkHourSetCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkHourSetCellID];
    if(cell == nil){
        cell = [[LPWorkHourSetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPWorkHourSetCellID];
    }
  
    if (self.WorkHourType == 3) {
        cell.Image.hidden = YES;
        cell.Switch.hidden = YES;
        if (indexPath.row == 0) {
            cell.NameTitle.text = @"工价设置";
            cell.Image.hidden = NO;
        }else if (indexPath.row == 1) {
            cell.NameTitle.text = @"考勤周期";
            cell.Image.hidden = NO;
        }else if (indexPath.row == 2) {
            cell.NameTitle.text =  @"记账本";
            cell.Switch.hidden = NO;
            cell.Switch.on = !kUserDefaultsValue(BOOK).integerValue;
        }
        return cell;
    }
    
    cell.Image.hidden = YES;
    cell.Switch.hidden = YES;
    if (indexPath.row == 0) {
        cell.NameTitle.text = @"企业底薪";
        cell.Image.hidden = NO;
    }else if (indexPath.row == 1) {
        cell.NameTitle.text = @"考勤周期";
        cell.Image.hidden = NO;

    }else if (indexPath.row == 2) {
        if (self.WorkHourType == 2) {
            cell.NameTitle.text =  @"每月工作小时数";
        }else if (self.WorkHourType == 4){
            cell.NameTitle.text =  @"产品设置";
        }else{
            cell.NameTitle.text =  @"正常工作日";
        }
        cell.Image.hidden = NO;
    }else if (indexPath.row == 3) {
        cell.NameTitle.text =  @"记账本";
        cell.Switch.hidden = NO;
        cell.Switch.on = !kUserDefaultsValue(BOOK).integerValue;
    }
     return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (self.WorkHourType == 4) {
            LPWorkHourBaseSalary2VC *vc = [[LPWorkHourBaseSalary2VC alloc] init];
            vc.WorkHourType = self.WorkHourType;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.WorkHourType == 3){
            LPLabourCostSetVC *vc = [[LPLabourCostSetVC alloc] init];
            vc.Type = 1;
            vc.WorkHourType = self.WorkHourType;
            [self.navigationController pushViewController:vc animated:YES];
        } else{
            LPWorkHourBaseSalaryVC *vc = [[LPWorkHourBaseSalaryVC alloc] init];
            vc.WorkHourType = self.WorkHourType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.row == 1){
        LPWorkHourKQWeekVC *vc = [[LPWorkHourKQWeekVC alloc] init];
        vc.WorkHourType = self.WorkHourType;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        if (self.WorkHourType == 2 ) {
            LPHoursNumderVC *vc = [[LPHoursNumderVC alloc] init];
            vc.WorkHourType = self.WorkHourType;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.WorkHourType == 4){
            LPLabourCostSetVC *vc = [[LPLabourCostSetVC alloc] init];
            vc.Type = 2;
            vc.WorkHourType = self.WorkHourType;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else{
            LPWorkdaySetVC *vc = [[LPWorkdaySetVC alloc] init];
            vc.WorkHourType = self.WorkHourType;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#E6E6E6"];
        [_tableview registerNib:[UINib nibWithNibName:LPWorkHourSetCellID bundle:nil] forCellReuseIdentifier:LPWorkHourSetCellID];

    }
    return _tableview;
}

@end
