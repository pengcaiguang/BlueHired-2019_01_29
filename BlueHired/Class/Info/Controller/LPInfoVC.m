//
//  LPInfoVC.m
//  BlueHired
//
//  Created by peng on 2018/9/20.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInfoVC.h"
#import "LPInfoCell.h"
#import "LPInforCollectionViewCell.h"
#import "LPMoodDetailVC.h"
#import "LPInfoDetailVC.h"
#import "LPCircleInfoListVC.h"
#import "LPWorkInfoVC.h"

static NSString *LPInfoCellID = @"LPInfoCell";

@interface LPInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UIView *HeadTableView;
@property (nonatomic,strong) UILabel *WorkNumLabel;
@property (nonatomic,strong) UILabel *CircleNumLabel;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) NSNumber *labelListModelId;

@property (nonatomic,strong) LPInfoListModel *model;

@property (nonatomic,strong) NSMutableArray <LPInfoListDataModel *>*listArray;
@property (nonatomic,strong) NSMutableArray <LPInfoListDataModel *>*selectArray;

@property (nonatomic,strong) UIView *Deleteview;

@property (nonatomic,strong) UILabel *NumLabel;

 
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,assign) BOOL selectAll;
@property (nonatomic,strong) UIButton *allButton;
 

@end

@implementation LPInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    self.selectArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息中心";
    UIView *TitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.navigationItem.titleView = TitleView;
    
    UILabel *TitleLabel = [[UILabel alloc] init];
    [TitleView addSubview:TitleLabel];
    [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(TitleView);
    }];
    TitleLabel.text = @"消息中心";
    TitleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    UIButton *clearBT = [[UIButton alloc] init];
    [TitleView addSubview:clearBT];
    [clearBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(TitleLabel.mas_right).offset(13);
    }];
    [clearBT setImage:[UIImage imageNamed:@"news_read"] forState:UIControlStateNormal];
    [clearBT addTarget:self action:@selector(TouchclearBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setNavigationButton];
    [self initDeleteView];
    
    self.page = 1;
    [self requestQueryGetInfolist];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


 
-(void)setNavigationButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#333333"]];
}
-(void)touchManagerButton{
    [self.selectArray removeAllObjects];
    self.NumLabel.text = @"已选0条";

    self.allButton.selected = NO;

    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
        self.isSelect = YES;
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        [self.Deleteview  mas_remakeConstraints:^(MASConstraintMaker *make){
            make.right.left.mas_offset(0);
            make.height.mas_offset(LENGTH_SIZE(48));
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
            } else {
                make.bottom.mas_offset(0);
            }
        }];
    }else{
        self.isSelect = NO;
         [self.Deleteview  mas_remakeConstraints:^(MASConstraintMaker *make){
            make.right.left.mas_offset(0);
            make.height.mas_offset(LENGTH_SIZE(0));
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
            } else {
                make.bottom.mas_offset(0);
            }
        }];
         
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
     }
    [self.tableview reloadData];
    
}


-(void)initDeleteView{
    UIView *Deleteview = [[UIView alloc] init];
    [self.view addSubview:Deleteview];
    self.Deleteview = Deleteview;
    Deleteview.clipsToBounds = YES;
    [Deleteview  mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.left.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(0));
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.mas_offset(0);
        }
    }];
    Deleteview.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(0));
        make.left.right.mas_offset(0);
        make.bottom.equalTo(Deleteview.mas_top).offset(0);
    }];
    
    UIButton *AllBtn = [[UIButton alloc] init];
    self.allButton = AllBtn;
    [Deleteview addSubview:AllBtn];
    [AllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_offset(0);
        make.width.mas_offset(LENGTH_SIZE(108));
    }];
    [AllBtn setTitle:@"  全选" forState:UIControlStateNormal];
    [AllBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [AllBtn setImage:[UIImage imageNamed:@"add_ record_normal2"] forState:UIControlStateNormal];
    [AllBtn setImage:[UIImage imageNamed:@"add_ record_selected2"] forState:UIControlStateSelected];
    AllBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(16)];
    [AllBtn addTarget:self action:@selector(TouchAllSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *NumderLabel = [[UILabel alloc] init];
    self.NumLabel = NumderLabel;
    [Deleteview addSubview:NumderLabel];
    [NumderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(AllBtn.mas_right).offset(0);
    }];
    NumderLabel.textColor = [UIColor baseColor];
    NumderLabel.font = FONT_SIZE(16);
    NumderLabel.text = @"已选0条";
 
    
    
    UIButton *DeleteBtn = [[UIButton alloc] init];
    [Deleteview addSubview:DeleteBtn];

    [DeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_offset(0);
        make.width.mas_offset(LENGTH_SIZE(120));
    }];
    DeleteBtn.backgroundColor = [UIColor colorWithHexString:@"#FF5353"];
    [DeleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [DeleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    DeleteBtn.titleLabel.font = FONT_SIZE(17);
    [DeleteBtn addTarget:self action:@selector(TouchDelete:) forControlEvents:UIControlEventTouchUpInside];
    
}

 

-(void)TouchDelete:(UIButton *)sender{
    if (self.selectArray.count == 0) {
        [self.view showLoadingMeg:@"请选择删除的消息" time:MESSAGE_SHOW_TIME];
        return;
    }
 
 
        
    [self requestDelInfos];
  
    
}

-(void)TouchAllSelect:(UIButton *)sender{
    [self.selectArray removeAllObjects];
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.selectArray addObjectsFromArray:self.listArray];
    }
    self.NumLabel.text = [NSString stringWithFormat:@"已选%lu条",(unsigned long)self.selectArray.count];
    [self.tableview reloadData];
    
}

