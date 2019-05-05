//
//  LPInviteVC.m
//  BlueHired
//
//  Created by peng on 2018/9/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPInviteVC.h"
#import "CustomIOSAlertView.h"
#import "WHActivityView.h"

@interface LPInviteVC ()
{
    WHActivityView  *activityView;//分享界面
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property(nonatomic,strong)CustomIOSAlertView *CustomAlert;

@end

@implementation LPInviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"邀请二维码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"WechatIMG2"] style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
   //    Constant.BASEURL + "bluehired/login.html?identity=" + (id == -1 ? userCookieEntity.getIdentity() : id)
    
    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];

    if (user.data.user_url.length) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:user.data.user_url]];
    }else{
        self.headImageView.image = [UIImage imageNamed:@"logo_Information"];
     }
    
    
    
    NSString *str = kUserDefaultsValue(COOKIES);
    NSString *s = [self URLDecodedString:str];
    
    NSDictionary *dic = [self dictionaryWithJsonString:[s substringFromIndex:5]];
    
    NSString *st = dic[@"identity"];
    
//    NSString *strutl = [NSString stringWithFormat:@"%@bluehired/login.html?identity=%@",BaseRequestURL,st];
    NSString *strutl = [NSString stringWithFormat:@"%@bluehired/login.html?identity=%@",BaseRequestWeiXiURL,st];
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSString *urlStr = strutl;
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:240];//重绘二维码,使其显示清晰
    self.imageView.layer.borderWidth = 4;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

-(void)touchManagerButton
{
//    [self WeiXinOrQQAlertView];
//    NSString *url = [NSString stringWithFormat:@"%@bluehired/login.html?identity=%@",BaseRequestWeiXiURL,st];
//    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [LPTools ClickShare:encodedUrl Title:_model.data.essayName];
    [self btnClickShare];
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
    NSString *s = [self URLDecodedString:str];
    
    NSDictionary *dic = [self dictionaryWithJsonString:[s substringFromIndex:5]];
    
    NSString *st = dic[@"identity"];
    
    //    NSString *strutl = [NSString stringWithFormat:@"%@bluehired/login.html?identity=%@",BaseRequestURL,st];
//    NSString *strutl = [NSString stringWithFormat:@"%@lanpin_h5/login.html?identity=%@",BaseRequestWeiXiURL,st];
    
    NSString *url = [NSString stringWithFormat:@"%@bluehired/login.html?identity=%@",BaseRequestWeiXiURL,st];
    
    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    UIImage *WxImage = [self addImage:self.imageView.image withImage:self.headImageView.image];

    

    
    
    
    if (sender.tag == 1)
    {
        if ([WXApi isWXAppInstalled]==NO) {
            [self.view showLoadingMeg:@"请安装微信" time:MESSAGE_SHOW_TIME];
            [_CustomAlert close];
            return;
        }
        
        
//        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//        req.scene = WXSceneSession;
//        WXMediaMessage *message = [WXMediaMessage message];
//        message.title = @"蓝聘";
////        message.description= _model.data.essayName;
//        WXAppExtendObject *ext = [WXAppExtendObject object];
//
//        ext.url = encodedUrl;
//        message.mediaObject = ext;
//        req.message = message;
//        [WXApi sendReq:req];
        
        
        // 用于微信终端和第三方程序之间传递消息的多媒体消息内容
        WXMediaMessage *message = [WXMediaMessage message];
        // 多媒体消息中包含的图片数据对象
        WXImageObject *imageObject = [WXImageObject object];
         // 图片真实数据内容
        imageObject.imageData =  UIImagePNGRepresentation(WxImage);
        // 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
        message.mediaObject = imageObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;// 分享到朋友圈
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
        
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(WxImage)
                                                    previewImageData:UIImagePNGRepresentation(WxImage)
                                                               title:title
                                                         description:nil];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        //将内容分享到qzone
        //        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        
    }
    [_CustomAlert close];
}


