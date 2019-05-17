//
//  LPHomeCustomerServiceVC.m
//  BlueHired
//
//  Created by iMac on 2018/12/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPHomeCustomerServiceVC.h"
#import "LPCustomerServiceModel.h"
#import "LPCustomerServiceVC.h"
#import "LPtestViewController.h"
#import "LPHFButton.h"
#import "LPRHFButton.h"

@interface LPHomeCustomerServiceVC ()<UITextFieldDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) LPCustomerServiceModel *model;
@property (nonatomic, strong) NSMutableArray <UILabel *>*LabelArray;
@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) UIView *searchBgView;
@property (nonatomic, strong) UIView *BacksearchView;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) NSMutableArray *KeuArrayList;

@property (nonatomic, strong) LPHFButton *TopReplyImage;

@end

@implementation LPHomeCustomerServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _LabelArray = [[NSMutableArray alloc] init];
    _KeuArrayList = [[NSMutableArray alloc] init];

    [self setupUI];
    [self setBottomView];
    [self requestQueryProblem];
 
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;

}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [btn setTitle:@" 返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)setupUI{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFEBF7FF"];
    
    self.navigationItem.title = @"我的客服";
    UIFont *font = [UIFont fontWithName:@"Arial-ItalicMT" size:19];
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes =dic;
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor baseColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forBarMetrics:UIBarMetricsDefault];
    
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"Phone_Image"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    self.automaticallyAdjustsScrollViewInsets = YES;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kNavBarHeight - kBottomBarHeight - 48)];
//    scrollView.backgroundColor = [UIColor redColor];
    scrollView.alwaysBounceVertical = YES;
     scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    NSLog(@"%f",scrollView.frame.origin.y);
    NSLog(@"self%f",SCREEN_HEIGHT);
//    UIView *view2 = [[UIView alloc] init];
//    [scrollView addSubview:view2];
//    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(113);
//        make.right.mas_equalTo(-50);
//        make.width.mas_equalTo(160);
//        make.height.mas_equalTo(160);
//    }];
//    view2.backgroundColor = [UIColor redColor];
    
    
    UIView *HeadView = [[UIView alloc] initWithFrame:CGRectMake(10, 14, SCREEN_WIDTH - 20, SCREEN_WIDTH/320 *109 )];
    HeadView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:HeadView];
    UIImageView *Image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/320 * 62, HeadView.frame.size.height)];
    Image.image = [UIImage imageNamed:@"serviceHeadImage"];
    [HeadView addSubview:Image];
    
    [_LabelArray removeAllObjects];
    for (int i =0 ; i <3; i++) {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Image.frame.size.width+8, i*HeadView.frame.size.height/3, HeadView.frame.size.width - Image.frame.size.width - 37 -8, HeadView.frame.size.height/3)];
        label1.font = [UIFont systemFontOfSize:14];
        label1.text = @"Label1";
        label1.tag = i;
        label1.numberOfLines =2;
        [HeadView addSubview:label1];
        [_LabelArray addObject:label1];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y+label1.frame.size.height, HeadView.frame.size.width - Image.frame.size.width - 37 -8, 1)];
        lineView.backgroundColor = i==2?[UIColor clearColor]: [UIColor colorWithHexString:@"#FFE6E6E6"];
        [HeadView addSubview:lineView];
    }
    
    UIImageView *ToImage = [[UIImageView alloc] initWithFrame:CGRectMake(HeadView.frame.size.width - 37, 0, 37, HeadView.frame.size.height)];
    ToImage.image = [UIImage imageNamed:@"ServiceToImage"];
    ToImage.contentMode = UIViewContentModeCenter;
    [HeadView addSubview:ToImage];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, HeadView.frame.size.width, HeadView.frame.size.height)];
    [button addTarget:self action:@selector(touchTOVC) forControlEvents:UIControlEventTouchUpInside];
    [HeadView addSubview:button];
    
}

-(void)touchTOVC{
    LPCustomerServiceVC *vc = [[LPCustomerServiceVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)touchButton:(UIButton *)sender{
    sender.enabled = NO;
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.data.telephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}



-(void)setBottomView{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //监听键盘，键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification object:nil];
    //监听键盘隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keybaordWillHide:)
                                                name:UIKeyboardWillHideNotification object:nil];
    
    self.bottomBgView = [[UIView alloc]init];
    self.bottomBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bottomBgView];
    [self.bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(48);
    }];
    
    UIView *backSearch = [[UIView alloc] init];
    [self.bottomBgView addSubview:backSearch];
    self.BacksearchView = backSearch;
