//
//  LPHourlyWorkVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPHourlyWorkVC.h"
#import "LPDurationView.h"
#import "LPDateSelectView.h"
#import "LPHourlyWorkDetailVC.h"
#import "LPQueryCurrecordModel.h"

@interface LPHourlyWorkVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *tableFooterView;
@property(nonatomic,strong) UIButton *timeButton;

@property(nonatomic,strong) LPDateSelectView *dateSelectView;
@property(nonatomic,strong) LPDurationView *durationView;

@property(nonatomic,strong) NSArray *timeArray;

@property(nonatomic,strong) NSString *currentDateString;

@property(nonatomic,strong) LPQueryCurrecordModel *model;

@property(nonatomic,assign) CGFloat labourCost;
@property(nonatomic,assign) CGFloat workReHour;

@end

@implementation LPHourlyWorkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"小时工";

    self.timeArray = @[@"0.5",@"1",@"1.5",@"2",@"2.5",@"3",@"3.5",@"4",@"4.5",@"5",@"5.5",@"6",@"6.5",@"7",@"7.5",@"8",@"8.5",@"9",@"9.5",@"10",@"10.5",@"11",@"11.5",@"12",@"12.5",@"13",@"13.5",@"14",@"14.5",@"15",@"15.5",@"16",@"16.5",@"17",@"17.5",@"18",@"18.5",@"19",@"19.5",@"20",@"20.5",@"21",@"21.5",@"22",@"22.5",@"23",@"23.5",@"24"];

    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    self.currentDateString = [dateFormatter stringFromDate:currentDate];
    
    [self setupUI];
    [self requestQueryCurrecord];
    
}

-(void)setupUI{
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    bgView.backgroundColor = [UIColor baseColor];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    [bgView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.centerY.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(19, 20));
    }];
    imgView.image = [UIImage imageNamed:@"calendar"];
    
    UIButton *timeButton = [[UIButton alloc]init];
    [bgView addSubview:timeButton];
    [timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
    }];
    [timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    [timeButton addTarget:self action:@selector(selectCalenderButton:) forControlEvents:UIControlEventTouchUpInside];
    self.timeButton = timeButton;
    
    UIImageView *leftImgView = [[UIImageView alloc]init];
    [bgView addSubview:leftImgView];
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 12));
        make.centerY.equalTo(timeButton);
        make.right.equalTo(timeButton.mas_left).offset(-10);
    }];
    leftImgView.image = [UIImage imageNamed:@"left_arrow"];
    
    UIImageView *rightImgView = [[UIImageView alloc]init];
    [bgView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 12));
        make.centerY.equalTo(timeButton);
        make.left.equalTo(timeButton.mas_right).offset(10);
    }];
    rightImgView.image = [UIImage imageNamed:@"right_arrow"];
    
    UIButton *deleteButton = [[UIButton alloc]init];
    [bgView addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.centerY.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(15, 19));
    }];
    [deleteButton setImage:[UIImage imageNamed:@"delete_white"] forState:UIControlStateNormal];
    
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(48);
    }];
}

#pragma mark - setter
-(void)setModel:(LPQueryCurrecordModel *)model{
    _model = model;
    //    if (model.data) {
    self.workReHour = model.data.workReHour.floatValue;
    self.labourCost = model.data.labourCost.floatValue;
    [self.tableview reloadData];
    //    }
}

