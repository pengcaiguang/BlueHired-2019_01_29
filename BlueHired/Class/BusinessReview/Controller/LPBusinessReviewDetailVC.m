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
@property(nonatomic,strong) NSMutableArray <UILabel *>*screeningLabelArray;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,assign) NSInteger selectType;
@property(nonatomic,strong) LPMechanismcommentDetailModel *model;
@property(nonatomic,strong) NSMutableArray <LPMechanismcommentDetailDataModel *>*listArray;
@property(nonatomic,assign) NSInteger bottomSelectType;

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
    [self setBottomView];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(89);
        make.bottom.mas_equalTo(-49);
    }];
    [self requestMechanismcommentDeatil];
}

-(void)setTitleView{
    UIView *titleBgView = [[UIView alloc]init];
    [self.view addSubview:titleBgView];
    [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(89);
    }];
    NSArray *imgArray = @[@"businessReview_all",@"businessReview_img",@"businessReview_review",@"businessReview_wage"];
    NSArray *titleArray = @[@"查看全部",@"只看有图",@"只看评论",@"只看工资"];
    
    for (int i = 0; i < imgArray.count; i++) {
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(i%4 * SCREEN_WIDTH/4, floor(i/4)*86, SCREEN_WIDTH/4, 86);
        //        bgView.backgroundColor = randomColor;
        bgView.userInteractionEnabled = YES;
        bgView.tag = i;
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake((SCREEN_WIDTH/4-37)/2, 15, 37, 37);
        //        imageView.backgroundColor = randomColor;
        imageView.image = [UIImage imageNamed:imgArray[i]];
        [bgView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 60, SCREEN_WIDTH/4, 20);
        //        label.backgroundColor = randomColor;
        label.textColor = [UIColor colorWithHexString:@"#343434"];
        label.font = [UIFont systemFontOfSize:12];
        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];
        [self.screeningLabelArray addObject:label];
        [titleBgView addSubview:bgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchBgView:)];
        [bgView addGestureRecognizer:tap];
    }
    self.screeningLabelArray[0].textColor = [UIColor baseColor];
}
-(void)setBottomView{
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    NSMutableArray *bottomButtonArray = [NSMutableArray array];
    NSArray *titleArray = @[@"我来点评",@"晒个工资"];
    for (int i =0; i<titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        [bgView addSubview:button];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (i == 0) {
            button.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
        }else{
            button.backgroundColor = [UIColor baseColor];

        }
        button.titleLabel.font = [UIFont systemFontOfSize:16];
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
-(void)touchBgView:(UITapGestureRecognizer *)tap{
    NSInteger index = [tap view].tag;
    for (UILabel *label in self.screeningLabelArray) {
        label.textColor = [UIColor colorWithHexString:@"#343434"];
    }
    self.screeningLabelArray[index].textColor = [UIColor baseColor];
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
        [self requestCheckIsmechanism];
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
            make.top.mas_equalTo(89);
            make.bottom.mas_equalTo(-49);
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
        CGFloat DetailsHeight = [LPTools calculateRowHeight:model.commentContent fontSize:15 Width:SCREEN_WIDTH - 26];
        if (DetailsHeight>90) {
            return 118+ ImageHeight + (model.IsAllShow?DetailsHeight:90.0)+28;
        }else{
            return 118+ ImageHeight + DetailsHeight+8;
        }
    }
    return 120.5;
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
                          @"type":@(self.bottomSelectType)
                          };
    [NetApiManager requestCheckIsmechanismWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (self.bottomSelectType == 1) {
                    LPbusinessMyReviewViewController *my =[[LPbusinessMyReviewViewController alloc] init];
                    my.mechanismlistDataModel = self.mechanismlistDataModel;
                    [self.navigationController pushViewController:my animated:YES];
                }
                else if (self.bottomSelectType == 2)
                {
                    LPBusinessReviewWageVC *wage = [[LPBusinessReviewWageVC alloc] init];
                    wage.mechanismlistDataModel = self.mechanismlistDataModel;
                    [self.navigationController pushViewController:wage animated:YES];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"连接错误" time:MESSAGE_SHOW_TIME];
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
        return -10;
    }
    CGFloat imgw = (SCREEN_WIDTH-28 - 10)/3;
    NSArray *imageArray = [string componentsSeparatedByString:@";"];
    if (imageArray.count ==1)
    {
        return 260;
    }
    else
    {
        return ceil(imageArray.count/3.0)*imgw + floor(imageArray.count/3)*5;
    }
}

@end
