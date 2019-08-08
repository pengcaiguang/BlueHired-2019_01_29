//
//  LPRegisterDetailVC.m
//  BlueHired
//
//  Created by peng on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRegisterDetailVC.h"
#import "LPRegisterDetailCell.h"
#import "LPRegisterDetailModel.h"
#import "LPSalaryBreakdownVC.h"

static NSString *LPRegisterDetailCellID = @"LPRegisterDetailCell";

@interface LPRegisterDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) NSMutableArray <UIButton *>*bottomButtonArray;
@property(nonatomic,strong) UIButton *timeButton;
@property(nonatomic,strong) UIView *monthView;
@property(nonatomic,strong) UIView *monthBackView;
@property(nonatomic,strong) NSMutableArray <UIButton *>*monthButtonArray;

@property(nonatomic,strong) NSString *currentDateString;
@property(nonatomic,assign) NSInteger month;

@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPRegisterDetailModel *model;
@property(nonatomic,strong) NSMutableArray <LPRegisterDetailDataListModel *>*listArray;

@property(nonatomic,strong) UILabel *monthLabel;
//@property(nonatomic,strong) UILabel *moneyLabel;
@property(nonatomic,strong) CustomIOSAlertView *CustomAlert;
@property(nonatomic,strong) UITextField *AlertTF;
@property(nonatomic,strong) LPRegisterDetailDataListModel *selectmodel;


@end

@implementation LPRegisterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.Type == 1) {
        self.navigationItem.title = @"邀请入职奖励";
    }else if (self.Type == 2){
        self.navigationItem.title = @"邀请注册奖励";
    }
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    self.currentDateString = [dateFormatter stringFromDate:currentDate];
    
    [dateFormatter setDateFormat:@"MM"];
    self.month = [dateFormatter stringFromDate:currentDate].integerValue;
    
    self.page = 1;
    [self setupUI];
    [self requestGetOnWork];
}
-(void)setupUI{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];

    
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(LENGTH_SIZE(44));
    }];
    bgView.backgroundColor = [UIColor baseColor];
    