#pragma mark - tagter
-(void)textFieldChanged:(UITextField *)textField{
    self.labourCost = [textField.text floatValue];
}
-(void)selectCalenderButton:(UIButton *)button{
    self.dateSelectView.hidden = NO;
    WEAK_SELF()
    self.dateSelectView.block = ^(NSString *string) {
        weakSelf.currentDateString = string;
        [weakSelf.timeButton setTitle:string forState:UIControlStateNormal];
        [weakSelf requestQueryCurrecord];
    };
}
-(void)touchRecordButton{
    if (!self.labourCost || !self.workReHour) {
        [self.view showLoadingMeg:@"请选择工时及工价" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestSaveorupdateWorkhour];
}
#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:rid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 1 || indexPath.row == 2) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(10, 15, 2, 14);
        if (indexPath.section == 0) {
            view.backgroundColor = [UIColor baseColor];
        }else if (indexPath.section == 1){
            view.backgroundColor = [UIColor colorWithHexString:@"#FFBC3C"];
        }else{
            view.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
        }
        [cell.contentView addSubview:view];
        
        
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"正常上班";
        cell.imageView.image = [UIImage imageNamed:@"zhengchangshangban"];
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"工时";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = self.model.data.workReHour ? [NSString stringWithFormat:@"%@",self.model.data.workReHour] : @"";
        

    }else {
        cell.textLabel.text = @"工价";

        UITextField *textField = [[UITextField alloc]init];
        [cell.contentView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
            make.centerY.equalTo(cell.contentView);
            make.left.mas_equalTo(cell.textLabel.mas_right).offset(10);
        }];
        textField.placeholder = @"请输入工价(元/小时)";
        textField.textAlignment = NSTextAlignmentRight;
        textField.font = [UIFont systemFontOfSize:16];
        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

        textField.text = self.model.data.labourCost ? [NSString stringWithFormat:@"%@",self.model.data.labourCost] : @"";
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 1) {
        self.durationView.timeArray = self.timeArray;
        self.durationView.titleString = @"时长";
        self.durationView.hidden = NO;
        self.durationView.type = 2;
        WEAK_SELF()
        self.durationView.block = ^(NSInteger index) {
            weakSelf.workReHour = [weakSelf.timeArray[index] floatValue];
            cell.detailTextLabel.text = weakSelf.timeArray[index];
        };
    }
}
#pragma mark - target
-(void)touchDetailButton{
    LPHourlyWorkDetailVC *vc = [[LPHourlyWorkDetailVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request
-(void)requestQueryCurrecord{
    NSDictionary *dic = @{
                          @"type":@(1),
                          @"day":self.currentDateString
                          };
    [NetApiManager requestQueryCurrecordWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPQueryCurrecordModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestSaveorupdateWorkhour{
    NSDictionary *dic = @{
                          @"labourCost":self.labourCost ? @(self.labourCost) : @"",
                          @"workReHour":self.workReHour ? @(self.workReHour) : @"",
                          @"time":self.currentDateString,
                          @"optType":self.model.data ? @(2) : @(1),
                          @"type":@(1),
                          };
    [NetApiManager requestSaveorupdateWorkhourWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"]) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self.view showLoadingMeg:@"记录成功" time:MESSAGE_SHOW_TIME];
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
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
        _tableview.tableFooterView = self.tableFooterView;
        
    }
    return _tableview;
}

-(UIView *)tableFooterView{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc]init];
        _tableFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
        UIButton *recordButton = [[UIButton alloc]init];
        recordButton.frame = CGRectMake(13, 21, SCREEN_WIDTH-26, 48);
        recordButton.backgroundColor = [UIColor baseColor];
        [recordButton setTitle:@"工时记录" forState:UIControlStateNormal];
        [recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        recordButton.layer.masksToBounds = YES;
        recordButton.layer.cornerRadius = 24;
        [recordButton addTarget:self action:@selector(touchRecordButton) forControlEvents:UIControlEventTouchUpInside];
        [_tableFooterView addSubview:recordButton];
        
        UIButton *detailButton = [[UIButton alloc]init];
        detailButton.frame = CGRectMake(13, 92, SCREEN_WIDTH-26, 48);
        detailButton.backgroundColor = [UIColor whiteColor];
        [detailButton setTitle:@"工时详情" forState:UIControlStateNormal];
        [detailButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        detailButton.layer.masksToBounds = YES;
        detailButton.layer.cornerRadius = 24;
        detailButton.layer.borderColor = [UIColor baseColor].CGColor;
        detailButton.layer.borderWidth = 0.5;
        [detailButton addTarget:self action:@selector(touchDetailButton) forControlEvents:UIControlEventTouchUpInside];
        [_tableFooterView addSubview:detailButton];
        
    }
    return _tableFooterView;
}

-(LPDurationView *)durationView{
    if (!_durationView) {
        _durationView = [[LPDurationView alloc]init];
    }
    return _durationView;
}

-(LPDateSelectView *)dateSelectView{
    if (!_dateSelectView) {
        _dateSelectView = [[LPDateSelectView alloc]init];
    }
    return _dateSelectView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
