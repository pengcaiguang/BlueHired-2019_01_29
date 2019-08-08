//
//  LPTools.m
//  BlueHired
//
//  Created by iMac on 2018/10/10.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPTools.h"
#import "WHActivityView.h"
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>

@interface LPTools ()

@property (nonatomic, strong) NSDateFormatter * strDateFormatter;

@end

@implementation LPTools

LPTools * LPTools_instance = nil ;
+ (LPTools *)shareInstance{
    if (LPTools_instance == nil) {
        LPTools_instance = [[LPTools alloc] init];
    }
    return (LPTools *)LPTools_instance;
}

+ (NSString *)isNullToString:(id)string
{
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]){
        return @"";
    }else{
        return (NSString *)string;
    }
}

+(void)AlertMessageView:(NSString *)str{
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
        
     }];
    [alert show];
}


+(void)AlertMessageView:(NSString *)str dismiss:(CGFloat) Float{
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
        
    }];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Float * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismiss];
    });
}

+(void)AlertMessage2View:(NSString *)str dismiss:(CGFloat) Float{
    NSMutableAttributedString *Mutablestr = [[NSMutableAttributedString alloc]initWithString:str];

    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:Mutablestr message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
        
    }];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Float * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismiss];
    });
}


+(void)AlertMessageCommentLoginView{
//    NSMutableAttributedString *Mutablestr = [[NSMutableAttributedString alloc]initWithString:@"登录后才能进行评论回复，是否进行登录？"];
//
//    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:Mutablestr message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
//        if (buttonIndex) {
            [LoginUtils validationLogin:[UIWindow visibleViewController]];
//        }
//    }];
//    [alert show];
//
}



+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int minute = (int)value /60%60;
    //    int house = (int)value / (24 * 3600)%3600;
    //    int sum = house * 60 + minute + 1;
    NSString *str = [NSString stringWithFormat:@"%d",minute];
    return str;
}

+ (NSString *)URLDecodedString:(NSString *)str
{
    NSString *result = [str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [result stringByRemovingPercentEncoding];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
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

//收藏
+(void)AlertCollectView:(NSString *)str{
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(205) , LENGTH_SIZE(182))];
    view.image = [UIImage imageNamed:@"AlertCollectImage"];
    alert.containerView = view;
    alert.buttonTitles=@[];
    [alert setUseMotionEffects:true];
    [alert setCloseOnTouchUpOutside:true];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert close];
    });
    
}

//签到
+(void)AlertSignInView:(NSString *)str{
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(205) , LENGTH_SIZE(182))];
    view.image = [UIImage imageNamed:@"AlertSignImage"];
    
    UIImageView *IconImage = [[UIImageView alloc] initWithFrame:CGRectMake(LENGTH_SIZE(79), LENGTH_SIZE(127), LENGTH_SIZE(17), LENGTH_SIZE(17))];
    IconImage.image = [UIImage imageNamed:@"AlertSignIcon"];
    [view addSubview:IconImage];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LENGTH_SIZE(99), LENGTH_SIZE(131), LENGTH_SIZE(80), LENGTH_SIZE(10))];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    label.text = [NSString stringWithFormat:@"+%@",str];
    label.textColor = [UIColor colorWithHexString:@"#FFFFB300"];
    [view addSubview:label];
    
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, LENGTH_SIZE(151), LENGTH_SIZE(205), LENGTH_SIZE(15))];
    TitleLabel.font = [UIFont systemFontOfSize:16];
    TitleLabel.textAlignment = NSTextAlignmentCenter;
    TitleLabel.textColor = [UIColor colorWithHexString:@"#FF434343"];
    TitleLabel.text = [NSString stringWithFormat:@"签到成功！"];
    [view addSubview:TitleLabel];
    
    
    alert.containerView = view;
    alert.buttonTitles=@[];
    [alert setUseMotionEffects:true];
    [alert setCloseOnTouchUpOutside:true];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert close];
    });
}

//首评成功
+(void)AlertTopCommentView:(NSString *)str{
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(205) , LENGTH_SIZE(182))];
    view.image = [UIImage imageNamed:@"TopAlertCommentImage"];
    alert.containerView = view;
    alert.buttonTitles=@[];
    [alert setUseMotionEffects:true];
    [alert setCloseOnTouchUpOutside:true];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert close];
    });
}

//评价成功
+(void)AlertCommentView:(NSString *)str{
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(205) , LENGTH_SIZE(182))];
    view.image = [UIImage imageNamed:@"AlertCommentImage"];
    alert.containerView = view;
    alert.buttonTitles=@[];
    [alert setUseMotionEffects:true];
    [alert setCloseOnTouchUpOutside:true];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert close];
    });
}

//工时记录
+(void)AlertWorkHourView:(NSString *)str{
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(205) , LENGTH_SIZE(182))];
    view.image = [UIImage imageNamed:@"AlertWorkHourImage"];
    alert.containerView = view;
    alert.buttonTitles=@[];
    [alert setUseMotionEffects:true];
    [alert setCloseOnTouchUpOutside:true];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert close];
    });
}

