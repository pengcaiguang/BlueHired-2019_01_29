//
//  LPWorkDetailVC.m
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkDetailVC.h"
#import "LPWorkDetailModel.h"
#import "LPWorkDetailHeadCell.h"
#import "LPWorkDetailTextCell.h"
#import "LPIsApplyOrIsCollectionModel.h"
#import "LPWorkorderListVC.h"
#import "LPMain2Cell.h"

static NSString *LPWorkDetailHeadCellID = @"LPWorkDetailHeadCell";
static NSString *LPWorkDetailTextCellID = @"LPWorkDetailTextCell";
static NSString *LPMainCellID = @"LPMain2Cell";

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

@property(nonatomic,strong) NSArray <LPWorklistDataWorkListModel *> *RecommendList;

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
    
    [self request];
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
//    if (kUserDefaultsValue(USERDATA).integerValue == 4 ||
//        kUserDefaultsValue(USERDATA).integerValue >=8) {
//        [self.signUpButton setTitle:@"禁止报名" forState:UIControlStateNormal];
//        self.signUpButton.backgroundColor = [UIColor colorWithHexString:@"#939393"];
//        self.signUpButton.enabled = NO;
//    }
    
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
//
//    NSString *string = [NSString stringWithFormat:@"姓名：%@\n报名企业：%@",useername,self.model.data.mechanismName];
//    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"报名成功" message:string textAlignment:NSTextAlignmentLeft buttonTitles:@[@"查看详情"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
//        if (buttonIndex == 0) {
//            LPWorkorderListVC *vc = [[LPWorkorderListVC alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }];
//    [alert show];
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    self.CustomAlert = alertView;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 223.0/320*SCREEN_WIDTH , 59.0/320*SCREEN_WIDTH + 233)];
    view.backgroundColor = [UIColor colorWithHexString:@"#E0F2FF"];
    UIImageView *imageView =[[UIImageView alloc] init];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.mas_offset(0);
        make.height.mas_offset(59.0/320*SCREEN_WIDTH);
    }];
    imageView.image = [UIImage imageNamed:@"SignUpHead_icon"];
    
    
    UIView *TopView = [[UIView alloc] init];
    [view addSubview:TopView];
    [TopView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(7);
        make.right.mas_offset(-7);
        make.top.equalTo(imageView.mas_bottom).offset(3);
        make.height.mas_offset(83);
    }];
    TopView.layer.cornerRadius = 4;
    TopView.backgroundColor = [UIColor whiteColor];

    UILabel *TopLabel1 = [[UILabel alloc] init];
    [TopView addSubview:TopLabel1];
    [TopLabel1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(7);
        make.right.mas_offset(-7);
        make.top.mas_offset(8);
    }];
    TopLabel1.textAlignment = NSTextAlignmentCenter;
    TopLabel1.font = [UIFont systemFontOfSize:14];
    TopLabel1.textColor = [UIColor baseColor];
    TopLabel1.text = @"报名成功";
    
    UILabel *TopLabel2 = [[UILabel alloc] init];
    [TopView addSubview:TopLabel2];
    [TopLabel2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(7);
        make.right.mas_offset(-7);
        make.top.equalTo(TopLabel1.mas_bottom).offset(8);
    }];
    TopLabel2.font = [UIFont systemFontOfSize:13];
    TopLabel2.text = [NSString stringWithFormat:@"姓名：%@",useername];
    
    UILabel *TopLabel3 = [[UILabel alloc] init];
    [TopView addSubview:TopLabel3];
    [TopLabel3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(7);
        make.right.mas_offset(-7);
        make.top.equalTo(TopLabel2.mas_bottom).offset(11);
    }];
    TopLabel3.font = [UIFont systemFontOfSize:13];
    TopLabel3.text = [NSString stringWithFormat:@"报名企业：%@",self.model.data.mechanismName];
    
    
    
    UIView *BottomView = [[UIView alloc] init];
    [view addSubview:BottomView];
    [BottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(7);
        make.right.mas_offset(-7);
        make.top.equalTo(TopView.mas_bottom).offset(3);
        make.height.mas_offset(83);
    }];
    BottomView.layer.cornerRadius = 4;
    BottomView.backgroundColor = [UIColor whiteColor];
    
    UILabel *BottomLabel1 = [[UILabel alloc] init];
    [BottomView addSubview:BottomLabel1];
    [BottomLabel1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(7);
        make.right.mas_offset(-7);
        make.top.mas_offset(8);
    }];
    BottomLabel1.textAlignment = NSTextAlignmentCenter;
    BottomLabel1.font = [UIFont systemFontOfSize:14];
    BottomLabel1.textColor = [UIColor baseColor];
    BottomLabel1.text = @"推荐分享";
    
    UILabel *BottomLabel2 = [[UILabel alloc] init];
    [BottomView addSubview:BottomLabel2];
    [BottomLabel2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(7);
        make.right.mas_offset(-7);
        make.top.equalTo(BottomLabel1.mas_bottom).offset(8);
    }];
    BottomLabel2.font = [UIFont systemFontOfSize:13];
    BottomLabel2.numberOfLines = 0;
    BottomLabel2.text = @"分享给好友，让好友为你加油点赞，可获取更多高额返费！";
    
    
    
    
    UIButton *LeftBt = [[UIButton alloc] init];
    [view addSubview:LeftBt];
    [LeftBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(7);
        make.top.equalTo(BottomView.mas_bottom).offset(9);
        make.height.mas_offset(42);
    }];
    LeftBt.layer.cornerRadius = 4;
    LeftBt.backgroundColor = [UIColor colorWithHexString:@"#FF6060"];
    [LeftBt setTitle:@"推荐分享" forState:UIControlStateNormal];
    [LeftBt addTarget:self action:@selector(CustomLeft:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *RightBt = [[UIButton alloc] init];
    [view addSubview:RightBt];
    [RightBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(LeftBt.mas_right).offset(7);
        make.right.mas_offset(-7);
        make.top.equalTo(BottomView.mas_bottom).offset(9);
        make.height.mas_offset(42);
        make.width.equalTo(LeftBt.mas_width);
    }];
    RightBt.layer.cornerRadius = 4;
    RightBt.backgroundColor = [UIColor baseColor];
    [RightBt setTitle:@"报名详情" forState:UIControlStateNormal];
    [RightBt addTarget:self action:@selector(CustomRightBt:) forControlEvents:UIControlEventTouchUpInside];
    
    alertView.containerView = view;
    alertView.buttonTitles=@[];
    [alertView setUseMotionEffects:true];
    [alertView setCloseOnTouchUpOutside:true];
    [alertView show];
    
}

