//
//  LPBusinessReviewDetailVC.m
//  BlueHired
//
//  Created by peng on 2018/9/5.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPBusinessReviewDetailVC.h"
#import "LPMechanismcommentDetailModel.h"
#import "LPBusinessReviewDetailCell.h"
#import "LPBusinessReviewDetailSalaryCell.h"
#import "LPbusinessMyReviewViewController.h"
#import "LPBusinessReviewWageVC.h"

static NSString *LPBusinessReviewDetailCellID = @"LPBusinessReviewDetailCell";
static NSString *LPBusinessReviewDetailSalaryCellID = @"LPBusinessReviewDetailSalaryCell";

@interface LPBusinessReviewDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) NSMutableArray <UIButton *>*screeningLabelArray;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,assign) NSInteger selectType;
@property(nonatomic,strong) LPMechanismcommentDetailModel *model;
@property(nonatomic,strong) NSMutableArray <LPMechanismcommentDetailDataModel *>*listArray;
@property(nonatomic,assign) NSInteger bottomSelectType;

@property(nonatomic,strong) UIView *ButtonView;


@end

@implementation LPBusinessReviewDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"企业点评详情";
    self.screeningLabelArray = [NSMutableArray array];
    self.page = 1;
    
    [self setTitleView];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(LENGTH_SIZE(44));
        make.bottom.mas_equalTo(LENGTH_SIZE(-49));
    }];
    [self setBottomView];

    [self requestMechanismcommentDeatil];
    [self requestCheckIsmechanism];

}

-(void)setTitleView{
    UIView *titleBgView = [[UIView alloc]init];
    [self.view addSubview:titleBgView];
    [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(LENGTH_SIZE(44));
    }];
//    NSArray *imgArray = @[@"businessReview_all",@"businessReview_img",@"businessReview_review",@"businessReview_wage"];
    NSArray *titleArray = @[@"查看全部",@"只看有图",@"只看评论",@"只看工资"];
    
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *bt = [[UIButton alloc]init];
        bt.frame = CGRectMake(0, 60, SCREEN_WIDTH/4, 20);
        [bt setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
        [bt setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F2F1F0"]] forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#E4F4FF"]] forState:UIControlStateSelected];
        bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        [bt setTitle:titleArray[i] forState:UIControlStateNormal];
        bt.layer.cornerRadius = 4;
        bt.clipsToBounds = YES;
        bt.tag = i;
        
        [self.screeningLabelArray addObject:bt];
        [titleBgView addSubview:bt];
        [bt addTarget:self action:@selector(touchBgView:) forControlEvents:UIControlEventTouchUpInside];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchBgView:)];
    }
    [self.screeningLabelArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:8 leadSpacing:13 tailSpacing:13];
    [self.screeningLabelArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(LENGTH_SIZE(8));
        make.bottom.mas_equalTo(LENGTH_SIZE(-8));
    }];
    
    self.screeningLabelArray[0].selected = YES;
}
-(void)setBottomView{
    UIView *bgView = [[UIView alloc]init];
    self.ButtonView = bgView;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(LENGTH_SIZE(49));
    }];
    bgView.hidden = YES;
    
    NSMutableArray *bottomButtonArray = [NSMutableArray array];
    NSArray *titleArray = @[@"晒个工资",@"我来点评"];
    for (int i =0; i<titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        [bgView addSubview:button];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (i == 0) {
            button.backgroundColor = [UIColor colorWithHexString:@"#FFC24B"];
        }else{
            button.backgroundColor = [UIColor baseColor];

        }
        button.titleLabel.font = [UIFont systemFontOfSize:FontSize(17)];
        button.tag = i;
        [button addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [bottomButtonArray addObject:button];
    }
    [bottomButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [bottomButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
}
#pragma mark - selector
-(void)touchBgView:(UIButton *)tap{
    NSInteger index = tap.tag;
    for (UIButton *label in self.screeningLabelArray) {
        label.selected = NO;
    }
    self.screeningLabelArray[index].selected = YES;
    if (index == 0) {
        self.selectType = 0;
    }else if (index == 1){
        self.selectType = 3;
    }else if (index == 2){
        self.selectType = 1;
    }else if (index == 3){
        self.selectType = 2;
    }
    self.page = 1;
    [self requestMechanismcommentDeatil];
}
-(void)touchBottomButton:(UIButton *)button{
    if ([LoginUtils validationLogin:self]) {
        self.bottomSelectType = button.tag +1;
        
        if (self.bottomSelectType == 2) {
            LPbusinessMyReviewViewController *my =[[LPbusinessMyReviewViewController alloc] init];
            my.mechanismlistDataModel = self.mechanismlistDataModel;
            [self.navigationController pushViewController:my animated:YES];
        }
        else if (self.bottomSelectType == 1)
        {
            LPBusinessReviewWageVC *wage = [[LPBusinessReviewWageVC alloc] init];
            wage.mechanismlistDataModel = self.mechanismlistDataModel;
            [self.navigationController pushViewController:wage animated:YES];
        }
        
    }
}

#pragma mark - setter
-(void)setModel:(LPMechanismcommentDetailModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:model.data];
            [self.tableview reloadData];
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
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
-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectZero];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.view addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(LENGTH_SIZE(44));
            make.bottom.mas_equalTo(LENGTH_SIZE(-49));
        }];
        noDataView.hidden = hidden;
    }
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPMechanismcommentDetailDataModel *model = self.listArray[indexPath.row];
    
    if (model.type.integerValue == 1) {
       CGFloat ImageHeight = [self calculateImageHeight:model.commentUrl];
        CGFloat DetailsHeight = [LPTools calculateRowHeight:model.commentContent fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(70)];
        NSLog(@"行高 = %f",[UIFont systemFontOfSize:FontSize(14)].lineHeight);
        
        CGFloat LineHeight = [UIFont systemFontOfSize:FontSize(14)].lineHeight;
        NSInteger LineCount = ceilf( DetailsHeight /ceilf(LineHeight));
        if (LineCount>5) {
            return LENGTH_SIZE(106)+ ImageHeight + (model.IsAllShow?DetailsHeight:LineHeight*5)+LENGTH_SIZE(30) + LENGTH_SIZE(17);
        }else{
            return LENGTH_SIZE(106)+ ImageHeight + DetailsHeight+LENGTH_SIZE(17);
        }
    }
    return LENGTH_SIZE(200);
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPMechanismcommentDetailDataModel *model = self.listArray[indexPath.row];
    if (model.type.integerValue == 1) {
        LPBusinessReviewDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:LPBusinessReviewDetailCellID];
        cell.model = self.listArray[indexPath.row];
        cell.Block = ^(void) {
            [self.tableview reloadData];
        };
        return cell;
    }else{
        LPBusinessReviewDetailSalaryCell *cell = [tableView dequeueReusableCellWithIdentifier:LPBusinessReviewDetailSalaryCellID];
        cell.model = self.listArray[indexPath.row];
        return cell;
    }    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - request
