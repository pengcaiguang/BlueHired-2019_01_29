//
//  LPWorkDetailVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkDetailVC.h"
#import "LPWorkDetailModel.h"
#import "LPWorkDetailHeadCell.h"
#import "LPWorkDetailTextCell.h"
#import "LPIsApplyOrIsCollectionModel.h"

static NSString *LPWorkDetailHeadCellID = @"LPWorkDetailHeadCell";
static NSString *LPWorkDetailTextCellID = @"LPWorkDetailTextCell";

@interface LPWorkDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) LPWorkDetailModel *model;

@property(nonatomic,strong) LPIsApplyOrIsCollectionModel *isApplyOrIsCollectionModel;
@property(nonatomic,strong) NSMutableArray <UIButton *>*buttonArray;
@property(nonatomic,strong) UIView *lineView;

@property(nonatomic,strong) NSArray *textArray;
@property(nonatomic,strong) NSMutableArray <UIButton *> *bottomButtonArray;
@property(nonatomic,strong) UIButton *signUpButton;

@property(nonatomic,strong) NSString *userName;

@end

@implementation LPWorkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"企业详情";
    self.buttonArray = [NSMutableArray array];
    self.bottomButtonArray = [NSMutableArray array];
    self.textArray = @[@"入职要求",@"薪资福利",@"住宿餐饮",@"工作时间",@"面试材料",@"其他说明"];

    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
    }];
    [self setBottomView];
    [self requestWorkDetail];
    [self requestIsApplyOrIsCollection];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.block) {
        self.block(self.isApplyOrIsCollectionModel.data.isApply);
    }
}

-(void)setBottomView{
    
    UIView *bottomBgView = [[UIView alloc]init];
    [self.view addSubview:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-136);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    
    self.signUpButton = [[UIButton alloc]init];
    [self.view addSubview:self.signUpButton];
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(136);
    }];
    [self.signUpButton setTitle:@"入职报名" forState:UIControlStateNormal];
    [self.signUpButton setTitle:@"取消报名" forState:UIControlStateSelected];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.signUpButton.backgroundColor = [UIColor baseColor];
    self.signUpButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.signUpButton addTarget:self action:@selector(touchSiginUpButton) forControlEvents:UIControlEventTouchUpInside];
    [self.signUpButton addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];

    
    NSArray *imgArray = @[@"collection_normal",@"share_btn",@"customersService"];
    NSArray *titleArray = @[@"收藏",@"分享",@"咨询"];
    for (int i =0; i<titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        [bottomBgView addSubview:button];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#424242"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"collection_selected"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        button.tag = i;
        [button addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomButtonArray addObject:button];
    }
    [self.bottomButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    [self.bottomButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    
    for (UIButton *button in self.bottomButtonArray) {
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width, -button.imageView.frame.size.height, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height, 0, 0, -button.titleLabel.intrinsicContentSize.width);
    }
}
-(void)touchSiginUpButton{
    if (!self.isApplyOrIsCollectionModel.data.isApply) {
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否取消报名" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self requestCancleApply];
            }
        }];
        [alert show];
        return;
    }
    if (kStringIsEmpty(self.isApplyOrIsCollectionModel.data.userName)) {
        GJAlertText *alert = [[GJAlertText alloc]initWithTitle:@"企业入职报名，请填写您的真实姓名！" message:@"请填写真实姓名" buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex , NSString * string) {
            if (buttonIndex == 0) {
            }else{
                self.userName = string;
                [self requestEntryApply];
            }
        }];
        [alert show];
    }else{
        [self requestEntryApply];
    }
}
-(void)touchBottomButton:(UIButton *)button{
    if (button.tag == 2) {
        NSLog(@"咨询");
        NSString *number = @"18888888888";
        NSString *string = [NSString stringWithFormat:@"姓名：老王 \n联系方式：%@ \n微信搜索客服号码添加即可添加客服微信",number];
        GJAlert2 *alert = [[GJAlert2 alloc]initWithTitle:@"客服联系方式" message:string buttonTitles:@[@"复制号码",@"立即拨打"] buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor colorWithHexString:@"#434343"]] buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = number;
                [self.view showLoadingMeg:@"复制成功" time:MESSAGE_SHOW_TIME];
            }else{
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",number];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }
        }];
        [alert show];
        return;
    }
    if ([LoginUtils validationLogin:self]) {
        NSInteger index = button.tag;
        if (index == 0) {
            [self requestSetCollection];
        }
    }
}
- (void)preventFlicker:(UIButton *)button {
    button.highlighted = NO;
}
-(void)applySuccessAlert{
    NSString *string = [NSString stringWithFormat:@"姓名：%@\n报名企业：%@",self.isApplyOrIsCollectionModel.data.userName,self.model.data.mechanismName];
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"报名成功" message:string textAlignment:NSTextAlignmentLeft buttonTitles:@[@"查看详情"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSLog(@"查看详情");
        }
    }];
    [alert show];
}

