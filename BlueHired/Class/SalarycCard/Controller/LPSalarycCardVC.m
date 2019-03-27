//
//  LPSalarycCardVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPSalarycCardVC.h"
#import "LPSalarycCardBindVC.h"
#import "LPSalarycCardChangePasswordVC.h"
#import "LPBankcardwithDrawModel.h"
#import "LPSalarycCard2VC.h"

@interface LPSalarycCardVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) LPBankcardwithDrawModel *model;

@end

@implementation LPSalarycCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"工资卡管理";
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self requestQueryBankcardwithDraw];

}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"工资卡绑定";
    }else{
        cell.textLabel.text = @"修改提现密码";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
//        LPSalarycCardBindVC *vc = [[LPSalarycCardBindVC alloc]init];
        LPSalarycCard2VC *vc = [[LPSalarycCard2VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (_model.data.type.integerValue == 1) {
            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"请先进行工资卡绑定！" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
            }];
            [alert show];
            return;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *string = [dateFormatter stringFromDate:[NSDate date]];
        
        if (kUserDefaultsValue(@"ERRORTIMES")) {
            NSString *errorString = kUserDefaultsValue(@"ERRORTIMES");
            NSString *d = [errorString substringToIndex:16];
            NSString *str = [self dateTimeDifferenceWithStartTime:d endTime:string];
            NSString *t = [errorString substringFromIndex:17];
            if ([t integerValue] >= 3 && [str integerValue] < 10) {
                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请十分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
                }];
                [alert show];
                return;
            }
            else
            {
                kUserDefaultsRemove(@"ERRORTIMES");
            }
        }
        LPSalarycCardChangePasswordVC *vc = [[LPSalarycCardChangePasswordVC alloc]init];
        vc.phone = self.model.data.phone;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int minute = (int)value /60%60;
//    int house = (int)value / (24 * 3600)%3600;
//    int sum = house * 60 + minute + 1;
    NSString *str = [NSString stringWithFormat:@"%d",minute];
    return str;
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
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        //        [_tableview registerNib:[UINib nibWithNibName:LPWorkHourDetailPieChartCellID bundle:nil] forCellReuseIdentifier:LPWorkHourDetailPieChartCellID];
        
    }
    return _tableview;
}


-(void)requestQueryBankcardwithDraw{
    [NetApiManager requestQueryBankcardwithDrawWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPBankcardwithDrawModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
