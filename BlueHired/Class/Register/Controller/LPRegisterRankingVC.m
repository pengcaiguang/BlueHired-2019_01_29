//
//  LPRegisterRankingVC.m
//  BlueHired
//
//  Created by iMac on 2019/11/7.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPRegisterRankingVC.h"
#import "LPInviteRankListModel.h"
#import "LPRegisterRankRecordCell.h"
#import "LPRegisterRankListCell.h"

static NSString *LPRegisterRankRecordCellID = @"LPRegisterRankRecordCell";
static NSString *LPRegisterRankListCellID = @"LPRegisterRankListCell";


@interface LPRegisterRankingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) LPInviteRankListModel *modelList;
@property (nonatomic, strong) LPInviteRankListModel *model;
@property (nonatomic, strong) NSMutableArray <LPInviteRankListInviteRankModel *>*listArray;
@property (nonatomic, strong) UIButton *LeftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, assign) NSInteger SelectType;
@property (nonatomic, strong) UIImageView *GIFImage;
@property (nonatomic, strong) UIView *rulesView;
@property (nonatomic, strong) UIView *bgView;



@end

@implementation LPRegisterRankingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请注册月排名";
    [self initView];
    [self initRulesView];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(LENGTH_SIZE(190));
    }];

    self.page = 1;
    [self requestQueryinviteRecord];
    [self requestQueryinviteRankList];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //加在这里是OK的


}

-(void)initView{
    UIView *HeadView = [[UIView alloc] init];
    [self.view addSubview:HeadView];
    [HeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(190));
    }];
    
    UIImageView *bgImage = [[UIImageView alloc] init];
    [HeadView addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
    bgImage.image = [UIImage imageNamed:@"Ranking_list_bg"];
    
    UIButton *rulesBtn = [[UIButton alloc] init];
    [HeadView addSubview:rulesBtn];
    [rulesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(13));
        make.right.mas_offset(LENGTH_SIZE(-13));
        make.width.mas_offset(LENGTH_SIZE(72));
        make.height.mas_offset(LENGTH_SIZE(24));
    }];
    rulesBtn.layer.cornerRadius = LENGTH_SIZE(12);
    rulesBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    rulesBtn.layer.borderWidth = LENGTH_SIZE(1);
    [rulesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rulesBtn setTitle:@"奖励规则" forState:UIControlStateNormal];
    rulesBtn.titleLabel.font = FONT_SIZE(13);
    [rulesBtn addTarget:self action:@selector(TouchrulesBtn:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *LeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, LENGTH_SIZE(140), SCREEN_WIDTH/2, LENGTH_SIZE(50))];
    [HeadView addSubview:LeftBtn];
    self.LeftBtn = LeftBtn;
//    [LeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.mas_offset(0);
//        make.width.mas_offset(SCREEN_WIDTH/2);
//        make.height.mas_offset(LENGTH_SIZE(50));
//    }];
    LeftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    [LeftBtn setTitle:@"本月排名" forState:UIControlStateNormal];
    [LeftBtn setTitleColor:[UIColor colorWithHexString:@"#964E12"] forState:UIControlStateSelected];
    [LeftBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [LeftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [LeftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FDCE3A"]] forState:UIControlStateSelected];
    [LeftBtn addTarget:self action:@selector(TouchSelectTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    LeftBtn.selected = YES;
    [self setViewShapeLayer:self.LeftBtn CornerRadii:18.0 byRoundingCorners:UIRectCornerTopLeft];

    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, LENGTH_SIZE(140), SCREEN_WIDTH/2, LENGTH_SIZE(50))];
    [HeadView addSubview:rightBtn];
    self.rightBtn = rightBtn;
//    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.right.mas_offset(0);
//        make.width.mas_offset(SCREEN_WIDTH/2);
//        make.height.mas_offset(LENGTH_SIZE(50));
//    }];
    rightBtn.titleLabel.font = FONT_SIZE(16);
    [rightBtn setTitle:@"我的历史排名" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#964E12"] forState:UIControlStateSelected];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FDCE3A"]] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(TouchSelectTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
                         
    [self setViewShapeLayer:self.rightBtn CornerRadii:18.0 byRoundingCorners:UIRectCornerTopRight];

    UIImageView *GIFImage = [[UIImageView alloc] init];
    [HeadView addSubview:GIFImage];
    self.GIFImage = GIFImage;
    [GIFImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.with.mas_offset(LENGTH_SIZE(21));
        make.right.mas_offset(LENGTH_SIZE(-18));
        make.bottom.mas_offset(LENGTH_SIZE(-25));
    }];
    GIFImage.image = [UIImage animatedImageNamed:@"Registerlabel" duration:1.0];
    GIFImage.hidden = YES;
}

- (void)initRulesView{
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, LENGTH_SIZE(337)+kBottomBarHeight)];
    View.backgroundColor = [UIColor whiteColor];
    self.rulesView = View;
    UILabel *TitleLabel = [[UILabel alloc] init];
    [View addSubview:TitleLabel];
    [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(50));
    }];
    TitleLabel.text = @"奖励规则";
    TitleLabel.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
    TitleLabel.font = FONT_SIZE(17);
    TitleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *DelBtn = [[UIButton alloc] init];
    [View addSubview:DelBtn];
    [DelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(TitleLabel);
        make.right.mas_offset(LENGTH_SIZE(-13));
    }];
    [DelBtn setImage:[UIImage imageNamed:@"cancel2"] forState:UIControlStateNormal];
    [DelBtn addTarget:self action:@selector(hiddenSelect) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineV = [[UIView alloc] init];
    [View addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(TitleLabel.mas_bottom).offset(0);
        make.right.left.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(0.5));
    }];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    
    UILabel *ContentLabel = [[UILabel alloc] init];
    [View addSubview:ContentLabel];
    [ContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineV.mas_bottom).offset(LENGTH_SIZE(26));
        make.left.mas_offset(LENGTH_SIZE(15));
        make.right.mas_offset(LENGTH_SIZE(-15));
    }];
    ContentLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    ContentLabel.font = FONT_SIZE(15);
    ContentLabel.numberOfLines = 0;
    ContentLabel.text = @"1. 每个自然月的月底进行统计结算，进入排行榜前十的，均可获得奖励。\n\n2. 月邀请注册排行榜前十获得奖励如下：\n    第一名：10000积分、第二名：9000积分、\n    第三名：8000积分、第四名：7000积分、\n    第五名：6000积分、第六名：5000积分、\n    第七名：4000积分、第八名：3000积分、\n    第九名：2000积分、第十名：1000积分\n\n3. 本平台保留该活动的解释权。";
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.rulesView];
    
}


