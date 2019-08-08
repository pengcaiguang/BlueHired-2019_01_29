//
//  LPVideoVC.m
//  BlueHired
//
//  Created by iMac on 2018/11/20.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPVideoVC.h"
#import "LPVideoPlayCell.h"
#import "LPEssayDetailCommentCell.h"
#import "UIView+LJBarrageTool.h"

static NSString *LPVideoPlayCellID = @"LPVideoPlayCell";
static NSString *LPEssayDetailCommentCellID = @"LPEssayDetailCommentCell";

@interface LPVideoVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,LPEssayDetailCommentCellDelegate,UITextFieldDelegate,LJBarrageViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger currentpage;

@property (nonatomic, strong) GKDYVideoPlayer *playerTop;
@property (nonatomic, strong) GKDYVideoPlayer *playerCurrent;
@property (nonatomic, strong) GKDYVideoPlayer *playerNext;

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *Commentview;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) LPCommentListModel *commentListModel;
@property (nonatomic, strong) NSMutableArray <LPCommentListDataModel *>*commentListArray;

@property (nonatomic, strong) LPVideoListModel *VideoListModel;


@property (nonatomic, assign) NSInteger commentType;
@property (nonatomic, strong) NSNumber *commentId;

@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) UIView *searchBgView;
@property (nonatomic, strong) UIView *BacksearchView;

@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic,assign) UIScrollView *LabelscrollView;
@property (nonatomic,strong) NSMutableArray <UILabel *>*labelArray;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIButton *recommendBt;
@property (nonatomic,strong) UIButton *TypeBt;

@property (nonatomic,strong) NSString *IsRecommend;
@property (nonatomic,strong) NSString *IsVideoType;

@property (nonatomic,assign) NSInteger Commentpage;

@property(nonatomic,strong) LPCommentListDataModel *commentUserModel;
@property (nonatomic, strong) LJBarrageView *barrageView;
@property (nonatomic, assign) BOOL barrageStatus;

@property (nonatomic,assign) NSInteger VideoPage;
@property (nonatomic,assign) BOOL isRequest;

@end

@implementation LPVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelArray = [NSMutableArray array];
    self.IsRecommend = @"";
    self.IsVideoType = @"";
    self.barrageStatus = YES;
    
    self.currentpage = 0;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-0);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.Commentview];
     self.currentpage = self.VideoRow;
     [self setBottomView];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
     }
 
    
    //初始化展示区域界面
    LJBarrageView *barrageView = [LJBarrageView lj_creatNormalWithFrame:CGRectMake(0, LENGTH_SIZE(82), self.view.frame.size.width, LENGTH_SIZE(96))];
    [self.view addSubview:barrageView];
    self.barrageView = barrageView;
    
    //配置参数
    barrageView.barrageRow = 3;
    barrageView.barrageHeightType = BarrageHeightTypeNormal;
    barrageView.barrageShowStyle = LJBarrageShowStyleTypeShowTime;
    barrageView.styleParameter = 6;
    barrageView.delegate = self;
    barrageView.barrageStyle.barrageBackgroundColor  = [UIColor clearColor];
    barrageView.barrageStyle.barrageHeight = LENGTH_SIZE(32);
    barrageView.barrageStyle.barrageFont = FONT_SIZE(15);
    barrageView.barrageStyle.barrageTextAlignment = NSTextAlignmentCenter;
    barrageView.barrageEnterInterval = 1.0;
    barrageView.barrageShowMax = 4;
    
    WEAK_SELF()
    self.barrageView.BarrageViewBlock = ^{
        NSLog(@"弹幕库少于10条回调");
        if (weakSelf.isRequest == NO && weakSelf.VideoPage != 0) {
            weakSelf.VideoPage ++;
            [weakSelf requestQueryGetVideoComment];
        }
    };
    
 
 }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];

    NSLog(@"视频显示,滚动到%ld",(long)self.VideoRow);
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.VideoRow inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    [self.collectionView layoutIfNeeded];

    LPVideoPlayCell *Playcell = (LPVideoPlayCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.VideoRow inSection:0]];
    Playcell.PlayImage.hidden = YES;
    Playcell.barrageBtn.selected = self.barrageStatus;
    if (self.barrageStatus) {
        [self BarrageViewopen];
    }else{
        [self BarrageViewshut];
    }
    
    [self.playerCurrent removeVideo];
    LPVideoListDataModel *model = self.listArray[self.VideoRow];
    [self.playerCurrent playVideoWithView:Playcell.coverImgView url:model.videoUrl];
   
    [self requestQuerySetVideoView:self.VideoRow];
    
    self.VideoPage = 1;
    [self requestQueryGetVideoComment];
    
    
