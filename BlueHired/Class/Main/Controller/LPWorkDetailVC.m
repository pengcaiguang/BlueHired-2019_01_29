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
#import "LPBusinessReviewDetailVC.h"
#import "LPMechanismcommentMechanismlistModel.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import "LPWorkDetailFromCell.h"
#import "WHActivityView.h"
#import "LPSalarycCard2VC.h"

static NSString *LPWorkDetailHeadCellID = @"LPWorkDetailHeadCell";
static NSString *LPWorkDetailTextCellID = @"LPWorkDetailTextCell";
static NSString *LPMainCellID = @"LPMain2Cell";
static NSString *LPWorkDetailFromCellID = @"LPWorkDetailFromCell";

typedef void(^AddShareRecord)(NSString *data);

@interface LPWorkDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
         WHActivityView  *activityView;//分享界面
}

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

@property(nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;  //!< 要导航的坐标

@property (nonatomic,strong) UITextField *NameTextField;
@property (nonatomic, strong) AddShareRecord Record;

@end

@implementation LPWorkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"招聘详情";
    self.navigationController.navigationBar.hidden = YES;
 
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor clearColor], NSForegroundColorAttributeName, nil]];

    self.buttonArray = [NSMutableArray array];
    self.bottomButtonArray = [NSMutableArray array];
    self.textArray = @[@"岗位要求",@"薪资福利",@"食宿条件",@"工作时间",@"面试资料"];

    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.mas_equalTo(-kNavBarHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-48);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(LENGTH_SIZE(-48));
        } else {
           make.bottom.mas_equalTo(LENGTH_SIZE(-48));
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
    [super viewWillAppear:animated];
    [self requestWorkDetail];
//    if (AlreadyLogin) {
        [self requestIsApplyOrIsCollection];
//    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    [self.NBackBT setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0] forState:UIControlStateNormal];
//    [self.NBackBT setImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
//    [self.NBackBT setTitle:@" 返回" forState:UIControlStateNormal];

}

-(void)setBottomView{

    UIView *bottomBgView = [[UIView alloc]init];
    [self.view addSubview:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(LENGTH_SIZE(-136));
//        make.bottom.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(LENGTH_SIZE(48));
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
        make.height.mas_equalTo(LENGTH_SIZE(48));
        make.width.mas_equalTo(LENGTH_SIZE( 136));
    }];
    [self.signUpButton setTitle:@"入职报名" forState:UIControlStateNormal];
    [self.signUpButton setTitle:@"取消报名" forState:UIControlStateSelected];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.signUpButton.backgroundColor = [UIColor baseColor];
    self.signUpButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(17)];
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
        button.titleLabel.font = [UIFont systemFontOfSize:FontSize(11)];
        button.tag = i;
        button.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomButtonArray addObject:button];
    }
    [self.bottomButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [self.bottomButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-0);
    }];
    
    for (UIButton *button in self.bottomButtonArray) {
        button.titleEdgeInsets = UIEdgeInsetsMake(5, -button.imageView.frame.size.width, -button.imageView.frame.size.height, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height, 0, 0, -button.titleLabel.intrinsicContentSize.width);
    }
    
