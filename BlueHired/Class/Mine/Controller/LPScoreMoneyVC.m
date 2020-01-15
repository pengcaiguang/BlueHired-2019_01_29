//
//  LPScoreMoneyVC.m
//  BlueHired
//
//  Created by iMac on 2019/7/26.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPScoreMoneyVC.h"
#import "LPUndergoWebVC.h"
#import "LPScoreMoneyModel.h"
#import "LPGetScoreMoneyRecordModel.h"
#import "LPScoreMoneyCell.h"
#import "NSTimer+block.h"

static NSString *LPScoreMoneyCellID = @"LPScoreMoneyCell";

@interface LPScoreMoneyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *ScoreTitle;

@property (weak, nonatomic) IBOutlet UILabel *MinuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *SecondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *MinuteUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *SecondsUnitLabel;

@property (weak, nonatomic) IBOutlet UILabel *TotalMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *ableScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *UserMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *EndLabel;

@property (weak, nonatomic) IBOutlet UIButton *RightBtn;
@property (weak, nonatomic) IBOutlet UIButton *LeftBtn;

@property (weak, nonatomic) IBOutlet UIButton *GetScoreBtn;

@property (weak, nonatomic) IBOutlet UIButton *RuleBtn;
@property (weak, nonatomic) IBOutlet UIButton *RecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *AllRecordBtn;

@property (weak, nonatomic) IBOutlet IQTextView *RuleTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Layoutconstraint_View_height;


@property (nonatomic,strong) LPScoreMoneyModel *model;


@property (nonatomic,weak) NSTimer *countDownTimer;
@property (nonatomic,assign) NSInteger seconds;//倒计时

//@property (nonatomic,assign) NSTimer *StartcountDownTimer;
//@property (nonatomic,assign) NSInteger Startseconds;//倒计时

@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UITableView *Alltableview;
@property(nonatomic,strong) NSMutableArray <LPGetScoreMoneyRecordDataModel *>*listArray;
@property(nonatomic,strong) NSMutableArray <LPGetScoreMoneyRecordDataModel *>*AlllistArray;
@property (nonatomic,strong) LPGetScoreMoneyRecordModel *RecordModel;
@property (nonatomic,strong) LPGetScoreMoneyRecordModel *AllRecordModel;


@property(nonatomic,assign) NSInteger page;
@property(nonatomic,assign) NSInteger Allpage;


@property(nonatomic,assign) BOOL isShow;


@end

@implementation LPScoreMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"积分兑换";
    
    self.Layoutconstraint_View_height.constant = SCREEN_HEIGHT - LENGTH_SIZE(322)-kNavBarHeight + kBottomBarHeight ;
  
     self.ScrollView.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
        [self requestGetScoreMoney];
         self.Allpage = 1;
        [self requestGetScoreMoneyRecord:@"2"];
        self.page = 1;
        [self requestGetScoreMoneyRecord:@"1"];
    }];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isShow = YES;
    [self requestGetScoreMoney];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.isShow = NO;

    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
    
//    if (self.StartcountDownTimer) {
//        [self.StartcountDownTimer invalidate];
//        self.StartcountDownTimer = nil;
//    }
    
}

- (void)initTableView{
    [self.RuleBtn.superview  addSubview:self.tableview];
    [self.RuleBtn.superview  addSubview:self.Alltableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.RuleBtn.mas_bottom).offset(1);
        make.left.right.bottom.mas_offset(0);
    }];
    
    [self.Alltableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.RuleBtn.mas_bottom).offset(1);
        make.left.right.bottom.mas_offset(0);
    }];
    
    self.tableview.hidden = YES;
    self.Alltableview.hidden = YES;

}


//兑换
- (IBAction)TouchGetScore:(UIButton *)sender {
    
    CGFloat Money =  [[self.UserMoneyLabel.text substringToIndex:self.UserMoneyLabel.text.length -1] floatValue];

    if (self.model.data.id.integerValue == 0 || Money == 0.0) {
        return;
    }
    
    [self requestGetScoreMoney:[NSString stringWithFormat:@"%.1f",Money]
                         Score:[NSString stringWithFormat:@"%.0f",Money*self.model.data.consumeScore.integerValue]];
}