//    if (self.listArray.count>1) {
//        if (self.VideoRow == 0) {       //第一个视频进来
//            //缓存下一个
//            [self.playerNext playVideourl:self.listArray[self.VideoRow+1].videoUrl];
//        }else if (self.VideoRow+1 == self.listArray.count){     //最后一个视频进来
//            //缓存上一个
//            [self.playerTop playVideourl:self.listArray[self.VideoRow-1].videoUrl];
//        }else{
//            //缓存上下两个
//            [self.playerTop playVideourl:self.listArray[self.VideoRow-1].videoUrl];
//            [self.playerNext playVideourl:self.listArray[self.VideoRow+1].videoUrl];
//        }
//    }
    
 
  [IQKeyboardManager sharedManager].enable = NO;

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.playerTop removeVideo];
    [self.playerCurrent removeVideo];
    [self.playerNext removeVideo];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.barrageView shut];
 
 
    
}

- (void) dealloc{
    // 销毁界面时需释放
    NSLog(@"VideoVC销毁界面时需释放");
 
}



- (void)setTypeModel:(LPVideoTypeModel *)TypeModel{
    _TypeModel = TypeModel;
    if (self.Type != 1) {
        return;
    }
    
     self.recommendBt = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - LENGTH_SIZE(140))/2 ,
                                                                   kStatusBarHeight,
                                                                   LENGTH_SIZE(70),
                                                                   LENGTH_SIZE(44))];
    //    [recommendBt setImage:[UIImage imageNamed:@"推荐"] forState:UIControlStateNormal];
    [self.recommendBt setTitle:@"推荐" forState:UIControlStateNormal];
    self.recommendBt.titleLabel.font = [UIFont systemFontOfSize:FontSize(17)];
    [self.recommendBt addTarget:self action:@selector(touchrecommended:) forControlEvents:UIControlEventTouchUpInside];
    [self.recommendBt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.recommendBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [self.view addSubview:self.recommendBt];
    
    self.TypeBt = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - LENGTH_SIZE(140))/2+70,
                                                             kStatusBarHeight,
                                                             LENGTH_SIZE(70),
                                                             LENGTH_SIZE(44))];
    //    [TypeBt setImage:[UIImage imageNamed:@"分类"] forState:UIControlStateNormal];
    [self.TypeBt setTitle:@"分类" forState:UIControlStateNormal];
    self.TypeBt.titleLabel.font = [UIFont systemFontOfSize:FontSize(17)];
    [self.TypeBt addTarget:self action:@selector(touchtype:) forControlEvents:UIControlEventTouchUpInside];
    [self.TypeBt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.TypeBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [self.view addSubview:self.TypeBt];
    
    if ([TypeModel.code integerValue] == 0) {
        if (TypeModel.data.count <= 0) {
            return;
        }
 
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
                                                                                 kStatusBarHeight+LENGTH_SIZE(44),
                                                                                 SCREEN_WIDTH,
                                                                                 LENGTH_SIZE(40))];
        [self.view addSubview:scrollView];
        self.LabelscrollView = scrollView;
        scrollView.backgroundColor = [UIColor colorWithRed:27/255.0 green:27/255.0 blue:27/255.0 alpha:1];
        scrollView.showsHorizontalScrollIndicator = NO;
 
        CGFloat w = 0;
        for (int i = 0; i <TypeModel.data.count; i++) {
            UILabel *label = [[UILabel alloc]init];
            label.text = TypeModel.data[i].labelName;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:FontSize(14)];
            [scrollView addSubview:label];
            label.textColor = [UIColor whiteColor];
            CGSize size = CGSizeMake(LENGTH_SIZE(100), MAXFLOAT);//设置高度宽度的最大限度
            CGRect rect = [label.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
            
            CGFloat lw = rect.size.width + LENGTH_SIZE(30);
            w += lw;
            label.frame = CGRectMake(w - lw, 0, lw, LENGTH_SIZE(40));
            label.tag = i;
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLabel:)];
            [label addGestureRecognizer:tap];
            [self.labelArray addObject:label];
        }
        scrollView.contentSize = CGSizeMake(w, LENGTH_SIZE(50));
        
        self.lineView = [[UIView alloc]init];
        CGFloat s = CGRectGetWidth(self.labelArray[0].frame);
        self.lineView.frame = CGRectMake(0, LENGTH_SIZE(48), s,LENGTH_SIZE(2));
        self.lineView.backgroundColor = [UIColor baseColor];
//        [scrollView addSubview:self.lineView];
        self.labelArray[0].textColor = [UIColor whiteColor];
         //        [self.collectionView reloadData];
    }
    self.LabelscrollView.hidden = YES;
}

-(void)touchLabel:(UITapGestureRecognizer *)tap{
    NSInteger index = [tap view].tag;
//    [self selectButtonAtIndex:index];
    [self scrollToItenIndex:index];
}

-(void)selectButtonAtIndex:(NSInteger)index{
    CGFloat x = CGRectGetMinX(self.labelArray[index].frame);
    CGFloat w = CGRectGetWidth(self.labelArray[index].frame);
    for (UILabel *label in self.labelArray) {
        label.textColor = [UIColor whiteColor];
    }
    self.labelArray[index].textColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = CGRectMake(x, LENGTH_SIZE(48), w, LENGTH_SIZE(2));
    }];
    
    if (x+w>SCREEN_WIDTH) {
        [self.LabelscrollView setContentOffset:CGPointMake(x+w - SCREEN_WIDTH,0) animated:YES];
    }else{
        [self.LabelscrollView setContentOffset:CGPointMake(0,0) animated:YES];
    }
    
}

