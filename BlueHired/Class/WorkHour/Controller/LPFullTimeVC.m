//
//  LPFullTimeVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/10.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPFullTimeVC.h"
#import "LPDurationView.h"
#import "LPDateSelectView.h"
#import "LPFullTimeDetailVC.h"

@interface LPFullTimeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *tableFooterView;
@property(nonatomic,strong) UIButton *timeButton;

@property(nonatomic,strong) LPDateSelectView *dateSelectView;
@property(nonatomic,strong) LPDurationView *durationView;

@property(nonatomic,strong) NSString *currentDateString;
@property(nonatomic,assign) NSInteger month;

@end

@implementation LPFullTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"正式工";
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    self.currentDateString = [dateFormatter stringFromDate:currentDate];
    
    [dateFormatter setDateFormat:@"MM"];
    self.month = [dateFormatter stringFromDate:currentDate].integerValue;
    
    [self setupUI];
    [self requestQueryCurrecord];
    [self requestQueryNormalrecord];
    
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
    
    self.timeButton = [[UIButton alloc]init];
    [bgView addSubview:self.timeButton];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
    }];
    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    [self.timeButton addTarget:self action:@selector(selectCalenderButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *leftImgView = [[UIImageView alloc]init];
    [bgView addSubview:leftImgView];
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 12));
        make.centerY.equalTo(self.timeButton);
        make.right.equalTo(self.timeButton.mas_left).offset(-10);
    }];
    leftImgView.image = [UIImage imageNamed:@"left_arrow"];
    
    UIImageView *rightImgView = [[UIImageView alloc]init];
    [bgView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 12));
        make.centerY.equalTo(self.timeButton);
        make.left.equalTo(self.timeButton.mas_right).offset(10);
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

#pragma mark - tagter
-(void)selectCalenderButton:(UIButton *)button{
    self.dateSelectView.hidden = NO;
    WEAK_SELF()
    self.dateSelectView.block = ^(NSString *string) {
        weakSelf.currentDateString = string;
        [weakSelf.timeButton setTitle:string forState:UIControlStateNormal];
        [weakSelf requestQueryCurrecord];
    };
}

#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"正常上班";
            cell.imageView.image = [UIImage imageNamed:@"zhengchangshangban"];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"类型";
        }else {
            cell.textLabel.text = @"时长";
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"加班记录";
            cell.imageView.image = [UIImage imageNamed:@"jiabanjilu"];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"类型";
        }else {
            cell.textLabel.text = @"时长";
        }
    }else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"请假记录";
            cell.imageView.image = [UIImage imageNamed:@"qingjiajilu"];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"类型";
        }else {
            cell.textLabel.text = @"时长";
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 1 || indexPath.row == 2) {
        self.durationView.hidden = NO;
        self.durationView.type = indexPath.row;
        self.durationView.block = ^(NSString *string) {
            cell.detailTextLabel.text = string;
        };
    }
}

#pragma mark - target
-(void)touchDetailButton{
    LPFullTimeDetailVC *vc = [[LPFullTimeDetailVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request
-(void)requestQueryCurrecord{
    NSDictionary *dic = @{
                          @"type":@(0),
                          @"day":self.currentDateString
                          };
    [NetApiManager requestQueryCurrecordWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestQueryNormalrecord{
    NSDictionary *dic = @{
                          @"month":@(self.month)
                          };
    [NetApiManager requestQueryNormalrecordWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            
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
