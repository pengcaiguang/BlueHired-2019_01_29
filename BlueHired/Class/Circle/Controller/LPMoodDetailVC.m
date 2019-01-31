//
//  LPMoodDetailVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/18.
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
    [self.view addSubview:self.bottomBgView];
    [self.bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    
    UIView *backSearch = [[UIView alloc] init];
    [self.view addSubview:backSearch];
    self.BacksearchView = backSearch;
    self.BacksearchView.backgroundColor = [UIColor whiteColor];
    [self.BacksearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
//        make.right.mas_equalTo(self.bottomBgView.mas_left).offset(-5);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
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
    [self.commentTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *button = [[UIButton alloc]init];
//    [self.bottomBgView addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(5);
//        make.right.mas_equalTo(-5);
//        make.size.mas_equalTo(CGSizeMake(40, 20));
//        make.center.equalTo(self.bottomBgView);
//    }];
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
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        [self.BacksearchView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.height.mas_equalTo(48);
            if (transformY < 0) {
                make.right.mas_equalTo(-10);
                make.bottom.mas_equalTo(transformY);
            }else{
//                make.right.mas_equalTo(self.bottomBgView.mas_left).offset(-5);
                make.right.mas_equalTo(-10);
                make.bottom.mas_equalTo(0);
            }
            
        }];
        [self.searchBgView.superview layoutIfNeeded];
        
        [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(48);
            make.left.equalTo(self.searchBgView.mas_right).mas_offset(5);
            if (transformY == 0) {
                make.right.mas_equalTo(0);
            }
        }];
        [self.bottomBgView.superview layoutIfNeeded];
        
        //        [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.left.mas_equalTo(0);
        //            make.right.mas_equalTo(0);
        //            make.bottom.mas_equalTo(transformY);
        //            make.height.mas_equalTo(49);
        //        }];
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

#pragma mark - target
-(void)touchSendButton:(UIButton *)button{
    if (self.commentTextField.text.length > 0) {
        [self requestCommentAddcomment];
    }
}

#pragma mark - textfield
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return [LoginUtils validationLogin:self];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self requestCommentAddcomment];
    return YES;
}
-(void)textFieldChanged:(UITextField *)textField{
    if (textField.text.length > 0) {
        self.sendButton.enabled = YES;
        self.sendButton.backgroundColor = [UIColor baseColor];
    }else{
        self.sendButton.enabled = NO;
        self.sendButton.backgroundColor = [UIColor lightGrayColor];
    }
}
#pragma mark - LPEssayDetailCommentCellDelegate
-(void)touchReplyButton:(LPCommentListDataModel *)model{
    NSLog(@"回复");
    self.commentId = model.id;
    self.commentType = 3;
    [self.commentTextField becomeFirstResponder];
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
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - request
-(void)requestSetMoodView{
    NSDictionary *dic = @{
                          @"id":self.moodListDataModel.id
                          };
    [NetApiManager requestSetMoodViewWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
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
            self.model = [LPGetMoodModel mj_objectWithKeyValues:responseObject];
            if (self.model.data == nil)
            {
//                [self.view showLoadingMeg:@"圈子可能已经被删除" time:MESSAGE_SHOW_TIME];
//                [LPTools AlertMessageView:@"圈子可能已经被删除" dismiss:1.0];
                [self  addNodataViewHidden:NO];

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
                    
                    if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] isKindOfClass:[LPCircleVC class]]) {
                        LPCircleVC *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                        vc.isSenderBack = 3;
                        [self.moodListArray removeObject:self.moodListDataModel];
                        [self.SuperTableView reloadData];
//                        [self.navigationController popToViewController:vc animated:YES];
                    }else{
                         [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                });
        
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
                          @"id":self.moodListDataModel.id
                          };
    [NetApiManager requestCommentListWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.commentListModel = [LPCommentListModel mj_objectWithKeyValues:responseObject];
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
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    } IsShowActiviTy:YES];
}
-(void)requestCommentAddcomment{
    
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSString *string = [dateFormatter stringFromDate:[NSDate date]];
//    
//    if (kUserDefaultsValue(@"ERRORMOOD")) {
//        NSString *errorString = kUserDefaultsValue(@"ERRORMOOD");
//         NSString *str = [LPTools dateTimeDifferenceWithStartTime:errorString endTime:string];
//         if ([str integerValue] < 1) {
//            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"请勿频繁操作" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
//            }];
//            [alert show];
//            return;
//        }
//    }
//    kUserDefaultsSave(string, @"ERRORMOOD");

    [self.commentTextField resignFirstResponder];

    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
    NSDictionary *dic = @{
                          @"commentDetails": self.commentTextField.text,
                          @"commentType": @(self.commentType),
                          @"commentId": self.commentId,
                          @"userName": user.data.user_name,
                          @"userId": kUserDefaultsValue(LOGINID),
                          @"userUrl": user.data.user_url,
                          @"versionType":@"2.1"
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
                if (self.moodListDataModel.commentModelList.count<=5) {
                    LPMoodCommentListDataModel *CommentModel = [[LPMoodCommentListDataModel alloc] init];
                    CommentModel.userId =kUserDefaultsValue(LOGINID);
                    CommentModel.userName = user.data.user_name;
                    CommentModel.identity = kUserDefaultsValue(USERIDENTIY);

                    CommentModel.commentDetails = self.commentTextField.text;
                    if (self.commentType == 2) {
                        
                    }else if (self.commentType == 3){
                        for (LPCommentListDataModel *model in self.commentListArray) {
                            if (model.id == self.commentId) {
                                CommentModel.toUserId = model.userId;
                                CommentModel.toUserName = model.userName;
                                CommentModel.toUserIdentity = model.identity;
                                break;
                            }
                        }
                    }
                    
                    [self.moodListDataModel.commentModelList insertObject:CommentModel atIndex:self.moodListDataModel.commentModelList.count];
                    if (self.SuperTableView) {
                        [self.SuperTableView reloadData];
                    }
                }
                
                m.time = @([NSString getNowTimestamp]);
                m.commentId = nil;
                m.commentType = nil;
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
                        if (model.id == self.commentId) {
                            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:model.commentList];
                            [array addObject:m];
                            model.commentList = [array copy];
                            break;
                        }
                    }
                }
                [self.tableview reloadData];
                self.moodListDataModel.commentTotal = self.model.data.commentTotal;
                

                self.commentTextField.text = nil;
                [self.commentTextField resignFirstResponder];
                self.commentId = self.moodListDataModel.id;
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
            if (!ISNIL(responseObject[@"data"])) {
                LPMoodDetailHeaderCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                if ([responseObject[@"data"] integerValue] == 0) {
                    cell.isUserConcern = YES;
                }else if ([responseObject[@"data"] integerValue] == 1) {
                    cell.isUserConcern = NO;
                }
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
            if ([responseObject[@"data"] integerValue] == 1) {
//                [self.navigationController popViewControllerAnimated:YES];
        
                if (self.Type == 1) {
                    LPCircleVC *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                    vc.isSenderBack = 3;
                    [self.moodListArray removeObject:self.moodListDataModel];

                    [self.navigationController popToViewController:vc animated:YES];
//                    [self.navigationController popViewControllerAnimated:YES];
                }else if (self.Type == 2){
                    LPReportVC *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                    vc.isSenderBack = 3;
                     [self.navigationController popToViewController:vc animated:YES];
//                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
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
