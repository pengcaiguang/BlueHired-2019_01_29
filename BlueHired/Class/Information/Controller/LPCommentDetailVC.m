//
//  LPCommentDetailVC.m
//  BlueHired
//
//  Created by peng on 2018/9/3.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPCommentDetailVC.h"
#import "LPEssayDetailCommentCell.h"

static NSString *LPEssayDetailCommentCellID = @"LPEssayDetailCommentCell";

@interface LPCommentDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LPEssayDetailCommentCellDelegate>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPCommentListModel *commentListModel;
@property(nonatomic,strong) NSMutableArray <LPCommentListDataModel *>*commentListArray;

@property(nonatomic,strong) UITextField *commentTextField;
@property(nonatomic,strong) UIButton *sendButton;

@property(nonatomic,assign) NSInteger commentType;
@property(nonatomic,strong) NSNumber *commentId;
@end

@implementation LPCommentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"评论详情";
    
    self.commentType = 3;
    self.commentId = self.commentListDatamodel.id;
    
    self.page = 1;
    self.commentListArray = [NSMutableArray array];
    
    [self setBottomView];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
    }];
    [self requestCommentList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//     [IQKeyboardManager sharedManager].enable = NO;
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;
    
}

-(void)setBottomView{
    
//    UIView *bottomBgView = [[UIView alloc]init];
//    [self.view addSubview:bottomBgView];
//    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(48);
//    }];
    
    UIView *searchBgView = [[UIView alloc]init];
    [self.view addSubview:searchBgView];
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
//        make.right.mas_equalTo(-88);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-7);
        make.height.mas_equalTo(34);
    }];
    searchBgView.layer.masksToBounds = YES;
    searchBgView.layer.cornerRadius = 17;
    searchBgView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UIImageView *writeImg = [[UIImageView alloc]init];
    [searchBgView addSubview:writeImg];
    [writeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.equalTo(searchBgView);
        make.size.mas_equalTo(CGSizeMake(15, 14));
    }];
    writeImg.image = [UIImage imageNamed:@"comment_write"];
    
    self.commentTextField = [[UITextField alloc]init];
    [searchBgView addSubview:self.commentTextField];
    [self.commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(writeImg.mas_right).offset(5);
        make.right.mas_equalTo(5);
        make.height.mas_equalTo(searchBgView.mas_height);
        make.centerY.equalTo(searchBgView);
    }];
    self.commentTextField.delegate = self;
    self.commentTextField.tintColor = [UIColor baseColor];
    self.commentTextField.placeholder = @"Biu一下";
    self.commentTextField.returnKeyType = UIReturnKeySend;
    self.commentTextField.enablesReturnKeyAutomatically =YES;
    [self.commentTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
//    self.sendButton = [[UIButton alloc]init];
//    [self.view addSubview:self.sendButton];
//    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(searchBgView.mas_right).offset(10);
//        make.right.mas_equalTo(-10);
//        make.size.mas_equalTo(CGSizeMake(68, 34));
//        make.centerY.equalTo(searchBgView);
//    }];
//    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
//    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.sendButton.backgroundColor = [UIColor baseColor];
//    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.sendButton.layer.masksToBounds = YES;
//    self.sendButton.layer.cornerRadius = 17;
//    [self.sendButton addTarget:self action:@selector(touchSendButton) forControlEvents:UIControlEventTouchUpInside];
    
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
//            [self.tableview reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableview reloadData];
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
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
-(void)touchSendButton{
    if ([LoginUtils validationLogin:self]) {
        
    }
}

#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.commentListArray.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPEssayDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:LPEssayDetailCommentCellID];
    if (indexPath.section == 0) {
        cell.model = self.commentListDatamodel;
        cell.replyBgView.hidden = YES;
        cell.replyButton.hidden = NO;
        cell.replyBgView_constraint_height.constant = 0;
        cell.delegate = self;
    }else{
        cell.model = self.commentListArray[indexPath.row];
        cell.replyButton.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - LPEssayDetailCommentCellDelegate
-(void)touchReplyButton:(LPCommentListDataModel *)model{
    NSLog(@"回复");
    self.commentId = model.id;
    self.commentType = 3;
    [self.commentTextField becomeFirstResponder];
}

#pragma mark - request
-(void)requestCommentList{
    NSDictionary *dic = @{
                          @"type":@(3),
                          @"page":@(self.page),
                          @"id":self.commentListDatamodel.id
                          };
    [NetApiManager requestCommentListWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
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
-(void)requestCommentAddcomment{
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSString *string = [dateFormatter stringFromDate:[NSDate date]];
//
//    if (kUserDefaultsValue(@"ERRORINFORMATION")) {
//        NSString *errorString = kUserDefaultsValue(@"ERRORINFORMATION");
//        NSString *str = [LPTools dateTimeDifferenceWithStartTime:errorString endTime:string];
//        if ([str integerValue] < 1) {
//            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"请勿频繁操作" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
//            }];
//            [alert show];
//            return;
//        }
//    }
//    kUserDefaultsSave(string, @"ERRORINFORMATION");
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
                
                m.time = @([NSString getNowTimestamp]);
                m.commentId = nil;
                m.commentType = nil;
                m.grading = user.data.grading;
                if (self.commentType == 3){
                    [self.commentListArray insertObject:m atIndex:0];
                 }
                 [self.tableview reloadData];
                
                if (self.commentListDatamodel.commentList.count<=3) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.commentListDatamodel.commentList];
                    [array addObject:m];
                    self.commentListDatamodel.commentList = [array copy];
                    [self.superTabelView reloadData];
                }
                
                
                self.commentTextField.text = nil;
                [self.commentTextField resignFirstResponder];
//                self.page = 1;
//                [self requestCommentList];
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
#pragma mark - lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPEssayDetailCommentCellID bundle:nil] forCellReuseIdentifier:LPEssayDetailCommentCellID];
        
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