//发圈子
+(void)AlertCircleView:(NSString *)str{
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(205) , LENGTH_SIZE(182))];
    view.image = [UIImage imageNamed:@"AlertCircleImage"];
    alert.containerView = view;
    alert.buttonTitles=@[];
    [alert setUseMotionEffects:true];
    [alert setCloseOnTouchUpOutside:true];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert close];
    });
}

//领取个人资料奖励金
+(void)AlertUserInfoView:(NSString *)str{
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(205) , LENGTH_SIZE(182))];
    view.image = [UIImage imageNamed:@"bounced"];
    alert.containerView = view;
    alert.buttonTitles=@[];
    [alert setUseMotionEffects:true];
    [alert setCloseOnTouchUpOutside:true];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert close];
    });
}

//积分兑换成功
+(void)AlertIntegralView:(NSString *)str{
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      LENGTH_SIZE(205) ,
                                                                      LENGTH_SIZE(182))];
    view.image = [UIImage imageNamed:@"integral_bg"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LENGTH_SIZE(0),
                                                               LENGTH_SIZE(131),
                                                               LENGTH_SIZE(205),
                                                               LENGTH_SIZE(20))];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:FontSize(15)];
    label.text = [NSString stringWithFormat:@"%@",str];
    label.textColor = [UIColor colorWithHexString:@"#FFA21A"];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:label.text];
    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#434343"]} range:NSMakeRange(label.text.length-5, 5)];
    
    label.attributedText = string;
    
    [view addSubview:label];
    
    
    
    alert.containerView = view;
    alert.buttonTitles=@[];
    [alert setUseMotionEffects:true];
    [alert setCloseOnTouchUpOutside:true];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert close];
    });
}


//企业点评
+(void)AlertBusinessView:(NSString *)str{
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(205) , LENGTH_SIZE(182))];
    view.image = [UIImage imageNamed:@"AlertBusinessImage"];
    alert.containerView = view;
    alert.buttonTitles=@[];
    [alert setUseMotionEffects:true];
    [alert setCloseOnTouchUpOutside:true];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert close];
    });
}

//清空本地数据
+(void)UserDefaulatsRemove{
    kUserDefaultsRemove(COOKIES);
    kUserDefaultsRemove(USERDATA);
    kUserDefaultsSave(@"0", kLoginStatus);
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for(id obj in cookieArray)
    {
        [cookieJar deleteCookie:obj];
    }
}

//分享按钮：
+(void)ClickShare:(NSString *)Url  Title:(NSString *)Title
{
    [[LPTools shareInstance] btnClickShare:Url Title:Title];
}

-(void)btnClickShare:(NSString *)StrUrl Title:(NSString *)Title{
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
            [weakSelf share:1 Url:StrUrl    Title:Title];//QQ好友
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"QQ空间"  image:[UIImage imageNamed:@"QQSpace"] handler:^(ButtonView *buttonView){
            [weakSelf share:2 Url:StrUrl Title:Title];//QQ空间
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"微信"  image:[UIImage imageNamed:@"weixinLogo"] handler:^(ButtonView *buttonView){
            [weakSelf share:3 Url:StrUrl Title:Title];//微信
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"朋友圈"  image:[UIImage imageNamed:@"WXSpace"] handler:^(ButtonView *buttonView){
            [weakSelf share:4 Url:StrUrl Title:Title];//微信朋友圈
        }];
        [activityView addButtonView:bv];
    
        [activityView show];
    }
}

-(void)share:(int)type Url:(NSString *)Str  Title:(NSString *)Title{
    //分享代码；
    if (type == 1) {        //qq
        if (![QQApiInterface isSupportShareToQQ])
        {
            [LPTools AlertMessageView:@"请安装QQ" dismiss:1.0];
             return;
        }
        NSString *title = @"蓝聘";
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:[NSURL URLWithString:Str]
                                    title:title
                                    description:Title
                                    previewImageData:UIImagePNGRepresentation([UIImage imageNamed:@"logo_Information"])];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        
    }else if (type == 2){      //QQ空间
        if (![QQApiInterface isSupportShareToQQ])
        {
            [LPTools AlertMessageView:@"请安装QQ" dismiss:1.0];
            return;
        }
        NSString *title = @"蓝聘";
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:[NSURL URLWithString:Str]
                                    title:Title
                                    description:Title
                                    previewImageData:UIImagePNGRepresentation([UIImage imageNamed:@"logo_Information"])];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        
    }else if (type == 3){       //  wx
        if ([WXApi isWXAppInstalled]==NO) {
            [LPTools AlertMessageView:@"请安装微信" dismiss:1.0];
            return;
        }
             SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
             req.scene = WXSceneSession;
             WXMediaMessage *message = [WXMediaMessage message];
             message.title = @"蓝聘";
             message.description= Title;
             message.thumbData = UIImagePNGRepresentation([UIImage imageNamed:@"logo_Information"]);
             
             WXWebpageObject *ext = [WXWebpageObject object];
             
             ext.webpageUrl = Str;
             message.mediaObject = ext;
             req.message = message;
             [WXApi sendReq:req];
    }else if (type == 4){       //朋友圈
        if ([WXApi isWXAppInstalled]==NO) {
            [LPTools AlertMessageView:@"请安装微信" dismiss:1.0];
            return;
        }
             SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
             req.scene = WXSceneTimeline;
             WXMediaMessage *message = [WXMediaMessage message];
             message.title = Title;
             message.description= @"";
             message.thumbData = UIImagePNGRepresentation([UIImage imageNamed:@"logo_Information"]);
             
             WXWebpageObject *ext = [WXWebpageObject object];
             
             ext.webpageUrl = Str;
             message.mediaObject = ext;
             req.message = message;
             [WXApi sendReq:req];
    }
}


