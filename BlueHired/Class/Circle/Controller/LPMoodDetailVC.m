//
//  LPMoodDetailVC.m
//  BlueHired
//
//  Created by peng on 2018/9/18.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMoodDetailVC.h"
#import "LPGetMoodModel.h"
#import "LPEssayDetailCommentCell.h"
#import "LPMoodDetailHeaderCell.h"
#import "LPCommentListModel.h"
#import "LPCircleVC.h"
#import "LPReportVC.h"

static NSString *LPMoodDetailHeaderCellID = @"LPMoodDetailHeaderCell";
static NSString *LPEssayDetailCommentCellID = @"LPEssayDetailCommentCell";

@interface LPMoodDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LPEssayDetailCommentCellDelegate>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) LPGetMoodModel *model;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPCommentListModel *commentListModel;
@property(nonatomic,strong) NSMutableArray <LPCommentListDataModel *>*commentListArray;

@property(nonatomic,strong) UIView *searchBgView;
@property(nonatomic,strong) UIView *bottomBgView;
@property (nonatomic, strong) UIView *BacksearchView;

@property(nonatomic,strong) NSMutableArray <UIButton *>*bottomButtonArray;
@property(nonatomic,strong) UIButton *praiseButton;
@property(nonatomic,strong) UITextField *commentTextField;
@property(nonatomic,strong) UIButton *sendButton;

@property(nonatomic,assign) NSInteger commentType;
@property(nonatomic,strong) NSNumber *commentId;
@property(nonatomic,strong) LPCommentListDataModel *commentUserModel;

@end

@implementation LPMoodDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"圈子详情";
    
    self.page = 1;
    self.commentListArray = [NSMutableArray array];
    self.bottomButtonArray = [NSMutableArray array];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
    }];
    [self setBottomView];
    
    [self requestSetMoodView];
    [self requestGetMood];
    [self requestCommentList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self requestGetMood];
    [IQKeyboardManager sharedManager].enable = NO;

}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;

}
-(void)setBottomView{
    self.bottomBgView = [[UIView alloc]init];
    [self.view addSubview:self.bottomBgView];
    [self.bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(48);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    
    UIView *backSearch = [[UIView alloc] init];
    [self.view addSubview:backSearch];
    self.BacksearchView = backSearch;
    self.BacksearchView.backgroundColor = [UIColor whiteColor];
    [self.BacksearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
//        make.right.mas_equalTo(self.bottomBgView.mas_left).offset(-5);
        make.right.mas_equalTo(-40);
//        make.bottom.mas_equalTo(0);
 
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(48);
    }];
 
    self.searchBgView = [[UIView alloc]init];
    [self.BacksearchView addSubview:self.searchBgView];
    [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
//        make.right.mas_equalTo(self.bottomBgView.mas_left).offset(-5);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-7);
        make.height.mas_equalTo(34);
    }];
    self.searchBgView.layer.masksToBounds = YES;
    self.searchBgView.layer.cornerRadius = 17;
    self.searchBgView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
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
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(self.searchBgView.mas_height);
        make.centerY.equalTo(self.searchBgView);
    }];
    self.commentTextField.delegate = self;
    self.commentTextField.tintColor = [UIColor baseColor];
    self.commentTextField.placeholder = @"评一下";
    self.commentTextField.returnKeyType = UIReturnKeySend;
    self.commentTextField.enablesReturnKeyAutomatically =YES;
