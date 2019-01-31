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
#import "LPEssaylistModel.h"
#import "LPInformationMoreCell.h"
#import "LPInformationSingleCell.h"

static NSString *LPEssayDetailHeadCellID = @"LPEssayDetailHeadCell";
static NSString *LPEssayDetailCommentCellID = @"LPEssayDetailCommentCell";
static NSString *LPInformationSingleCellID = @"LPInformationSingleCell";
static NSString *LPInformationMoreCellID = @"LPInformationMoreCell";

@interface LPEssayDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LPEssayDetailCommentCellDelegate>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) LPEssayDetailModel *model;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPCommentListModel *commentListModel;
@property(nonatomic,strong) NSMutableArray <LPCommentListDataModel *>*commentListArray;

@property(nonatomic,strong) UIView *searchBgView;
@property(nonatomic,strong) UIView *bottomBgView;
@property (nonatomic, strong) UIView *BacksearchView;

@property(nonatomic,strong) NSMutableArray <UIButton *>*bottomButtonArray;
@property(nonatomic,strong) UITextField *commentTextField;
@property(nonatomic,strong) UIButton *sendButton;

@property(nonatomic,assign) NSInteger commentType;
@property(nonatomic,strong) NSNumber *commentId;
@property(nonatomic,strong)CustomIOSAlertView *CustomAlert;

@property(nonatomic,assign) BOOL IsAddComment;

@property(nonatomic,assign) CGFloat TableHeadHeight;


@property (nonatomic,strong) LPEssaylistModel *LabelEssayModel;

@end