//    UIButton *BusinessreviewBtn = [[UIButton alloc] init];
//    [self.view addSubview:BusinessreviewBtn];
//    [BusinessreviewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_offset(0);
//        make.bottom.equalTo(bottomBgView.mas_top).offset(LENGTH_SIZE(-10));
//    }];
//    [BusinessreviewBtn setImage:[UIImage imageNamed:@"btn_review"] forState:UIControlStateNormal];
//    [BusinessreviewBtn addTarget:self action:@selector(touchBusinessReview) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touchBusinessReview{
    if ([LoginUtils validationLogin:self]) {
        LPBusinessReviewDetailVC *vc = [[LPBusinessReviewDetailVC alloc] init];
        LPMechanismcommentMechanismlistDataModel *m = [[LPMechanismcommentMechanismlistDataModel alloc] init];
        m.id = self.model.data.mechanismId;
        m.mechanismName = self.model.data.mechanismName;
        
        vc.mechanismlistDataModel = m;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)touchSiginUpButton{
    if ([LoginUtils validationLogin:self]) {
        //    LPWorkorderListVC *vc = [[LPWorkorderListVC alloc]init];
        //    [self.navigationController pushViewController:vc animated:YES];
        //    return;
        if ([self.isApplyOrIsCollectionModel.data.isApply integerValue] == 0) {
            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"请问是否确认取消报名？" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self requestCancleApply];
                }
            }];
            [alert show];
            return;
        }
        
        if (self.isApplyOrIsCollectionModel.data.isRealname.integerValue == 1) {
            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"请先实名认证，再入职报名" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"取消",@"去实名"] buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    LPSalarycCard2VC *vc = [[LPSalarycCard2VC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
            [alert show];
            return;
        }else if (kStringIsEmpty(self.isApplyOrIsCollectionModel.data.userName)) {
            
            CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
            self.CustomAlert = alertView;
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(300),LENGTH_SIZE(177))];
            view.layer.cornerRadius = LENGTH_SIZE(6);
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel *Title = [[UILabel alloc] init];
            [view addSubview:Title];
            [Title mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.right.mas_offset(0);
                make.top.mas_offset(LENGTH_SIZE(24));
            }];
            Title.font = [UIFont boldSystemFontOfSize:FontSize(18)];
            Title.textColor =[UIColor colorWithHexString:@"#333333"];
            Title.textAlignment = NSTextAlignmentCenter;
            Title.text = @"企业入职报名";
            
            UILabel *NameLabel = [[UILabel alloc] init];
            [view addSubview:NameLabel];
            [NameLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.mas_offset(LENGTH_SIZE(20));
                make.top.mas_offset(LENGTH_SIZE(76));
                make.width.mas_offset(LENGTH_SIZE(75));
            }];
            NameLabel.font = [UIFont systemFontOfSize:FontSize(16)];
            NameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            NameLabel.text = @"真实姓名:";
            
            UITextField *textField = [[UITextField alloc] init];
            [view addSubview:textField];
            self.NameTextField = textField;
            [textField mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(NameLabel.mas_right).offset(LENGTH_SIZE(8));
                make.centerY.equalTo(NameLabel);
                make.right.mas_offset(LENGTH_SIZE(-20));
                make.height.mas_offset(LENGTH_SIZE(36));
            }];
            textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,LENGTH_SIZE(8),LENGTH_SIZE(36))];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.layer.cornerRadius = LENGTH_SIZE(6);
            textField.layer.borderWidth = 1;
            textField.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
            [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            textField.tag = 1000;

            UIButton *button =[[UIButton alloc] init];
            [view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.mas_offset(LENGTH_SIZE(20));
                make.right.mas_offset(LENGTH_SIZE(-20));
                make.bottom.mas_offset(LENGTH_SIZE(-20));
                make.height.mas_offset(LENGTH_SIZE(40));
            }];
            
            button.layer.cornerRadius = 6;
            button.backgroundColor = [UIColor baseColor];
            [button setTitle:@"报  名" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(TouchApplyBt:) forControlEvents:UIControlEventTouchUpInside];

            alertView.containerView = view;
            alertView.buttonTitles=@[];
            [alertView setUseMotionEffects:true];
            [alertView setCloseOnTouchUpOutside:true];
            [alertView show];
        }else{
            [self requestEntryApply];
        }
    }
}