//    [self.commentTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *button = [[UIButton alloc]init];
    [self.bottomBgView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.center.equalTo(self.bottomBgView);
    }];
    [button setImage:[UIImage imageNamed:@"praise_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"praise_selected"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
    [button addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    self.praiseButton = button;
//    [self.bottomButtonArray addObject:button];
    
//    [self.bottomButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:15 tailSpacing:15];
//    [self.bottomButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(5);
//        make.bottom.mas_equalTo(-5);
//        make.size.mas_equalTo(CGSizeMake(21, 20));
//    }];
    
    self.sendButton = [[UIButton alloc]init];
    [self.bottomBgView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentTextField.mas_right).offset(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(26);
        make.centerY.equalTo(self.bottomBgView);
    }];
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.layer.cornerRadius = 13;
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendButton.hidden = YES;
    self.sendButton.enabled = NO;
    self.sendButton.backgroundColor = [UIColor lightGrayColor];
//    [self.sendButton addTarget:self action:@selector(touchSendButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)preventFlicker:(UIButton *)button {
    button.highlighted = NO;
}
-(void)touchBottomButton:(UIButton *)button{
    if ([LoginUtils validationLogin:self]) {
        [self requestSocialSetlike];
    }
}
#pragma mark - setter
-(void)setModel:(LPGetMoodModel *)model{
    _model = model;
//    if (model.data.likeStatus) {
//        self.bottomButtonArray[1].selected = YES;
//    }else{
//        self.bottomButtonArray[1].selected = NO;
//    }
    if ([model.data.isPraise integerValue] == 0 && AlreadyLogin){
        self.praiseButton.selected = YES;
    }else{
        self.praiseButton.selected = NO;
    }
    self.commentType = 2;
    self.commentId = self.moodListDataModel.id;
    self.commentUserModel = nil;
//    [self.tableview reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableview reloadData];
}
-(void)setCommentListModel:(LPCommentListModel *)commentListModel{
    _commentListModel = commentListModel;
    if ([commentListModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.commentListArray = [NSMutableArray array];
        }
        if (commentListModel.data.count > 0) {
            self.page += 1;
            [self.commentListArray addObjectsFromArray:commentListModel.data];
            [self.tableview reloadData];
//            [self.tableview reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            //            if (self.isComment) {
            //                [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            //            }
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}

#pragma mark - textfield
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
 
    if ([LoginUtils validationLogin:self]) {
        self.commentId = self.moodListDataModel.id;
        self.commentType = 2;
        self.commentUserModel = nil;
        
        [XHInputView showWithStyle:InputViewStyleLarge configurationBlock:^(XHInputView *inputView) {
            /** 请在此block中设置inputView属性 */
            
            /** 代理 */
            
            /** 占位符文字 */
            inputView.placeholder = @"评一下";
            /** 设置最大输入字数 */
            inputView.maxCount = 300;
            /** 输入框颜色 */
            inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
           
            /** 更多属性设置,详见XHInputView.h文件 */
            
        } sendBlock:^BOOL(NSString *text) {
            if(text.length){
                [self requestCommentAddcomment:text];
                return YES;//return YES,收起键盘
            }else{
//                NSLog(@"显示提示框-请输入要评论的的内容");
                [self.view showLoadingMeg:@"请输入评价内容" time:MESSAGE_SHOW_TIME];
                return NO;//return NO,不收键盘
            }
        }];
    }
    
    
    return NO;
}

#pragma mark - LPEssayDetailCommentCellDelegate
-(void)touchReplyButton:(LPCommentListDataModel *)model{
    NSLog(@"回复");
    self.commentId = model.id;
    self.commentType = 3;
    self.commentUserModel = model;
//    [self.commentTextField becomeFirstResponder];
    
    [XHInputView showWithStyle:InputViewStyleLarge configurationBlock:^(XHInputView *inputView) {
        /** 请在此block中设置inputView属性 */
        
        /** 代理 */
        
        /** 占位符文字 */
        inputView.placeholder = [NSString stringWithFormat:@"回复 %@:",model.userName];
        /** 设置最大输入字数 */
        inputView.maxCount = 300;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
        
        /** 更多属性设置,详见XHInputView.h文件 */
        
    } sendBlock:^BOOL(NSString *text) {
        if(text.length){
            [self requestCommentAddcomment:text];
            return YES;//return YES,收起键盘
        }else{
            //                NSLog(@"显示提示框-请输入要评论的的内容");
            [self.view showLoadingMeg:@"请输入评价内容" time:MESSAGE_SHOW_TIME];
            return NO;//return NO,不收键盘
        }
    }];

    
    
}

#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 30;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.commentListArray.count;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(16, 0, SCREEN_WIDTH-16, 30);
        label.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
        label.font = [UIFont systemFontOfSize:12];
        label.text = [NSString stringWithFormat:@"全部评论（%ld）",self.commentListArray.count];
        [view addSubview:label];
        return view;
    }else{
        return nil;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LPMoodDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMoodDetailHeaderCellID];
        cell.model = self.model;
        cell.userConcernBlock = ^{
            if ([LoginUtils validationLogin:self]) {
                if ([self.model.data.userId integerValue] == [kUserDefaultsValue(LOGINID) integerValue] ) {
                    [self requestDeleteMood];
                }
                else
                {
                    [self requestSetUserConcern];
                }
            }
        };
        
        
        return cell;
    }else{
        LPEssayDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:LPEssayDetailCommentCellID];
        cell.model = self.commentListArray[indexPath.row];
        cell.delegate = self;
        cell.SuperTableView = tableView;
        WEAK_SELF();
        cell.DeleteBlock = ^(NSString *CommId){
            [weakSelf requestQueryDeleteComment:CommId];
        };
        cell.AddBlock = ^(LPCommentListDataModel *model){
            LPMoodCommentListDataModel *CommentModel = [LPMoodCommentListDataModel mj_objectWithKeyValues:[model mj_JSONObject]];
 
            if (self.moodListDataModel.commentModelList.count < 5) {
                for (NSInteger i = weakSelf.moodListDataModel.commentModelList.count ; i>0 ;i-- ) {
                    LPMoodCommentListDataModel *m = weakSelf.moodListDataModel.commentModelList[i-1];
                    if ((m.commentType.integerValue == 2 && m.id == CommentModel.commentId) ||
                        (m.commentType.integerValue == 3 && m.commentId == CommentModel.commentId)) {
                        [weakSelf.moodListDataModel.commentModelList insertObject:CommentModel atIndex:i];
                        break;
                    }
                }
            }
            
            
            for (int i = 0 ;i <weakSelf.moodListArray.count;i++) {
                LPMoodListDataModel *com = weakSelf.moodListArray[i];
                if (com.id == weakSelf.moodListDataModel.id) {
                    weakSelf.moodListArray[i] = weakSelf.moodListDataModel;
                    break;
                }
            }
            
            if (weakSelf.SuperTableView) {
                [weakSelf.SuperTableView reloadData];
            }
            
            
        };
  
        return cell;
    }
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