-(void)CustomLeft:(UIButton *)sender{
    [self.CustomAlert close];
    NSString *url = [NSString stringWithFormat:@"%@bluehired/recruitmentlist_detail.html?id=%@",BaseRequestWeiXiURL,self.workListModel.id];
    
    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [LPTools ClickShare:encodedUrl Title:_model.data.mechanismName];
    
}
-(void)CustomRightBt:(UIButton *)sender{
    [self.CustomAlert close];
    LPWorkorderListVC *vc = [[LPWorkorderListVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - setdata
-(void)setModel:(LPWorkDetailModel *)model{
    _model = model;
    
//    if (kUserDefaultsValue(USERDATA).integerValue == 4 ||
//        kUserDefaultsValue(USERDATA).integerValue >= 8) {
//        [self.signUpButton setTitle:@"禁止报名" forState:UIControlStateNormal];
//        self.signUpButton.backgroundColor = [UIColor colorWithHexString:@"#939393"];
//        self.signUpButton.enabled = NO;
//    }
    
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
            
//            if (kUserDefaultsValue(USERDATA).integerValue == 4 ||
//                kUserDefaultsValue(USERDATA).integerValue >= 8) {
//                [self.signUpButton setTitle:@"禁止报名" forState:UIControlStateNormal];
//                self.signUpButton.backgroundColor = [UIColor colorWithHexString:@"#939393"];
//                self.signUpButton.enabled = NO;
//            }
            
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
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else if (section == 1) {
        return 0.0;
    }else if (section == 2){
         return 20.0;
    }else{
        return 35.0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 6;
    }else if (section == 2) {
        return 2;
    }else{
        return self.RecommendList.count;
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
    
    
    if (section == 3){
             UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 35)];
            view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];

            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(60, 17, Screen_Width-120, 1)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#FFE6E6E6"];
            [view addSubview:lineView];
            
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake((Screen_Width-70)/2, 0, 70, 35);
            label.textColor = [UIColor colorWithHexString:@"#666666"];
            label.font = [UIFont systemFontOfSize:15];
            label.text = @"推荐企业";
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
            [view addSubview:label];
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
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
        cell.detailTitleLabel.text = self.textArray[indexPath.row];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
            cell.detailTitleLabel.text = @"企业简介";
            cell.detailLabel.text = [self removeHTML2:[self.model.data.mechanismDetails stringByDecodingHTMLEntities]];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return cell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.imageView.image = [UIImage imageNamed:@"detail_location"];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#444444"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = [NSString stringWithFormat:@"地址：%@",self.model.data.mechanismAddress];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return cell;
        }
    }else{
        LPMain2Cell *cell = [tableView dequeueReusableCellWithIdentifier:LPMainCellID];
        if(cell == nil){
            cell = [[LPMain2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMainCellID];
        }
        cell.model = self.RecommendList[indexPath.row];
        //    WEAK_SELF()
        //    cell.block = ^(void) {
        //        weakSelf.page = 1;
        //        [weakSelf request];
        //    };
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section== 3) {
        LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.workListModel = self.RecommendList[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
                    self.workListModel.isApply = @(0);
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
                    self.workListModel.isApply = @(1);
                    [self requestIsApplyOrIsCollection];
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)request{
    NSDictionary *dic = @{@"id":self.workListModel.id
                          };
    [NetApiManager requestQueryWorkRecommend:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
           self.RecommendList = [LPWorklistDataWorkListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableview reloadData];
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
        [_tableview registerNib:[UINib nibWithNibName:LPMainCellID bundle:nil] forCellReuseIdentifier:LPMainCellID];

    }
    return _tableview;
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
