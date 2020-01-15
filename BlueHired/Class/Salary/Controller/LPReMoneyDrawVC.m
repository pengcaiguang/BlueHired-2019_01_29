//
//  LPReMoneyDrawVC.m
//  BlueHired
//
//  Created by iMac on 2019/8/28.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPReMoneyDrawVC.h"
#import "LPRemoneyListVC.h"
#import "LPInvitationDrawVC.h"
#import "LPPrizeMoney.h"

@interface LPReMoneyDrawVC ()
@property (weak, nonatomic) IBOutlet UIView *HeadView;
@property (weak, nonatomic) IBOutlet UIView *HeadBGView;
@property (weak, nonatomic) IBOutlet UILabel *WorkName;
@property (weak, nonatomic) IBOutlet UILabel *InTime;
@property (weak, nonatomic) IBOutlet UILabel *MoneyTime;
@property (weak, nonatomic) IBOutlet UILabel *NormalLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIView *fromView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_form_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_WorkName_Top;


@property (nonatomic,strong) LPReMoneyDrawModel *model;

@end

@implementation LPReMoneyDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setNavigationButton];
   
    self.navigationItem.title = @"返费奖励领取";
    
    [self setfromUI];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,LENGTH_SIZE(375),LENGTH_SIZE(90));
    gl.startPoint = CGPointMake(1, 1);
    gl.endPoint = CGPointMake(0, 0);
    gl.colors = @[(__bridge id)[UIColor baseColor].CGColor,
                  (__bridge id)[UIColor colorWithHexString:@"#43CCFF"].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    
    [self.HeadBGView.layer addSublayer:gl];
    
    [self requestGetbillrecordExpList];
}

- (void)setNavigationButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"历史记录" style:UIBarButtonItemStyleDone target:self action:@selector(touchBarButton)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor baseColor]];
}

- (void)touchBarButton{
    LPRemoneyListVC *vc = [[LPRemoneyListVC alloc] init];
    vc.SuperVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setfromUI{
    [self.fromView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSInteger i = 0; i < self.ListModel.reMoneyDetailsList.count; i++) {
        LPReMoneyDrawDataDetailsModel *m = self.ListModel.reMoneyDetailsList[i];
        UILabel *MonthLabel = [[UILabel alloc] init];
        [self.fromView addSubview:MonthLabel];
        [MonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(LENGTH_SIZE(1));
            make.width.mas_offset(LENGTH_SIZE(89));
            make.top.mas_offset(i*LENGTH_SIZE(67));
            make.height.mas_offset(LENGTH_SIZE(66));
        }];
        MonthLabel.backgroundColor = [UIColor whiteColor];
        MonthLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        MonthLabel.font = FONT_SIZE(13);
        MonthLabel.textAlignment = NSTextAlignmentCenter;
        MonthLabel.text = m.reMoneyTime;
        
        UIButton *DrawBtn = [[UIButton alloc] init];
        [self.fromView addSubview:DrawBtn];
        [DrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(LENGTH_SIZE(-1));
            make.width.mas_offset(LENGTH_SIZE(89));
            make.top.mas_offset(i*LENGTH_SIZE(67));
            make.height.mas_offset(LENGTH_SIZE(66));
        }];
        DrawBtn.backgroundColor = [UIColor whiteColor];
        [DrawBtn setTitleColor:[UIColor colorWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
        DrawBtn.titleLabel.font = FONT_SIZE(13);
        DrawBtn.titleLabel.lineBreakMode = 0;
        DrawBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        DrawBtn.tag = i;
        if (m.delStatus.integerValue == 1) {        //待领取
            [DrawBtn setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
            [DrawBtn setTitle:@"点击领取" forState:UIControlStateNormal];
        }else if (m.delStatus.integerValue == 2){       //已领取
            [DrawBtn setTitleColor:[UIColor colorWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
            [DrawBtn setTitle:@"已领取" forState:UIControlStateNormal];
        }else if (m.delStatus.integerValue == 3){       //可领取并读取可领取时间字段
            NSString *avaStr = [NSString stringWithFormat:@"%@\n  可领取",m.avaTime];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:avaStr];
            NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:LENGTH_SIZE(5)];
            [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [avaStr length])];
            [DrawBtn setAttributedTitle:string forState:UIControlStateNormal];
            [DrawBtn setTitleColor:[UIColor colorWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
        }
        [DrawBtn addTarget:self action:@selector(TouchBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *money = [[UILabel alloc] init];
        [self.fromView addSubview:money];
        [money mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MonthLabel.mas_right).offset(LENGTH_SIZE(1));
            make.right.equalTo(DrawBtn.mas_left).offset(LENGTH_SIZE(-1));
            make.top.mas_offset(i*LENGTH_SIZE(67));
            make.height.mas_offset(LENGTH_SIZE(66));
        }];
        money.backgroundColor = [UIColor whiteColor];
        money.textColor = [UIColor colorWithHexString:@"#999999"];
        money.font = FONT_SIZE(13);
        money.numberOfLines = 0;
        if (m.money.length>0) {
            NSString *MoneyStr = [NSString stringWithFormat:@"%@\n%@",m.money,m.day];
            money.text = MoneyStr;
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:money.text];
            [string addAttributes:@{NSFontAttributeName:FONT_SIZE(14),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]} range:[money.text rangeOfString:m.money]];
            NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:LENGTH_SIZE(5)];
            [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [money.text length])];
            money.attributedText = string;
            money.textAlignment = NSTextAlignmentCenter;
        }else{
            money.text = m.day;
            money.textAlignment = NSTextAlignmentCenter;
        }
    }
    
    if (self.ListModel.workEndTime.length>0) {
        UILabel *dimission = [[UILabel alloc] init];
        [self.fromView addSubview:dimission];
        [dimission mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(LENGTH_SIZE(1));
            make.right.mas_offset(LENGTH_SIZE(-1));
            make.top.mas_offset(self.ListModel.reMoneyDetailsList.count*LENGTH_SIZE(67));
            make.height.mas_offset(LENGTH_SIZE(66));
        }];
        dimission.backgroundColor = [UIColor whiteColor];
        dimission.textColor = [UIColor colorWithHexString:@"#333333"];
        dimission.font = FONT_SIZE(13);
        dimission.textAlignment = NSTextAlignmentCenter;
        dimission.text = [NSString stringWithFormat:@"%@离职%@",[NSString convertStringToYYYNMMYDDR:self.ListModel.workEndTime],self.ListModel.diffDay.integerValue<15?@",入职未满15天":@""];
        self.LayoutConstraint_form_height.constant = (self.ListModel.reMoneyDetailsList.count +1)* LENGTH_SIZE(67);
    }else{
        self.LayoutConstraint_form_height.constant = self.ListModel.reMoneyDetailsList.count * LENGTH_SIZE(67);
    }
   
    

}


