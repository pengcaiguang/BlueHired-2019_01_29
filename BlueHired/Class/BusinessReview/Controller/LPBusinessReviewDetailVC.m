//
//  LPBusinessReviewDetailVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/5.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPBusinessReviewDetailVC.h"
#import "LPMechanismcommentDetailModel.h"

@interface LPBusinessReviewDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) NSMutableArray <UILabel *>*screeningLabelArray;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,assign) NSInteger selectType;
@property(nonatomic,strong) LPMechanismcommentDetailModel *model;
@property(nonatomic,strong) NSMutableArray <LPMechanismcommentDetailDataModel *>*listArray;
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
    [self requestMechanismcommentDeatil];
}
-(void)touchBottomButton:(UIButton *)button{
    if ([LoginUtils validationLogin:self]) {
        
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
    return 20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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
            self.model = [LPMechanismcommentDetailModel mj_objectWithKeyValues:responseObject];
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
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//        [_tableview registerNib:[UINib nibWithNibName:LPBusinessReviewCellID bundle:nil] forCellReuseIdentifier:LPBusinessReviewCellID];
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