#pragma mark - setdata
-(void)setModel:(LPWorkDetailModel *)model{
    _model = model;
    [self.tableview reloadData];
}
-(void)setIsApplyOrIsCollectionModel:(LPIsApplyOrIsCollectionModel *)isApplyOrIsCollectionModel{
    _isApplyOrIsCollectionModel = isApplyOrIsCollectionModel;
    if (isApplyOrIsCollectionModel.data) {
        self.bottomButtonArray[0].selected = !isApplyOrIsCollectionModel.data.isCollection;
        self.signUpButton.selected = !isApplyOrIsCollectionModel.data.isApply;
    }
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else if (section == 1) {
        return 50;
    }else{
        return 20;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 6;
    }else{
        return 2;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [view addSubview:scrollView];
        scrollView.showsHorizontalScrollIndicator = NO;
        
        CGFloat btnw = SCREEN_WIDTH/self.textArray.count;
        for (int i = 0; i <self.textArray.count; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(btnw*i, 0, btnw, 50);
            [button setTitle:self.textArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button addTarget:self action:@selector(touchTextButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonArray addObject:button];
            [scrollView addSubview:button];
        }
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 50);
        
        self.lineView = [[UIView alloc]init];
        self.lineView.frame = CGRectZero;
        self.lineView.backgroundColor = [UIColor baseColor];
        [scrollView addSubview:self.lineView];
        [self selectButtonAtIndex:0];
        
        return view;
    }
    return nil;
}