//    UIImageView *imgView = [[UIImageView alloc]init];
//    [bgView addSubview:imgView];
//    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(14);
//        make.centerY.equalTo(bgView);
//        make.size.mas_equalTo(CGSizeMake(0, 20));
//    }];
//    imgView.image = [UIImage imageNamed:@"calendar"];
    
    self.timeButton = [[UIButton alloc]init];
    [bgView addSubview:self.timeButton];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
    }];
    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    [self.timeButton addTarget:self action:@selector(chooseMonth) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftImgView = [[UIButton alloc]init];
    [bgView addSubview:leftImgView];
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(LENGTH_SIZE(44), LENGTH_SIZE(44)));
        make.centerY.equalTo(self.timeButton);
        make.right.equalTo(self.timeButton.mas_left).offset(-10);
    }];
    [leftImgView setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    leftImgView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [leftImgView addTarget:self action:@selector(TouchLeftBt:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightImgView = [[UIButton alloc]init];
    [bgView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(LENGTH_SIZE(44), LENGTH_SIZE(44)));
        make.centerY.equalTo(self.timeButton);
        make.left.equalTo(self.timeButton.mas_right).offset(10);
    }];
    [rightImgView setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    rightImgView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [rightImgView addTarget:self action:@selector(TouchrightBt:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *headView = [[UIView alloc] init];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(bgView.mas_bottom).offset(0);
        if (self.Type == 1) {
            make.height.mas_equalTo(LENGTH_SIZE(0));
        }else if (self.Type == 2){
            make.height.mas_equalTo(LENGTH_SIZE(60));
        }
    }];
    headView.backgroundColor = [UIColor whiteColor];
    headView.clipsToBounds = YES;
    
    UILabel *MonthLabel = [[UILabel alloc] init];
    self.monthLabel = MonthLabel;
    [headView addSubview:MonthLabel];
    [MonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.right.mas_offset(LENGTH_SIZE(-13));
        make.centerY.equalTo(headView);
    }];
    MonthLabel.textColor = [UIColor baseColor];
    MonthLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
    MonthLabel.numberOfLines = 0;
    MonthLabel.text = @"说明：A邀请B注册，B入职满30天后才会开始计算A的邀请注册奖励。";
    
    
//    UILabel *MoneyLabel = [[UILabel alloc] init];
//    self.moneyLabel = MoneyLabel;
//    [headView addSubview:MoneyLabel];
//    [MoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(0);
//        make.right.mas_equalTo(LENGTH_SIZE(-13));
//        make.height.mas_equalTo(LENGTH_SIZE(60));
//    }];
//    MoneyLabel.textColor = [UIColor baseColor];
//    MoneyLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(LENGTH_SIZE(-49));
        } else {
            make.bottom.mas_equalTo(LENGTH_SIZE(-49));
        }
        if (self.Type == 1) {
            make.top.equalTo(headView.mas_bottom).offset(LENGTH_SIZE(0));
        }else if (self.Type == 2){
            make.top.equalTo(headView.mas_bottom).offset(LENGTH_SIZE(10));
        }
    }];
    
    UIButton *RegBtn = [[UIButton alloc] init];
    [self.view addSubview:RegBtn];
    [RegBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(LENGTH_SIZE(0));
        } else {
            make.bottom.mas_equalTo(LENGTH_SIZE(0));
        }
        make.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(49));
    }];
    [RegBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RegBtn.backgroundColor = [UIColor baseColor];
    RegBtn.titleLabel.font = FONT_SIZE(17);
    [RegBtn setTitle:@"领取奖励" forState:UIControlStateNormal];
    [RegBtn addTarget:self action:@selector(touchRegBtn:) forControlEvents:UIControlEventTouchUpInside];

}


