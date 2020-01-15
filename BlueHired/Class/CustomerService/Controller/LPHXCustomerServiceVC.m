//
//  LPHXCustomerServiceVC.m
//  BlueHired
//
//  Created by iMac on 2019/10/31.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPHXCustomerServiceVC.h"
#import "LPCustomerServiceModel.h"
#import "LPHXServiceHeadCell.h"
#import "LPHXMessageTxtCell.h"
#import "LPHXMessageTimeCell.h"
#import "LPHXMessageImageCell.h"
#import "LPMessageToServiceCell.h"

#import "HDIMessageModel.h"
#import "HDMessageModel.h"
 
#import "LPServiceCommentVC.h"


static  NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvh1MAVToAiuEVOFq9mo3IOJxN5aekgto1kyOh07qQ+1Wc+Uxk1wX2t6+HCA31ojcgaR/dZz/kQ5aZvzlB8odYHJXRtIcOAVQe/FKx828XFTzC8gp1zGh7vTzBCW3Ieuq+WRiq9cSzEZlNw9RcU38st9q9iBT8PhK0AkXE2hLbKQIDAQAB";
static NSString *RSAPrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO+HUwBVOgCK4RU4Wr2ajcg4nE3lp6SC2jWTI6HTupD7VZz5TGTXBfa3r4cIDfWiNyBpH91nP+RDlpm/OUHyh1gcldG0hw4BVB78UrHzbxcVPMLyCnXMaHu9PMEJbch66r5ZGKr1xLMRmU3D1FxTfyy32r2IFPw+ErQCRcTaEtspAgMBAAECgYBSczN39t5LV4LZChf6Ehxh4lKzYa0OLNit/mMSjk43H7y9lvbb80QjQ+FQys37UoZFSspkLOlKSpWpgLBV6gT5/f5TXnmmIiouXXvgx4YEzlXgm52RvocSCvxL81WCAp4qTrp+whPfIjQ4RhfAT6N3t8ptP9rLgr0CNNHJ5EfGgQJBAP2Qkq7RjTxSssjTLaQCjj7FqEYq1f5l+huq6HYGepKU+BqYYLksycrSngp0y/9ufz0koKPgv1/phX73BmFWyhECQQDx1D3Gui7ODsX02rH4WlcEE5gSoLq7g74U1swbx2JVI0ybHVRozFNJ8C5DKSJT3QddNHMtt02iVu0a2V/uM6eZAkEAhvmce16k9gV3khuH4hRSL+v7hU5sFz2lg3DYyWrteHXAFDgk1K2YxVSUODCwHsptBNkogdOzS5T9MPbB+LLAYQJBAKOAknwIaZjcGC9ipa16txaEgO8nSNl7S0sfp0So2+0gPq0peWaZrz5wa3bxGsqEyHPWAIHKS20VRJ5AlkGhHxECQQDr18OZQkk0LDBZugahV6ejb+JIZdqA2cEQPZFzhA3csXgqkwOdNmdp4sPR1RBuvlVjjOE7tCiFLup/8TvRJDdr";

static NSString *LPHXServiceHeadCellID = @"LPHXServiceHeadCell";
static NSString *LPHXCustomerServiceCellID = @"LPHXCustomerServiceCell";
static NSString *LPHXMessageTxtCellID = @"LPHXMessageTxtCell";
static NSString *LPHXMessageTimeCellID = @"LPHXMessageTimeCell";
static NSString *LPHXMessageImageCellID = @"LPHXMessageImageCell";
static NSString *LPMessageToServiceCellID = @"LPMessageToServiceCell";

static NSInteger messageCountOfPage = 10;

@interface LPHXCustomerServiceVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HDChatManagerDelegate>
{
    dispatch_queue_t _messageQueue;
}
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong) UIView *HeadView;
@property (nonatomic, strong) LPCustomerServiceModel *model;

@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) NSMutableArray *messsagesSource;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) HDConversation *conversation;
@property (nonatomic) NSTimeInterval messageTimeIntervalTag;

@property (nonatomic, assign) BOOL isECEIM;


@end

@implementation LPHXCustomerServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"专属客服";
    _messageQueue = dispatch_queue_create("com.helpdesk.message.queue", NULL);
    self.dataArray = [[NSMutableArray alloc] init];
    self.messsagesSource = [[NSMutableArray alloc] init];

    [self setBottomView];
    [self requestQueryProblem];
    
    [self.tableview reloadData];

}

