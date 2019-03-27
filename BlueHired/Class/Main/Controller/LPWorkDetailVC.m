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
#import "LPWorkorderListVC.h"

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

@property(nonatomic,strong)CustomIOSAlertView *CustomAlert;

@end

@implementation LPWorkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"招聘详情";
    self.buttonArray = [NSMutableArray array];
    self.bottomButtonArray = [NSMutableArray array];
    self.textArray = @[@"入职要求",@"薪资福利",@"住宿餐饮",@"工作时间",@"面试材料",@"其他说明"];

    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-48);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-48);
        } else {
           make.bottom.mas_equalTo(-48);
        }
    }];
    [self setBottomView];
    
 
//    [self requestWorkDetail];
//    if (AlreadyLogin) {
//        [self requestIsApplyOrIsCollection];
//    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self requestWorkDetail];
//    if (AlreadyLogin) {
        [self requestIsApplyOrIsCollection];
//    }
}

-(void)setBottomView{
    
    UIView *bottomBgView = [[UIView alloc]init];
    [self.view addSubview:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-136);
//        make.bottom.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(48);
    }];
    
    self.signUpButton = [[UIButton alloc]init];
    [self.view addSubview:self.signUpButton];
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
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
    if (kUserDefaultsValue(USERDATA).integerValue == 4 ||
        kUserDefaultsValue(USERDATA).integerValue >=8) {
        [self.signUpButton setTitle:@"禁止报名" forState:UIControlStateNormal];
        self.signUpButton.backgroundColor = [UIColor colorWithHexString:@"#939393"];
        self.signUpButton.enabled = NO;
    }
    
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
    if ([LoginUtils validationLogin:self]) {
        //    LPWorkorderListVC *vc = [[LPWorkorderListVC alloc]init];
        //    [self.navigationController pushViewController:vc animated:YES];
        //    return;
        if ([self.isApplyOrIsCollectionModel.data.isApply integerValue] == 0) {
            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否取消报名" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self requestCancleApply];
                }
            }];
            [alert show];
            return;
        }
        if (kStringIsEmpty(self.isApplyOrIsCollectionModel.data.userName)) {
            GJAlertText *alert = [[GJAlertText alloc]initWithTitle:@"企业入职报名，请填写您的真实姓名！" message:@"请填写真实姓名" buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor baseColor]] MaxLength:5 NilTitel:@"请填写真实姓名" buttonClick:^(NSInteger buttonIndex , NSString * string) {
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
}
-(void)touchBottomButton:(UIButton *)button{
    if (button.tag == 2) {
        NSLog(@"咨询");
        NSString *name = self.isApplyOrIsCollectionModel.data.teacher.teacherName;
        NSString *number = self.isApplyOrIsCollectionModel.data.teacher.teacherTel;

        NSString *string = [NSString stringWithFormat:@"姓名：%@ \n联系方式：%@ \n微信搜索驻厂号码即可添加驻厂微信",name,number];
        GJAlert2 *alert = [[GJAlert2 alloc]initWithTitle:@"驻厂联系方式" message:string buttonTitles:@[@"复制号码",@"立即拨打"] buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor colorWithHexString:@"#434343"]] buttonClick:^(NSInteger buttonIndex) {
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
    else if (button.tag == 1)
    {
//        [self WeiXinOrQQAlertView ];
        NSString *url = [NSString stringWithFormat:@"%@bluehired/recruitmentlist_detail.html?id=%@",BaseRequestWeiXiURL,self.workListModel.id];
        
        NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [LPTools ClickShare:encodedUrl Title:_model.data.mechanismName];
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
    
    NSString *useername = [[LPTools isNullToString:self.isApplyOrIsCollectionModel.data.userName] isEqualToString:@""] ? self.userName: self.isApplyOrIsCollectionModel.data.userName ;
    
    NSString *string = [NSString stringWithFormat:@"姓名：%@\n报名企业：%@",useername,self.model.data.mechanismName];
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"报名成功" message:string textAlignment:NSTextAlignmentLeft buttonTitles:@[@"查看详情"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            LPWorkorderListVC *vc = [[LPWorkorderListVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [alert show];
}

#pragma mark - setdata
-(void)setModel:(LPWorkDetailModel *)model{
    _model = model;
    
    if (kUserDefaultsValue(USERDATA).integerValue == 4 ||
        kUserDefaultsValue(USERDATA).integerValue >= 8) {
        [self.signUpButton setTitle:@"禁止报名" forState:UIControlStateNormal];
        self.signUpButton.backgroundColor = [UIColor colorWithHexString:@"#939393"];
        self.signUpButton.enabled = NO;
    }
    
    if ([model.data.status integerValue] == 1) {// "status": 1,//0正在招工1已经招满
        [self.signUpButton setTitle:@"停止报名" forState:UIControlStateNormal];
        self.signUpButton.backgroundColor = [UIColor colorWithHexString:@"#939393"];
        self.signUpButton.enabled = NO;
    }
    

    
    [self.tableview reloadData];
}
-(void)setIsApplyOrIsCollectionModel:(LPIsApplyOrIsCollectionModel *)isApplyOrIsCollectionModel{
    _isApplyOrIsCollectionModel = isApplyOrIsCollectionModel;
    if (isApplyOrIsCollectionModel.data) {
        if ([isApplyOrIsCollectionModel.data.isCollection integerValue] == 0) {
            self.bottomButtonArray[0].selected = YES;
        }else{
            self.bottomButtonArray[0].selected = NO;
        }
        if (self.model) {
            
            if (kUserDefaultsValue(USERDATA).integerValue == 4 ||
                kUserDefaultsValue(USERDATA).integerValue >= 8) {
                [self.signUpButton setTitle:@"禁止报名" forState:UIControlStateNormal];
                self.signUpButton.backgroundColor = [UIColor colorWithHexString:@"#939393"];
                self.signUpButton.enabled = NO;
            }
            
            if ([self.model.data.status integerValue] == 1) {// "status": 1,//0正在招工1已经招满
                [self.signUpButton setTitle:@"停止报名" forState:UIControlStateNormal];
                self.signUpButton.backgroundColor = [UIColor colorWithHexString:@"#939393"];
                self.signUpButton.enabled = NO;
            }else{
                if ([isApplyOrIsCollectionModel.data.isApply integerValue] == 0  && AlreadyLogin) {
                    self.signUpButton.selected = YES;
                }else{
                    self.signUpButton.selected = NO;
                }
            }
            

        }
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
            NSString *string=[self removeHTML2:[self.model.data.workDemand stringByDecodingHTMLEntities]];
            cell.detailLabel.text = string;
//            cell.detailLabel.text = [self.model.data.workDemand htmlUnescapedString];
        }else if (indexPath.row == 1){
            NSString *string=[self removeHTML2:[self.model.data.workSalary stringByDecodingHTMLEntities]];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 2){
            NSString *string=[self removeHTML2:[self.model.data.eatSleep stringByDecodingHTMLEntities]];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 3){
            NSString *string=[self removeHTML2:[self.model.data.workTime stringByDecodingHTMLEntities]];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 4){
            NSString *string=[self removeHTML2:[self.model.data.workKnow stringByDecodingHTMLEntities]];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 5){
            NSString *string=[self removeHTML2:[self.model.data.remarks stringByDecodingHTMLEntities]];
            cell.detailLabel.text = string;
        }
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
            cell.detailTitleLabel.text = @"企业简介";
            cell.detailLabel.text = [self removeHTML2:[self.model.data.mechanismDetails stringByDecodingHTMLEntities]];
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
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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
                    [LPTools AlertCollectView:@""];
                }else if ([responseObject[@"data"] integerValue] == 1) {
                    self.bottomButtonArray[0].selected = NO;
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    } IsShowActivity:YES];
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
                          @"userName":[[LPTools isNullToString:self.isApplyOrIsCollectionModel.data.userName] isEqualToString:@""] ? self.userName: self.isApplyOrIsCollectionModel.data.userName ,
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

-(void)WeiXinOrQQAlertView
{
    _CustomAlert = [[CustomIOSAlertView alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 130)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 21)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"请选择分享平台";
    
    UIButton *weixinBt = [[UIButton alloc] initWithFrame:CGRectMake(180, 40, 60, 60)];
    [weixinBt setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:(UIControlStateNormal)];
    [weixinBt addTarget:self action:@selector(weixinOrQQtouch:) forControlEvents:UIControlEventTouchUpInside];
    weixinBt.tag = 1;
    UILabel *wxlabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 105, 60, 20)];
    wxlabel.text = @"微信";
    wxlabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIButton *QQBt = [[UIButton alloc] initWithFrame:CGRectMake(60, 40, 60, 60)];
    [QQBt setBackgroundImage:[UIImage imageNamed:@"QQ"] forState:(UIControlStateNormal)];
    [QQBt addTarget:self action:@selector(weixinOrQQtouch:) forControlEvents:UIControlEventTouchUpInside];
    QQBt.tag = 2;
    UILabel *qqlabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 105, 60, 20)];
    qqlabel.text = @"qq";
    qqlabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [view addSubview:weixinBt];
    [view addSubview:wxlabel];
    [view addSubview:QQBt];
    [view addSubview:qqlabel];
    
    [_CustomAlert setContainerView:view];
    [_CustomAlert setButtonTitles:@[@"取消"]];
    [_CustomAlert show];
}