-(void)textFieldChanged:(UITextField *)textField{
    //
    
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    int kMaxLength = 6;
    NSString *toBeString = textField.text;
    // 获取键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    textField.text = [self filterCharactor:textField.text withRegex:@"[^\u4e00-\u9fa5]"];

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


//根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}




-(void)TouchApplyBt:(UIButton *)sender{
    UITextField *tf = [sender.superview viewWithTag:1000];
    NSString *name = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (name.length>0) {
        [self.CustomAlert close];
        self.userName = name;
        [self requestEntryApply];
    }else{
        [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"请填写真实姓名" time:MESSAGE_SHOW_TIME];
    }
}

-(void)touchBottomButton:(UIButton *)button{
    if (button.tag == 2) {
        NSLog(@"咨询");
        NSString *name = self.isApplyOrIsCollectionModel.data.teacher.teacherName;
        NSString *number = self.isApplyOrIsCollectionModel.data.teacher.teacherTel;
 
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
        self.CustomAlert = alertView;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(300), LENGTH_SIZE(250))];
        view.layer.cornerRadius = LENGTH_SIZE(6);
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *titlelabel = [[UILabel alloc] init];
        [view addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.left.mas_offset(0);
            make.top.mas_offset(LENGTH_SIZE(24));
        }];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.font = [UIFont boldSystemFontOfSize:FontSize(18)];
        titlelabel.text = @"驻厂联系方式";
        
        UILabel *titlelabel2 = [[UILabel alloc] init];
        [view addSubview:titlelabel2];
        [titlelabel2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.left.mas_offset(0);
            make.top.equalTo(titlelabel.mas_bottom).offset(LENGTH_SIZE(12));
        }];
        titlelabel2.textAlignment = NSTextAlignmentCenter;
        titlelabel2.font = [UIFont systemFontOfSize:FontSize(14)];
        titlelabel2.text = @"微信搜索号码即可添加驻厂微信";
        titlelabel2.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
        
        UIView *SubView = [[UIView alloc] init];
        [view addSubview:SubView];
        [SubView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(titlelabel2.mas_bottom).offset(LENGTH_SIZE(19));
            make.left.mas_offset(LENGTH_SIZE(20));
            make.right.mas_offset(LENGTH_SIZE(-20));
            make.height.mas_offset(LENGTH_SIZE(75));
        }];
        SubView.layer.cornerRadius = LENGTH_SIZE(4);
        SubView.backgroundColor = [UIColor colorWithHexString:@"#F5F7FA"];
        
        
        UILabel *SubLabel1 = [[UILabel alloc] init];
        [SubView addSubview:SubLabel1];
        [SubLabel1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_offset(LENGTH_SIZE(13));
            make.left.mas_offset(LENGTH_SIZE(16));
            make.right.mas_offset(LENGTH_SIZE(-16));
        }];
        SubLabel1.textColor = [UIColor colorWithHexString:@"#666666"];
        SubLabel1.font = [UIFont systemFontOfSize:FontSize(15)];
        SubLabel1.text = [NSString stringWithFormat:@"姓名：%@ ",name];
        
        UILabel *SubLabel2 = [[UILabel alloc] init];
        [SubView addSubview:SubLabel2];
        [SubLabel2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(SubLabel1.mas_bottom).offset(LENGTH_SIZE(12));
            make.left.mas_offset(LENGTH_SIZE(16));
        }];
        SubLabel2.textColor = [UIColor colorWithHexString:@"#666666"];
        SubLabel2.font = [UIFont systemFontOfSize:FontSize(15)];
        SubLabel2.text = [NSString stringWithFormat:@"电话：%@ ",number];
        
        UIButton *CopyBt = [[UIButton alloc] init];
        [SubView addSubview:CopyBt];
        [CopyBt mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.mas_offset(LENGTH_SIZE(-16));
            make.centerY.equalTo(SubLabel2);
        }];
        CopyBt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        [CopyBt setTitle:@"复制号码" forState:UIControlStateNormal];
        [CopyBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [CopyBt addTarget:self action:@selector(TouchCopyBt) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *dialBt = [[UIButton alloc] init];
        [view addSubview:dialBt];
        [dialBt mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(SubView.mas_bottom).offset(LENGTH_SIZE(24));
            make.right.mas_offset(LENGTH_SIZE(-20));
            make.left.mas_offset(LENGTH_SIZE(20));
            make.height.mas_offset(LENGTH_SIZE(40));
        }];
        [dialBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dialBt setTitle:@"立即拨打" forState:UIControlStateNormal];
        dialBt.layer.cornerRadius = LENGTH_SIZE(6);
        dialBt.backgroundColor = [UIColor baseColor];
        [dialBt addTarget:self action:@selector(TouchDialBt:) forControlEvents:UIControlEventTouchUpInside];
        
        alertView.containerView = view;
        alertView.buttonTitles=@[];
        [alertView setUseMotionEffects:true];
        [alertView setCloseOnTouchUpOutside:true];
        [alertView show];
        
        return;
    }
    else if (button.tag == 1)
    {
        if ([LoginUtils validationLogin:self]) {
                    NSString *url = @"";
                    if (AlreadyLogin) {
                        url = [NSString stringWithFormat:@"%@resident/#/recruitdetail?id=%@&identity=%@",BaseRequestWeiXiURL,self.workListModel.id,kUserDefaultsValue(USERIDENTIY)];
                    }else{
                        url = [NSString stringWithFormat:@"%@resident/#/recruitdetail?id=%@",BaseRequestWeiXiURL,self.workListModel.id];
                    }
                    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    [self btnClickShare:encodedUrl Title:[NSString stringWithFormat:@"您的好友通过蓝聘平台给您推荐了%@，快来看看吧！",_model.data.mechanismName]];
        }
        return;

    }
    
    if ([LoginUtils validationLogin:self]) {
        NSInteger index = button.tag;
        if (index == 0) {
            [self requestSetCollection];
        }
    }
}