-(void)touchRegBtn:(UIButton *)sender{
    LPSalaryBreakdownVC *vc = [[LPSalaryBreakdownVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.RecordDate = self.currentDateString;
    vc.type = 1;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}


-(void)TouchLeftBt:(UIButton *)sender{
    
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitMonth;//只比较天数差异
    NSDateComponents *delta = [calendar components:unit fromDate:[DataTimeTool dateFromString:self.currentDateString DateFormat:@"yyyy-MM"] toDate:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"] options:0];
    
    
    if (delta.month>=0) {
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [dateFormatter dateFromString:self.currentDateString];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
    self.currentDateString = [dateFormatter stringFromDate:StartDate];
    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    self.page = 1;
    [self requestGetOnWork];

    
}
-(void)TouchrightBt:(UIButton *)sender{
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitMonth;//只比较天数差异
    NSDateComponents *delta = [calendar components:unit fromDate:[DataTimeTool dateFromString:self.currentDateString DateFormat:@"yyyy-MM"] toDate:[NSDate date] options:0];
    
    
    if (delta.month<=0) {
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [dateFormatter dateFromString:self.currentDateString];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
    self.currentDateString = [dateFormatter stringFromDate:StartDate];
    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    self.page = 1;
    [self requestGetOnWork];
}


-(void)chooseMonth{
    NSComparisonResult sCOM= [[NSDate date] compare:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"]];
    
    if (sCOM == NSOrderedAscending) {
        
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"系统时间不对,请前往设置修改时间" message:nil textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        [alert show];
        return;
    }
    
    QFDatePickerView *datePickerView = [[QFDatePickerView  alloc]initDatePackerWith:[DataTimeTool dateFromString:self.currentDateString DateFormat:@"yyyy-MM"]
                                                                            minDate:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"]
                                                                            maxDate:[NSDate date]
                                                                           Response:^(NSString *str) {
                                                                               NSLog(@"str = %@", str);
                                                                               [self.timeButton setTitle:str forState:UIControlStateNormal];
                                                                               self.currentDateString = self.timeButton.titleLabel.text;
                                                                               self.page = 1;
                                                                               [self requestGetOnWork];
                                                                           }];
    
    [datePickerView show];
    
}

-(void)monthViewHidden{
    self.monthView.hidden = YES;
    self.monthBackView.hidden = YES;
}

-(void)touchMonthButton:(UIButton *)button{
    NSString *year = [self.currentDateString substringToIndex:4];
    self.currentDateString = [NSString stringWithFormat:@"%@-%02ld",year,button.tag+1];
    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    for (UIButton *button in self.monthButtonArray) {
        button.selected = NO;
        button.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    }
    button.selected = YES;
    button.backgroundColor = [UIColor baseColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self monthViewHidden];
    });
    self.page = 1;
    [self requestGetOnWork];
    
}



-(void)textFieldChanged:(UITextField *)textField{
    //
    
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    int kMaxLength = 10;
    NSString *toBeString = textField.text;
    // 获取键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                // 截取子串
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            // 截取子串
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}


-(void)setModel:(LPRegisterDetailModel *)model{
    _model = model;

//    self.monthLabel.text = [DataTimeTool getDataTime:self.currentDateString DateFormat:@"yyyy年MM月"];
//    self.moneyLabel.text = [NSString stringWithFormat:@"到账总计：%.2f元",model.data.totalMoney.floatValue];
    
    if ([self.model.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.relationList.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data.relationList];
            if (self.model.data.relationList.count<20) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableview reloadData];
        
        if (self.listArray.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
        
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
    
}
-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.tableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.tableview.frame))];
        [self.tableview addSubview:noDataView];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];

        noDataView.hidden = hidden;
    }
}
//-(void)addNodataViewHidden:(BOOL)hidden{
//    BOOL has = NO;
//    for (UIView *view in self.view.subviews) {
//        if ([view isKindOfClass:[LPNoDataView class]]) {
//            view.hidden = hidden;
//            has = YES;
//        }
//    }
//    if (!has) {
//        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectZero];
//        [self.view addSubview:noDataView];
//        [noDataView image:nil text:@"抱歉！没有相关记录！"];
//        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//            //            make.edges.equalTo(self.view);
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(48);
//            make.bottom.mas_equalTo(-96);
//        }];
//        noDataView.hidden = hidden;
//    }
//}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.Type == 1) {
        return 48;
    }
    return 66;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPRegisterDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:LPRegisterDetailCellID];
    cell.Type = self.Type;
    cell.model = self.listArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.Type == 2) {
        self.selectmodel = self.listArray[indexPath.row];
        CustomIOSAlertView *alertview = [[CustomIOSAlertView alloc] init];
        self.CustomAlert = alertview;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  LENGTH_SIZE(300), LENGTH_SIZE(177))];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *title = [[UILabel alloc] init];
        [view addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_offset(LENGTH_SIZE(22));
            make.left.right.mas_offset(0);
        }];
        title.textColor = [UIColor colorWithHexString:@"#333333"];
        title.font = [UIFont boldSystemFontOfSize:18];
        title.text = @"编辑备注";
        title.textAlignment = NSTextAlignmentCenter;
        
        UITextField *TF = [[UITextField alloc] init];
        self.AlertTF = TF;
        [view addSubview:TF];
        [TF mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_offset(LENGTH_SIZE(65));
            make.left.mas_offset(LENGTH_SIZE(20));
            make.right.mas_offset(LENGTH_SIZE(-20));
            make.height.mas_offset(LENGTH_SIZE(36));
        }];
        TF.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
        TF.layer.borderWidth = 1;
        TF.layer.cornerRadius = 6;
        TF.placeholder = @"请输入备注";
        [TF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

        UIButton *button = [[UIButton alloc] init];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(TF.mas_bottom).offset(LENGTH_SIZE(15));
            make.left.mas_offset(LENGTH_SIZE(20));
            make.right.mas_offset(LENGTH_SIZE(-20));
            make.height.mas_offset(LENGTH_SIZE(40));
        }];
        button.layer.cornerRadius = 6;
        button.backgroundColor = [UIColor baseColor];
        [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [button setTitle:@"保  存" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(Touchremark:) forControlEvents:UIControlEventTouchUpInside];
        
        alertview.containerView = view;
        alertview.buttonTitles=@[];
        [alertview setUseMotionEffects:true];
        [alertview setCloseOnTouchUpOutside:true];
        [alertview show];
    }
}