//规则
- (IBAction)TouchRuleRecord:(UIButton *)sender {
    if (sender.selected == NO) {
        self.RuleBtn.selected = NO;
        self.RecordBtn.selected = NO;
        self.AllRecordBtn.selected = NO;
        sender.selected = YES;
        
        if (sender == self.RuleBtn){        //兑换规则
            self.RuleTextView.hidden = NO;
            self.tableview.hidden = YES;
            self.Alltableview.hidden = YES;
        }else if (sender == self.RecordBtn){        //个人记录
            self.RuleTextView.hidden = YES;
            self.tableview.hidden = NO;
            self.Alltableview.hidden = YES;
            if (self.listArray.count == 0) {
                self.page = 1;
                [self requestGetScoreMoneyRecord:@"1"];
            }
        }else if (sender == self.AllRecordBtn){     //所以记录
            self.RuleTextView.hidden = YES;
            self.tableview.hidden = YES;
            self.Alltableview.hidden = NO;
            if (self.AlllistArray.count == 0) {
                self.Allpage = 1;
                [self requestGetScoreMoneyRecord:@"2"];
            }
        }
        
    }


}

//加减
- (IBAction)TouchLeftRight:(UIButton *)sender {
    if (sender.selected == YES) {
        
        CGFloat Money =  [[self.UserMoneyLabel.text substringToIndex:self.UserMoneyLabel.text.length -1] floatValue];
        
        if (sender == self.LeftBtn) {
            Money -=  0.1;
        }else if (sender == self.RightBtn){
            Money +=  0.1;
        }
    
        self.UserMoneyLabel.text = [NSString stringWithFormat:@"%.1f元",Money];
        [self.GetScoreBtn setTitle:[NSString stringWithFormat:@"消耗%.0f积分 兑换",
                                    Money*
                                    self.model.data.consumeScore.floatValue]
                          forState:UIControlStateNormal];
        
        if ([self.UserMoneyLabel.text isEqualToString:@"0.1元"]) {
            self.LeftBtn.selected = NO;
        }else{
            self.LeftBtn.selected = YES;
        }
        
        if ([self.UserMoneyLabel.text isEqualToString:[NSString stringWithFormat:@"%.1f元",self.model.data.RealityremainMoney.floatValue]]){
            self.RightBtn.selected = NO;
        }else{
            self.RightBtn.selected = YES;
        }
        
    }
    
}