#pragma mark - request
-(void)requestSetMoodView{
    NSDictionary *dic = @{
                          @"id":self.moodListDataModel.id
                          };
    [NetApiManager requestSetMoodViewWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestGetMood{
    NSDictionary *dic = @{
                          @"id":self.moodListDataModel.id,
                          @"infoId":[LPTools isNullToString:self.InfoId]
                          };
    [NetApiManager requestGetMoodWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPGetMoodModel mj_objectWithKeyValues:responseObject];
                if (self.model.data == nil)
                {
                    [self  addNodataViewHidden:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] isKindOfClass:[LPCircleVC class]]) {
                            LPCircleVC *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                            vc.isSenderBack = 3;
                            [self.moodListArray removeObject:self.moodListDataModel];
                            [self.SuperTableView reloadData];
                        }else{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                    });
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestCommentList{
    NSDictionary *dic = @{
                          @"type":@(2),
                          @"page":@(self.page),
                          @"id":self.moodListDataModel.id,
                          @"versionType":@"2.3"
                          };
    [NetApiManager requestCommentListWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.commentListModel = [LPCommentListModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestSocialSetlike{
    NSDictionary *dic = @{
                          @"type":@(2),
                          @"id":self.moodListDataModel.id
                          };
    [NetApiManager requestSocialSetlikeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
                if (!ISNIL(responseObject[@"data"])) {
                    if ([responseObject[@"data"] integerValue] == 0) {
                        self.praiseButton.selected = YES;
                        self.moodListDataModel.praiseTotal = @(self.moodListDataModel.praiseTotal.integerValue+1);
                        self.moodListDataModel.isPraise = @([responseObject[@"data"] integerValue]);
                        
                        LPMoodPraiseListDataModel *Pmodel = [[LPMoodPraiseListDataModel alloc] init];
                        Pmodel.grading = user.data.grading;
                        Pmodel.role = user.data.role;
                        Pmodel.userId = kUserDefaultsValue(LOGINID);
                        Pmodel.userName = user.data.user_name;
                        Pmodel.userImage = user.data.user_url;
                        Pmodel.phone = user.data.userTel;
                        
                        [self.moodListDataModel.praiseList insertObject:Pmodel atIndex:0];
                        
                    }else if ([responseObject[@"data"] integerValue] == 1) {
                        self.praiseButton.selected = NO;
                        self.moodListDataModel.praiseTotal = @(self.moodListDataModel.praiseTotal.integerValue-1);
                        self.moodListDataModel.isPraise = @([responseObject[@"data"] integerValue]);
                        for (LPMoodPraiseListDataModel *m in self.moodListDataModel.praiseList) {
                            if (m.userId == kUserDefaultsValue(LOGINID)) {
                                [self.moodListDataModel.praiseList removeObject:m];
                                break;
                            }
                        }
                    }
                    for (int i =0 ; i < self.moodListArray.count ; i++) {
                        LPMoodListDataModel *DataModel = self.moodListArray[i];
                        if (DataModel.id.integerValue == self.moodListDataModel.id.integerValue) {
                            DataModel.praiseList = self.moodListDataModel.praiseList;
                            DataModel.isPraise = self.moodListDataModel.isPraise;
                            DataModel.praiseTotal = self.moodListDataModel.praiseTotal;
                            break;
                        }
                    }
                    if (self.SuperTableView) {
                        [self.SuperTableView reloadData];
                    }
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
           
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    } IsShowActiviTy:YES];
}
-(void)requestCommentAddcomment:(NSString *) commentText{

    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
    NSDictionary *dic = @{
                          @"commentDetails": commentText,
                          @"commentType": @(self.commentType),
                          @"commentId": self.commentId,
                          @"userName": user.data.user_name,
                          @"userId": kUserDefaultsValue(LOGINID),
                          @"userUrl": user.data.user_url,
                          @"versionType":@"2.1",
                          @"replyUserId":self.commentUserModel?@(self.commentUserModel.userId.integerValue):@""
                          };
    [NetApiManager requestCommentAddcommentWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                
//                self.page = 1;
//                [self requestCommentList];
 
                NSString *StrData = [LPTools isNullToString:responseObject[@"data"]];
                NSArray *DataList = [StrData componentsSeparatedByString:@"-"];
                
                LPCommentListDataModel *m = [LPCommentListDataModel mj_objectWithKeyValues:dic];
                if (DataList.count>=2) {
                    if ([DataList[0] integerValue] ==1) {
                        [LPTools AlertTopCommentView:@""];
                    }else{
//                        [LPTools AlertCommentView:@""];
                    }
                    m.id = @([[LPTools isNullToString:DataList[1]] integerValue]);
                }
                
                //评价圈子列表里面的评论列表
//                if (self.moodListDataModel.commentModelList.count<5) {
                    LPMoodCommentListDataModel *CommentModel = [LPMoodCommentListDataModel mj_objectWithKeyValues:dic];
   
                    CommentModel.identity = kUserDefaultsValue(USERIDENTIY);
                    CommentModel.id = [LPTools isNullToString:DataList[1]];
                    CommentModel.time = [NSString stringWithFormat:@"%ld",(long)[NSString getNowTimestamp]];
                    CommentModel.grading = user.data.grading;
                    if (self.commentType == 2 && self.moodListDataModel.commentModelList.count < 5 ) {
                        [self.moodListDataModel.commentModelList addObject:CommentModel];
                    }else if (self.commentType == 3 && self.moodListDataModel.commentModelList.count < 5 ){
                        for (LPCommentListDataModel *model in self.commentListArray) {
                            if (model.id.integerValue == self.commentId.integerValue) {
                                CommentModel.toUserId = model.userId;
                                CommentModel.toUserName = model.userName;
                                CommentModel.toUserIdentity = model.identity;
                                break;
                            }
                        }
                        
                        for (NSInteger i = self.moodListDataModel.commentModelList.count ;i>0;i-- ) {
                            LPMoodCommentListDataModel *m = self.moodListDataModel.commentModelList[i-1];
                            if ((m.commentType.integerValue == 2 && m.id.integerValue == CommentModel.commentId.integerValue) ||
                                (m.commentType.integerValue == 3 && m.commentId.integerValue == CommentModel.commentId.integerValue)) {
                                [self.moodListDataModel.commentModelList insertObject:CommentModel atIndex:i];
                                break;
                            }
                        }
//                                [self.moodListDataModel.commentModelList insertObject:CommentModel atIndex:0];
 
 
                    }
                    
                     for (int i = 0 ;i <self.moodListArray.count;i++) {
                        LPMoodListDataModel *com = self.moodListArray[i];
                        if (com.id == self.moodListDataModel.id) {
                            self.moodListArray[i] = self.moodListDataModel;
                            break;
                        }
                    }
                    
                    if (self.SuperTableView) {
                        [self.SuperTableView reloadData];
                    }
//                }
                
                m.time = @([NSString getNowTimestamp]);
                m.grading = user.data.grading;
                if (self.commentType == 2) {
                    [self.commentListArray insertObject:m atIndex:0];
                    self.model.data.commentTotal = @(self.model.data.commentTotal.integerValue+1);
                    self.moodListDataModel.commentTotal = self.model.data.commentTotal;
                    if (self.SuperTableView) {
                        [self.SuperTableView reloadData];
                    }
                }else if (self.commentType == 3){
                    for (LPCommentListDataModel *model in self.commentListArray) {
                        if (model.id.integerValue == self.commentId.integerValue) {
                            m.toUserId = self.commentUserModel.userId;
                            m.toUserName = self.commentUserModel.userName;
                            m.toUserIdentity = self.commentUserModel.identity;
                            if (model.commentModelList.count == 0) {
                                model.commentModelList = [[NSMutableArray alloc] init];
                            }
                            [model.commentModelList addObject:m];
                            break;
                        }
                    }
                }
                [self.tableview reloadData];
                self.moodListDataModel.commentTotal = self.model.data.commentTotal;
                [self.tableview layoutIfNeeded];
                if (self.commentType == 2) {
                    NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:1];
                    [self.tableview scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }


           
                self.commentId = self.moodListDataModel.id;
                self.commentUserModel = nil;
                self.commentType = 2;
                
            }else{
                if ([responseObject[@"code"] integerValue] == 10045) {
                    [LPTools AlertMessageView:responseObject[@"msg"]];
                }else{
                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestSetUserConcern{
    NSDictionary *dic = @{
                          @"concernUserId":self.model.data.userId,
                          };
    [NetApiManager requestSetUserConcernWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (!ISNIL(responseObject[@"data"])) {
                    LPMoodDetailHeaderCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    if ([responseObject[@"data"] integerValue] == 0) {
                        cell.isUserConcern = YES;
                    }else if ([responseObject[@"data"] integerValue] == 1) {
                        cell.isUserConcern = NO;
                    }
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestDeleteMood{
    NSDictionary *dic = @{
                          @"ids":self.model.data.id,
                          };
    [NetApiManager requestDeleteMoodWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                   
                    if (self.moodListArray.count) {
                        [self.moodListArray removeObject:self.moodListDataModel];
                    }
                    if (self.SuperTableView) {
                        [self.SuperTableView reloadData];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    //                }
                    
                }else{
                    [self.view showLoadingMeg:@"删除失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryDeleteComment:(NSString *) CommentId{
    
    NSString * appendURLString = [NSString stringWithFormat:@"comment/update_comment?id=%@&moodId=%@&versionType=2.4",CommentId,self.moodListDataModel.id];
    
    [NetApiManager requestQueryDeleteComment:nil URLString:appendURLString withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"][@"result"] integerValue] == 1) {
                    NSMutableArray <LPMoodCommentListDataModel *>*CommArr = [LPMoodCommentListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"commentList"]];
                    self.moodListDataModel.commentModelList = CommArr;
                    
                    for (int i =0 ; i < self.moodListArray.count ; i++) {
                        LPMoodListDataModel *DataModel = self.moodListArray[i];
                        if (DataModel.id.integerValue == self.moodListDataModel.id.integerValue) {
                            DataModel.commentModelList = CommArr;
                            break;
                        }
                    }
                    if (self.SuperTableView) {
                        [self.SuperTableView reloadData];
                    }
                    
                    for (LPCommentListDataModel *model in self.commentListArray) {
                        if (model.id.integerValue == CommentId.integerValue) {
                            [self.commentListArray removeObject:model];
                            break;
                        }
                        BOOL isDelete = NO;
                        for (LPCommentListDataModel *m in model.commentModelList) {
                            if (m.id.integerValue == CommentId.integerValue) {
                                [model.commentModelList removeObject:m];
                                isDelete = YES;
                                break;
                             }
                        }
                        if (isDelete) {
                            break;
                        }
                    }
                    [self.tableview reloadData];
                }else{
                    [[UIWindow  visibleViewController].view showLoadingMeg:@"删除失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIWindow  visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow  visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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
        [_tableview registerNib:[UINib nibWithNibName:LPMoodDetailHeaderCellID bundle:nil] forCellReuseIdentifier:LPMoodDetailHeaderCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPEssayDetailCommentCellID bundle:nil] forCellReuseIdentifier:LPEssayDetailCommentCellID];
        
        //        [_tableview registerNib:[UINib nibWithNibName:LPInformationMoreCellID bundle:nil] forCellReuseIdentifier:LPInformationMoreCellID];
        
        //        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            self.page = 1;
        //            [self requestEssaylist];
        //        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestCommentList];
        }];
    }
    return _tableview;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        [noDataView image:nil text:@"该动态已被删除!"];
        [self.view addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}
@end