-(void)setRulesHidden:(BOOL)hidden{
    if (hidden) {
              
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0;
            self.rulesView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CGRectGetHeight(self.rulesView.frame));
        } completion:^(BOOL finished) {
   
        }];
    }else{
          [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0.5;
            self.rulesView.frame = CGRectMake(0, SCREEN_HEIGHT-CGRectGetHeight(self.rulesView.frame), SCREEN_WIDTH, CGRectGetHeight(self.rulesView.frame));
        }completion:^(BOOL finished){

        }];
    }
}


//view单边圆角设置
- (void)setViewShapeLayer:(UIView *) View CornerRadii:(CGFloat) Radius byRoundingCorners:(UIRectCorner)corners{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(View.bounds.origin.x,
                                                                                View.bounds.origin.y,
                                                                                View.bounds.size.width,
                                                                                View.bounds.size.height)
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(LENGTH_SIZE(Radius), 0.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(View.bounds.origin.x,
                                 View.bounds.origin.y,
                                 View.bounds.size.width,
                                 View.bounds.size.height) ;
    maskLayer.path = maskPath.CGPath;
    View.layer.mask = maskLayer;
}


#pragma mark - Touch
- (void)TouchSelectTypeBtn:(UIButton *)sender{
 
    self.rightBtn.adjustsImageWhenDisabled  = NO;
    self.LeftBtn.adjustsImageWhenDisabled  = NO;
    
    self.rightBtn.enabled  = NO;
    self.LeftBtn.enabled  = NO;
    
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           self.rightBtn.enabled  = YES;
           self.LeftBtn.enabled  = YES;
       });
    
    if (!sender.selected) {

        if (sender == self.LeftBtn) {
            self.SelectType = 0;
            self.rightBtn.selected = NO;
            self.rightBtn.titleLabel.font = FONT_SIZE(16);
            self.LeftBtn.selected = YES;
            self.LeftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];

        }else{
            self.SelectType = 1;
            self.LeftBtn.selected = NO;
            self.LeftBtn.titleLabel.font = FONT_SIZE(16);
            self.rightBtn.selected = YES;
            self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        }
        [self.tableview reloadData];
        
        if (self.model.data.inviteRankList.count<20 || self.SelectType == 0  ) {
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        } else{
            [self.tableview.mj_footer resetNoMoreData];
        }
        
        if (self.listArray.count == 0 && self.SelectType == 1) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
        
    }
}