//积分规则
- (IBAction)TouchToWebView:(UIButton *)sender {
    LPUndergoWebVC *vc = [[LPUndergoWebVC alloc]init];
    vc.type = 2;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)setModel:(LPScoreMoneyModel *)model{
    _model = model;
   
    if (self.isShow == NO) {
        return;
    }
 
    
    CGFloat Reality = floor(self.model.data.ableScore.floatValue/self.model.data.consumeScore.floatValue*10.0)/10.0;
    
    if (Reality < model.data.remainMoney.floatValue) {
        model.data.RealityremainMoney = [NSString stringWithFormat:@"%.1f",Reality];
    }else{
        model.data.RealityremainMoney = model.data.remainMoney;
    }
    
    NSArray *ruleArr = [model.data.rule componentsSeparatedByString:@"#"];
    if (ruleArr.count>=3) {
            self.RuleTextView.text = [NSString stringWithFormat:@"1. 每天有两次兑换时间，分别为：%@。每次发放固定的兑换额度，先兑先得，兑完为止。\n\n2.  使用积分兑换余额的兑换比例为：%@；但每人每天的兑换上限为%@；\n\n3. 凡通过非正常手段获取积分或者进行积分兑换行为，一经查证，我们将不再对其提供相应服务。",ruleArr[0],ruleArr[1],ruleArr[2]];
    }
    
    self.TotalMoneyLabel.text = [NSString stringWithFormat:@"本次剩余兑换金额 %.1f 元",model.data.totalMoney.floatValue];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.TotalMoneyLabel.text];
    [string addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(18)]}
                    range:[self.TotalMoneyLabel.text rangeOfString:[NSString stringWithFormat:@"%.1f",model.data.totalMoney.floatValue]]];
    self.TotalMoneyLabel.attributedText = string;
    self.TotalMoneyLabel.hidden = NO;
    
    self.ableScoreLabel.text = [NSString stringWithFormat:@"当前积分：%ld",(long)model.data.ableScore.integerValue];
    
    self.UserMoneyLabel.text = [NSString stringWithFormat:@"%.1f元",model.data.RealityremainMoney.floatValue];
    self.remainMoneyLabel.text = [NSString stringWithFormat:@"今天剩余兑换额度%.1f元",model.data.remainMoney.floatValue];
    [self.GetScoreBtn setTitle:[NSString stringWithFormat:@"消耗%.0f积分 兑换",model.data.RealityremainMoney.floatValue*model.data.consumeScore.floatValue]
                      forState:UIControlStateNormal];

    
    self.RightBtn.selected = NO;
    self.LeftBtn.selected = NO;
    
    NSInteger CountDown = ceilf((model.data.endTime.integerValue - model.data.time.integerValue)/1000.0);

    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        self.GetScoreBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    }
    self.ScoreTitle.hidden = NO;
    self.EndLabel.hidden = YES;

    if (model.data.activityStatus.integerValue == 1) {
        self.MinuteLabel.hidden = YES;
        self.MinuteUnitLabel.hidden = YES;
        self.SecondsLabel.hidden = YES;
        self.SecondsUnitLabel.hidden = YES;
        self.ScoreTitle.hidden = YES;
        self.TotalMoneyLabel.hidden = YES;
        self.EndLabel.hidden = NO;

        
        self.RightBtn.selected = NO;
        self.LeftBtn.selected = NO;
        self.GetScoreBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
        return;
    }
    
    
    if (model.data.id.integerValue == 0 || CountDown <= 0) {
        self.ScoreTitle.text = [NSString stringWithFormat:@"下次兑换时间：%@",model.data.activityTime];
        self.MinuteLabel.hidden = YES;
        self.MinuteUnitLabel.hidden = YES;
        self.SecondsLabel.hidden = YES;
        self.SecondsUnitLabel.hidden = YES;
        
        self.RightBtn.selected = NO;
        self.LeftBtn.selected = NO;
        self.GetScoreBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
        
        // 还有多久开始
        NSInteger startCountDown = ceilf(( model.data.beginTime.integerValue - model.data.time.integerValue)/1000.0);
      
        __weak LPScoreMoneyVC * weakSelf = self;
        self.seconds = startCountDown;
//        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        self.countDownTimer = [NSTimer repeatWithInterval:1 block:^(NSTimer *timer) {
            //收到timer回调
            [weakSelf timeFireMethod];
        }];
        
    } else {     //活动期间
        self.ScoreTitle.text = @"兑换倒计时：";
        self.MinuteLabel.hidden = NO;
        self.MinuteUnitLabel.hidden = NO;
        self.SecondsLabel.hidden = NO;
        self.SecondsUnitLabel.hidden = NO;
        
        self.RightBtn.selected = NO;
        self.LeftBtn.selected = YES;
        self.GetScoreBtn.backgroundColor = [UIColor baseColor];
        // 启动倒计时后会每秒钟调用一次方法
        self.seconds = CountDown;
        WEAK_SELF()
        self.MinuteLabel.text = [NSString stringWithFormat:@"%.2ld", self.seconds/60];
        self.SecondsLabel.text = [NSString stringWithFormat:@"%.2ld", self.seconds%60];
        
        self.countDownTimer = [NSTimer repeatWithInterval:1 block:^(NSTimer *timer) {
            //收到timer回调
            [weakSelf timeFireMethod];
        }];
        
    }
    
    if (model.data.RealityremainMoney.floatValue == 0.0) {
        self.RightBtn.selected = NO;
        self.LeftBtn.selected = NO;
        self.GetScoreBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    }else if (model.data.RealityremainMoney.floatValue > 0.0 && model.data.RealityremainMoney.floatValue <= 0.11){
        self.RightBtn.selected = NO;
        self.LeftBtn.selected = NO;
    }
 
    //倒计时
    
}

-(void)timeFireMethod{
    _seconds--;
    
    NSLog(@"倒计时 = %ld",(long)_seconds);
    
    if (self.model.data.id.integerValue != 0) {
        self.MinuteLabel.text = [NSString stringWithFormat:@"%.2ld", _seconds/60];
        self.SecondsLabel.text = [NSString stringWithFormat:@"%.2ld", _seconds%60];
    }

    if(_seconds ==0){
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        
        if (self.model.data.id.integerValue == 0) {
            [self requestGetScoreMoney];
        }else{
            [self requestGetScoreMoney];
        }
    }
}