- (void)dealloc {
    //参数为是否解绑推送的devicetoken
    [[HDClient sharedClient].chatManager removeDelegate:self];
    HDError *error = [[HDClient sharedClient] logout:YES];
    if (error) { //登出出错
    } else {//登出成功
    }
}


- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.NBackBT = btn;
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)setBottomView{
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
  
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor baseColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forBarMetrics:UIBarMetricsDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.bottomBgView = [[UIView alloc]init];
    self.bottomBgView.backgroundColor = [UIColor whiteColor];
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
        make.height.mas_equalTo(LENGTH_SIZE(60));
    }];
    
   
    
    self.commentTextField = [[UITextField alloc]init];
    [self.bottomBgView addSubview:self.commentTextField];
    [self.commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(LENGTH_SIZE(13));
        make.right.mas_offset(LENGTH_SIZE(-81));
        make.height.mas_equalTo(LENGTH_SIZE(36));
        make.centerY.equalTo(self.bottomBgView);
    }];
    self.commentTextField.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    self.commentTextField.layer.cornerRadius = LENGTH_SIZE(18);
    self.commentTextField.clipsToBounds = YES;
    self.commentTextField.leftViewMode = UITextFieldViewModeAlways;
    self.commentTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(16), LENGTH_SIZE(30))];

    self.commentTextField.delegate = self;
    self.commentTextField.placeholder = @"请输入你要咨询的问题";
    self.commentTextField.returnKeyType = UIReturnKeySend;
    self.commentTextField.enablesReturnKeyAutomatically =YES;
    
    self.sendButton = [[UIButton alloc]init];
    [self.bottomBgView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(LENGTH_SIZE(-13));
        make.height.mas_equalTo(LENGTH_SIZE(30));
        make.width.mas_offset(LENGTH_SIZE(60));
        make.centerY.equalTo(self.bottomBgView);
    }];
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.layer.cornerRadius = LENGTH_SIZE(15);
    self.sendButton.layer.borderWidth = LENGTH_SIZE(1);

    self.sendButton.layer.borderColor = [UIColor baseColor].CGColor;
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    
    
    [self.sendButton addTarget:self action:@selector(touchSendButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(0));
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.bottomBgView.mas_top).offset(0);
    }];
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
    
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(LENGTH_SIZE(48));
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
        
        [self.tableview mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.mas_offset(LENGTH_SIZE(0));
               make.left.right.mas_offset(0);
               make.bottom.equalTo(self.bottomBgView.mas_top).offset(0);
        }];
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.bottomBgView];
        if ([self.dataArray count]) {
            [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - 1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    }];
    
 
}

#pragma mark - Touch
-(void)touchSendButton:(UIButton *)button{
    if (self.commentTextField.text.length > 300) {
        [self.view showLoadingMeg:@"问题内容过长" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    button.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           button.enabled = YES;
    });
    
    if (self.commentTextField.text.length > 0) {
        [self sendMessageTxt:self.commentTextField.text];
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.commentTextField.text.length > 300) {
        [self.view showLoadingMeg:@"问题内容过长" time:MESSAGE_SHOW_TIME];
        return YES;
    }
    
 
    if (self.commentTextField.text.length > 0) {
        [self sendMessageTxt:textField.text];
        self.commentTextField.text = nil;
    }
    return YES;
}