-(void)TouchBtn:(UIButton *)sender{
    LPReMoneyDrawDataDetailsModel *m = self.ListModel.reMoneyDetailsList[sender.tag];
    if (m.delStatus.integerValue == 1) {        //待领取
        LPPrizeDataMoney *Pmodel = [[LPPrizeDataMoney alloc] init];
        Pmodel.id = m.id;
        Pmodel.type = @"1";
        Pmodel.relationMoney = m.reMoney;
        Pmodel.relationMoneyTime = m.reMoneyTime;
        Pmodel.mechanismName = self.ListModel.mechanismName;
        Pmodel.title = m.title;

        LPInvitationDrawVC *vc = [[LPInvitationDrawVC alloc] init];
        vc.ReMoneyModel = m;
        vc.model = Pmodel;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        vc.block = ^{
            [sender setTitleColor:[UIColor colorWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
            [sender setTitle:@"已领取" forState:UIControlStateNormal];
        };
    }
}
 
- (void)setListModel:(LPReMoneyDrawDataModel *)ListModel{
    _ListModel = ListModel;
    [self addNodataViewHidden:YES];

    self.NormalLabel.hidden = YES;
    self.WorkName.hidden = NO;
    self.InTime.hidden = NO;
    self.MoneyTime.hidden = NO;
    self.LayoutConstraint_form_height.constant = LENGTH_SIZE(0);
    [self.fromView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.WorkName.text = [NSString stringWithFormat:@"企业：%@",ListModel.mechanismName];
    self.InTime.text = [NSString stringWithFormat:@"入职日期：%@",[NSString convertStringToYYYMMDD:ListModel.workBeginTime]];
    if (ListModel.prizeTime.length>0) {
        self.MoneyTime.text = [NSString stringWithFormat:@"奖励时间：%@",ListModel.prizeTime];
        self.LayoutConstraint_WorkName_Top.constant = LENGTH_SIZE(12);
        if (ListModel.reMoneyDetailsList.count>0 || ListModel.endReTime.length>0) {
            [self setfromUI];
        }else{
            [self addNodataViewHidden:NO];
        }
    }else{
        self.LayoutConstraint_WorkName_Top.constant = LENGTH_SIZE(24);
        self.MoneyTime.text = @"";
        [self addNodataViewHidden:NO];
    }
    
}

- (void)setModel:(LPReMoneyDrawModel *)model{
    _model = model;
    [self addNodataViewHidden:YES];
    if (model.data.count > 0) {
        
        self.ListModel = model.data[0];

        
        
//        [self addNodataViewHidden:YES];
    }else{
        self.NormalLabel.hidden = NO;
        self.WorkName.hidden = YES;
        self.InTime.hidden = YES;
        self.MoneyTime.hidden = YES;
        [self addNodataViewHidden:NO];
    }
}


-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.ScrollView.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]init];
        [self.ScrollView addSubview:noDataView];
        [noDataView image:nil text:@"暂无返费奖励~"];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(LENGTH_SIZE(90));
            make.height.mas_offset(Screen_Height - kNavBarHeight - kBottomBarHeight -LENGTH_SIZE(90 + 66));
//            make.bottom.mas_equalTo(LENGTH_SIZE(0));
            
        }];
        noDataView.hidden = hidden;
    }
}


#pragma mark - request
-(void)requestGetbillrecordExpList{
    NSDictionary *dic = @{
                          @"type":@"1"
                          };
    [NetApiManager requestGetbillrecordExpList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPReMoneyDrawModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
