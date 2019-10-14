//
//  LPEmployeeManageVC.m
//  BlueHired
//
//  Created by iMac on 2019/8/28.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPEmployeeManageVC.h"
#import "LPMainSortAlertView.h"
#import "LPEmployeeManageCell.h"
#import "LPInformationSearchVC.h"
#import "LPLPEmployeeModel.h"
#import "LPWorkRecordListVC.h"

static NSString *LPEmployeeManageCellID = @"LPEmployeeManageCell";

@interface LPEmployeeManageVC ()<LPMainSortAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIButton *screenButton;
@property(nonatomic,strong) LPMainSortAlertView *sortAlertView;
@property(nonatomic,strong) NSArray *TypeArr;
@property(nonatomic,strong) NSArray *TypeIndexArr;

@property(nonatomic,strong) CustomIOSAlertView *CustomAlert;
@property(nonatomic,strong) UITextField *AlertTF;

@property(nonatomic,assign) NSInteger page;
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) LPLPEmployeeModel *model;
@property(nonatomic,strong) NSMutableArray <LPLPEmployeeDataModel *>*listArray;
@property(nonatomic,strong) NSString *Type;
@property(nonatomic,strong) LPLPEmployeeDataModel *selectmodel;

@end

@implementation LPEmployeeManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"员工归属管理";
    self.TypeArr = @[@"全部状态",@"未报名",@"已报名",@"面试失败",@"面试通过",@"放弃入职",@"在职",@"离职"];
    self.TypeIndexArr = @[@"-1",@"7",@"0",@"2",@"1",@"4",@"5",@"6"];

    self.Type = @"-1";
    [self setViewUI];
    self.page = 1;
    [self requestGetEmployeeList];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.sortAlertView close];
}

- (void)setViewUI{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"search2"] forState:UIControlStateNormal];
//    button.frame = CGRectMake(0,100,24, 24);
    [button addTarget:self action:@selector(touchSelectButton) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = navLeftButton;
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    
    UIView *HeadView = [[UIView alloc] init];
    [self.view addSubview:HeadView];
    [HeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(0));
    }];
    HeadView.backgroundColor = [UIColor whiteColor];
    HeadView.clipsToBounds = YES;
    
    UILabel *TitleLabel = [[UILabel alloc] init];
    [HeadView addSubview:TitleLabel];
    [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(LENGTH_SIZE(0));
        make.left.mas_offset(LENGTH_SIZE(13));
    }];
    TitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    TitleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    TitleLabel.text = @"员工列表";
    
    _screenButton = [[UIButton alloc]init];
    [HeadView addSubview:_screenButton];
    _screenButton.frame = CGRectMake(SCREEN_WIDTH-LENGTH_SIZE(75+13) , 0,LENGTH_SIZE(75), LENGTH_SIZE(40));
    [_screenButton setTitle:@"全部状态" forState:UIControlStateNormal];
    [_screenButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [_screenButton setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
    [_screenButton setImage:[UIImage imageNamed:@"drop_down"] forState:UIControlStateNormal];
    [_screenButton setImage:[UIImage imageNamed:@"drop_down_sel"] forState:UIControlStateSelected];
    _screenButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    _screenButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(13)];
    _screenButton.titleEdgeInsets = UIEdgeInsetsMake(0, -_screenButton.imageView.frame.size.width - _screenButton.frame.size.width + _screenButton.titleLabel.intrinsicContentSize.width, 0,LENGTH_SIZE(20));
    _screenButton.imageEdgeInsets = UIEdgeInsetsMake(0,LENGTH_SIZE(55+8) , 0, 0);
    [_screenButton addTarget:self action:@selector(touchScreenButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(LENGTH_SIZE(10));
        make.bottom.mas_equalTo(0);
    }];
    
}

-(void)touchSelectButton{
    LPInformationSearchVC *vc = [[LPInformationSearchVC alloc]init];
    vc.Type = 5;
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)touchScreenButton:(UIButton *)button{
    dispatch_async(dispatch_get_main_queue(), ^{
 
            self.sortAlertView.titleArray  = self.TypeArr;
            button.selected = !button.isSelected;
            self.sortAlertView.touchButton = button;
            self.sortAlertView.selectTitle = button.tag;
            self.sortAlertView.hidden = !button.isSelected;
       
    });
}


#pragma mark - LPMainSortAlertViewDelegate
-(void)touchTableView:(NSInteger)index{
    
    [self.screenButton setTitle:self.TypeArr[index] forState:UIControlStateNormal];
    self.screenButton.tag = index;
   
    self.Type = self.TypeIndexArr[index];
   
    self.page = 1;
    [self requestGetEmployeeList];
 
}


#pragma mark - TableViewDelegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(126);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPEmployeeManageCell *cell = [tableView dequeueReusableCellWithIdentifier:LPEmployeeManageCellID];
    cell.model = self.listArray[indexPath.row];
    WEAK_SELF()
    cell.remarkBlock = ^{
        weakSelf.selectmodel = weakSelf.listArray[indexPath.row];
        [weakSelf initRemarkAlertView];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)initRemarkAlertView{
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
    TF.text = self.selectmodel.remark;
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

-(void)Touchremark:(UIButton *)sender{
    [self.CustomAlert close];
//    [self requestUpdateRelationReg:self.selectmodel.id.stringValue remark:self.AlertTF.text];
    [self requestUpdateEmpRemark];
}

#pragma mark textFieldChanged
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

#pragma mark lazy
-(LPMainSortAlertView *)sortAlertView{
    if (!_sortAlertView) {
        _sortAlertView = [[LPMainSortAlertView alloc]init];
        _sortAlertView.touchButton = self.screenButton;
        _sortAlertView.delegate = self;
    }
    return _sortAlertView;
}



- (void)setModel:(LPLPEmployeeModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:model.data];
            [self.tableview reloadData];
            if (model.data.count<20) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
                self.tableview.mj_footer.hidden = self.listArray.count<20?YES:NO;
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
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]init];
        [self.view addSubview:noDataView];
        [noDataView image:nil text:@"没有相关数据~"];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(LENGTH_SIZE(0));
            make.bottom.mas_equalTo(LENGTH_SIZE(0));
        }];
        noDataView.hidden = hidden;
    }
}





-(void)requestGetEmployeeList{
    NSDictionary *dic = @{
//                          @"status":self.Type,
                            @"versionType":@"2.4",
                            @"page":[NSString stringWithFormat:@"%ld",self.page]
                          };
    
    [NetApiManager requestGetEmployeeList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPLPEmployeeModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestUpdateEmpRemark{
    NSDictionary *dic = @{
                          @"id":self.selectmodel.id,
                          @"type":self.selectmodel.type,
                          @"remark":self.AlertTF.text
                          };
    
    [NetApiManager requestUpdateEmpRemark:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self.view showLoadingMeg:@"编辑备注成功" time:MESSAGE_SHOW_TIME];
                    self.selectmodel.remark = self.AlertTF.text;
                    [self.tableview reloadData];
                }else{
                    [self.view showLoadingMeg:@"编辑备注失败,请稍后再试" time:MESSAGE_SHOW_TIME];
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
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 64;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#E6E6E6"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPEmployeeManageCellID bundle:nil] forCellReuseIdentifier:LPEmployeeManageCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestGetEmployeeList];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestGetEmployeeList];
        }];
    }
    return _tableview;
}

@end