#pragma mark - TableViewDelegate & Datasource
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSMutableArray *Problem = [[NSMutableArray alloc] init];
        for (LPCustomerServiceDataListModel *M in self.model.data.list) {
            [Problem addObjectsFromArray:[M.problemTitle componentsSeparatedByString:@"#"]];
        }
        CGFloat StrHeight = 12.0;
        NSInteger Count = Problem.count >= 3 ? 3 : Problem.count;
        for (int i = 0 ;i < Count ; i++) {
            NSString *str = [NSString stringWithFormat:@"%d.%@",i+1,Problem[i]];
            StrHeight+=[LPTools calculateRowHeight:str fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(46)];
            StrHeight+= 13;
        }
        return StrHeight + LENGTH_SIZE(106);
    }else{
        id object = [self.dataArray objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[NSString class]]) {
            return LENGTH_SIZE(44);
        }else if ([object isKindOfClass:[LPCustomMessageModel class]]){
            LPCustomMessageModel *model = object;
            if (model.Type == 0) {
                CGFloat StrHeight = [LPTools calculateRowHeight:model.text fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(130)];
                return StrHeight + LENGTH_SIZE(52);
            }else{
                CGFloat StrHeight = [LPTools calculateRowHeight:model.text fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(130)];
                return LENGTH_SIZE(173 + 18);
            }
        }else{
            id<HDIMessageModel> model = object;

            if (model.bodyType == EMMessageBodyTypeText) {
                HDExtMsgType extMsgType = [HDMessageHelper getMessageExtType:model.message];
                if (extMsgType == HDExtEvaluationMsg) {
                    return LENGTH_SIZE(120);
                }else{
                    CGFloat StrHeight = [LPTools calculateRowHeight:model.text fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(130)];
                    return StrHeight + LENGTH_SIZE(52);
                }
            }else if (model.bodyType == EMMessageBodyTypeImage){
                return LENGTH_SIZE(138);
            } else {
                return LENGTH_SIZE(44);
            }
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        id object = [self.dataArray objectAtIndex:indexPath.row];
        //time cell
        if ([object isKindOfClass:[NSString class]]) {
            LPHXMessageTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:LPHXMessageTimeCellID];
            cell.MessageTime.text = [NSString stringWithFormat:@"  %@  ",object];
            return cell;
        }else if ([object isKindOfClass:[LPCustomMessageModel class]]){
            LPCustomMessageModel *model = object;
            if (model.Type == 0) {
                LPHXMessageTxtCell *cell = [tableView dequeueReusableCellWithIdentifier:LPHXMessageTxtCellID];
                cell.CustonModel = model;
                return cell;
            }else{
                LPMessageToServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMessageToServiceCellID];
                cell.model = model;
                WEAK_SELF()
                cell.block = ^{
                    weakSelf.isECEIM = YES;
                    [weakSelf sendMessageTxt:@"在线聊天"];
                };
                return cell;
            }
        } else{
            id<HDIMessageModel> model = object;

            if (model.bodyType == EMMessageBodyTypeText) {
                HDExtMsgType extMsgType = [HDMessageHelper getMessageExtType:model.message];
                if (extMsgType == HDExtEvaluationMsg) {
                    LPMessageToServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMessageToServiceCellID];
                    
                    LPCustomMessageModel *m = [[LPCustomMessageModel alloc] init];
                    m.text = @"很高兴为您服务，请对本次服务进行评价";
                    m.Type = 2;
                    m.telephone = self.model.data.telephone;
                    
                    cell.model = m;
                    
                    WEAK_SELF()
                    cell.CommentBlock = ^{
                        [weakSelf moveViewEvaluationAction:model];
                    };
                    
                    return cell;
                }else{
                    LPHXMessageTxtCell *cell = [tableView dequeueReusableCellWithIdentifier:LPHXMessageTxtCellID];
                    cell.model = model;
                    return cell;
                }
            }else if (model.bodyType == EMMessageBodyTypeImage){
                LPHXMessageImageCell *cell = [tableView dequeueReusableCellWithIdentifier:LPHXMessageImageCellID];
                cell.model = model;
                return cell;
            } else {
                LPHXMessageTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:LPHXMessageTimeCellID];
                   cell.MessageTime.text = @"未知消息";
                   return cell;
            }
           
           
        }
    }else{
        LPHXServiceHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:LPHXServiceHeadCellID];
        cell.model = self.model;
        WEAK_SELF()
        cell.block = ^{
            [weakSelf sendMessageTxt:@"转人工客服"];
        };
        return cell;
    }
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// 评价
- (void)moveViewEvaluationAction:(id <HDIMessageModel>) model {

 
    
    __block NSString *sessionId = nil;
    id service_session = model.message.ext[@"service_session"];
    if (service_session != [NSNull null]) {
        sessionId = service_session[@"serviceSessionId"] == [NSNull null] ? nil : service_session[@"serviceSessionId"];
    }
    
    if (!sessionId) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [HDClient.sharedClient.chatManager asyncFetchSessionWithConversationId:self.conversation.conversationId
                                                                       sessionType:HSessionType_Processing
                                                                        completion:^(NSArray *sessions, HDError *error)
             {
                 sessionId = sessions.firstObject;
                 dispatch_semaphore_signal(semaphore);
             }];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
        
        [HDClient.sharedClient.chatManager asyncFetchEvaluationDegreeInfoWithCompletion:^(NSDictionary *info, HDError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (!error) {
                     LPServiceCommentVC *vc = [[LPServiceCommentVC alloc] init];
                     HDMessage *msg = model.message;
                     NSMutableDictionary *ext = [[NSMutableDictionary alloc] initWithDictionary:@{@"weichat":@{@"ctrlArgs":@{@"evaluationDegree":info[@"entities"]}}}];
                     if (sessionId) {
                         [ext setValue:sessionId forKey:@"serviceSessionId"];
                     }
                     msg.ext = ext;
                     vc.messageModel = [[HDMessageModel alloc] initWithMessage:msg];
                     vc.conversation = self.conversation;
                     [self.navigationController pushViewController:vc animated:YES];
                     
                     vc.block = ^(NSString * _Nonnull Comment, NSInteger Tag) {
                         [self.dataArray removeObject:model];
                         [self.tableview reloadData];
                     };
                     
                 }else {
                     [self.view showLoadingMeg:@"获取评价信息失败" time:MESSAGE_SHOW_TIME];
                 }
             });
         }];
    }
}

 #pragma mark lazy
 - (UITableView *)tableview{
     if (!_tableview) {
         _tableview = [[UITableView alloc]init];
         _tableview.delegate = self;
         _tableview.dataSource = self;
         _tableview.tableFooterView = [[UIView alloc]init];
     
         _tableview.estimatedRowHeight = 0;
         _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
         _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
         [_tableview registerNib:[UINib nibWithNibName:LPHXCustomerServiceCellID bundle:nil] forCellReuseIdentifier:LPHXCustomerServiceCellID];
         [_tableview registerNib:[UINib nibWithNibName:LPHXServiceHeadCellID bundle:nil] forCellReuseIdentifier:LPHXServiceHeadCellID];
         [_tableview registerNib:[UINib nibWithNibName:LPHXMessageTxtCellID bundle:nil] forCellReuseIdentifier:LPHXMessageTxtCellID];
         [_tableview registerNib:[UINib nibWithNibName:LPHXMessageTimeCellID bundle:nil] forCellReuseIdentifier:LPHXMessageTimeCellID];
         [_tableview registerNib:[UINib nibWithNibName:LPHXMessageImageCellID bundle:nil] forCellReuseIdentifier:LPHXMessageImageCellID];
         [_tableview registerNib:[UINib nibWithNibName:LPMessageToServiceCellID bundle:nil] forCellReuseIdentifier:LPMessageToServiceCellID];

         
         _tableview.backgroundColor = [UIColor colorWithHexString:@"ebf7ff"];

 
 //        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
 //
 //        }];
 //
 //        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
 //
 //        }];
     }
     return _tableview;
 }
 