-(void)weixinOrQQtouch:(UIButton *)sender
{
    NSString *url = [NSString stringWithFormat:@"%@bluehired/recruitmentlist_detail.html?id=%@",BaseRequestWeiXiURL,self.workListModel.id];
    
    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if (sender.tag == 1)
    {
        if ([WXApi isWXAppInstalled]==NO) {
            [self.view showLoadingMeg:@"请安装微信" time:MESSAGE_SHOW_TIME];
            [_CustomAlert close];
            return;
        }
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.scene = WXSceneSession;
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"蓝聘";
        message.description= _model.data.mechanismName;
        message.thumbData = UIImagePNGRepresentation([UIImage imageNamed:@"logo_Information"]);
        WXWebpageObject *ext = [WXWebpageObject object];

        ext.webpageUrl = encodedUrl;
        message.mediaObject = ext;
        req.message = message;
        [WXApi sendReq:req];
    }
    else if (sender.tag == 2)
    {
        if (![QQApiInterface isSupportShareToQQ])
        {
            [self.view showLoadingMeg:@"请安装QQ" time:MESSAGE_SHOW_TIME];
            [_CustomAlert close];
            return;
        }
        NSString *title = @"蓝聘";
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:[NSURL URLWithString:encodedUrl]
                                    title:title
                                    description:nil
                                    previewImageURL:nil];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        //将内容分享到qzone
        //        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];

    }
    [_CustomAlert close];
}


- (NSString *)removeHTML2:(NSString *)html{
    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    for (int i = 0; i < [components count]; i = i + 2) {
        [componentsToKeep addObject:[components objectAtIndex:i]];
    }
    NSString *plainText = [componentsToKeep componentsJoinedByString:@"\n"];
    return plainText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