-(void)btnClickShare{
    //更多。用于分享及编辑
    for (UIView *sub in [activityView subviews]) {
        [sub removeFromSuperview];
    }
    [activityView removeFromSuperview];
    activityView=nil;
    if (!activityView)
    {
        activityView = [[WHActivityView alloc]initWithTitle:nil referView:[[UIWindow visibleViewController].view window] isNeed:YES];
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        activityView.numberOfButtonPerLine = 4;
        activityView.titleLabel.text = @"请选择分享平台";
        __weak __typeof(self) weakSelf = self;
        ButtonView *bv = [[ButtonView alloc]initWithText:@"QQ" image:[UIImage imageNamed:@"QQLogo"] handler:^(ButtonView *buttonView){
            [weakSelf share:1];//QQ好友
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"QQ空间"  image:[UIImage imageNamed:@"QQSpace"] handler:^(ButtonView *buttonView){
            [weakSelf share:2];//QQ空间
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"微信"  image:[UIImage imageNamed:@"weixinLogo"] handler:^(ButtonView *buttonView){
            [weakSelf share:3];//微信
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"朋友圈"  image:[UIImage imageNamed:@"WXSpace"] handler:^(ButtonView *buttonView){
            [weakSelf share:4];//微信朋友圈
        }];
        [activityView addButtonView:bv];
        
        [activityView show];
    }
}


-(void)share:(int)type{
    NSString *str = kUserDefaultsValue(COOKIES);
    NSString *s = [self URLDecodedString:str];
    
    NSDictionary *dic = [self dictionaryWithJsonString:[s substringFromIndex:5]];
    
    NSString *st = dic[@"identity"];
    NSString *url = [NSString stringWithFormat:@"%@bluehired/login.html?identity=%@",BaseRequestWeiXiURL,st];
    
    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    UIImage *WxImage = [self addImage:self.imageView.image withImage:self.headImageView.image];
    //分享代码；
    if (type == 1) {        //qq
        if (![QQApiInterface isSupportShareToQQ])
        {
            [LPTools AlertMessageView:@"请安装QQ" dismiss:1.0];
            return;
        }
        NSString *title = @"蓝聘";
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(WxImage)
                                                   previewImageData:UIImagePNGRepresentation(WxImage)
                                                              title:title
                                                        description:nil];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        
    }else if (type == 2){      //QQ空间
        if (![QQApiInterface isSupportShareToQQ])
        {
            [LPTools AlertMessageView:@"请安装QQ" dismiss:1.0];
            return;
        }
        NSString *title = @"蓝聘";
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(WxImage)
                                                   previewImageData:UIImagePNGRepresentation(WxImage)
                                                              title:title
                                                        description:nil];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        
    }else if (type == 3){       //  wx
        if ([WXApi isWXAppInstalled]==NO) {
            [LPTools AlertMessageView:@"请安装微信" dismiss:1.0];
            return;
        }
        // 用于微信终端和第三方程序之间传递消息的多媒体消息内容
        WXMediaMessage *message = [WXMediaMessage message];
        // 多媒体消息中包含的图片数据对象
        WXImageObject *imageObject = [WXImageObject object];
        // 图片真实数据内容
        imageObject.imageData =  UIImagePNGRepresentation(WxImage);
        // 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
        message.mediaObject = imageObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;// 分享到朋友圈
        [WXApi sendReq:req];
    }else if (type == 4){       //朋友圈
        if ([WXApi isWXAppInstalled]==NO) {
            [LPTools AlertMessageView:@"请安装微信" dismiss:1.0];
            return;
        }
 
        // 用于微信终端和第三方程序之间传递消息的多媒体消息内容
        WXMediaMessage *message = [WXMediaMessage message];
        // 多媒体消息中包含的图片数据对象
        WXImageObject *imageObject = [WXImageObject object];
        // 图片真实数据内容
        imageObject.imageData =  UIImagePNGRepresentation(WxImage);
        // 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
        message.mediaObject = imageObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;// 分享到朋友圈
        [WXApi sendReq:req];
    }
}


- (UIImage *)addImage:(UIImage *)imageName1 withImage:(UIImage *)imageName2 {
    
    UIImage *image1 = imageName1;
    UIImage *image2 = imageName2;
    
    UIGraphicsBeginImageContext(image1.size);
    
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    [image2 drawInRect:CGRectMake((image1.size.width - 50)/2,(image1.size.height - 50)/2, 50, 50)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}



- (NSString *)URLDecodedString:(NSString *)str
{
    NSString *result = [str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [result stringByRemovingPercentEncoding];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



@end