- (void)TouchrulesBtn:(UIButton *)sender{
    [self setRulesHidden:NO];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.SelectType == 1) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.SelectType == 1){
        return LENGTH_SIZE(30);
    }
    return LENGTH_SIZE(24);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.SelectType == 1) {
        UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(30))];
               View.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        NSArray *arr = @[@"月份",@"邀请注册",@"排名",@"奖励"];
        for (NSInteger i =0 ; i < arr.count; i++) {
            UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/arr.count, 0, SCREEN_WIDTH/arr.count, LENGTH_SIZE(30))];
            [View addSubview:Label];
            Label.textColor = [UIColor colorWithHexString:@"#666666"];
            Label.font = FONT_SIZE(14);
            Label.textAlignment = NSTextAlignmentCenter;
            Label.text = arr[i];
        }
        
        return View;
    }else{
        UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(24))];
        View.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];

        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(LENGTH_SIZE(13), 0, SCREEN_WIDTH-LENGTH_SIZE(13), LENGTH_SIZE(24))];
        [View addSubview:Label];
        Label.textColor = [UIColor colorWithHexString:@"#666666"];
        Label.font = FONT_SIZE(12);
        if (section == 0) {
            Label.text = @"我的排名";
        }else{
            Label.text = @"全部排名";
        }
        return View;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.SelectType == 1) {
            return self.listArray.count;
        }else{
            return 1;
        }
    }
    
    return self.modelList.data.inviteRankList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.SelectType == 1) {
        return LENGTH_SIZE(45);
    }
    return LENGTH_SIZE(50);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.SelectType == 1){
            LPRegisterRankRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:LPRegisterRankRecordCellID];
            cell.model = self.listArray[indexPath.row];
            return cell;
        }else{
            LPRegisterRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:LPRegisterRankListCellID];
            cell.model = self.modelList.data.inviteRank;
            if (self.modelList.data.inviteRank.rank.integerValue>0) {
                if (self.modelList.data.inviteRank.rank.integerValue>3) {
                    [cell.RankBtn setTitle:[NSString stringWithFormat:@"%ld.",(long)self.modelList.data.inviteRank.rank.integerValue] forState:UIControlStateNormal];
                    [cell.RankBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                    [cell.RankBtn setImage:nil forState:UIControlStateNormal];
                }else{
                    [cell.RankBtn setTitle:@"" forState:UIControlStateNormal];
                    [cell.RankBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Ranking_no%ld",(long)self.modelList.data.inviteRank.rank.integerValue]] forState:UIControlStateNormal];
                }
            }else{
                [cell.RankBtn setTitle:@"未入榜" forState:UIControlStateNormal];
                [cell.RankBtn setTitleColor:[UIColor colorWithHexString:@"#FF5353"] forState:UIControlStateNormal];
                [cell.RankBtn setImage:[UIImage new] forState:UIControlStateNormal];
                
            }
            return cell;
        }
    }else{
        LPRegisterRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:LPRegisterRankListCellID];
        cell.model = self.modelList.data.inviteRankList[indexPath.row];
        if (indexPath.row>2) {
            [cell.RankBtn setTitle:[NSString stringWithFormat:@"%ld.",(long)indexPath.row+1] forState:UIControlStateNormal];
            [cell.RankBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            [cell.RankBtn setImage:nil forState:UIControlStateNormal];
        }else{
            [cell.RankBtn setTitle:@"" forState:UIControlStateNormal];
            [cell.RankBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Ranking_no%ld",indexPath.row+1]] forState:UIControlStateNormal];
        }
        return cell;
    }
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        
        [_tableview registerNib:[UINib nibWithNibName:LPRegisterRankRecordCellID bundle:nil] forCellReuseIdentifier:LPRegisterRankRecordCellID];
               
        [_tableview registerNib:[UINib nibWithNibName:LPRegisterRankListCellID bundle:nil] forCellReuseIdentifier:LPRegisterRankListCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            if (self.SelectType == 1) {
                self.page = 1;
                [self requestQueryinviteRecord];
            }else{
                [self requestQueryinviteRankList];
            }

        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.SelectType == 1) {
                [self requestQueryinviteRecord];
            }else{
                [self.tableview.mj_footer endRefreshing];
            }
        }];
    }
    return _tableview;
}

-(void)hiddenSelect{
    [self setRulesHidden:YES];
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenSelect)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}


- (void)setModel:(LPInviteRankListModel *)model{
    _model = model;
       
       if ([self.model.code integerValue] == 0) {
           
           if (model.data.unGainNum.integerValue > 0) {
               self.GIFImage.hidden = NO;
           }else{
               self.GIFImage.hidden = YES;
           }
           
           if (self.page == 1) {
               self.listArray = [NSMutableArray array];
           }
           if (self.model.data.inviteRankList.count > 0) {
               self.page += 1;
               [self.listArray addObjectsFromArray:self.model.data.inviteRankList];
               if (self.model.data.inviteRankList.count<20) {
                   [self.tableview.mj_footer endRefreshingWithNoMoreData];
               }
           }else{
               [self.tableview.mj_footer endRefreshingWithNoMoreData];
           }
           [self.tableview reloadData];
           
           if (self.listArray.count == 0 && self.SelectType == 1) {
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
        [noDataView image:nil text:@"暂无排名记录~"];
        noDataView.imageView.hidden = YES;
        noDataView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        noDataView.hidden = hidden;
        noDataView.label.textColor = [UIColor colorWithHexString:@"999999"];
        [noDataView.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(LENGTH_SIZE(50));
            make.right.mas_equalTo(LENGTH_SIZE(-50));
            make.top.mas_offset(LENGTH_SIZE(170));
        }];
    }
}
#pragma mark - request

-(void)requestQueryinviteRecord{
    NSDictionary *dic = @{@"page":@(self.page)};
    
 
    [NetApiManager requestQueryinviteRecord:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPInviteRankListModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryinviteRankList{
    NSDictionary *dic = @{};
 
    [NetApiManager requestQueryinviteRankList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.modelList = [LPInviteRankListModel mj_objectWithKeyValues:responseObject];
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
                [self.tableview reloadData];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