-(void)btnClickShare:(NSString *)StrUrl Title:(NSString *)Title{
    //更多。用于分享及编辑
    for (UIView *sub in [activityView subviews]) {
        [sub removeFromSuperview];
    }
    [activityView removeFromSuperview];
    activityView=nil;
    if (!activityView)
    {
        activityView = [[WHActivityView alloc]initWithTitle:nil referView:[[UIWindow visibleViewController].view window] isNeed:YES];
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        activityView.numberOfButtonPerLine = 4;
        activityView.titleLabel.text = @"请选择分享平台";
        __weak __typeof(self) weakSelf = self;
        ButtonView *bv = [[ButtonView alloc]initWithText:@"QQ" image:[UIImage imageNamed:@"QQLogo"] handler:^(ButtonView *buttonView){
                if (![QQApiInterface isSupportShareToQQ])
                {
                    [LPTools AlertMessageView:@"请安装QQ" dismiss:1.0];
                    return;
                }
            [weakSelf requestQueryAddShareRecord:^(NSString *data) {
                [[LPTools shareInstance] share:1 Url:StrUrl Title:Title];
            }];
            
         }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"QQ空间"  image:[UIImage imageNamed:@"QQSpace"] handler:^(ButtonView *buttonView){
             if (![QQApiInterface isSupportShareToQQ])
                            {
                                [LPTools AlertMessageView:@"请安装QQ" dismiss:1.0];
                                return;
                            }
            [weakSelf requestQueryAddShareRecord:^(NSString *data) {
                [[LPTools shareInstance] share:2 Url:StrUrl Title:Title];
            }];
            
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"微信"  image:[UIImage imageNamed:@"weixinLogo"] handler:^(ButtonView *buttonView){
             if ([WXApi isWXAppInstalled]==NO) {
                 [LPTools AlertMessageView:@"请安装微信" dismiss:1.0];
                 return;
             }
            [weakSelf requestQueryAddShareRecord:^(NSString *data) {
                           [[LPTools shareInstance] share:3 Url:StrUrl Title:Title];
                       }];
            
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"朋友圈"  image:[UIImage imageNamed:@"WXSpace"] handler:^(ButtonView *buttonView){
             if ([WXApi isWXAppInstalled]==NO) {
                 [LPTools AlertMessageView:@"请安装微信" dismiss:1.0];
                 return;
             }
            [weakSelf requestQueryAddShareRecord:^(NSString *data) {
                [[LPTools shareInstance] share:4 Url:StrUrl Title:Title];
            }];
        }];
        [activityView addButtonView:bv];
    
        [activityView show];
    }
}
 


-(void)TouchCopyBt{
    [self.CustomAlert close];

    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.isApplyOrIsCollectionModel.data.teacher.teacherTel;
    [self.view showLoadingMeg:@"复制成功" time:MESSAGE_SHOW_TIME];
}

-(void)TouchDialBt:(UIButton *)sender{
    [self.CustomAlert close];

    sender.enabled = NO;
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.isApplyOrIsCollectionModel.data.teacher.teacherTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}

- (void)preventFlicker:(UIButton *)button {
    button.highlighted = NO;
}
-(void)applySuccessAlert:(NSString *) interViewID{
    
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 256.0/320*SCREEN_WIDTH , 67.0/320*SCREEN_WIDTH + 211.0/320*SCREEN_WIDTH)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView =[[UIImageView alloc] init];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.mas_offset(0);
        make.height.mas_offset(67.0/320*SCREEN_WIDTH);
    }];
    imageView.image = [UIImage imageNamed:@"SignUpHead_icon"];
    
    
    UIView *TopView = [[UIView alloc] init];
    [view addSubview:TopView];
    TopView.layer.cornerRadius = 4;
    TopView.backgroundColor = [UIColor colorWithHexString:@"#F5F7FA"];

    UIButton *TopLabel1 = [[UIButton alloc] init];
    [view addSubview:TopLabel1];
    [TopLabel1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(7);
        make.right.mas_offset(-7);
        make.top.equalTo(imageView.mas_bottom).offset(0);
        make.height.mas_offset(60.0/320*SCREEN_WIDTH);
    }];
    TopLabel1.titleLabel.font = FONT_SIZE(15);
    [TopLabel1 setTitle:@"报名成功，查看详情 >>" forState:UIControlStateNormal];
    [TopLabel1 setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [TopLabel1 addTarget:self action:@selector(CustomRightBt:) forControlEvents:UIControlEventTouchUpInside];

    
    [TopView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.top.equalTo(TopLabel1.mas_bottom).offset(0);
        make.height.mas_offset(64.0/320*SCREEN_WIDTH);
    }];
    
    
    UILabel *TopLabel2 = [[UILabel alloc] init];
    [TopView addSubview:TopLabel2];
    [TopLabel2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(16);
        make.right.mas_offset(-7);
        make.top.mas_offset(13.0/320*SCREEN_WIDTH);
    }];
    TopLabel2.font = FONT_SIZE(13);
    TopLabel2.text = [NSString stringWithFormat:@"姓名：%@",useername];
    TopLabel2.textColor = [UIColor colorWithHexString:@"#666666"];
    
    UILabel *TopLabel3 = [[UILabel alloc] init];
    [TopView addSubview:TopLabel3];
    [TopLabel3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(16);
        make.right.mas_offset(-16);
        make.top.equalTo(TopLabel2.mas_bottom).offset(8.0/320*SCREEN_WIDTH);
    }];
    TopLabel3.font = FONT_SIZE(13);
    TopLabel3.text = [NSString stringWithFormat:@"报名企业：%@",self.model.data.mechanismName];
    TopLabel3.textColor = [UIColor colorWithHexString:@"#666666"];

    
    
    UIView *BottomView = [[UIView alloc] init];
