//
//  LPEssayDetailVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/1.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPEssayDetailVC.h"
#import "LPEssayDetailHeadCell.h"
#import "LPEssayDetailCommentCell.h"
#import "LPEssayDetailModel.h"
#import "LPCommentListModel.h"


static NSString *LPEssayDetailHeadCellID = @"LPEssayDetailHeadCell";
static NSString *LPEssayDetailCommentCellID = @"LPEssayDetailCommentCell";

@interface LPEssayDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LPEssayDetailCommentCellDelegate>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) LPEssayDetailModel *model;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPCommentListModel *commentListModel;
@property(nonatomic,strong) NSMutableArray <LPCommentListDataModel *>*commentListArray;

@property(nonatomic,strong) UIView *searchBgView;
@property(nonatomic,strong) UIView *bottomBgView;
@property(nonatomic,strong) NSMutableArray <UIButton *>*bottomButtonArray;
@property(nonatomic,strong) UITextField *commentTextField;
@property(nonatomic,strong) UIButton *sendButton;

@property(nonatomic,assign) NSInteger commentType;
@property(nonatomic,strong) NSNumber *commentId;


@end

@implementation LPEssayDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"资讯详情";

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

    [self requestEssay];
    [self requestSetEssayView];
    [self requestCommentList];
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
    
    self.searchBgView = [[UIView alloc]init];
    [self.view addSubview:self.searchBgView];
    [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(self.bottomBgView.mas_left).offset(-5);
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
        make.right.mas_equalTo(5);
        make.height.mas_equalTo(self.searchBgView.mas_height);
        make.centerY.equalTo(self.searchBgView);
    }];
    self.commentTextField.delegate = self;
    self.commentTextField.tintColor = [UIColor baseColor];
    self.commentTextField.placeholder = @"Biu一下";
    self.commentTextField.returnKeyType = UIReturnKeySend;
    self.commentTextField.enablesReturnKeyAutomatically =YES;
    [self.commentTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    NSArray *imgArray = @[@"collection_normal",@"praise_normal",@"share_btn",];
    for (int i =0; i<imgArray.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        [self.bottomBgView addSubview:button];
        [button setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"collection_selected"] forState:UIControlStateSelected];
        }else if(i == 1) {
            [button setImage:[UIImage imageNamed:@"praise_selected"] forState:UIControlStateSelected];
        }
        [button addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
        button.tag = i;
        [button addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomButtonArray addObject:button];
    }
    [self.bottomButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:15 tailSpacing:15];
    [self.bottomButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(21, 20));
    }];
    
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
        [self.searchBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-7);
            make.height.mas_equalTo(34);
            if (transformY < 0) {
                make.right.mas_equalTo(-10);
            }else{
                make.right.mas_equalTo(self.bottomBgView.mas_left).offset(-5);
            }
            
        }];
        [self.searchBgView.superview layoutIfNeeded];
        
        [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(48);
            make.left.equalTo(self.searchBgView.mas_right).mas_offset(-5);
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
        NSInteger index = button.tag;
        if (index == 0) {
            [self requestSetCollection];
        }else if (index == 1){
            [self requestSocialSetlike];
        }
    }
}
-(void)setModel:(LPEssayDetailModel *)model{
    _model = model;
    if (model.data.likeStatus) {
        self.bottomButtonArray[1].selected = YES;
    }else{
        self.bottomButtonArray[1].selected = NO;
    }
    if (model.data.collectionStatus) {
        self.bottomButtonArray[0].selected = YES;
    }else{
        self.bottomButtonArray[0].selected = NO;
    }
    self.commentType = 1;
    self.commentId = self.essaylistDataModel.id;
    [self.tableview reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableview reloadData];
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
//            [self.tableview reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        LPEssayDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:LPEssayDetailHeadCellID];
        cell.model = self.model;
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
-(void)requestEssay{
    NSDictionary *dic = @{
                          @"id":self.essaylistDataModel.id
                          };
    [NetApiManager requestEssayWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPEssayDetailModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:@"网络错误" time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestSetEssayView{
    NSDictionary *dic = @{
                          @"id":self.essaylistDataModel.id
                          };
    [NetApiManager requestSetEssayViewWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
    }];
}
-(void)requestCommentList{
    NSDictionary *dic = @{
                          @"type":@(1),
                          @"page":@(self.page),
                          @"id":self.essaylistDataModel.id
                          };
    [NetApiManager requestCommentListWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.commentListModel = [LPCommentListModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:@"网络错误" time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestSetCollection{
    NSDictionary *dic = @{
                          @"type":@(2),
                          @"id":self.essaylistDataModel.id
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

-(void)requestSocialSetlike{
    NSDictionary *dic = @{
                          @"type":@(1),
                          @"id":self.essaylistDataModel.id
                          };
    [NetApiManager requestSocialSetlikeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (!ISNIL(responseObject[@"data"])) {
                if ([responseObject[@"data"] integerValue] == 0) {
                    self.bottomButtonArray[1].selected = YES;
                }else if ([responseObject[@"data"] integerValue] == 1) {
                    self.bottomButtonArray[1].selected = NO;
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestCommentAddcomment{
    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
    NSDictionary *dic = @{
                          @"commentDetails": self.commentTextField.text,
                          @"commentType": @(self.commentType),
                          @"commentId": self.commentId,
                          @"userName": user.data.user_name,
                          @"userId": kUserDefaultsValue(LOGINID),
                          @"userUrl": user.data.user_url
                          };
    [NetApiManager requestCommentAddcommentWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.commentTextField.text = nil;
            [self.commentTextField resignFirstResponder];
            self.commentId = self.essaylistDataModel.id;
            self.commentType = 1;
            self.page = 1;
            [self requestCommentList];
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
        [_tableview registerNib:[UINib nibWithNibName:LPEssayDetailHeadCellID bundle:nil] forCellReuseIdentifier:LPEssayDetailHeadCellID];
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