//选择视频类型
-(void)scrollToItenIndex:(NSInteger)index{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [DSBaActivityView showActiviTy];
        });
    self.LabelscrollView.hidden = YES;
    self.TypeBt.selected = YES;
    self.IsVideoType = self.TypeModel.data[index].id;
    self.currentpage = 0;
    self.IsRecommend = @"";
    self.page = 1;
    self.currentpage = 0;
//    [self.listArray removeAllObjects];
    [self requestQueryGetVideoList];
     self.recommendBt.selected = NO;
     self.bgView.alpha = 0;
    self.bgView.hidden = YES;
 }


-(void)setBottomView{
    
    
    
    self.bottomBgView = [[UIView alloc]init];
    [self.Commentview addSubview:self.bottomBgView];
    [self.bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(LENGTH_SIZE(48));
    }];
 
    UIView *backSearch = [[UIView alloc] init];
    [self.Commentview addSubview:backSearch];
    self.BacksearchView = backSearch;
    self.BacksearchView.backgroundColor = [UIColor whiteColor];
    [self.BacksearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.Commentview.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(LENGTH_SIZE(48));
    }];
    
    self.searchBgView = [[UIView alloc]init];
    [self.BacksearchView addSubview:self.searchBgView];
    [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(10));
        make.right.mas_equalTo(LENGTH_SIZE(-10));
        make.bottom.mas_equalTo(LENGTH_SIZE(-7));
        make.height.mas_equalTo(LENGTH_SIZE(34));
    }];
    self.searchBgView.layer.masksToBounds = YES;
    self.searchBgView.layer.cornerRadius = LENGTH_SIZE(17);
    self.searchBgView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UIImageView *writeImg = [[UIImageView alloc]init];
    [self.searchBgView addSubview:writeImg];
    [writeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.equalTo(self.searchBgView);
        make.size.mas_equalTo(CGSizeMake(LENGTH_SIZE(15), LENGTH_SIZE(14)));
    }];
    writeImg.image = [UIImage imageNamed:@"comment_write"];
    
    self.commentTextField = [[UITextField alloc]init];
    [self.searchBgView addSubview:self.commentTextField];
    [self.commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(writeImg.mas_right).offset(5);
        make.right.mas_equalTo(LENGTH_SIZE(10));
        make.height.mas_equalTo(self.searchBgView.mas_height);
        make.centerY.equalTo(self.searchBgView);
    }];
    self.commentTextField.delegate = self;
    self.commentTextField.tintColor = [UIColor baseColor];
    self.commentTextField.placeholder = @"Biu一下";
    self.commentTextField.returnKeyType = UIReturnKeySend;
    self.commentTextField.enablesReturnKeyAutomatically =YES;
//    [self.commentTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    self.sendButton = [[UIButton alloc]init];
    [self.bottomBgView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentTextField.mas_right).offset(LENGTH_SIZE(15));
        make.right.mas_equalTo(LENGTH_SIZE(-15));
        make.height.mas_equalTo(LENGTH_SIZE(26));
        make.centerY.equalTo(self.bottomBgView);
    }];
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.layer.cornerRadius = LENGTH_SIZE(13);
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendButton.hidden = YES;
     self.sendButton.enabled = NO;
    self.sendButton.backgroundColor = [UIColor lightGrayColor];
//    [self.sendButton addTarget:self action:@selector(touchSendButton:) forControlEvents:UIControlEventTouchUpInside];
}
 
#pragma mark - touch
//推荐点击
-(void)touchrecommended:(UIButton *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [DSBaActivityView showActiviTy];
        NSLog(@"推荐点击");
        self.currentpage = 0;
        if (sender.selected == NO) {
            sender.selected = YES;
//            [self.listArray removeAllObjects];
            self.IsRecommend = @"1";
            self.page = 1;
            self.IsVideoType =@"";
            self.currentpage = 0;
            [self requestQueryGetVideoList];
        }else{
//            sender.selected = NO;
//            [self.listArray removeAllObjects];
//            self.page = 1;
//            self.IsRecommend = @"";
//            self.IsVideoType =@"";
//            [self requestQueryGetVideoList];
        }
        self.TypeBt.selected = NO;
        self.LabelscrollView.hidden = YES;
        self.bgView.hidden = YES;
        self.bgView.alpha = 0;
    });
    
}

//分类
-(void)touchtype:(UIButton *)sender{
     self.LabelscrollView.hidden = !self.LabelscrollView.hidden;
    if (self.LabelscrollView.hidden == NO) {
        self.bgView.hidden = NO;
        self.bgView.alpha = 0.5;
        [self.view bringSubviewToFront:self.bgView];
        [self.view bringSubviewToFront:self.LabelscrollView];
    }else{
        self.bgView.hidden = YES;
        self.bgView.alpha = 0;
    }
    
}