-(void)setModel:(LPCustomerServiceModel *)model{
    _model = model;
    [self.tableview reloadData];
    if (!self.model.data.imUserName) {
        [self requestQueryCustomerAddimuser];
    }else{
        [self LoginIm];
    }
}

- (void)LoginIm{
    HDClient *client = [HDClient sharedClient];
    if (client.isLoggedInBefore == NO) {
        HDError *error = [client loginWithUsername:self.model.data.imUserName
                                          password:[RSAEncryptor decryptString:self.model.data.imPassword privateKey:RSAPrivateKey]];
        if (!error) { //登录成功
            NSLog(@"im 登录成功");

            self.conversation = [[HDClient sharedClient].chatManager getConversation:CECServiceIMNumber];
            [[HDClient sharedClient].chatManager addDelegate:self delegateQueue:nil];

            NSString *messageId = nil;
            if ([self.messsagesSource count] > 0) {
                messageId = [(HDMessage *)self.messsagesSource.firstObject messageId];
            }
            else {
                messageId = nil;
            }
            [self _loadMessagesBefore:messageId count:messageCountOfPage append:YES];

        } else { //登录失败
            NSLog(@"im 登录失败");
        }
    }else{
        self.conversation = [[HDClient sharedClient].chatManager getConversation:CECServiceIMNumber];
        [[HDClient sharedClient].chatManager addDelegate:self delegateQueue:nil];

        NSString *messageId = nil;
        if ([self.messsagesSource count] > 0) {
            messageId = [(HDMessage *)self.messsagesSource.firstObject messageId];
        }
        else {
            messageId = nil;
        }
        [self _loadMessagesBefore:messageId count:messageCountOfPage append:YES];
    }
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


-(void)requestQueryCustomerAddimuser{
    [NetApiManager requestQueryCustomerAddimuser:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (responseObject[@"data"]) {
                    self.model.data.imUserName = responseObject[@"data"];
                    [self LoginIm];
                }else{
                    [self.view showLoadingMeg:@"暂时无法连接客服，请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryProblemDetailWithParamKey:(NSString *) str{
    
    NSDictionary *dic = @{@"key":str};
    [NetApiManager requestQueryProblemDetailWithParamKey:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0 ) {
                self.commentTextField.text = nil;

                LPCustomMessageModel *m = [[LPCustomMessageModel alloc] init];
                m.text = str;
                m.isSender = YES;
                [self addCustomMessage:m];
                
                LPCustomMessageModel *m2 = [[LPCustomMessageModel alloc] init];
                m2.text = responseObject[@"data"];
                [self addCustomMessage:m2];
                
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


#pragma mark - pivate data

- (void)_loadMessagesBefore:(NSString*)messageId
                      count:(NSInteger)count
                     append:(BOOL)isAppend
{
    __weak typeof(self) weakSelf = self;
    void (^refresh)(NSArray *messages) = ^(NSArray *messages) {
        dispatch_async(_messageQueue, ^{
            //Format the message
            NSArray *formattedMessages = [weakSelf formatMessages:messages];
            //Refresh the page
            dispatch_async(dispatch_get_main_queue(), ^{
                LPHXCustomerServiceVC *strongSelf = weakSelf;
                if (strongSelf) {
                    NSInteger scrollToIndex = 0;
                    if (isAppend) {
                        [strongSelf.messsagesSource insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                        //Combine the message
                        id object = [strongSelf.dataArray firstObject];
                        if ([object isKindOfClass:[NSString class]]) {
                            NSString *timestamp = object;
                            [formattedMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                                if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model]) {
                                    [strongSelf.dataArray removeObjectAtIndex:0];
                                    *stop = YES;
                                }
                            }];
                        }
                        scrollToIndex = [strongSelf.dataArray count];
                        [strongSelf.dataArray insertObjects:formattedMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formattedMessages count])]];
                    }
                    else {
                        [strongSelf.messsagesSource removeAllObjects];
                        [strongSelf.messsagesSource addObjectsFromArray:messages];
                        
                        [strongSelf.dataArray removeAllObjects];
                        [strongSelf.dataArray addObjectsFromArray:formattedMessages];
                    }
                    
                    HDMessage *latest = [strongSelf.messsagesSource lastObject];
                    strongSelf.messageTimeIntervalTag = latest.messageTime;
                    
                    [strongSelf.tableview reloadData];
                    if ([self.dataArray count] - scrollToIndex  >= 1) {
                        [strongSelf.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - scrollToIndex - 1 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];

                    }
                }
            });
            //re-download all messages that are not successfully downloaded
            for (HDMessage *message in messages)
            {
                [weakSelf _downloadMessageAttachments:message];
            }
        });
    };
    
    [self.conversation loadMessagesStartFromId:messageId
                                         count:(int)count
                               searchDirection:HDMessageSearchDirectionUp
                                    completion:^(NSArray *aMessages, HDError *aError)
     {
        if (!aError && [aMessages count]) {
            refresh(aMessages);
        }
    }];
}


#pragma mark - public

- (NSArray *)formatMessages:(NSArray *)messages
{
    NSMutableArray *formattedArray = [[NSMutableArray alloc] init];
    if ([messages count] == 0) {
        return formattedArray;
    }
    
    for (HDMessage *message in messages) {
        if ([message isKindOfClass:[HDMessage class]]) {
           //Calculate time interval
                 CGFloat interval = (self.messageTimeIntervalTag - message.messageTime) / 1000;
                 if (self.messageTimeIntervalTag < 0 || interval > 60 || interval < -60) {
                     NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.messageTime];
                     NSString *timeStr = @"";
                     
                     
                     timeStr = [messageDate formattedTime];
                      
                     [formattedArray addObject:timeStr];
                     self.messageTimeIntervalTag = message.messageTime;
                 }

                 //Construct message model
                 id<HDIMessageModel> model = nil;
                  
                 model = [[HDMessageModel alloc] initWithMessage:message];
                  

                 if (model) {
                     [formattedArray addObject:model];
                 }
        }
      
    }
    
    return formattedArray;
}