-(void)requestMechanismcommentDeatil{
    NSDictionary *dic = @{
                          @"selectType":self.selectType ? @(self.selectType) : @"",
                          @"mechanismId":self.mechanismlistDataModel.id,
                          @"page":@(self.page)
                          };
    [NetApiManager requestMechanismcommentDeatilWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPMechanismcommentDetailModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestCheckIsmechanism{
    NSDictionary *dic = @{
                          @"mechanismName":self.mechanismlistDataModel.mechanismName,
                          @"mechanismId":self.mechanismlistDataModel.id,
                          @"type":@"-1"
                          };
    [NetApiManager requestCheckIsmechanismWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
 
                self.ButtonView.hidden = NO;
                [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
                    if (@available(iOS 11.0, *)) {
                        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(LENGTH_SIZE(-49));
                    } else {
                        make.bottom.mas_equalTo(LENGTH_SIZE(-49));
                    }
                }];
                
            }else{
                self.ButtonView.hidden = YES;
                [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
                   
                    make.bottom.mas_equalTo(0);
                   
                }];
                if ([responseObject[@"code"] integerValue] != 20020) {
                    [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"连接错误" time:MESSAGE_SHOW_TIME];
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
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPBusinessReviewDetailCellID bundle:nil] forCellReuseIdentifier:LPBusinessReviewDetailCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPBusinessReviewDetailSalaryCellID bundle:nil] forCellReuseIdentifier:LPBusinessReviewDetailSalaryCellID];

        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestMechanismcommentDeatil];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestMechanismcommentDeatil];
        }];
    }
    return _tableview;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//计算图片高度
- (CGFloat)calculateImageHeight:(NSString *)string
{
    if (kStringIsEmpty(string)) {
        return  0;
    }
    CGFloat imgw = (SCREEN_WIDTH- LENGTH_SIZE(57) - LENGTH_SIZE(13))/3;
    NSArray *imageArray = [string componentsSeparatedByString:@";"];
    if (imageArray.count ==1)
    {
        return LENGTH_SIZE(260) +LENGTH_SIZE(14);
    }
    else
    {
        return ceil(imageArray.count/3.0)*imgw + floor(imageArray.count/3)*LENGTH_SIZE(6) +LENGTH_SIZE(14);
    }
}

@end