-(void)TouchCircleBtn:(UIButton *)sender{
    
    self.CircleNumLabel.hidden = YES;
    self.model.data.moodInfoNum = @"0";
    
    LPCircleInfoListVC *vc = [[LPCircleInfoListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)TouchWorkBtn:(UIButton *)sender{
    self.WorkNumLabel.hidden = YES;
    self.model.data.workInfoNum = @"0";
    LPWorkInfoVC *vc = [[LPWorkInfoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
 
-(void)TouchclearBtn:(UIButton *)sender{
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"确定将消息全部标记为已读？" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
        if (buttonIndex) {
            [self requestQueryUpdateInfoRead];
        }
    }];
    [alert show];
}



#pragma mark - TableViewDelegate & Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(72);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:LPInfoCellID];
    cell.model = self.listArray[indexPath.row];
    cell.selectStatus = self.isSelect;
 
    if ([self.selectArray containsObject:cell.model]) {
        cell.selectButton.selected = YES;
     }else{
         cell.selectButton.selected = NO;
     }
    
    cell.selectBlock = ^(LPInfoListDataModel * _Nonnull model) {
        if ([self.selectArray containsObject:model]) {
            [self.selectArray removeObject:model];
        }else{
            [self.selectArray addObject:model];
        }
        
        if (self.selectArray.count == self.listArray.count){
            self.allButton.selected = YES;
        }else{
            self.allButton.selected = NO;
        }
        self.NumLabel.text = [NSString stringWithFormat:@"已选%lu条",(unsigned long)self.selectArray.count];

    };
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.isSelect) {
        
        LPInfoListDataModel *modelData = self.listArray[indexPath.row];
        modelData.status = @(1);
        [tableView reloadData];
        
        if (modelData.moodId != nil) {
            LPMoodDetailVC *vc = [[LPMoodDetailVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            LPMoodListDataModel *moodListDataModel = [[LPMoodListDataModel alloc] init];
            moodListDataModel.id = modelData.moodId;
            vc.moodListDataModel = moodListDataModel;
            vc.InfoId = [NSString stringWithFormat:@"%@",modelData.id];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        LPInfoDetailVC *vc = [[LPInfoDetailVC alloc]init];
        vc.model = modelData;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark - request
-(void)requestQueryGetInfolist{
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          @"type":@"1"
                          };
    [NetApiManager requestQueryGetInfolist:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPInfoListModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
 

-(void)requestDelInfos{
    NSMutableArray *array = [NSMutableArray array];
    for (LPInfoListDataModel *model in self.selectArray) {
        [array addObject:model.id];
    }
    NSString *string = [array componentsJoinedByString:@","];
    NSDictionary *dic = @{
                          @"infoId":string
                          };
    [NetApiManager requestDelInfosWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
           
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    self.allButton.selected = NO;
                    self.NumLabel.text = @"已选0条";
                    [self.listArray removeObjectsInArray:self.selectArray];
                    [self.tableview reloadData];
                    [self.selectArray removeAllObjects];
                    [[UIWindow visibleViewController].view showLoadingMeg:@"删除成功" time:MESSAGE_SHOW_TIME];
                }else{
                    [[UIWindow visibleViewController].view showLoadingMeg:@"删除失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

//一键清空圈子通知或者招工通知
-(void)requestQueryUpdateInfoMood:(NSInteger) Type{
 
    NSDictionary *dic = @{};
    if (Type == 1) {
        dic = @{@"type":@"1"};
    }
    [NetApiManager requestQueryUpdateInfoMood:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                     
                }
            }

        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryUpdateInfoRead{
 
    NSDictionary *dic = @{};
   
    [NetApiManager requestQueryUpdateInfoRead:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    for (LPInfoListDataModel *m in self.listArray) {
                        m.status = @(1);
                    }
                }
                [self.tableview reloadData];
            }

        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPInfoCellID bundle:nil] forCellReuseIdentifier:LPInfoCellID];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _tableview.tableHeaderView = self.HeadTableView;
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            if (!self.isSelect) {
                self.page = 1;
                [self requestQueryGetInfolist];
            }else{
                [self.tableview.mj_header endRefreshing];
            }

        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (!self.isSelect) {
                [self requestQueryGetInfolist];
            }else{
                [self.tableview.mj_footer endRefreshing];
            }
        }];
    }
    return _tableview;
}

-(UIView *)HeadTableView{
    if (!_HeadTableView) {
        _HeadTableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(100))];
        _HeadTableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(90))];
        [_HeadTableView addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *Circleimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"news_dynamic"]];
        [view addSubview:Circleimage];
        [Circleimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.mas_offset(LENGTH_SIZE(33));
        }];
        
        UILabel *CircleLabel = [[UILabel alloc] init];
        [view addSubview:CircleLabel];
        [CircleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(Circleimage.mas_right).offset(LENGTH_SIZE(17));
        }];
        CircleLabel.text = @"圈子动态";
        CircleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        CircleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        
        
        UIView *lineV = [[UIView alloc] init];
        [view addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.width.mas_offset(LENGTH_SIZE(0.5));
            make.height.mas_offset(LENGTH_SIZE(30));
        }];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
        
        UIImageView *Workimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"news_hire"]];
        [view addSubview:Workimage];
        [Workimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(lineV.mas_right).offset(LENGTH_SIZE(33));
        }];
        
        UILabel *WorkLabel = [[UILabel alloc] init];
        [view addSubview:WorkLabel];
        [WorkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(Workimage.mas_right).offset(LENGTH_SIZE(17));
        }];
        WorkLabel.text = @"招工通知";
        WorkLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        WorkLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        
        
        UILabel *WorkNumLabel = [[UILabel alloc] init];
        [view addSubview:WorkNumLabel];
        self.WorkNumLabel = WorkNumLabel;
        [WorkNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(Workimage.mas_top);
            make.centerX.equalTo(Workimage.mas_right);
            make.height.mas_offset(LENGTH_SIZE(14));
            make.width.greaterThanOrEqualTo(LENGTH_SIZE(14));
        }];
        WorkNumLabel.backgroundColor = [UIColor colorWithHexString:@"#F23730"];
        WorkNumLabel.layer.cornerRadius = LENGTH_SIZE(7);
        WorkNumLabel.layer.borderWidth = LENGTH_SIZE(1);
        WorkNumLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        WorkNumLabel.textColor = [UIColor whiteColor];
        WorkNumLabel.clipsToBounds = YES;
        WorkNumLabel.hidden = YES;
        WorkNumLabel.font = [UIFont boldSystemFontOfSize:9];
        WorkNumLabel.textAlignment = NSTextAlignmentCenter;

        UILabel *CircleNumLabel = [[UILabel alloc] init];
        [view addSubview:CircleNumLabel];
        self.CircleNumLabel = CircleNumLabel;
        [CircleNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(Circleimage.mas_top);
            make.centerX.equalTo(Circleimage.mas_right);
            make.height.mas_offset(LENGTH_SIZE(14));
            make.width.greaterThanOrEqualTo(LENGTH_SIZE(14));
        }];
        CircleNumLabel.backgroundColor = [UIColor colorWithHexString:@"#F23730"];
        CircleNumLabel.layer.cornerRadius = LENGTH_SIZE(7);
        CircleNumLabel.layer.borderWidth = LENGTH_SIZE(1);
        CircleNumLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        CircleNumLabel.textColor = [UIColor whiteColor];
        CircleNumLabel.clipsToBounds = YES;
        CircleNumLabel.hidden = YES;
        CircleNumLabel.font = [UIFont boldSystemFontOfSize:9];
        CircleNumLabel.textAlignment = NSTextAlignmentCenter;

        UIButton *CircleBtn = [[UIButton alloc] init];
        [view addSubview:CircleBtn];
        [CircleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_offset(0);
            make.width.mas_offset(SCREEN_WIDTH/2);
        }];
        [CircleBtn addTarget:self action:@selector(TouchCircleBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *WorkBtn = [[UIButton alloc] init];
        [view addSubview:WorkBtn];
        [WorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_offset(0);
            make.width.mas_offset(SCREEN_WIDTH/2);
        }];
        [WorkBtn addTarget:self action:@selector(TouchWorkBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _HeadTableView;
}



-(void)setModel:(LPInfoListModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (model.data.moodInfoNum.integerValue > 0 ) {
            self.CircleNumLabel.hidden = NO;
            if (model.data.moodInfoNum.integerValue>99) {
                self.CircleNumLabel.text = @" 99+ ";
            }else{
                self.CircleNumLabel.text = [NSString stringWithFormat:@"%ld",(long)model.data.moodInfoNum.integerValue];
            }
        }else{
            self.CircleNumLabel.hidden = YES;
        }
        
        if (model.data.workInfoNum.integerValue > 0 ) {
            self.WorkNumLabel.hidden = NO;
            if (model.data.workInfoNum.integerValue>99) {
                self.WorkNumLabel.text = @" 99+ ";
            }else{
                self.WorkNumLabel.text = [NSString stringWithFormat:@"%ld",(long)model.data.workInfoNum.integerValue];
            }
        }else{
            self.WorkNumLabel.hidden = YES;
        }
        
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.list.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data.list];
            [self.tableview reloadData];
            if (self.model.data.list.count < 20) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
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

-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.tableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, LENGTH_SIZE(100), SCREEN_WIDTH, self.tableview.lx_height - LENGTH_SIZE(100))];
        [noDataView image:nil text:@"抱歉！没有新的消息！"];
        [self.tableview addSubview:noDataView];
        noDataView.hidden = hidden;
    }
}

@end