- (void)_downloadMessageAttachments:(HDMessage *)message
{
    __weak typeof(self) weakSelf = self;
    void (^completion)(HDMessage *, HDError *) = ^(HDMessage *aMessage, HDError *error) {
        if (!error)
        {
            [weakSelf _reloadTableViewDataWithMessage:message];
        }
        else
        {
            [weakSelf.view showLoadingMeg:@"图片加载失败!" time:MESSAGE_SHOW_TIME];
        }
    };
    
    EMMessageBody *messageBody = message.body;
    if ([messageBody type] == EMMessageBodyTypeImage) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed) {
            //download the message thumbnail
            [[HDClient sharedClient].chatManager downloadAttachment:message progress:nil completion:completion];
        }
    }else if ([messageBody type] == EMMessageBodyTypeVideo) {
        /* 目前后台没有提供缩略图，暂时不自动下载视频缩略图
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
        if (videoBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed) {
            //download the message thumbnail
            [[HDClient sharedClient].chatManager downloadThumbnail:message progress:nil completion:completion];
        }
         */
    }else if ([messageBody type] == EMMessageBodyTypeVoice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.downloadStatus > EMDownloadStatusSuccessed) {
            //download the message attachment
            [[HDClient sharedClient].chatManager downloadAttachment:message progress:nil completion:^(HDMessage *message, HDError *error) {
                if (!error) {
                    [weakSelf _reloadTableViewDataWithMessage:message];
                }
                else {
                    [weakSelf.view showLoadingMeg:@"语音加载失败!" time:MESSAGE_SHOW_TIME];
                }
            }];
        }
    }
}