//    [view addSubview:BottomView];
//    [BottomView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.mas_offset(7);
//        make.right.mas_offset(-7);
//        make.top.equalTo(TopView.mas_bottom).offset(3);
//        make.height.mas_offset(83);
//    }];
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
    BottomLabel1.font = FONT_SIZE(14);
    BottomLabel1.textColor = [UIColor baseColor];
    BottomLabel1.text = @"推荐分享";
    
    UILabel *BottomLabel2 = [[UILabel alloc] init];
    [BottomView addSubview:BottomLabel2];
    [BottomLabel2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(7);
        make.right.mas_offset(-7);
        make.top.equalTo(BottomLabel1.mas_bottom).offset(8);
    }];
    BottomLabel2.font = FONT_SIZE(13);
    BottomLabel2.numberOfLines = 0;
    BottomLabel2.text = @"分享给好友，让好友为你加油点赞，可获取更多高额返费！";
    
    UIButton *LeftBt = [[UIButton alloc] init];
    [view addSubview:LeftBt];
    [LeftBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.top.equalTo(TopView.mas_bottom).offset(LENGTH_SIZE(30));
        make.height.mas_offset(42);
    }];
    LeftBt.layer.cornerRadius = 4;
    LeftBt.backgroundColor = [UIColor baseColor];
    LeftBt.titleLabel.font = FONT_SIZE(16);
    [LeftBt setTitle:@"分享好友，获取更多高额返费" forState:UIControlStateNormal];
    [LeftBt addTarget:self action:@selector(CustomLeft:) forControlEvents:UIControlEventTouchUpInside];
    LeftBt.tag = interViewID.integerValue;
    
    UIButton *RightBt = [[UIButton alloc] init];