#pragma mark - textfield
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([LoginUtils validationLogin:self]) {
        self.commentId = @(self.listArray[self.currentpage].id.integerValue);
        self.commentType = 4;
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


// 滚动视图滚动, 就会执行
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableview) {
        return;
    }
    
    // tracking 用户触摸
    CGFloat pageheight = scrollView.frame.size.height;
    int page = floor((scrollView.contentOffset.y - pageheight / 2) / pageheight) + 1;

    if (scrollView.tracking) {
//        NSLog(@"正在拖动滚动");
    } else {
//        NSLog(@"自己滚动中");
    }
    // dragging 用户开始滑动
    if (scrollView.dragging) {
//        NSLog(@"用户开始滑动");
    }
    // decelerating 用户触摸结束
    if (scrollView.decelerating) {
//        NSLog(@"用户触摸结束");
        if (page !=self.currentpage && self.playerCurrent.isPlaying ) {
         [self.playerCurrent pause];
            [self.playerCurrent setStartTime:0.0];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.tableview) {
        return;
    }
    
    CGFloat pageheight = scrollView.frame.size.height;
    int page = floor((scrollView.contentOffset.y - pageheight / 2) / pageheight) + 1;
//    [self selectButtonAtIndex:page];
       if (self.currentpage <page) {       //下
          LPVideoPlayCell *Playcell = (LPVideoPlayCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
           Playcell.PlayImage.hidden = YES;
           Playcell.barrageBtn.selected = self.barrageStatus;

           if ((page +2 == self.listArray.count || page +1 == self.listArray.count) && !self.isReloadData) {
               [self requestQueryGetVideoList];
               self.currentpage = page;
               return;
           }
           [self.playerCurrent removeVideo];
//            self.playerCurrent = [GKDYVideoPlayer new];
           [self.playerCurrent playVideoWithView:Playcell.coverImgView url:self.listArray[page].videoUrl];
//           if (self.currentpage+1 == page) {
//               [self.playerCurrent pause];
//               [self.playerCurrent setStartTime:0];
//               if (self.playerTop!=self.playerCurrent) {
//                  [self.playerTop removeVideo];
//               }
//               self.playerTop = self.playerCurrent;
//               self.playerCurrent = self.playerNext;
//               if ([self.playerCurrent getPlayerDuration]) {
//                   [self.playerCurrent playVideoWithView:Playcell.coverImgView];
//               }else{
//                   [self.playerCurrent playVideoWithView:Playcell.coverImgView url:self.listArray[page].videoUrl];
//               }
////               [self.playerCurrent playVideoWithView:Playcell.coverImgView];
//               [self requestQuerySetVideoView:page];
//                   [self.playerCurrent resume];
//               if (page +1 < self.listArray.count) {
//                   self.playerNext = [GKDYVideoPlayer new];
//                   [self.playerNext playVideourl:self.listArray[page+1].videoUrl];
//               }
//           }else{
//               [self.playerCurrent removeVideo];
//               [self.playerTop removeVideo];
//               [self.playerNext removeVideo];
//               LPVideoListDataModel *model = self.listArray[page];
//               [self.playerCurrent playVideoWithView:Playcell.coverImgView url:model.videoUrl];
//               [self requestQuerySetVideoView:page];
//
//               [self.playerCurrent resume];
//               if (page == 0) {       //第一个视频进来
//                   //缓存下一个
//                   [self.playerNext playVideourl:self.listArray[page+1].videoUrl];
//               }else if (page+1 == self.listArray.count){     //最后一个视频进来
//                   //缓存上一个
//                   [self.playerTop playVideourl:self.listArray[page-1].videoUrl];
//               }else{
//                   //缓存上下两个
//                   [self.playerTop playVideourl:self.listArray[page-1].videoUrl];
//                   [self.playerNext playVideourl:self.listArray[page+1].videoUrl];
//               }
//           }
          
       }else if (self.currentpage >page){       //上
           LPVideoPlayCell *Playcell = (LPVideoPlayCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
           Playcell.PlayImage.hidden = YES;
           Playcell.barrageBtn.selected = self.barrageStatus;
           [self.playerCurrent removeVideo];
           [self.playerCurrent playVideoWithView:Playcell.coverImgView url:self.listArray[page].videoUrl];

//           if (self.currentpage -1 == page) {
//               [self.playerCurrent pause];
//               [self.playerCurrent setStartTime:0];
//
//               if (self.playerNext!=self.playerCurrent) {
//                   [self.playerNext removeVideo];
//               }
//                self.playerNext = self.playerCurrent;
//
//               self.playerCurrent = self.playerTop;
//               if ([self.playerCurrent getPlayerDuration]) {
//                   [self.playerCurrent playVideoWithView:Playcell.coverImgView];
//               }else{
//                   [self.playerCurrent playVideoWithView:Playcell.coverImgView url:self.listArray[page].videoUrl];
//               }
////               [self.playerCurrent playVideoWithView:Playcell.coverImgView];
//               [self requestQuerySetVideoView:page];
//
//               [self.playerCurrent resume];
//
//               //               [self.playerCurrent resume];
//                if (page>0) {
//                   self.playerTop = [GKDYVideoPlayer new];
//                   [self.playerTop playVideourl:self.listArray[page-1].videoUrl];
//               }
//           }else{
//               [self.playerCurrent removeVideo];
//               [self.playerTop removeVideo];
//               [self.playerNext removeVideo];
//
//               LPVideoListDataModel *model = self.listArray[page];
//               [self.playerCurrent playVideoWithView:Playcell.coverImgView url:model.videoUrl];
//              [self requestQuerySetVideoView:page];
////               [self.playerCurrent resume];
//
//               [self.playerCurrent resume];
//
//               if (page == 0) {       //第一个视频进来
//                   //缓存下一个
//                   [self.playerNext playVideourl:self.listArray[page+1].videoUrl];
//               }else if (page+1 == self.listArray.count){     //最后一个视频进来
//                   //缓存上一个
//                   [self.playerTop playVideourl:self.listArray[page-1].videoUrl];
//               }else{
//                   //缓存上下两个
//                   [self.playerTop playVideourl:self.listArray[page-1].videoUrl];
//                   [self.playerNext playVideourl:self.listArray[page+1].videoUrl];
//               }
//           }
 
       }else{           //播放当前视频
           LPVideoPlayCell *Playcell = (LPVideoPlayCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
           Playcell.PlayImage.hidden = YES;
           Playcell.barrageBtn.selected = self.barrageStatus;

//           [self.playerCurrent resume];
               [self.playerCurrent resume];
       }
 
    NSLog(@"但是视频是否播放 = %@",self.playerCurrent.isPlaying?@"shi":@"no");
    if (self.playerCurrent.isPlaying == NO) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LPVideoPlayCell *Playcell = (LPVideoPlayCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
        Playcell.PlayImage.hidden = YES;
        Playcell.barrageBtn.selected = self.barrageStatus;
        [self.playerCurrent resume];
       });
    }
    NSLog(@"但是视频是否播放 = %@",self.playerCurrent.isPlaying?@"shi":@"no");

    if (self.barrageStatus && self.currentpage != page) {
        [self BarrageViewshut];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self BarrageViewopen];
            self.VideoPage = 1;
            [self requestQueryGetVideoComment];
        });
    }
    
    
    self.currentpage = page;
    self.VideoRow = self.currentpage;
    
   


}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LPVideoPlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPVideoPlayCellID forIndexPath:indexPath];
    cell.model = self.listArray[indexPath.row];
    cell.Row = indexPath.row;
    cell.Type = self.Type;
    cell.TypeModel = self.TypeModel;
    if (self.Type == 1) {
        cell.superVC= self.superVC;
     }else{
        cell.KeySuperVC= self.KeySuperVC;
     }
    WEAK_SELF()
    cell.BlockMessage = ^(void){
        weakSelf.commentListArray = [NSMutableArray array];
        [weakSelf.tableview reloadData];
        weakSelf.Commentpage = 1;
        [weakSelf requestCommentList];
        self.commentType = 4;
        self.commentId = @(weakSelf.listArray[weakSelf.currentpage].id.integerValue);
        [weakSelf TableViewHidden:NO];
    };
    cell.CollectionBlock = ^(void){
        if (weakSelf.LPCollectionBlock){
            weakSelf.LPCollectionBlock();
        }
    };
    cell.barrageBtn.selected = self.barrageStatus;
    cell.BarrageBlock = ^(BOOL Select) {
        weakSelf.barrageStatus = Select;
        if (Select) {
            [weakSelf BarrageViewopen];
            weakSelf.VideoPage = 1;
            [weakSelf requestQueryGetVideoComment];
        }else{
            [weakSelf BarrageViewshut];
        }
    };
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LPVideoPlayCell *Playcell = (LPVideoPlayCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    if (self.playerCurrent.isPlaying) {
        [self.playerCurrent pause];
        Playcell.PlayImage.hidden = NO;
    }else{
        [self.playerCurrent resume];
        Playcell.PlayImage.hidden = YES;
    }
}


