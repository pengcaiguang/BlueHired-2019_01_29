//
//  LPVideoPlayCell.m
//  BlueHired
//
//  Created by iMac on 2018/11/20.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPVideoPlayCell.h"
#import "KJMarqueeLabel.h"

@interface LPVideoPlayCell()

@property (nonatomic,strong) UIImageView *UserImage;
@property (nonatomic,strong) UIButton *LoveButton;
@property (nonatomic,strong) UILabel *LoveLabel;
@property (nonatomic,strong) UIButton *MessageButton;
@property (nonatomic,strong) UILabel *MessageLabel;
@property (nonatomic,strong) UIButton *CollectButton;
@property (nonatomic,strong) KJMarqueeLabel *TitleLabel;
@property(nonatomic,strong)CustomIOSAlertView *CustomAlert;



// 视频封面图:显示封面并播放视频
@end

@implementation LPVideoPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    [self addSubview:self.coverImgView];
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        
    }];
 
    UIButton *BackBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 42,40, 40)];
    [BackBt setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [BackBt addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:BackBt];
    
    UIImageView *User = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 391,40, 40)];
    self.UserImage = User;
    User.clipsToBounds = YES;
    User.layer.cornerRadius = 20;
      [self addSubview:User];
    
    UIButton *LoveBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 332,40, 40)];
    [LoveBt setImage:[UIImage imageNamed:@"Videopraise_normal"] forState:UIControlStateNormal];
     [LoveBt setImage:[UIImage imageNamed:@"Videopraise_Selected"] forState:UIControlStateSelected];
    [LoveBt addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
    [LoveBt addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:LoveBt];
    self.LoveButton = LoveBt;
    self.LoveLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60,SCREEN_HEIGHT - 292,40, 8)];
    [self addSubview:self.LoveLabel];
    self.LoveLabel.textColor = [UIColor whiteColor];
    self.LoveLabel.textAlignment =NSTextAlignmentCenter;
    self.LoveLabel.font = [UIFont systemFontOfSize:11];
    
    UIButton *MessageBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60,SCREEN_HEIGHT - 261,40, 40)];
    [MessageBt setImage:[UIImage imageNamed:@"messageImage"] forState:UIControlStateNormal];
    [MessageBt addTarget:self action:@selector(touchUpInsideMessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:MessageBt];
    self.MessageButton = MessageBt;
    self.MessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60,SCREEN_HEIGHT - 221,40, 8)];
    [self addSubview:self.MessageLabel];
    self.MessageLabel.textColor = [UIColor whiteColor];
    self.MessageLabel.textAlignment =NSTextAlignmentCenter;
    self.MessageLabel.font = [UIFont systemFontOfSize:11];
    
    UIButton *CollectionBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60,SCREEN_HEIGHT - 192,40, 40)];
    [CollectionBt setImage:[UIImage imageNamed:@"Videocollection_normal"] forState:UIControlStateNormal];
    [CollectionBt setImage:[UIImage imageNamed:@"Videocollection_Selected"] forState:UIControlStateSelected];
    [CollectionBt addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
    [CollectionBt addTarget:self action:@selector(touchCollectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:CollectionBt];
    self.CollectButton = CollectionBt;
    
    UIButton *ShareBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT-120,40, 40)];
    [ShareBt setImage:[UIImage imageNamed:@"分享(7)"] forState:UIControlStateNormal];
    [ShareBt addTarget:self action:@selector(touchShare) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ShareBt];
    
    UIImageView *titleImage = [[UIImageView alloc] init];
    [self addSubview:titleImage];
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-44);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(14);
     }];
    titleImage.image = [UIImage imageNamed:@"VideoTitleImage"];
    
    KJMarqueeLabel *Title = [[KJMarqueeLabel alloc] init];
    [self addSubview:Title];
    self.TitleLabel = Title;
    [Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-44);
        make.left.mas_equalTo(34);
        make.right.mas_equalTo(-23);
    }];
    Title.textColor = [UIColor whiteColor];
    Title.font = [UIFont systemFontOfSize:15];
    Title.marqueeLabelType = KJMarqueeLabelTypeLeft;
    Title.speed = 1;
    Title.stopTime = 1;
    
    self.PlayImage = [[UIImageView alloc] init];
    [self addSubview:self.PlayImage];
    [self.PlayImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.PlayImage.image = [UIImage imageNamed:@"PlayImage"];
    
}
-(void)ReloadComment:(LPVideoListDataModel *) model{
    self.MessageLabel.text = [NSString stringWithFormat:@"%ld",(long)[LPTools isNullToString:model.commentTotal].integerValue];
    self.TitleLabel.text = [LPTools isNullToString:model.videoName];
}
- (void)setModel:(LPVideoListDataModel *)model{
    _model = model;
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:model.videoImage] placeholderImage:[UIImage imageNamed:@""]];
    [self.UserImage sd_setImageWithURL:[NSURL URLWithString:model.labelUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
    self.LoveLabel.text = [NSString stringWithFormat:@"%ld",(long)[LPTools isNullToString:model.praiseTotal].integerValue];
    self.LoveButton.selected = [[LPTools isNullToString:model.likeStatus] integerValue]?NO:YES;
    self.MessageLabel.text = [NSString stringWithFormat:@"%ld",(long)[LPTools isNullToString:model.commentTotal].integerValue];
    self.CollectButton.selected = [[LPTools isNullToString:model.collectionStatus] integerValue]?NO:YES;
    self.TitleLabel.text = [LPTools isNullToString:model.videoName];
     //    [self.player playVideoWithView:self.coverImgView url:model.videoUrl];
    self.PlayImage.hidden = YES;
 
}





- (void)setIsPlay:(BOOL)isPlay{
    _isPlay = isPlay;
    if (isPlay) {
        [self.player playVideoWithView:self.coverImgView url:self.model.videoUrl];
    }else{
        [self.player removeVideo];
    }
}

-(void)touchUpInside{
    NSLog(@"点击退出");
    if (self.Type == 1) {
        self.superVC.IsBackVideo = YES;
        [self.superVC.videocollectionView reloadData];
        [self.superVC.videocollectionView layoutIfNeeded];
        [self.superVC.videocollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.Row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        [self.superVC.videocollectionView layoutIfNeeded];
    }else{
        [self.KeySuperVC.videocollectionView reloadData];
        [self.KeySuperVC.videocollectionView layoutIfNeeded];
        [self.KeySuperVC.videocollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.Row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        [self.KeySuperVC.videocollectionView layoutIfNeeded];
    }
    NSLog(@"准备退出");

     [[UIWindow visibleViewController].navigationController popViewControllerAnimated:NO];
}

-(void)touchUpInsideMessage{
    if (self.BlockMessage) {
        self.BlockMessage();
    }
}

//分享
-(void)touchShare{
//    [self WeiXinOrQQAlertView];
    NSString *url = [NSString stringWithFormat:@"%@bluehired/video.html?videoCover=%@&videoTitle=%@",BaseRequestWeiXiURL,self.model.videoImage,self.model.videoName];
    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [LPTools ClickShare:encodedUrl Title:self.model.videoName];
}

//推荐

//分类

- (void)preventFlicker:(UIButton *)button {
    button.highlighted = NO;
}

//点赞
-(void)touchBottomButton:(UIButton *)button{
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        self.LoveButton.selected = !self.LoveButton.selected;
        [self requestSocialSetlike];
     }
}
//收藏
-(void)touchCollectButton:(UIButton *)button{
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        self.CollectButton.selected = !self.CollectButton.selected;
        [self requestSetCollection];
    }
}


-(void)requestSocialSetlike{
    NSDictionary *dic = @{
                          @"type":@(4),
                          @"id":self.model.id,
                          @"likeStatus":self.LoveButton.selected?@"0":@"1"
                          };
    self.model.likeStatus = self.LoveButton.selected?@"0":@"1";
    if (self.LoveButton.selected) {
        self.model.praiseTotal = [NSString stringWithFormat:@"%ld",self.model.praiseTotal.integerValue+1];
    }else{
        self.model.praiseTotal = [NSString stringWithFormat:@"%ld",self.model.praiseTotal.integerValue-1];
    }
    self.LoveLabel.text = [NSString stringWithFormat:@"%ld",(long)[LPTools isNullToString:self.model.praiseTotal].integerValue];

    [NetApiManager requestSocialSetlikeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    } IsShowActiviTy:NO];
}