-(void)Touchremark:(UIButton *)sender{
    [self.CustomAlert close];
    [self requestUpdateRelationReg:self.selectmodel.id remark:self.AlertTF.text];
}


#pragma mark - request

-(void)requestGetOnWork{
    NSDictionary *dic;
    
    if (self.Type == 1) {
        dic = @{@"page":@(self.page),
                @"time":self.currentDateString
                };
    }else if (self.Type == 2){
        dic = @{@"page":@(self.page),
                @"time":self.currentDateString,
                @"type":@"1"
                };
    }
    
    [NetApiManager requestGetOnWorkWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPRegisterDetailModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



-(void)requestUpdateRelationReg:(NSString *)Modelid remark:(NSString *) remark{
 
 
    NSString *url = [NSString stringWithFormat:@"invite/update_relation_reg?id=%@&remark=%@",Modelid,remark];
    [NetApiManager requestUpdateRelationReg:nil URLString:url withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    self.selectmodel.remark = remark;
                    [self.tableview reloadData];
                    [self.view showLoadingMeg:@"更新备注成功" time:MESSAGE_SHOW_TIME];
                }else{
                    [self.view showLoadingMeg:@"更新备注失败，请稍后在试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
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
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];

        [_tableview registerNib:[UINib nibWithNibName:LPRegisterDetailCellID bundle:nil] forCellReuseIdentifier:LPRegisterDetailCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestGetOnWork];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestGetOnWork];
        }];
    }
    return _tableview;
}

-(UIView *)monthView{
    if (!_monthView) {
        _monthView = [[UIView alloc]init];
        [self.view addSubview:_monthView];
        [_monthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(48);
            make.bottom.mas_equalTo(0);
        }];
        _monthView.backgroundColor = [UIColor blackColor];
        _monthView.alpha = 0.5;
        _monthView.userInteractionEnabled = YES;
        _monthView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(monthViewHidden)];
        [_monthView addGestureRecognizer:tap];
        
        
        self.monthBackView = [[UIView alloc]init];
        [self.view addSubview:self.monthBackView];
        [self.monthBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(48);
            make.height.mas_equalTo(150);
        }];
        self.monthBackView.hidden = YES;
        self.monthBackView.backgroundColor = [UIColor whiteColor];
        
        self.monthButtonArray = [NSMutableArray array];
        
        for (int i = 0; i < 12; i++) {
            UIView *view = [[UIView alloc]init];
            view.frame = CGRectMake(i%4 * SCREEN_WIDTH/4, floor(i/4)*51, SCREEN_WIDTH/4, 51);
            view.backgroundColor = [UIColor whiteColor];
            [self.monthBackView addSubview:view];
            
            UIButton *button = [[UIButton alloc]init];
            [view addSubview:button];
            button.frame = CGRectMake((SCREEN_WIDTH/4-41)/2, 5, 41, 41);
            button.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithHexString:@"#939393"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 20.5;
            button.tag = i;
            [self.monthButtonArray addObject:button];
            [button addTarget:self action:@selector(touchMonthButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.monthButtonArray[self.month-1].selected = YES;
        self.monthButtonArray[self.month-1].backgroundColor = [UIColor baseColor];
        
    }
    return _monthView;
    
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