//已经展示某个Item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([DeviceUtils deviceType] == IPhone_X) {
        return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT);
    }else{
        return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return 0;
}

#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
      //开始手动计算cell高度
    LPCommentListDataModel *m = self.commentListArray[indexPath.row];
    CGFloat cellHeigh = 92.5 + [LPTools calculateRowHeight:m.commentDetails fontSize:13 Width:SCREEN_WIDTH - 67];
    //计算回复高度
    for (int i = 0 ;i < m.commentModelList.count;i++) {
        cellHeigh +=[LPTools calculateRowHeight:[NSString stringWithFormat:@"%@ 回复 %@: %@ ",
                                                 m.userName,
                                                 m.toUserName,
                                                 m.commentDetails]
                                       fontSize:13 Width:SCREEN_WIDTH-79]+8;
    }
    if (m.commentModelList.count) {
        cellHeigh +=8;
    }
    return cellHeigh;
//    return 100;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
         return self.commentListArray.count;
 }

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
         UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(16, 0, SCREEN_WIDTH-16, 30);
        label.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
        label.font = [UIFont systemFontOfSize:12];
        label.text = [NSString stringWithFormat:@"%ld条评论",(long)self.listArray[self.currentpage].commentTotal.integerValue];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        return view;
      }else{
        return nil;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
         LPEssayDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:LPEssayDetailCommentCellID];
        cell.model = self.commentListArray[indexPath.row];
        cell.delegate = self;
        cell.SuperTableView = tableView;
        WEAK_SELF()
        cell.DeleteBlock = ^(NSString *CommId){
            [weakSelf requestQueryDeleteComment:CommId];
        };
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

