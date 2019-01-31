//
//  SSYRedpacketDJSView.m
//  Drugdisc
//
//  Created by huangliwen on 2018/11/6.
//  Copyright © 2018年 Drugdisc. All rights reserved.
//

#import "SSYRedpacketDJSView.h"
#import "LPLoginVC.h"

#define kCoinCountKey   100     //总数
// 弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@interface SSYRedpacketDJSView()<CAAnimationDelegate>{
    NSMutableArray  *_coinTagsArr;  //存放生成的所有红包对应的tag值
}
@property (strong, nonatomic) UIView *viewDJS;
@property (strong, nonatomic) UILabel *labDJS;//倒计时
@property (strong, nonatomic) UIView *viewRedyu;//红包雨
@property (strong, nonatomic) UIButton *btnTotal;
@property (strong, nonatomic) UILabel *labDanciAdd;
@property(strong,nonatomic)UILabel *labRedyuDjs;//红包雨倒计时
@property (strong, nonatomic) UIView *viewRedpacketDown;//下雨动画
@property (strong, nonatomic) UIImageView *imgBox;

@property (nonatomic,assign) NSInteger seconds;//倒计时
@property (nonatomic,assign) NSTimer *countDownTimer;
@property (nonatomic,strong) UILabel *DJSlabel;


@property (nonatomic,assign) NSInteger RodCount;//倒计时
@property (nonatomic,strong) UILabel *rodLabel;//红包金额
@property (nonatomic,strong) UIButton *FxBt;//分享
@property (nonatomic,strong) UIImageView *redBack;//背景图
@property (nonatomic,assign) CGFloat redMoney;//背景图

@property(nonatomic,strong)CustomIOSAlertView *CustomAlert;


@end
@implementation SSYRedpacketDJSView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        _viewDJS=[[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-330)/2-4, (SCREEN_HEIGHT-305)/2-20, 330, 305)];
        UIImage *img=[UIImage imageNamed:@"activity_daojishi"];
        UIImageView *imgDJS=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
        [imgDJS setImage:img];
        imgDJS.contentMode=UIViewContentModeScaleAspectFit;
        [_viewDJS addSubview:imgDJS];
        _labDJS=[[UILabel alloc] initWithFrame:CGRectMake(136, 197, 80, 70)];
        [_labDJS setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:40]];
        [_labDJS setTextColor:[UIColor whiteColor]];
        _labDJS.textAlignment=NSTextAlignmentCenter;
        [_viewDJS addSubview:_labDJS];
        [self addSubview:_viewDJS];
        
        //红包雨
        _viewRedyu=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_viewRedyu setHidden:YES];
        [self addSubview:_viewRedyu];
        _labRedyuDjs=[[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 20)];
        [_labRedyuDjs setTextColor:[UIColor whiteColor]];
        [_labRedyuDjs setFont:[UIFont systemFontOfSize:25]];
        _labRedyuDjs.textAlignment=NSTextAlignmentCenter;
        [_viewRedyu addSubview:_labRedyuDjs];
        UILabel *labtishi=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-165)/2, SCREEN_HEIGHT-38, 165, 18)];
        [labtishi setTextColor:[UIColor whiteColor]];
        [labtishi setFont:[UIFont systemFontOfSize:13]];
        [_viewRedyu addSubview:labtishi];
        _btnTotal=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, SCREEN_HEIGHT-78, 100, 30)];
        [_btnTotal setBackgroundImage:[UIImage imageNamed:@"red_bottom_btn"] forState:0];
        [_btnTotal setTitle:@"¥ 0.0" forState:0];
        [_btnTotal setTitleColor:[UIColor whiteColor] forState:0];
        [_btnTotal.titleLabel setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:17]];
        [_btnTotal setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_btnTotal setTitleEdgeInsets:UIEdgeInsetsMake(4, 0, 0, 0)];
        [_viewRedyu addSubview:_btnTotal];
        _imgBox=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-131)/2, SCREEN_HEIGHT-196, 131, 105)];
        [_imgBox setImage:[UIImage imageNamed:@"red_box"]];
        [_viewRedyu addSubview:_imgBox];
        _labDanciAdd=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imgBox.frame), SCREEN_HEIGHT-115, 131, 17)];
        [_labDanciAdd setTextColor:[UIColor whiteColor]];
        [_labDanciAdd setFont:[UIFont systemFontOfSize:14]];
        _labDanciAdd.textAlignment=NSTextAlignmentCenter;
        [_viewRedyu addSubview:_labDanciAdd];
        
        //点击事件开始动画
         UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        image.image = [UIImage imageNamed:@"hongbaoBack"];
        [_viewRedyu addSubview:image];
        
        _viewRedpacketDown=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _viewRedpacketDown.clipsToBounds=YES;
        _viewRedpacketDown.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onQRedpacket:)];
        [_viewRedpacketDown addGestureRecognizer:singleTap];
        [_viewRedyu addSubview:_viewRedpacketDown];

        
        _DJSlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 30)];
        _DJSlabel.text = @"倒计时:15";
        _DJSlabel.font = [UIFont systemFontOfSize:15];
        _DJSlabel.textColor = [UIColor whiteColor];
        _DJSlabel.textAlignment = NSTextAlignmentCenter;
        [_viewRedyu addSubview:_DJSlabel];
        
        _seconds = 15;//60秒倒计时
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 20,40, 40)];
        [button setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_viewRedyu addSubview:button];
        
        UIView *rodview = [[UIView alloc] init];
        [_viewRedyu addSubview:rodview];
        [rodview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
         }];
        
        UIImageView *backImage = [[UIImageView alloc] init];
        self.redBack = backImage;