//    [view addSubview:RightBt];
//    [RightBt mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.equalTo(LeftBt.mas_right).offset(7);
//        make.right.mas_offset(-7);
//        make.top.equalTo(BottomView.mas_bottom).offset(9);
//        make.height.mas_offset(42);
//        make.width.equalTo(LeftBt.mas_width);
//    }];
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
    NSString *url = [NSString stringWithFormat:@"%@referral?interviewId=%ld",
                     BaseRequestWeiXiURLTWO,
                     (long)sender.tag];
    
    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [LPTools ClickShare:encodedUrl Title:[NSString stringWithFormat:@"您的好友在蓝聘报名了%@，快来替他点赞加油，帮他获取更多返费吧！",_model.data.mechanismName]];
    
}
-(void)CustomRightBt:(UIButton *)sender{
    [self.CustomAlert close];
    if (self.isWorkOrder) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        LPWorkorderListVC *vc = [[LPWorkorderListVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

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
        [self.signUpButton setTitle:@"入职报名" forState:UIControlStateNormal];
        self.signUpButton.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
        self.signUpButton.enabled = NO;
    }
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();

      
    //解析HTML
    self.model.data.reInstruction = [self removeHTML2:self.model.data.reInstruction];
    self.model.data.workDemand = [self removeHTML2:self.model.data.workDemand];
    self.model.data.workSalary = [self removeHTML2:self.model.data.workSalary];
    self.model.data.eatSleep = [self removeHTML2:self.model.data.eatSleep];
    self.model.data.workTime = [self removeHTML2:self.model.data.workTime];
    self.model.data.workKnow = [self removeHTML2:self.model.data.workKnow];
    self.model.data.remarks = [self removeHTML2:self.model.data.remarks];
    self.model.data.mechanismDetails = [self removeHTML2:self.model.data.mechanismDetails];
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();

           NSLog(@"解析html耗时 - %f", end - start);
   
       
    [self.tableview reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成，执行后续代码
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();

        NSLog(@"刷新耗时 - %f", end - start);
    });
    
    
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
                [self.signUpButton setTitle:@"入职报名" forState:UIControlStateNormal];
                self.signUpButton.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat reOffset = scrollView.contentOffset.y + (SCREEN_HEIGHT - kNavBarHeight) * 0.2;
    CGFloat alpha = reOffset / ((SCREEN_HEIGHT - kNavBarHeight) * 0.2);
    if (alpha <= 1)//下拉永不显示导航栏
    {
        alpha = 0;
    }
    else//上划前一个导航栏的长度是渐变的
    {
        alpha -= 1;
    }
//    if (alpha == 0) {
//        [self.NBackBT setImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
//    }else{
        [self.NBackBT setImage:[UIImage imageNamed:@"BackBttonImage"] forState:UIControlStateNormal];
//    }
    // 设置导航条的背景图片 其透明度随  alpha 值 而改变
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:alpha]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0 green:0 blue:0 alpha:alpha], NSForegroundColorAttributeName, nil]];
    [self.NBackBT setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:alpha] forState:UIControlStateNormal];

}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else if (section == 1){
         return 10.0;
    }else if (section == 2){
        return 10.0;
    } else{
        return 35.0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 3;
    } else{
        return self.RecommendList.count;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 1) {
//        UIView *view = [[UIView alloc]init];
//        view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
//        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 54);
//        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 43)];
//        scrollView.backgroundColor = [UIColor whiteColor];
//        [view addSubview:scrollView];
//        scrollView.showsHorizontalScrollIndicator = NO;
//
//        NSArray *TypeArr = @[@"入职要求",@"企业介绍"];
//        CGFloat btnw = SCREEN_WIDTH/TypeArr.count;
//        for (int i = 0; i <TypeArr.count; i++) {
//            UIButton *button = [[UIButton alloc]init];
//            button.frame = CGRectMake(btnw*i, 0, btnw, 43);
//            [button setTitle:TypeArr[i] forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
//            button.tag = i;
//            button.titleLabel.font = [UIFont systemFontOfSize:16];
//            [button addTarget:self action:@selector(touchTextButton:) forControlEvents:UIControlEventTouchUpInside];
//            [self.buttonArray addObject:button];
//            [scrollView addSubview:button];
//        }
//        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 43);
//
//        self.lineView = [[UIView alloc]init];
//        self.lineView.frame = CGRectZero;
//        self.lineView.backgroundColor = [UIColor baseColor];
//        [scrollView addSubview:self.lineView];
//        [self selectButtonAtIndex:self.selectIndex];
//
//        return view;
//
//
//    }
    
    if (section == 1 || section == 2) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
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
        self.lineView.frame = CGRectMake(btnx + x-5, 42, rect.size.width+10, 2);
    }];
    
}
-(void)scrollToItenIndex:(NSInteger)index{
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *strbackmoney = self.model.data.reInstruction;
        CGFloat KeyHeight = [self calculateKeyHeight:self.model.data.key];
        
//        if (self.model.data.key.length == 0 && ![self.model.data.lendType integerValue]) {
//            KeyHeight = 0;
//        }
        
        if ((strbackmoney.length>0 &&
             self.model.data.reTime.integerValue>0 &&
             self.model.data.reMoney.integerValue>0 &&
             self.model.data.reStatus.integerValue == 1 &&
             [self.model.data.postType integerValue] == 0 )||
            (strbackmoney.length>0 &&
             self.model.data.reTime.integerValue>0 &&
             self.model.data.addWorkMoney.floatValue>0.0 &&
             self.model.data.reStatus.integerValue == 1&&
             [self.model.data.postType integerValue] == 1)) {
            CGFloat BackMoneyHeight = [LPTools calculateRowHeight:strbackmoney fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(26)];
             return LENGTH_SIZE(280 + 128 + 36 + 20)  + BackMoneyHeight + KeyHeight;
        }else{
            return LENGTH_SIZE(280 + 128 ) + KeyHeight;
        }
    }else if (indexPath.section == 1){
 
            return [self calculateFromViewHeight];
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            CGFloat Height = [LPTools calculateRowHeight:self.model.data.mechanismDetails fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(28)];
            return LENGTH_SIZE(51)+Height;
        }else if (indexPath.row == 1){
            CGFloat Height = [LPTools calculateRowHeight:[NSString stringWithFormat:@"企业地址:%@\n面试地址:%@",self.model.data.mechanismAddress,self.model.data.recruitAddress] fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(28)];
            return LENGTH_SIZE(66)+Height;
        }else if (indexPath.row == 2){
            return LENGTH_SIZE(44.0);
        }
    } else{
        return LENGTH_SIZE(86) ;
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LPWorkDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailHeadCellID];
        cell.model = self.model;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }else if (indexPath.section == 1){
 
//        LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
//        cell.detailTitleLabel.text = [NSString stringWithFormat:@"%@:",self.textArray[indexPath.row]];
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        if (indexPath.row == 0) {
//            cell.detailLabel.text = self.model.data.workDemand;
////            cell.detailLabel.text = [self.model.data.workDemand htmlUnescapedString];
//        }else if (indexPath.row == 1){
//            cell.detailLabel.text = self.model.data.workSalary;
//        }else if (indexPath.row == 2){
//            cell.detailLabel.text = self.model.data.eatSleep;
//        }else if (indexPath.row == 3){
//            cell.detailLabel.text = self.model.data.workTime;
//        }else if (indexPath.row == 4){
//            cell.detailLabel.text = self.model.data.workKnow;
//        }else if (indexPath.row == 5){
//            cell.detailLabel.text = self.model.data.remarks;
//        }
        
        LPWorkDetailFromCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailFromCellID];
        cell.model = self.model;
        
        return cell;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
            cell.detailTitleLabel.text = @"企业简介:";
            cell.detailLabel.text = self.model.data.mechanismDetails;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }else if (indexPath.row == 1){

            LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
            cell.detailTitleLabel.text = @"企业地址:";
            cell.detailLabel.text = [NSString stringWithFormat:@"企业地址:%@\n面试地址:%@",self.model.data.mechanismAddress,self.model.data.recruitAddress];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }else{
            static NSString *rid=@"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            if(cell == nil){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
                UIView *LineV = [[UIView alloc] init];
                [cell.contentView addSubview:LineV];
                [LineV mas_makeConstraints:^(MASConstraintMaker *make){
                    make.left.top.mas_offset(0);
                    make.height.mas_offset(1);
                    make.width.mas_offset(SCREEN_WIDTH);
                }];
                LineV.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor baseColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = @"导航查看面试地址";
            cell.imageView.image = [UIImage imageNamed:@"guide"];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }
    } else{
        LPMain2Cell *cell = [tableView dequeueReusableCellWithIdentifier:LPMainCellID];
        if(cell == nil){
            cell = [[LPMain2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMainCellID];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

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
        NSMutableArray *naviVCsArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        for (UIViewController *vc in naviVCsArr) {
            if ([vc isKindOfClass:[self class]]) {
                [naviVCsArr removeObject:vc];
                break;
            }
        }
        [naviVCsArr addObject:vc];
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController  setViewControllers:naviVCsArr animated:YES];
 
    }else if (indexPath.section == 2 && indexPath.row == 2){
        NSDecimalNumber *XNumber = [NSDecimalNumber decimalNumberWithString:self.model.data.x];
        NSDecimalNumber *YNumber = [NSDecimalNumber decimalNumberWithString:self.model.data.y];
        
        CLLocationCoordinate2D pt2 = {[XNumber doubleValue],[YNumber doubleValue]};
        
        self.coordinate = [self GCJ02FromBD09:pt2];
        
        [self ToNavMap];
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
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPWorkDetailModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
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
            if ([responseObject[@"code"] integerValue] == 0) {
                if (!ISNIL(responseObject[@"data"])) {
                    if ([responseObject[@"data"] integerValue] == 0) {
                        self.bottomButtonArray[0].selected = YES;
                        [LPTools AlertCollectView:@""];
                    }else if ([responseObject[@"data"] integerValue] == 1) {
                        self.bottomButtonArray[0].selected = NO;
                        if (self.CollectionBlock) {
                            self.CollectionBlock();
                        }
                    }
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
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
            if ([responseObject[@"code"] integerValue] == 0) {
                self.isApplyOrIsCollectionModel = [LPIsApplyOrIsCollectionModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
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
                          @"identity":[LPTools isNullToString:self.upIdentity]
                          };
    NSString * string = @"work/entryApply?type=0";
    [NetApiManager requestEntryApplyWithUrl:string withParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0 ) {
                if ([responseObject[@"data"] integerValue] >0) {
                    self.workListModel.isApply = @(0);
                    [self requestIsApplyOrIsCollection];
                    [self applySuccessAlert:responseObject[@"data"]];
                }else{
                    [self.view showLoadingMeg:@"报名失败,请稍后再试" time:MESSAGE_SHOW_TIME*2];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME*2];
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
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    self.signUpButton.selected = NO;
                    self.workListModel.isApply = @(1);
                    [self requestIsApplyOrIsCollection];
                }else{
                    [self.view showLoadingMeg:@"取消报名失败,请稍后再试" time:MESSAGE_SHOW_TIME*2];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME*2];
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryAddShareRecord:(AddShareRecord)Record{

    NSString *urlStr = [NSString stringWithFormat:@"invite/add_share_record?type=0"];
    self.Record = Record;

    [NetApiManager requestQueryAddShareRecord:nil URLString:urlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                CGFloat Time = 0.0;
                if ([responseObject[@"data"] integerValue] >0 ) {
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"恭喜获得20积分，请去个人中心查看" time:MESSAGE_SHOW_TIME];
                    Time = 1.0;
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.Record) {
                        self.Record(responseObject[@"data"]) ;
                    }
                });
                
                
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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
            if ([responseObject[@"code"] integerValue] == 0) {
                self.RecommendList = [LPWorklistDataWorkListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [self.tableview reloadData];
                
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
        _tableview.estimatedRowHeight = 0;

        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPWorkDetailHeadCellID bundle:nil] forCellReuseIdentifier:LPWorkDetailHeadCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPWorkDetailTextCellID bundle:nil] forCellReuseIdentifier:LPWorkDetailTextCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPMainCellID bundle:nil] forCellReuseIdentifier:LPMainCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPWorkDetailFromCellID bundle:nil] forCellReuseIdentifier:LPWorkDetailFromCellID];
    }
    return _tableview;
}