-(void)setVideoListModel:(LPVideoListModel *)VideoListModel{
    _VideoListModel = VideoListModel;
    NSLog(@" self.page = %ld",(long)self.page);
    if ([self.VideoListModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.currentpage = 0;
            [self.listArray  removeAllObjects];

        }
        if (self.VideoListModel.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.VideoListModel.data];
            if (self.Type == 1) {
                [self.superVC.videocollectionView reloadData];
             }else{
                [self.KeySuperVC.videocollectionView reloadData];
             }
             [self.collectionView reloadData];
            [self.collectionView layoutIfNeeded];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentpage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
            [self.playerCurrent removeVideo];
            [self.playerTop removeVideo];
            [self.playerNext removeVideo];
            LPVideoListDataModel *model = self.listArray[self.currentpage];
            [self.collectionView layoutIfNeeded];

//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LPVideoPlayCell *Playcell = (LPVideoPlayCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentpage inSection:0]];
                [self.playerCurrent removeVideo];
                [self.playerCurrent playVideoWithView:Playcell.coverImgView url:model.videoUrl];
                [self requestQuerySetVideoView:self.currentpage];
 
//                [self.playerCurrent resume];
//                [self.playerCurrent resume];
//            if (self.listArray.count>1) {
//                if (self.currentpage == 0) {       //第一个视频进来
//                    //缓存下一个
//                    [self.playerNext playVideourl:self.listArray[self.currentpage+1].videoUrl];
//                }else if (self.currentpage+1 == self.listArray.count){     //最后一个视频进来
//                    //缓存上一个
//                    [self.playerTop playVideourl:self.listArray[self.currentpage-1].videoUrl];
//                }else{
//                    //缓存上下两个
//                    [self.playerTop playVideourl:self.listArray[self.currentpage-1].videoUrl];
//                    [self.playerNext playVideourl:self.listArray[self.currentpage+1].videoUrl];
//                }
//            }
            
//            });
            
            
             if (self.VideoListModel.data.count<20) {
//                 if (self.Type == 1) {
//                     [self.superVC.videocollectionView.mj_footer endRefreshingWithNoMoreData];
//                  }else{
//                     [self.KeySuperVC.videocollectionView.mj_footer endRefreshingWithNoMoreData];
//                  }
                self.isReloadData = YES;
            }
            
            
            if (self.page == 2) {
                self.VideoPage = 1;
                [self requestQueryGetVideoComment];
            }
            
        }else{
//             if (self.page == 1) {
//                 if (self.Type == 1) {
//                     [self.superVC.videocollectionView reloadData];
//                  }else{
//                     [self.KeySuperVC.videocollectionView reloadData];
//                  }
//             }else{
//                 if (self.Type == 1) {
//                     [self.superVC.videocollectionView.mj_footer endRefreshingWithNoMoreData];
//                 }else{
//                     [self.KeySuperVC.videocollectionView.mj_footer endRefreshingWithNoMoreData];
//                  }
                self.isReloadData = YES;
 
                LPVideoPlayCell *Playcell = (LPVideoPlayCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentpage inSection:0]];
             [self.playerCurrent removeVideo];
                [self.playerCurrent playVideoWithView:Playcell.coverImgView url:self.listArray[self.currentpage].videoUrl];
                [self requestQuerySetVideoView:self.currentpage];
 
//                [self.playerCurrent resume];
//                [self.playerCurrent resume];
//            if (self.listArray.count>1) {
//                if (self.currentpage == 0) {       //第一个视频进来
//                    //缓存下一个
//                    [self.playerNext playVideourl:self.listArray[self.currentpage+1].videoUrl];
//                }else if (self.currentpage+1 == self.listArray.count){     //最后一个视频进来
//                    //缓存上一个
//                    [self.playerTop playVideourl:self.listArray[self.currentpage-1].videoUrl];
//                }else{
//                    //缓存上下两个
//                    [self.playerTop playVideourl:self.listArray[self.currentpage-1].videoUrl];
//                    [self.playerNext playVideourl:self.listArray[self.currentpage+1].videoUrl];
//                }
//            }
            
                
//            }
        }
     
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}



-(void)setCommentListModel:(LPCommentListModel *)commentListModel{
    _commentListModel = commentListModel;
    if ([commentListModel.code integerValue] == 0) {
        if (self.Commentpage == 1) {
            self.commentListArray = [NSMutableArray array];
        }
        if (commentListModel.data.count > 0) {
            self.Commentpage += 1;
            [self.commentListArray addObjectsFromArray:commentListModel.data];
            [self.tableview reloadData];

        }else{
            [self.tableview reloadData];
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.commentListArray.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}
-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.Commentview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectZero];
        [noDataView image:nil text:@"赶紧来抢占一楼吧！"];
        [self.Commentview addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(30);
//            make.bottom.mas_equalTo(-48);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.Commentview.mas_safeAreaLayoutGuideBottom).offset(-48);
            } else {
                // Fallback on earlier versions
                make.bottom.mas_equalTo(-48);
            }
        }];
        noDataView.hidden = hidden;
    }
}