#pragma mark - CEC iOS SDK API
- (void)sendMessageTxt:(NSString *) str{
    
    if (self.isECEIM) {
        HDMessage *message = [HDMessage createTxtSendMessageWithContent:str to:self.conversation.conversationId];

         //属性可以缺省
         LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];

         HDVisitorInfo *visitor = [[HDVisitorInfo alloc] init];

         visitor.phone = user.data.userTel;
         visitor.nickName = user.data.user_name;
        message.direction = 0;
    
         [message addContent:visitor]; //传访客的属性
         
         
         [self addMessageToDataSource:message
                             progress:nil];
         __weak typeof(self) weakself = self;

        weakself.commentTextField.text = nil;
            [[HDClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
                //发送消息进度
            } completion:^(HDMessage *aMessage, HDError *aError) {
                //发送消息完成，aError为空则为发送成功
                if (!aError) {
                    [weakself _refreshAfterSentMessage:message];
                }
                else {
                    [weakself.tableview reloadData];
                }
//                weakself.commentTextField.text = nil;

            }];
    }else{
        if ([str containsString:@"人工" ]||
            [str containsString:@"客服"]) {
            LPCustomMessageModel *m = [[LPCustomMessageModel alloc] init];
            m.text = [NSString stringWithFormat:@"人工客服时间为：%@请在作息时间内联系人工客服",self.model.data.workTime];
            m.Type = 1;
            m.telephone = self.model.data.telephone;
            [self addCustomMessage:m];
            self.commentTextField.text = nil;

        }else{
            [self requestQueryProblemDetailWithParamKey:str];
        }
        
    }
    
}


#pragma mark - HDChatManagerDelegate

//收到普通消息,格式:<HDMessage *>
- (void)messagesDidReceive:(NSArray *)aMessages {
    for (HDMessage *message in aMessages) {
        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
            [_conversation markAllMessagesAsRead:nil];

            if (message.body.type == EMMessageBodyTypeText  ||
                message.body.type == EMMessageBodyTypeImage ) {
                self.isECEIM = YES;
                [self addMessageToDataSource:message progress:nil];
            } else if ([HDMessageHelper getMessageExtType:message] == HDExtEvaluationMsg){
                 self.isECEIM = YES;
                [self addMessageToDataSource:message progress:nil];
            }
        }
    }
}

//收到命令消息,格式:<HDMessage *>，命令消息不存数据库，一般用来作为系统通知，例如留言评论更新，
//会话被客服接入，被转接，被关闭提醒
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages{
      for (HDMessage *message in aCmdMessages) {
          if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
              [_conversation markAllMessagesAsRead:nil];
              EMCmdMessageBody *body = (EMCmdMessageBody *)message.body;
              NSLog(@"收到的action是 -- %@",body.action);
              NSString *str = @"";
              if ([body.action isEqualToString:@"ServiceSessionClosedEvent"]) {
                  str = @"会话结束，连接关闭";
                  self.isECEIM = NO;
              }else if ([body.action isEqualToString:@"ServiceSessionClosedEvent"]){
                  str = @"正在分配客服";
              }else if ([body.action isEqualToString:@"ServiceSessionOpenedEvent"]){
                  str = @"成功分配客服";
              }
              
              if (str.length) {
                  [self.dataArray addObject:str];
                  [self.tableview reloadData];
                  [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - 1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
              }
          }
      }
}