//    self.BacksearchView.backgroundColor = [UIColor whiteColor];
    [self.BacksearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-91);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    
    self.searchBgView = [[UIView alloc]init];
    [self.BacksearchView addSubview:self.searchBgView];
    [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-7);
        make.height.mas_equalTo(34);
    }];
    self.searchBgView.layer.masksToBounds = YES;
    self.searchBgView.layer.cornerRadius = 17;
    self.searchBgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFFFF"];
    
    UIImageView *writeImg = [[UIImageView alloc]init];
    [self.searchBgView addSubview:writeImg];
    [writeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.equalTo(self.searchBgView);
        make.size.mas_equalTo(CGSizeMake(15, 14));
    }];
    writeImg.image = [UIImage imageNamed:@"comment_write"];
    
    self.commentTextField = [[UITextField alloc]init];
    [self.searchBgView addSubview:self.commentTextField];
    [self.commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(writeImg.mas_right).offset(5);
        make.right.mas_equalTo(10);
        make.height.mas_equalTo(self.searchBgView.mas_height);
        make.centerY.equalTo(self.searchBgView);
    }];
    self.commentTextField.delegate = self;
    self.commentTextField.tintColor = [UIColor baseColor];
    self.commentTextField.placeholder = @"有问题，找客服";
    self.commentTextField.returnKeyType = UIReturnKeySend;
    self.commentTextField.enablesReturnKeyAutomatically =YES;
    [self.commentTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    self.sendButton = [[UIButton alloc]init];
    [self.bottomBgView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBgView.mas_right).offset(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(33);
        make.centerY.equalTo(self.bottomBgView);
    }];
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.layer.cornerRadius = 16.5;
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.sendButton.hidden = YES;
//    self.sendButton.enabled = NO;
    self.sendButton.backgroundColor = [UIColor baseColor];
    [self.sendButton addTarget:self action:@selector(touchSendButton:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  当键盘改变了frame(位置和尺寸)的时候调用
 */
-(void)keyboardWillChangeFrameNotify:(NSNotification*)notify {
    // 0.取出键盘动画的时间
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - SCREEN_HEIGHT;
    
    if (transformY<0) {
        self.bottomBgView.backgroundColor = [UIColor whiteColor];
        self.searchBgView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];

    }else{
        self.bottomBgView.backgroundColor = [UIColor clearColor];
        self.searchBgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFFFF"];
    }
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(48);
            if (transformY < 0) {
                make.bottom.mas_equalTo(0+transformY);
            }else{
                if (@available(iOS 11.0, *)) {
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                } else {
                    make.bottom.mas_equalTo(0);
                }
            }
            make.right.mas_equalTo(0);
        }];
        [self.view bringSubviewToFront:self.bottomBgView];
        
//        [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(0);
//            make.height.mas_equalTo(48);
//            make.left.equalTo(self.searchBgView.mas_right).mas_offset(-5);
//            if (transformY == 0) {
//                make.right.mas_equalTo(0);
//            }
//        }];
//        [self.view bringSubviewToFront:self.bottomBgView];
//        [self.bottomBgView.superview layoutIfNeeded];
        
        
    }];
}
-(void)keyboardWillShow:(NSNotification *)sender{
    //    for (UIButton *button in self.bottomButtonArray) {
    //        button.hidden = YES;
    //    }
    //    self.sendButton.hidden = NO;
}
-(void)keybaordWillHide:(NSNotification *)sender{
    //    for (UIButton *button in self.bottomButtonArray) {
    //        button.hidden = NO;
    //    }
    //    self.sendButton.hidden = YES;
}