//计算标签高度
-(CGFloat)calculateKeyHeight:(NSString *) Key{
    if (Key.length == 0) {
        return LENGTH_SIZE(17);
    }
    Key = [Key stringByReplacingOccurrencesOfString:@"丨" withString:@"|"];

    NSArray * tagArr = [Key componentsSeparatedByString:@"|"];
    CGFloat tagBtnX = 0;
    CGFloat tagBtnY = 0;
    for (int i= 0; i<tagArr.count; i++) {
        CGSize tagTextSize = [tagArr[i] sizeWithFont:[UIFont systemFontOfSize:FontSize(12)] maxSize:CGSizeMake(SCREEN_WIDTH-LENGTH_SIZE(73), LENGTH_SIZE(17))];
        if (tagBtnX+tagTextSize.width+14 > SCREEN_WIDTH-LENGTH_SIZE(73)) {
            tagBtnX = 0;
            tagBtnY += LENGTH_SIZE(17)+8;
        }
        tagBtnX = tagBtnX + tagTextSize.width + LENGTH_SIZE(4);
    }
    return tagBtnY + LENGTH_SIZE(17) ;
}

//计算Cell标签高度
-(CGFloat)calculateKeyHeightCell:(NSString *) Key{
    if (Key.length == 0) {
        return 0;
    }
    Key = [Key stringByReplacingOccurrencesOfString:@"丨" withString:@"|"];
    NSArray * tagArr = [Key componentsSeparatedByString:@"|"];
    CGFloat tagBtnX = 0;
    CGFloat tagBtnY = 0;
    for (int i= 0; i<tagArr.count; i++) {
        CGSize tagTextSize = [tagArr[i] sizeWithFont:[UIFont systemFontOfSize:FontSize(12)] maxSize:CGSizeMake(SCREEN_WIDTH-LENGTH_SIZE(116), LENGTH_SIZE(17))];
        if (tagBtnX+tagTextSize.width+14 > SCREEN_WIDTH-LENGTH_SIZE(116)) {
            tagBtnX = 0;
            tagBtnY += LENGTH_SIZE(17)+8;
        }
        tagBtnX = tagBtnX + tagTextSize.width + LENGTH_SIZE(4);
    }
    return tagBtnY + LENGTH_SIZE(17);
}
//计算from高度
-(CGFloat)calculateFromViewHeight{
    NSArray *TypeDataArr = @[[LPTools isNullToString:self.model.data.sexAge],
                             [LPTools isNullToString:self.model.data.tattooHair],
                             [LPTools isNullToString:self.model.data.medicalFee],
                             [LPTools isNullToString:self.model.data.vision],
                             [LPTools isNullToString:self.model.data.culturalSkills],
                             [LPTools isNullToString:self.model.data.nation],
                             [LPTools isNullToString:self.model.data.idCard],
                             [LPTools isNullToString:self.model.data.postOther],
                             [self.model.data.postType integerValue] == 0 ? [LPTools isNullToString:self.model.data.workingPrice] : [LPTools isNullToString:self.model.data.hoursPrice],
                             [LPTools isNullToString:self.model.data.overtimeDetails],
                             [LPTools isNullToString:self.model.data.subsidyDetails],
                             [LPTools isNullToString:self.model.data.payrollTime],
                             [LPTools isNullToString:self.model.data.salaryOther],
                             [LPTools isNullToString:self.model.data.accConditions],
                             [LPTools isNullToString:self.model.data.diet],
                             [LPTools isNullToString:self.model.data.accOther],
                             [LPTools isNullToString:self.model.data.workSystem],
                             [LPTools isNullToString:self.model.data.shiftTime],
                             [LPTools isNullToString:self.model.data.workOther],
                             [LPTools isNullToString:self.model.data.interviewData],
                             [LPTools isNullToString:self.model.data.interviewOther]];
    
    CGFloat FromHeight = LENGTH_SIZE(78) + LENGTH_SIZE(34) * 5 ;
    for (NSInteger i =0; i<TypeDataArr.count; i++) {
        NSString *str = TypeDataArr[i];
        if (str.length == 0) {
            str = @"无";
        }
        
        CGFloat RowHeight = [LPTools calculateRowHeight:str fontSize:FontSize(13) Width:SCREEN_WIDTH - LENGTH_SIZE(145)];
        
        FromHeight += LENGTH_SIZE(7+7+1) + RowHeight;

    }
    
    if ([self.model.data.postType integerValue] == 1) {
        NSString *str = self.model.data.overtimeDetails;
        if (str.length == 0) {
            str = @"无";
        }
        
        CGFloat overtimewHeight = [LPTools calculateRowHeight:str fontSize:FontSize(13) Width:SCREEN_WIDTH - LENGTH_SIZE(145)];
        FromHeight -= LENGTH_SIZE(14) + overtimewHeight + 1;
    }
    
    return FromHeight;
    
}


- (NSString *)removeHTML2:(NSString *)html{
 
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSString *string = [attrStr.string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    
    return string;
    
}



-(void)ToNavMap
{
    //系统版本高于8.0，使用UIAlertController
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //自带地图
    [alertController addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"alertController -- 自带地图");
        
        //使用自带地图导航
        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:nil]];
        
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
        
        
    }]];
    
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 高德地图");
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2&dname=%@",self.coordinate.latitude,self.coordinate.longitude,self.model.data.recruitAddress]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 百度地图");
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02&title=%@",self.coordinate.latitude,self.coordinate.longitude,self.model.data.recruitAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 腾讯地图");
            
            NSString *urlsting =[[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&to=%@&type=drive&tocoord=%f,%f&coord_type=1&referer={ios.blackfish.XHY}",self.model.data.recruitAddress,self.coordinate.latitude,self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    
    
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    //显示alertController
    [[UIWindow visibleViewController] presentViewController:alertController animated:YES completion:nil];
    
}


-(CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor
{
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude - 0.0065, y = coor.latitude - 0.006;
    CLLocationDegrees z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    CLLocationDegrees gg_lon = z * cos(theta);
    CLLocationDegrees gg_lat = z * sin(theta);
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