//- (void)messageAttachmentStatusDidChange:(HDMessage *)aMessage error:(HDError *)aError {
//    if (!aError) {
//        EMFileMessageBody *fileBody = (EMFileMessageBody*)[aMessage body];
//        if ([fileBody type] == EMMessageBodyTypeImage) {
//            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
//            if ([imageBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed)
//            {
//                [self _reloadTableViewDataWithMessage:aMessage];
//            }
//        }else if([fileBody type] == EMMessageBodyTypeVideo){
//            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
//            if ([videoBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed)
//            {
//                [self _reloadTableViewDataWithMessage:aMessage];
//            }
//        }else if([fileBody type] == EMMessageBodyTypeVoice){
//            if ([fileBody downloadStatus] == EMDownloadStatusSuccessed)
//            {
//                [self _reloadTableViewDataWithMessage:aMessage];
//            }
//        }
//
//    }else{
//
//    }
//}


#pragma mark - send message

- (void)_refreshAfterSentMessage:(HDMessage*)aMessage
{
    if ([self.messsagesSource count]) {
        NSString *msgId = aMessage.messageId;
        __block NSUInteger index = NSNotFound;
        [self.messsagesSource enumerateObjectsWithOptions:NSEnumerationReverse
                                               usingBlock:^(HDMessage *obj, NSUInteger idx, BOOL *stop)
         {
             if ([obj isKindOfClass:[HDMessage class]] && [obj.messageId isEqualToString:msgId]) {
                 index = idx;
                 *stop = YES;
             }
         }];
        if (index != NSNotFound) {
            [self.messsagesSource removeObjectAtIndex:index];
            [self.messsagesSource addObject:aMessage];
            
            //格式化消息
            self.messageTimeIntervalTag = -1;
            NSArray *formattedMessages = [self formatMessages:self.messsagesSource];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:formattedMessages];
            [self.tableview reloadData];
            return;
        }
    }
}



-(void)addMessageToDataSource:(HDMessage *)message
                     progress:(id)progress
{
    @synchronized (self.messsagesSource) {
        [self.messsagesSource addObject:message];
        NSArray *messageModels = [self formatMessages:@[message]];
        NSMutableArray  *mArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < messageModels.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count + i inSection:1];
            [mArr addObject:indexPath];
        }
        [self.dataArray addObjectsFromArray:messageModels];
        [self.tableview beginUpdates];
        [self.tableview insertRowsAtIndexPaths:mArr.copy withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableview endUpdates];
        [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - 1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    }
}

-(void)addCustomMessage:(LPCustomMessageModel *)message
{
    @synchronized (self.messsagesSource) {
       
        
        [self.messsagesSource addObject:message];
        NSArray *messageModels = @[message];
        NSMutableArray  *mArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < messageModels.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count + i inSection:1];
            [mArr addObject:indexPath];
        }
        [self.dataArray addObject:message];

        [self.tableview beginUpdates];
        [self.tableview insertRowsAtIndexPaths:mArr.copy withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableview endUpdates];
        [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - 1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

 

#pragma mark - private
- (void)_reloadTableViewDataWithMessage:(HDMessage *)message
{
    if ([self.conversation.conversationId isEqualToString:message.conversationId])
    {
        for (int i = 0; i < self.dataArray.count; i ++) {
            id object = [self.dataArray objectAtIndex:i];
            if ([object isKindOfClass:[HDMessageModel class]]) {
                id<HDIMessageModel> model = object;
                if ([message.messageId isEqualToString:model.messageId]) {
                    BOOL isSender = message.direction == HDMessageDirectionSend;
                    id<HDIMessageModel> newModel = nil;
                    newModel = [[HDMessageModel alloc] initWithMessage:message];
                    [self.tableview beginUpdates];
                    [self.dataArray replaceObjectAtIndex:i withObject:newModel];
                    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableview endUpdates];
                    break;
                }
            }
        }
    }
}

 
@end