//        rodview.backgroundColor = [UIColor whiteColor];
        [rodview addSubview:backImage];
        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(rodview);
         }];
        backImage.image = [UIImage imageNamed:@"rodHongBao"];

        UILabel *label = [[UILabel alloc] init];
        [rodview addSubview:label];
        self.rodLabel = label;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rodview.mas_centerX);
            make.centerY.equalTo(rodview.mas_centerY);
        }];
        
        label.font = [UIFont systemFontOfSize:23];
        label.text = @"20.00";
        label.textColor = [UIColor colorWithRed:255/255.0 green:198/255.0 blue:1/255.0 alpha:1.0];
        
        
        
        UIButton *FXbutton = [[UIButton alloc] init];
        self.FxBt = FXbutton;
        [rodview addSubview:FXbutton];
        [FXbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rodview.mas_centerX);
            make.top.equalTo(label.mas_bottom).offset(78);
        }];
        [FXbutton setImage:[UIImage imageNamed:@"立即分享"] forState:UIControlStateNormal];
        [FXbutton addTarget:self action:@selector(shareTouch) forControlEvents:UIControlEventTouchUpInside];

        rodview.hidden = YES;
        [self startTime];
    }
    return self;
}

-(void)touchUpInside{
    UIView *coinView = (UIView *)[self viewWithTag:[[_coinTagsArr firstObject] intValue]];
     [coinView removeFromSuperview];
    [_coinTagsArr removeObjectAtIndex:0];
    [[UIWindow visibleViewController].navigationController popViewControllerAnimated:YES];
}

-(void)shareTouch{
    NSLog(@"点击分享");
//        [self WeiXinOrQQAlertView];
    NSString *str = kUserDefaultsValue(COOKIES);
    NSString *s = [LPTools URLDecodedString:str];
    
    NSDictionary *dic = [LPTools dictionaryWithJsonString:[s substringFromIndex:5]];
    
    NSString *st = dic[@"userName"];
    
    NSString *url = [NSString stringWithFormat:@"%@bluehired/redpacket.html?nickname=%@&money=%.2f",BaseRequestWeiXiURL,st,self.redMoney];
    
    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [LPTools ClickShare:encodedUrl Title:@"蓝聘又开始下红包雨了，快来抢啊！"];
}

- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}


-(void)timeFireMethod{
    _seconds--;
    self.DJSlabel.text = [NSString stringWithFormat:@"倒计时:%ld",(long)_seconds];
    if(_seconds ==0){
        [self.countDownTimer invalidate];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             if (self.RodCount<5) {
                self.FxBt.hidden = YES;
                 self.rodLabel.hidden = YES;
                 self.redBack.image = [UIImage imageNamed:@"DidnGetThe"];
                 self.rodLabel.superview.hidden = NO;
                 
            }else{
                
                
                if (AlreadyLogin) {
                    [self requestQueryGetRedPacket];
                }else{
                    [[UIWindow visibleViewController].view showLoadingMeg:@"拆红包，请先进行登录！" time:2];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        LPLoginVC *vc = [[LPLoginVC alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.isRedpackVC = YES;
                        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                     });
                    
                } 
                


            }
        });
      }
}


- (void)startTime
{
    __block int timeout = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    WS(weakSelf);
    dispatch_source_set_event_handler(_timer, ^{
        if ( timeout <= 0 )
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.viewDJS setHidden:YES];
                [weakSelf.viewRedyu setHidden:NO];
                [weakSelf getAction];
            });
        }
        else
        {
            NSString * titleStr = [NSString stringWithFormat:@"%d",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.labDJS setText:titleStr];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)startdate
{
    
}

-(void)showView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

//统计数量的变量
static int coinCount = 0;
- (void)getAction
{
    for (int i = 0; i<75; i++) {
        [self performSelector:@selector(initRedViewWithInt:) withObject:[NSNumber numberWithInt:i] afterDelay:i * 0.2];
    }
 
}


//红包
- (void)initRedViewWithInt:(NSNumber *)i
{
    UIImage *image=[UIImage imageNamed:@"HongBaoImage"];
    CALayer *coin=[CALayer layer];
    int index= [i intValue] + 1000;
    coin.frame=CGRectMake(0, 0, 100, 100);
    coin.contents=(id)image.CGImage;
    [coin setValue:[NSString stringWithFormat:@"%d",index] forKey:@"name"];
     [_coinTagsArr addObject:[NSNumber numberWithInt:index]];
    [_viewRedpacketDown.layer addSublayer:coin];
    
    [self setAnimationWithLayer:coin type:1];
}