-(void)TableViewHidden:(BOOL) hidden
{
    self.bgView.hidden = hidden;
    if (hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0;
            self.Commentview.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3*2);
            [self.commentTextField resignFirstResponder];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0.5;
            [self.view bringSubviewToFront:self.bgView];
            [self.view bringSubviewToFront:self.Commentview];

            self.Commentview.frame = CGRectMake(0, SCREEN_HEIGHT/3, SCREEN_WIDTH, SCREEN_HEIGHT/3*2);
        }];
    }

}

-(UIView *)Commentview{
    if (!_Commentview) {
        _Commentview = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3*2)];
        self.tableview.layer.cornerRadius = 10;
        _Commentview.backgroundColor = [UIColor whiteColor];
        [_Commentview addSubview:self.tableview];
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.left.right.mas_equalTo(0);
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(_Commentview.mas_safeAreaLayoutGuideBottom);
            } else {
                 make.bottom.mas_equalTo(0);
            }
        }];
    }
    return _Commentview;
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
         _tableview = [[UITableView alloc] init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
         [_tableview registerNib:[UINib nibWithNibName:LPEssayDetailCommentCellID bundle:nil] forCellReuseIdentifier:LPEssayDetailCommentCellID];
 
        WEAK_SELF()
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestCommentList];
            NSLog(@"调用上啦刷新");
         }];
     }
    return _tableview;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        // layout.minimumInteritemSpacing = 10;// 垂直方向的间距
        layout.minimumLineSpacing = 0; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerNib:[UINib nibWithNibName:LPVideoPlayCellID bundle:nil] forCellWithReuseIdentifier:LPVideoPlayCellID];
//        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [self requestQueryGetVideoList];
//        }];
    }
    return _collectionView;
}


- (GKDYVideoPlayer *)playerTop {
    if (!_playerTop) {
        _playerTop = [GKDYVideoPlayer new];
     }
    return _playerTop;
}
- (GKDYVideoPlayer *)playerCurrent {
    if (!_playerCurrent) {
        _playerCurrent = [GKDYVideoPlayer new];
     }
    return _playerCurrent;
}
- (GKDYVideoPlayer *)playerNext {
    if (!_playerNext) {
        _playerNext = [GKDYVideoPlayer new];
     }
    return _playerNext;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT+20)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.1;
        _bgView.hidden = YES;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
        [_bgView addGestureRecognizer:tap];
     }
    return _bgView;
}
-(void)hidden{
    self.LabelscrollView.hidden = YES;
    [self TableViewHidden:YES];
}