+ (NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    //创建两个日期
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *startDate = [dateFormatter dateFromString:@"2017-07-26"];
//    NSDate *endDate = [dateFormatter dateFromString:@"2017-09-01"];
    
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:oneDay toDate:anotherDay options:0];
    //打印
   
 
    return delta.day;
    
}


//获取广告弹框
+(void)AlertactivityView:(NSString *)str{

}

//去掉字符串两端的空格及回车
+ (NSString *)removeSpaceAndNewline:(NSString *)str{
    
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    NSString *text = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    return text;
}

#pragma mark - 计算农历日期
+ (NSString *)calculationChinaCalendarWithDate:(NSDate *)date 
{
//    if (isEmpty(date)) {
//        return nil;
//    }
 
    NSArray * chineseMonths = @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                                @"九月", @"十月", @"冬月", @"腊月"];
    NSArray * chineseDays = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"廿十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
    
    NSCalendar * localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents * localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString * m_str = [chineseMonths objectAtIndex:localeComp.month - 1];
 
    NSString * d_str = [chineseDays objectAtIndex:localeComp.day - 1];
    
    NSString * chineseCal_str = d_str;
    chineseCal_str = @"";
    
    //计算周六周日
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;

    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];

    if (theComponents.weekday == 1 || theComponents.weekday == 7) {
        chineseCal_str = @"";
    }
    
    // 农历节日
    
        if([m_str isEqualToString:@"正月"] && ([d_str isEqualToString:@"初一"])) {
            chineseCal_str = @"春节";//春节
        } else if ([m_str isEqualToString:@"五月"] && [d_str isEqualToString:@"初五"]) {
            chineseCal_str = @"端午";//端午节
        } else if ([m_str isEqualToString:@"三月"] && [d_str isEqualToString:@"初一"]) {
            chineseCal_str = @"清明";//清明
        }  else if ([m_str isEqualToString:@"八月"] && [d_str isEqualToString:@"十五"]) {
            chineseCal_str = @"中秋";//中秋节
        }

    
    // 公历节日
    NSDictionary * Holidays = @{@"01-01":@"元旦",
                                @"05-01":@"劳动",
                                @"10-01":@"国庆",
                                };
    NSDateFormatter *strDateFormatter = [[NSDateFormatter alloc] init];
    [strDateFormatter setDateFormat:@"MM-dd"];
    
    NSString * nowStr = [strDateFormatter stringFromDate:date];

    NSArray * array = [Holidays allKeys];
    if([array containsObject:nowStr]) {
        chineseCal_str = [Holidays objectForKey:nowStr];
    }
 
 
 
    return chineseCal_str;
}

//获取本地/网络视频的第一帧图片
+ (UIImage *)getImage:(NSString *)videoURL{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize Width:(CGFloat) W
{
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paraStyle01};
    /*计算高度要先指定宽度*/
    CGRect rect = [string boundingRectWithSize:CGSizeMake(W, 0) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return ceil(rect.size.height);

}

//获取字符串的宽度
+(CGFloat) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}

//清楚webView缓存
+ (void)deleteWebCache {
    //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}

//view单边圆角设置
+(void)setViewShapeLayer:(UIView *) View CornerRadii:(CGFloat) Radius byRoundingCorners:(UIRectCorner)corners{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(LENGTH_SIZE(View.bounds.origin.x),
                                                                                LENGTH_SIZE(View.bounds.origin.y),
                                                                                LENGTH_SIZE(View.bounds.size.width),
                                                                                LENGTH_SIZE(View.bounds.size.height))
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(LENGTH_SIZE(Radius), 0.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(LENGTH_SIZE(View.bounds.origin.x),
                                 LENGTH_SIZE(View.bounds.origin.y),
                                 LENGTH_SIZE(View.bounds.size.width),
                                 LENGTH_SIZE(View.bounds.size.height)) ;
    maskLayer.path = maskPath.CGPath;
    View.layer.mask = maskLayer;
}



@end