-(void)onQRedpacket:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self];
    for (int i = 0 ; i < _viewRedpacketDown.layer.sublayers.count ; i ++)
    {
        CALayer * layer = _viewRedpacketDown.layer.sublayers[i];
        if ([[layer presentationLayer] hitTest:point] != nil)
        {
             //点击到了
            NSInteger index=[[layer valueForKey:@"name"] integerValue];
            if (index<10000) {
                self.RodCount++;
                NSLog(@"点击了红包 %ld",(long)self.RodCount);

                UIImage *image=[UIImage imageNamed:@"guanxgiao"];
                 layer.contents=(id)image.CGImage;
                
//                [self bagShakeAnimation];
//                self.labDanciAdd.text=[NSString stringWithFormat:@"+%ld",index];
//                [self.btnTotal setTitle:[NSString stringWithFormat:@"¥ %ld",index] forState:0];
            }
        }
    }
}

- (void)setAnimationWithLayer:(CALayer *)coin type:(int)type
{
    CGFloat duration =  arc4random() % 2  +1.6;
    
    CGMutablePathRef path = CGPathCreateMutable();
    NSInteger w = SCREEN_WIDTH;
    int fromX       = (arc4random() % w);     //起始位置:x轴上随机生成一个位置
    int fromY       = -30;//arc4random() % 400; //起始位置:生成位于福袋上方的随机一个y坐标
    if (type==1) {
        fromX=MAX(0, fromX);
        fromX=MIN(fromX, SCREEN_WIDTH-50);
    }
    CGFloat positionX   = fromX;    //终点x
    CGFloat positionY   = SCREEN_HEIGHT+50;    //终点y
    
    //动画的起始位置
    CGPathMoveToPoint(path, NULL, fromX, fromY);
    CGPathAddLineToPoint(path, nil, positionX, positionY);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
     [animation setPath:path];
    CFRelease(path);
    path = nil;
    
    NSInteger rean = (arc4random() % 100) ;
 
    CAKeyframeAnimation * tranAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D r0 = CATransform3DMakeRotation(M_PI/180 * (rean-50) , 0, 0, -1);
    CATransform3D r1 = CATransform3DMakeRotation(M_PI/180 * (arc4random() % 360 ) , 0, 0, -1);
    tranAnimation.values = @[[NSValue valueWithCATransform3D:r0],[NSValue valueWithCATransform3D:r0]];
    tranAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    tranAnimation.duration = arc4random() % 200 / 100.0 + 3.5;
    //为了避免旋转动画完成后再次回到初始状态。
    [tranAnimation setFillMode:kCAFillModeForwards];
    [tranAnimation setRemovedOnCompletion:NO];
    
 
    //动画组合
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = duration;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.repeatDuration=15;//动画持续时间
    group.repeatCount = 1;
    group.animations = @[animation,tranAnimation];
    
    [coin addAnimation:group forKey:@"position and transform"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    if (flag) {
//
//        //动画完成后把金币和数组对应位置上的tag移除
//        UIView *coinView = (UIView *)[self viewWithTag:[[_coinTagsArr firstObject] intValue]];
//
//        [coinView removeFromSuperview];
//        [_coinTagsArr removeObjectAtIndex:0];
//
//        //全部金币完成动画后执行的动作
//        if (++coinCount == kCoinCountKey) {
//
//            [self bagShakeAnimation];
//
//        }
//    }
}

//宝箱晃动动画
- (void)bagShakeAnimation
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:- 0.2];
    shake.toValue   = [NSNumber numberWithFloat:+ 0.2];
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = 4;
    
    [_imgBox.layer addAnimation:shake forKey:@"bagShakeAnimation"];
}


-(void)requestQueryGetRedPacket{
 
    [NetApiManager requestQueryGetRedPacket:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
         if (isSuccess) {
             if ([responseObject[@"code"] integerValue] == 0) {
                 self.redMoney = [responseObject[@"data"] floatValue];
                 self.rodLabel.text = responseObject[@"data"];
                 self.FxBt.hidden = NO;
                 self.rodLabel.hidden = NO;
                 self.redBack.image = [UIImage imageNamed:@"rodHongBao"];
                 self.rodLabel.superview.hidden = NO;
             }else{
                 [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
             }

         }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
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
     NSString *str = kUserDefaultsValue(COOKIES);
    NSString *s = [LPTools URLDecodedString:str];
    
    NSDictionary *dic = [LPTools dictionaryWithJsonString:[s substringFromIndex:5]];
    
    NSString *st = dic[@"userName"];
    
    NSString *url = [NSString stringWithFormat:@"%@bluehired/redpacket.html?nickname=%@&money=%.2f",BaseRequestWeiXiURL,st,self.redMoney];
    
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
        message.description= @"蓝聘又开始下红包雨了，快来抢啊！";
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