@implementation LPEssayDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"资讯详情";
    self.IsAddComment = NO;
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
//    [self requestCommentList];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self requestEssay];
    [IQKeyboardManager sharedManager].enable = NO;

}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;

    if (self.Supertableview) {
        [self.Supertableview reloadData];
    }
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
        make.right.mas_equalTo(self.bottomBgView.mas_left).offset(-5);
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
        [self.BacksearchView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.height.mas_equalTo(48);
            if (transformY < 0) {
                make.right.mas_equalTo(-10);
                make.bottom.mas_equalTo(transformY);
            }else{
                make.right.mas_equalTo(self.bottomBgView.mas_left).offset(-5);
                make.bottom.mas_equalTo(0);
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
    
    if (button.tag == 2) {
//        [self WeiXinOrQQAlertView];
        NSString *url = [NSString stringWithFormat:@"%@bluehired/newsdetails.html?id=%@",BaseRequestWeiXiURL,self.model.data.id];
        NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [LPTools ClickShare:encodedUrl Title:_model.data.essayName];
        return;
    }
    
    if ([LoginUtils validationLogin:self]) {
        NSInteger index = button.tag;
        if (index == 0) {
            [self requestSetCollection];
        }else if (index == 1){
            [self requestSocialSetlike];
        }
    }
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
    NSString *url = [NSString stringWithFormat:@"%@bluehired/newsdetails.html?id=%@",BaseRequestWeiXiURL,self.model.data.id];
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
        message.description= _model.data.essayName;
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


-(void)setModel:(LPEssayDetailModel *)model{
    _model = model;
    if (model.data.likeStatus  && AlreadyLogin) {
        self.bottomButtonArray[1].selected = YES;
    }else{
        self.bottomButtonArray[1].selected = NO;
    }
    if (model.data.collectionStatus  && AlreadyLogin) {
        self.bottomButtonArray[0].selected = YES;
    }else{
        self.bottomButtonArray[0].selected = NO;
    }
    self.commentType = 1;
    self.commentId = self.essaylistDataModel.id;
//    [self.tableview reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self requestCommentList];

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
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}

#pragma mark - target
-(void)touchSendButton:(UIButton *)button{
    if (self.commentTextField.text.length > 300) {
        [self.view showLoadingMeg:@"评论过长" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.commentTextField.text.length > 0) {
        [self requestCommentAddcomment];
    }
}

#pragma mark - textfield
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return [LoginUtils validationLogin:self];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.commentTextField.text.length > 300) {
        [self.view showLoadingMeg:@"评论过长" time:MESSAGE_SHOW_TIME];
        return YES;
    }
    NSLog(@"长度 = %lu",self.commentTextField.text.length);
    if (self.commentTextField.text.length > 0) {
        [self requestCommentAddcomment];
    }
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableview)
    {
        CGFloat sectionHeaderHeight = 30.0f;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}



#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.TableHeadHeight + 102 + [self calculateRowHeight:self.model.data.essayName fontSize:18 Width:SCREEN_WIDTH - 32];
    }else if (indexPath.section == 1){
        return 110.0;
    }
    else{      //开始手动计算cell高度
        LPCommentListDataModel *m = self.commentListArray[indexPath.row];
        CGFloat cellHeigh = 93.5 + [self calculateRowHeight:m.commentDetails fontSize:13 Width:SCREEN_WIDTH - 67] ;
        //计算回复高度
        for (int i = 0 ;i < m.commentList.count;i++) {
            cellHeigh +=[self calculateRowHeight:[NSString stringWithFormat:@"%@:  %@",m.commentList[i].userName,m.commentList[i].commentDetails] fontSize:13 Width:SCREEN_WIDTH-80]+11;
        }
        
        return cellHeigh;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.LabelEssayModel.data.count;
    }
    else{
        return self.commentListArray.count;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        if (self.commentListArray.count) {
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(16, 0, SCREEN_WIDTH-16, 30);
            label.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
            label.font = [UIFont systemFontOfSize:12];
            label.text = [NSString stringWithFormat:@"全部评论（%@）", self.model.data.commentTotal];
            [view addSubview:label];
            return view;
        }
        return nil;
    }else if (section == 1){
        if (self.LabelEssayModel.data.count) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 30)];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 15, Screen_Width-24, 1)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#FFE6E6E6"];
            [view addSubview:lineView];

            view.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake((Screen_Width-80)/2, 0, 80, 30);
            label.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
            label.font = [UIFont systemFontOfSize:17];
            label.text = @"相关推荐";
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor whiteColor];
            [view addSubview:label];
            return view;
        }
        return nil;
    } else{
        return nil;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LPEssayDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:LPEssayDetailHeadCellID];
        cell.model = self.model;
        WEAK_SELF()
        cell.Block = ^(CGFloat height) {
            weakSelf.TableHeadHeight = height;
            [self.tableview reloadData];
            [weakSelf requestCommentList];
        };
        return cell;
    }else if (indexPath.section == 1){
        NSArray *array = @[];
        if (self.LabelEssayModel.data.count > indexPath.row) {
            array = [self.LabelEssayModel.data[indexPath.row].essayUrl componentsSeparatedByString:@";"];
        }
        if (array.count ==0) {
            return nil;
        }else if (array.count == 1 || array.count == 2) {
            LPInformationSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:LPInformationSingleCellID];
            if(cell == nil){
                cell = [[LPInformationSingleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPInformationSingleCellID];
            }
            cell.model = self.LabelEssayModel.data[indexPath.row];
            return cell;
        }else{
            LPInformationMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LPInformationMoreCellID];
            if(cell == nil){
                cell = [[LPInformationMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPInformationMoreCellID];
            }
            cell.model = self.LabelEssayModel.data[indexPath.row];
            return cell;
        }
    }else{
        LPEssayDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:LPEssayDetailCommentCellID];
        cell.model = self.commentListArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==1) {
        LPEssayDetailVC *vc = [[LPEssayDetailVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.essaylistDataModel = self.LabelEssayModel.data[indexPath.row];
        vc.Supertableview = self.tableview;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - request
-(void)requestEssay{
    NSDictionary *dic = @{
                          @"id":self.essaylistDataModel.id
                          };
    [DSBaActivityView showActiviTy];
    [NetApiManager requestEssayWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPEssayDetailModel mj_objectWithKeyValues:responseObject];
            if (self.model.data) {
                [self requestEssay_Label];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
            
        }
        [DSBaActivityView hideActiviTy];
    }];
}

-(void)requestEssay_Label{
    NSDictionary *dic = @{@"labelId":self.model.data.labelId?self.model.data.labelId:@""};
     [NetApiManager requestEssay_LabelWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.LabelEssayModel = [LPEssaylistModel mj_objectWithKeyValues:responseObject];
        }else{
                        [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
     }];
}

-(void)requestSetEssayView{
    NSDictionary *dic = @{
                          @"id":self.essaylistDataModel.id
                          };
    [NetApiManager requestSetEssayViewWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        [DSBaActivityView hideActiviTy];

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
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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
                    self.essaylistDataModel.likeStatus = @(1);
                    self.essaylistDataModel.praiseTotal  =  @(self.essaylistDataModel.praiseTotal.integerValue+1);
                    
                }else if ([responseObject[@"data"] integerValue] == 1) {
                    self.bottomButtonArray[1].selected = NO;
                    self.essaylistDataModel.likeStatus = @(0);
                    self.essaylistDataModel.praiseTotal  =  @(self.essaylistDataModel.praiseTotal.integerValue-1);
                 }
                
                if (self.Supertableview) {
//                    [self.Supertableview reloadData];
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
    NSDictionary *dic = @{@"commentDetails": self.commentTextField.text,
                          @"commentType": @(self.commentType),
                          @"commentId": self.commentId,
                          @"userName": [LPTools isNullToString:user.data.user_name],
                          @"userId": [LPTools isNullToString:kUserDefaultsValue(LOGINID)],
                          @"userUrl": [LPTools isNullToString:user.data.user_url],
                          @"versionType":@"2.1"
                          };
    if (self.commentType ==1) {
        self.IsAddComment = YES;
    }
 
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
                if (self.commentType == 1) {
                    [self.commentListArray insertObject:m atIndex:0];
                    self.model.data.commentTotal = @(self.model.data.commentTotal.integerValue+1);
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
                
                self.commentTextField.text = nil;
                [self.commentTextField resignFirstResponder];
                self.commentId = self.essaylistDataModel.id;
                self.commentType = 1;
                
                [self.tableview reloadData];
                [self.tableview layoutIfNeeded];
                [self scrollViewToBottom:YES];
                self.essaylistDataModel.commentTotal = self.model.data.commentTotal;
                if (self.Supertableview) {
//                    [self.Supertableview reloadData];
                }
                
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
        [_tableview registerNib:[UINib nibWithNibName:LPEssayDetailHeadCellID bundle:nil] forCellReuseIdentifier:LPEssayDetailHeadCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPEssayDetailCommentCellID bundle:nil] forCellReuseIdentifier:LPEssayDetailCommentCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPInformationSingleCellID bundle:nil] forCellReuseIdentifier:LPInformationSingleCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPInformationMoreCellID bundle:nil] forCellReuseIdentifier:LPInformationMoreCellID];
        
//        [_tableview registerNib:[UINib nibWithNibName:LPInformationMoreCellID bundle:nil] forCellReuseIdentifier:LPInformationMoreCellID];
        
//        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            self.page = 1;
//            [self requestEssaylist];
//        }];
        WEAK_SELF()
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestCommentList];
            NSLog(@"调用上啦刷新");
            weakSelf.IsAddComment = NO;
        }];
 
    }
    return _tableview;
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.IsAddComment) {
            //刷新完成
            self.IsAddComment = NO;
            NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:2];
            [self.tableview scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }
}


- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize Width:(CGFloat) W
 {
     NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
     /*计算高度要先指定宽度*/
     CGRect rect = [string boundingRectWithSize:CGSizeMake(W, 0) options:NSStringDrawingUsesLineFragmentOrigin |
                    NSStringDrawingUsesFontLeading attributes:dic context:nil];
     return rect.size.height;
    
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