-(void)requestSetCollection{
    NSDictionary *dic = @{
                          @"type":@(5),
                          @"id":self.model.id,
                          @"collectionStatus":self.CollectButton.selected?@"0":@"1"
                          };
    self.model.collectionStatus = self.CollectButton.selected?@"0":@"1";

    [NetApiManager requestSetCollectionWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                    if ([responseObject[@"data"] integerValue] == 0) {
                        [LPTools AlertCollectView:@""];
                    }else if ([responseObject[@"data"] integerValue] == 1) {
                        
                    }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    } IsShowActivity:NO];
}

#pragma mark - 懒加载
- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = [UIImageView new];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImgView.backgroundColor = [UIColor blackColor];
        _coverImgView.clipsToBounds = YES;
    }
    return _coverImgView;
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
    
//    http://192.168.0.152:8020/bluehired/video.html?videoCover=132****0678&videoTitle=0.85
    NSString *url = [NSString stringWithFormat:@"%@bluehired/video.html?videoCover=%@&videoTitle=%@",BaseRequestWeiXiURL,self.model.videoImage,self.model.videoName];
    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (sender.tag == 1)
    {
        if ([WXApi isWXAppInstalled]==NO) {
            [[UIWindow visibleViewController].view showLoadingMeg:@"请安装微信" time:MESSAGE_SHOW_TIME];
            [_CustomAlert close];
            return;
        }
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.scene = WXSceneSession;
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"蓝聘";
        message.description= self.model.videoName;
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
            [[UIWindow visibleViewController].view showLoadingMeg:@"请安装QQ" time:MESSAGE_SHOW_TIME];
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



@end
