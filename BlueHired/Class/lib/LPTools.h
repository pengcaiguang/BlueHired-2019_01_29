//
//  LPTools.h
//  BlueHired
//
//  Created by iMac on 2018/10/10.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHActivityView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPTools : NSObject
{
     WHActivityView  *activityView;//分享界面
}

@property(nonatomic,assign) NSInteger UserRole;

+ (LPTools *)shareInstance;

+ (NSString *)isNullToString:(id)string;

+(void)AlertMessageView:(NSString *)str;

+(void)AlertMessageView:(NSString *)str dismiss:(CGFloat) Float;

+(void)AlertMessage2View:(NSString *)str dismiss:(CGFloat) Float;

+(void)AlertMessageCommentLoginView;

+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

+ (NSString *)URLDecodedString:(NSString *)str;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//收藏
+(void)AlertCollectView:(NSString *)str;
//签到
+(void)AlertSignInView:(NSString *)str;
//首评成功
+(void)AlertTopCommentView:(NSString *)str;
//评价成功
+(void)AlertCommentView:(NSString *)str;
//工时记录
+(void)AlertWorkHourView:(NSString *)str;
//发圈子
+(void)AlertCircleView:(NSString *)str;
//领取个人资料奖励金
+(void)AlertUserInfoView:(NSString *)str;
//积分兑换成功
+(void)AlertIntegralView:(NSString *)str;
//企业点评
+(void)AlertBusinessView:(NSString *)str;
//清空本地数据
+(void)UserDefaulatsRemove;

//分享按钮：
+(void)ClickShare:(NSString *)Url  Title:(NSString *)Title;

//时间比对
+ (NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

+(void)AlertactivityView:(NSString *)str;
//去掉字符串两端的空格及回车
+ (NSString *)removeSpaceAndNewline:(NSString *)str;

#pragma mark - 计算农历日期
+ (NSString *)calculationChinaCalendarWithDate:(NSDate *)date ;

//获取本地/网络视频的第一帧图片
+ (UIImage *)getImage:(NSString *)videoURL;

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize Width:(CGFloat) W;
//获取字符串的宽度
+(CGFloat) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height;
//清楚webView缓存
+ (void)deleteWebCache;
//view单边圆角设置
+(void)setViewShapeLayer:(UIView *) View CornerRadii:(CGFloat) Radius byRoundingCorners:(UIRectCorner)corners;
@end

NS_ASSUME_NONNULL_END