-(void)touchTextButton:(UIButton *)button{
    NSInteger index = button.tag;
    [self selectButtonAtIndex:index];
    [self scrollToItenIndex:index];
}
-(void)touchLabel:(UITapGestureRecognizer *)tap{
    NSInteger index = [tap view].tag;
    [self selectButtonAtIndex:index];
    [self scrollToItenIndex:index];
}
-(void)selectButtonAtIndex:(NSInteger)index{
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
    }
    self.buttonArray[index].selected = YES;;
    CGSize size = CGSizeMake(100, MAXFLOAT);//设置高度宽度的最大限度
    CGRect rect = [self.buttonArray[index].titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
    CGFloat btnx = CGRectGetMinX(self.buttonArray[index].frame);
    CGFloat btnw = CGRectGetWidth(self.buttonArray[index].frame);
    CGFloat x = (btnw - rect.size.width)/2;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = CGRectMake(btnx + x, 40, rect.size.width, 2);
    }];
    
}
-(void)scrollToItenIndex:(NSInteger)index{
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LPWorkDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailHeadCellID];
        cell.model = self.model;
        return cell;
    }else if (indexPath.section == 1){
        LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
        cell.detailTitleLabel.text = self.textArray[indexPath.row];
        if (indexPath.row == 0) {
            NSString *string=[self.model.data.workDemand stringByReplacingOccurrencesOfString:@"<p>"withString:@" "];
            string = [string stringByReplacingOccurrencesOfString:@"</p>"withString:@"\n"];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 1){
            NSString *string=[self.model.data.workSalary stringByReplacingOccurrencesOfString:@"<p>"withString:@" "];
            string = [string stringByReplacingOccurrencesOfString:@"</p>"withString:@"\n"];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 2){
            NSString *string=[self.model.data.eatSleep stringByReplacingOccurrencesOfString:@"<p>"withString:@" "];
            string = [string stringByReplacingOccurrencesOfString:@"</p>"withString:@"\n"];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 3){
            NSString *string=[self.model.data.workTime stringByReplacingOccurrencesOfString:@"<p>"withString:@" "];
            string = [string stringByReplacingOccurrencesOfString:@"</p>"withString:@"\n"];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 4){
            NSString *string=[self.model.data.workKnow stringByReplacingOccurrencesOfString:@"<p>"withString:@" "];
            string = [string stringByReplacingOccurrencesOfString:@"</p>"withString:@"\n"];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 5){
            NSString *string=[self.model.data.remarks stringByReplacingOccurrencesOfString:@"<p>"withString:@" "];
            string = [string stringByReplacingOccurrencesOfString:@"</p>"withString:@"\n"];
            cell.detailLabel.text = string;
        }
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
            cell.detailTitleLabel.text = @"企业简介";
            cell.detailLabel.text = self.model.data.mechanismDetails;
            return cell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.imageView.image = [UIImage imageNamed:@"detail_location"];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#444444"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = [NSString stringWithFormat:@"地址：%@",self.model.data.mechanismAddress];
            return cell;
        }
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - request
-(void)requestWorkDetail{
    NSDictionary *dic = @{
                          @"workId":self.workListModel.id
                          };
    [NetApiManager requestWorkDetailWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPWorkDetailModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:@"网络错误" time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestSetCollection{
    NSDictionary *dic = @{
                          @"type":@(1),
                          @"id":self.workListModel.id
                          };
    [NetApiManager requestSetCollectionWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (!ISNIL(responseObject[@"data"])) {
                if ([responseObject[@"data"] integerValue] == 0) {
                    self.bottomButtonArray[0].selected = YES;
                }else if ([responseObject[@"data"] integerValue] == 1) {
                    self.bottomButtonArray[0].selected = NO;
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestIsApplyOrIsCollection{
    NSDictionary *dic = @{
                          @"workId":self.workListModel.id
                          };
    [NetApiManager requestIsApplyOrIsCollectionWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.isApplyOrIsCollectionModel = [LPIsApplyOrIsCollectionModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestEntryApply{
    NSDictionary *dic = @{
                          @"interviewTime":self.model.data.interviewTime,
                          @"mechanismId":self.model.data.mechanismId,
                          @"mechanismName":self.model.data.mechanismName,
                          @"reMoney":self.model.data.reMoney,
                          @"reTime":self.model.data.reTime,
                          @"recruitAddress":self.model.data.recruitAddress,
                          @"userName":self.isApplyOrIsCollectionModel.data.userName ? self.isApplyOrIsCollectionModel.data.userName : self.userName,
                          @"workId":self.workListModel.id,
                          @"workName":self.model.data.workTypeName,
                          };
    NSString * string = @"work/entryApply?type=0";
    [NetApiManager requestEntryApplyWithUrl:string withParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (!ISNIL(responseObject[@"code"])) {
                if ([responseObject[@"code"] integerValue] == 0) {
                    [self requestIsApplyOrIsCollection];
                    [self applySuccessAlert];
                }else{
                    if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
                        [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME*2];
                    }
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestCancleApply{
    NSString *string = [NSString stringWithFormat:@"work/cancleApply?workId=%@",self.workListModel.id];
    [NetApiManager requestCancleApplyWithUrl:string withParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (!ISNIL(responseObject[@"code"])) {
                if ([responseObject[@"code"] integerValue] == 0) {
                    self.signUpButton.selected = NO;
                    [self requestIsApplyOrIsCollection];
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
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPWorkDetailHeadCellID bundle:nil] forCellReuseIdentifier:LPWorkDetailHeadCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPWorkDetailTextCellID bundle:nil] forCellReuseIdentifier:LPWorkDetailTextCellID];
        
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