-(void)textFieldChanged:(UITextField *)textField{
//    if (textField.text.length > 0) {
//        self.sendButton.enabled = YES;
//        self.sendButton.backgroundColor = [UIColor baseColor];
//    }else{
//        self.sendButton.enabled = NO;
//        self.sendButton.backgroundColor = [UIColor lightGrayColor];
//    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.commentTextField.text.length > 300) {
        [self.view showLoadingMeg:@"问题内容过长" time:MESSAGE_SHOW_TIME];
        return YES;
    }
    
    if (self.commentTextField.text.length > 0) {
        [self requestQueryProblemDetailWithParamKey];
    }
    return YES;
}
#pragma mark - target
-(void)touchSendButton:(UIButton *)button{
    if (self.commentTextField.text.length > 300) {
        [self.view showLoadingMeg:@"问题内容过长" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.commentTextField.text.length > 0) {
        [self requestQueryProblemDetailWithParamKey];
    }
}




-(void)setModel:(LPCustomerServiceModel *)model{
    _model = model;
    
    NSMutableArray *Problem = [[NSMutableArray alloc] init];
    for (LPCustomerServiceDataListModel *M in model.data.list) {
        [Problem addObjectsFromArray:[M.problemTitle componentsSeparatedByString:@"#"]];
    }
    if (Problem.count>=3) {
        for (int i = 0 ;i <self.LabelArray.count ; i++) {
            self.LabelArray[i].text = Problem[i];
        }
    }else{
        for (int i = 0 ;i <Problem.count ; i++) {
            self.LabelArray[i].text = Problem[i];
        }
    }
//    [self.tableview reloadData];
}


#pragma mark - request
-(void)requestQueryProblem{
    [NetApiManager requestQueryProblemWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPCustomerServiceModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestQueryProblemDetailWithParamKey{
    
    NSDictionary *dic = @{@"key":self.commentTextField.text};
    [NetApiManager requestQueryProblemDetailWithParamKey:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
//            self.model = [LPCustomerServiceModel mj_objectWithKeyValues:responseObject];
            if ([responseObject[@"code"] integerValue] == 0 ) {
                [self initComment:self.commentTextField.text Reply:responseObject[@"data"]];
                self.commentTextField.text = nil;
                [self.commentTextField resignFirstResponder];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)initComment:(NSString *)AskStr Reply:(NSString *) replyStr{
    //问
    UIImageView *AskImage = [[UIImageView  alloc] init];
    [self.scrollView addSubview:AskImage];
    [AskImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREEN_WIDTH-13-33);
        if (self.TopReplyImage) {
            make.top.mas_equalTo(self.TopReplyImage.mas_bottom).offset(15);
        }else{
            make.top.mas_equalTo(SCREEN_WIDTH/320 *109 +24);
        }
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(33);
    }];
    AskImage.image = [UIImage imageNamed:@"Head_image"];

    LPRHFButton *AskLable = [[LPRHFButton alloc] init];
    [self.scrollView addSubview:AskLable];

    [AskLable setTitle:AskStr forState:UIControlStateNormal];
    [AskLable setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // 0.创建一张图片CustomerServiceBaseImage
    UIImage *image = [UIImage imageNamed:@"CustomerServiceBaseImage"];
    // 1.获取图片尺寸
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    // 2.拉伸图片
    UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(height * 0.5, width * 0.5, height * 0.5 - 1, width * 0.5 - 1)];
    // 3.把拉伸过的图片设置为button的背景图片
    [AskLable setBackgroundImage:resizableImage forState:UIControlStateNormal];
    AskLable.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 22);
//    [AskLable setBackgroundImage:[UIImage imageNamed:@"CustomerServiceBaseImage"] forState:UIControlStateNormal];
//    AskLable.backgroundColor = [UIColor blackColor];
    AskLable.titleLabel.numberOfLines = 0;
    [AskLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(AskImage.mas_left).offset(5);
        make.top.equalTo(AskImage);
        make.left.mas_greaterThanOrEqualTo(@46);
        //        make.height.mas_lessThanOrEqualTo(@40);
    }];
    
    
    //答
    UIImageView *ReplyImage = [[UIImageView alloc] init];
    [self.scrollView addSubview:ReplyImage];
    [ReplyImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(AskLable.mas_bottom).offset(15);
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(33);
    }];
    ReplyImage.image = [UIImage imageNamed:@"ServiceHeadImage-1"];
    
    LPHFButton *ReplyLable = [[LPHFButton alloc] init];
    [self.scrollView addSubview:ReplyLable];
    [ReplyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ReplyImage.mas_right).offset(-5);
        make.top.equalTo(ReplyImage);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-88);
//        make.right.mas_equalTo(-446);
//        make.height.mas_lessThanOrEqualTo(@40);

    }];

    [ReplyLable setTitle:replyStr forState:UIControlStateNormal];
    [ReplyLable setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ReplyLable.titleLabel.numberOfLines = 0;
    
    // 0.创建一张图片
    UIImage *image2 = [UIImage imageNamed:@"CustomerServiceBlackImage"];
    // 1.获取图片尺寸
    CGFloat width2 = image.size.width;
    CGFloat height2 = image.size.height;
    // 2.拉伸图片
    UIImage *resizableImage2 = [image2 resizableImageWithCapInsets:UIEdgeInsetsMake(height2 * 0.5, width2 * 0.5, height2 * 0.5 - 1, width2 * 0.5 - 1)];
    // 3.把拉伸过的图片设置为button的背景图片
    [ReplyLable setBackgroundImage:resizableImage2 forState:UIControlStateNormal];
    ReplyLable.contentEdgeInsets = UIEdgeInsetsMake(10, 22, 10, 0);
    
//    [ReplyLable setBackgroundImage:[UIImage imageNamed:@"CustomerServiceBlackImage"] forState:UIControlStateNormal];
    
    self.TopReplyImage = ReplyLable;
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.TopReplyImage.frame) + SCREEN_WIDTH/320 *109 + 40);
    
    if ((self.scrollView.contentSize.height - self.scrollView.bounds.size.height)>0) {
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
        [self.scrollView setContentOffset:bottomOffset animated:YES];
    }
}


@end