-(void)setRecordModel:(LPGetScoreMoneyRecordModel *)RecordModel{
    _RecordModel = RecordModel;
    if ([RecordModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (RecordModel.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:RecordModel.data];
            [self.tableview reloadData];
        }else{
            if (self.page == 1) {
                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (self.listArray.count == 0) {
            self.tableview.mj_footer.alpha = 0;
            [self addNodataViewHidden:NO];
        }else{
            self.tableview.mj_footer.alpha = 1;
            [self addNodataViewHidden:YES];
        }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}

- (void)setAllRecordModel:(LPGetScoreMoneyRecordModel *)AllRecordModel{
    _AllRecordModel = AllRecordModel;
    if ([AllRecordModel.code integerValue] == 0) {
        if (self.Allpage == 1) {
            self.AlllistArray = [NSMutableArray array];
        }
        if (AllRecordModel.data.count > 0) {
            self.Allpage += 1;
            [self.AlllistArray addObjectsFromArray:AllRecordModel.data];
            [self.Alltableview reloadData];
        }else{
            if (self.Allpage == 1) {
                [self.Alltableview reloadData];
            }else{
                [self.Alltableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (self.AlllistArray.count == 0) {
            self.Alltableview.mj_footer.alpha = 0;
            [self addALLNodataViewHidden:NO ];
        }else{
            self.Alltableview.mj_footer.alpha = 1;
            [self addALLNodataViewHidden:YES];
        }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}

-(void)addNodataViewHidden:(BOOL)hidden {
    BOOL has = NO;
    LPNoDataView *noDataView ;
    for (UIView *view in self.tableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            noDataView = (LPNoDataView *)view;
            has = YES;
        }
    }
    if (!has) {
        noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(231))];
        [noDataView image:[UIImage new] text:@"暂无兑换记录~"];
        noDataView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];

        [self.tableview addSubview:noDataView];
        noDataView.hidden = hidden;
    }
    
}

-(void)addALLNodataViewHidden:(BOOL)hidden {
    BOOL has = NO;
    LPNoDataView *noDataView ;
    for (UIView *view in self.Alltableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            noDataView = (LPNoDataView *)view;
            has = YES;
        }
    }
    if (!has) {
        noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(231))];
        [noDataView image:[UIImage new] text:@"暂无兑换记录~"];
        noDataView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self.Alltableview addSubview:noDataView];
        noDataView.hidden = hidden;
    }
    
}



#pragma mark - TableViewDelegate & Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(60);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.Alltableview) {
        return self.AlllistArray.count;
    }
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPScoreMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:LPScoreMoneyCellID];
    if (tableView == self.Alltableview) {
        cell.type = 2;
        cell.model = self.AlllistArray[indexPath.row];
    }else{
        cell.type = 1;
        cell.model = self.listArray[indexPath.row];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
}



#pragma mark - request
-(void)requestGetScoreMoney{
    NSDictionary *dic = @{};
    WEAK_SELF()
    [NetApiManager requestGetScoreMoney:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [weakSelf.ScrollView.mj_header endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                weakSelf.model = [LPScoreMoneyModel mj_objectWithKeyValues:responseObject];
            }else{
                [weakSelf.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [weakSelf.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestGetScoreMoney:(NSString *)money Score:(NSString *) Score{

    NSString *UrlStr = [NSString stringWithFormat:@"prize/insert_score_money_record?money=%@&score=%@&id=%@",money,Score,self.model.data.id];
    
    [NetApiManager requestInsertScoremoney:nil URLString:UrlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.ScrollView.mj_header endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self requestGetScoreMoney];
                    
                    [LPTools AlertIntegralView:[NSString stringWithFormat:@"%@元兑换成功！",money]];
                }else{
                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestGetScoreMoneyRecord:(NSString *) Type{
    NSDictionary *dic = @{
                          @"type":Type,
                          @"page":[NSString stringWithFormat:@"%ld",(long)(Type.integerValue ==1 ? self.page :self.Allpage)]
                          };
    
    [NetApiManager requestGetScoreMoneyRecord:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
        [self.Alltableview.mj_header endRefreshing];
        [self.Alltableview.mj_footer endRefreshing];

        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (Type.integerValue == 1) {
                    self.RecordModel = [LPGetScoreMoneyRecordModel mj_objectWithKeyValues:responseObject];
                }else if (Type.integerValue == 2){
                    self.AllRecordModel = [LPGetScoreMoneyRecordModel mj_objectWithKeyValues:responseObject];
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
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_tableview registerNib:[UINib nibWithNibName:LPScoreMoneyCellID bundle:nil] forCellReuseIdentifier:LPScoreMoneyCellID];
//        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
//            self.page = 1;
//            [self requestGetScoreMoneyRecord:@"1"];
//        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestGetScoreMoneyRecord:@"1"];
        }];
    }
    return _tableview;
}

- (UITableView *)Alltableview{
    if (!_Alltableview) {
        _Alltableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _Alltableview.delegate = self;
        _Alltableview.dataSource = self;
        _Alltableview.tableFooterView = [[UIView alloc]init];
        _Alltableview.rowHeight = UITableViewAutomaticDimension;
        _Alltableview.estimatedRowHeight = 0;
        _Alltableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _Alltableview.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _Alltableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_Alltableview registerNib:[UINib nibWithNibName:LPScoreMoneyCellID bundle:nil] forCellReuseIdentifier:LPScoreMoneyCellID];
//        _Alltableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
//            self.Allpage = 1;
//            [self requestGetScoreMoneyRecord:@"2"];
//        }];
        _Alltableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestGetScoreMoneyRecord:@"2"];
        }];
    }
    return _Alltableview;
}



@end