-(void)requestQueryGetVideoList{
      //计算ids
    NSString *ids =@"";
    if (self.listArray.count<=40) {
        for (LPVideoListDataModel *m in self.listArray) {
            ids = [NSString stringWithFormat:@"%@%@v,",ids,m.id];
        }
    }else{
        for (NSInteger i = self.listArray.count-40 ; i<self.listArray.count ; i++) {
            LPVideoListDataModel *m = self.listArray[i];
            ids = [NSString stringWithFormat:@"%@%@v,",ids,m.id];
        }
    }
    if (self.page == 1) {
        ids =@"";
    }else{
        if (self.listArray.count) {
            if (self.listArray.count/20>0) {
                self.page = self.listArray.count/20+1;
            }else{
                self.page = 2;
            }
        }
    }
    
    NSLog(@"发送数据");
    NSDictionary *dic = @{@"videoName":self.key?self.key:@"",
                          @"ids":ids,
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"status":self.IsRecommend,
                          @"labelId":self.IsVideoType
                          };
 
    [NetApiManager requestQueryGetVideoList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
 
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [DSBaActivityView hideActiviTy];

        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.VideoListModel = [LPVideoListModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQuerySetVideoView:(NSInteger) page{
    
    NSDictionary *dic = @{@"id":[LPTools isNullToString:self.listArray[page].id]};
    self.listArray[page].view =[NSString stringWithFormat:@"%ld",self.listArray[page].view.integerValue+1];
    NSLog(@"%@",self.listArray[page].view);
    [NetApiManager requestQuerySetVideoView:dic withHandle:^(BOOL isSuccess, id responseObject) {
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

-(void)requestCommentList{
    NSDictionary *dic = @{
                          @"type":@(4),
                          @"page":@(self.Commentpage),
                          @"id":[LPTools isNullToString:self.listArray[self.currentpage].id],
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

-(void)requestCommentAddcomment:(NSString *) commentText{
    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
    NSDictionary *dic = @{@"commentDetails": commentText,
                          @"commentType": @(self.commentType),
                          @"commentId": self.commentId,
                          @"userName": [LPTools isNullToString:user.data.user_name],
                          @"userId": [LPTools isNullToString:kUserDefaultsValue(LOGINID)],
                          @"userUrl": [LPTools isNullToString:user.data.user_url],
                          @"versionType":@"2.1",
                          @"replyUserId":self.commentUserModel?@(self.commentUserModel.userId.integerValue):@""
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
    
                m.grading = user.data.grading;
                if (self.commentType == 4) {
                    [self.commentListArray insertObject:m atIndex:0];
                    self.listArray[self.currentpage].commentTotal = [NSString stringWithFormat:@"%ld",self.listArray[self.currentpage].commentTotal.integerValue+1];
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
               
                LPVideoPlayCell *Playcell = (LPVideoPlayCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentpage inSection:0]];
                [Playcell ReloadComment:self.listArray[self.currentpage]];
                [self.tableview reloadData];
                [self.tableview layoutIfNeeded];
                [self scrollViewToBottom:YES];
                [self addNodataViewHidden:YES];
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



-(void)requestQueryDeleteComment:(NSString *) CommentId{
    
    NSString * appendURLString = [NSString stringWithFormat:@"comment/update_comment?id=%@&moodId=%@&versionType=2.3",CommentId,self.listArray[self.currentpage].id];
    
    [NetApiManager requestQueryDeleteComment:nil URLString:appendURLString withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"][@"result"] integerValue] == 1) {
                    
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



-(void)requestQueryGetVideoComment{
    

    self.isRequest = YES;
    NSDictionary *dic = @{@"commentId":[LPTools isNullToString:self.listArray[self.currentpage].id],
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.VideoPage]
                          };
    
    [NetApiManager requestQueryGetVideoComment:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSArray *CommentArr = [responseObject[@"data"] mj_JSONObject];
                if (CommentArr.count < 20) {
                    self.VideoPage = 0;
                }
                [self.barrageView lj_addBarrageTexts:CommentArr];

            }else{
                [[UIWindow  visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow  visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        
        self.isRequest = NO;
    }];
}



- (void)scrollViewToBottom:(BOOL)animated
{
         //刷新完成
         NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableview scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


#pragma mark - <LJBarrageViewDelegate>

//重构弹幕样式
- (UIView *)refactoringView:(UIView *)view text:(id)text {

    view.lj_barrageLabel.textColor = arc4random_uniform(2) ? [UIColor colorWithHexString:@"#FFFFFF"] : [UIColor colorWithHexString:@"#FFDB32"];
//
    view.lj_barrageLabel.lx_width = view.lx_width+20;
    view.lj_barrageLabel.layer.cornerRadius = LENGTH_SIZE(12);
    view.lj_barrageLabel.clipsToBounds = YES;
    
    view.lx_width = view.lx_width+20;
//    view.lx_y = view.lx_y + view.lx_y/LENGTH_SIZE(24)*6;
//    view.lj_barrageLabel.lx_y = view.lj_barrageLabel.lx_y + view.lj_barrageLabel.lx_y/LENGTH_SIZE(24)*6;
    view.lj_barrageLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
   
    [view.lj_barrageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(LENGTH_SIZE(24));
        make.centerY.equalTo(view);
        make.left.right.mas_offset(0);
    }];
    
//    UILabel *label = [[UILabel alloc] init];
//    [view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_offset(LENGTH_SIZE(24));
//        make.centerY.equalTo(view);
//        make.left.right.mas_offset(0);
//    }];
//    label.text = text;
//    label.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
//    label.layer.cornerRadius = LENGTH_SIZE(12);
//    label.textColor = arc4random_uniform(2) ? [UIColor colorWithHexString:@"#FFFFFF"] : [UIColor colorWithHexString:@"#FFDB32"];


    return view;
}

//单次点击弹幕
- (void)clickBarrageWithView:(UIView *)view text:(id)text {
    
    NSLog(@"%@",text);
}

-(void)BarrageViewshut{
    if (self.barrageView) {
        [self.barrageView removeFromSuperview];
        self.barrageView = nil;
    }
}

-(void)BarrageViewopen{
    //初始化展示区域界面
    if (self.barrageView == nil) {
        LJBarrageView *barrageView = [LJBarrageView lj_creatNormalWithFrame:CGRectMake(0, LENGTH_SIZE(82), self.view.frame.size.width, LENGTH_SIZE(96))];
        [self.view addSubview:barrageView];
        self.barrageView = barrageView;
        
        //配置参数
        barrageView.barrageRow = 3;
        barrageView.barrageHeightType = BarrageHeightTypeNormal;
        barrageView.barrageShowStyle = LJBarrageShowStyleTypeShowTime;
        barrageView.styleParameter = 4;
        barrageView.delegate = self;
        barrageView.barrageStyle.barrageBackgroundColor  = [UIColor clearColor];
        barrageView.barrageStyle.barrageHeight = LENGTH_SIZE(32);
        barrageView.barrageStyle.barrageFont = FONT_SIZE(15);
        barrageView.barrageStyle.barrageTextAlignment = NSTextAlignmentCenter;
        barrageView.barrageEnterInterval = 0.5;
        barrageView.barrageShowMax = 13;
    }
    
}


@end
