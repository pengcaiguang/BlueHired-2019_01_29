//
//  NetApiManager.h
//  RedPacket
//
//  Created by 邢晓亮 on 2018/6/8.
//  Copyright © 2018年 邢晓亮. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^response)(BOOL isSuccess,id responseObject);


@interface NetApiManager : NSObject
#pragma mark - 获取网络状态
//获取网络状态
+ (BOOL) getNetStaus;

/***********************************************************
 *
 * 请求示例
 *
 //请求首页数据 GET
 + (void)requestHomePageDataWithParam:(NSDictionary *)dict
 withHandle:(response)responseHandle;
 
 //首页-获取健身房相关课程 POST
 + (void)requestGetgymsclWithParam:(NSDictionary *)paramer
 withHandle:(response)responseHandle;
 
 //修改头像  RequestTypeUploadSingleImage 单张图片上传
 + (void)avartarChangeWithParam:(NSDictionary *)paramer
 singleImage:(UIImage *)image
 singleImageName:(NSString *)imageName
 withHandle:(response)responseHandle;
 
 //发布帖子 RequestTypeUploadImagesArray 多张图片上传
 + (void)requestPublishArticle:(NSDictionary*)parameters
 imageArray:(NSArray*)imageArray
 imageNameArray:(NSArray*)imageNameArray
 response:(response)response;
 ***********************************************************/


#pragma mark - 首页
/************************************************************/
//*  首页
/************************************************************/
//首页列表
+ (void)requestWorklistWithParam:(id)paramer
                      withHandle:(response)responseHandle;
//查询所有行业/工种
+ (void)requestMechanismlistWithParam:(id)paramer
                           withHandle:(response)responseHandle;
//招聘详情
+ (void)requestWorkDetailWithParam:(id)paramer
                        withHandle:(response)responseHandle;
//收藏接口
+ (void)requestSetCollectionWithParam:(id)paramer
                           withHandle:(response)responseHandle;
//查询是否报名/收藏公司/实名认证
+ (void)requestIsApplyOrIsCollectionWithParam:(id)paramer
                                   withHandle:(response)responseHandle;
//入职报名
+ (void)requestEntryApplyWithUrl:(NSString *)urlString
                       withParam:(id)paramer
                      withHandle:(response)responseHandle;
//取消报名
+ (void)requestCancleApplyWithUrl:(NSString *)urlString
                        withParam:(id)paramer
                       withHandle:(response)responseHandle;
//查询面试预约列表
+ (void)requestWorkorderlistWithParam:(id)paramer
                           withHandle:(response)responseHandle;
#pragma mark - 资讯
/************************************************************/
//*  资讯
/************************************************************/
//资讯分类
+ (void)requestLabellistWithParam:(id)paramer
                       withHandle:(response)responseHandle;
//资讯列表
+ (void)requestEssaylistWithParam:(id)paramer
                       withHandle:(response)responseHandle;
//资讯详情
+ (void)requestEssayWithParam:(id)paramer
                   withHandle:(response)responseHandle;
//增加新闻浏览量
+ (void)requestSetEssayViewWithParam:(id)paramer
                          withHandle:(response)responseHandle;
//获取评论列表
+ (void)requestCommentListWithParam:(id)paramer
                         withHandle:(response)responseHandle;
//点赞（取消）
+ (void)requestSocialSetlikeWithParam:(id)paramer
                           withHandle:(response)responseHandle;
//添加评论
+ (void)requestCommentAddcommentWithParam:(id)paramer
                               withHandle:(response)responseHandle;
#pragma mark - 圈子
/************************************************************/
//*  圈子
/************************************************************/
//查看圈子种类
+ (void)requestMoodTypeWithParam:(id)paramer
                      withHandle:(response)responseHandle;
//查看圈子列表
+ (void)requestMoodListWithParam:(id)paramer
                      withHandle:(response)responseHandle;

#pragma mark - 登陆注册
/************************************************************/
//*  登陆注册
/************************************************************/
//登陆
+ (void)requestLoginWithParam:(id)paramer
                   withHandle:(response)responseHandle;
//退出登陆
+ (void)requestSignoutWithParam:(id)paramer
                     withHandle:(response)responseHandle;
#pragma mark - 我的
/************************************************************/
//*  我的
/************************************************************/
//查询用户个人资料
+ (void)requestUserMaterialWithParam:(id)paramer
                          withHandle:(response)responseHandle;
//查询当天是否签到
+ (void)requestSelectCurIsSignWithParam:(id)paramer
                             withHandle:(response)responseHandle;

#pragma mark - 企业点评
/************************************************************/
//*  企业点评
/************************************************************/
//查询所有企业
+ (void)requestMechanismcommentMechanismlistWithParam:(id)paramer
                                           withHandle:(response)responseHandle;
//企业点评详情
+ (void)requestMechanismcommentDeatilWithParam:(id)paramer
                                    withHandle:(response)responseHandle;
#pragma mark - 工时记录
/************************************************************/
//*  工时记录
/************************************************************/
//记录/修改工时
+ (void)requestSaveorupdateWorkhourWithParam:(id)paramer
                                  withHandle:(response)responseHandle;
//查询工时记录详情
+ (void)requestSelectWorkhourWithParam:(id)paramer
                            withHandle:(response)responseHandle;
//查询当天工时记录
+ (void)requestQueryCurrecordWithParam:(id)paramer
                            withHandle:(response)responseHandle;
//查询已记录工时
+ (void)requestQueryNormalrecordWithParam:(id)paramer
                               withHandle:(response)responseHandle;
//删除加班记录
+ (void)requestDeleteAddtimeWithParam:(id)paramer
                           withHandle:(response)responseHandle;
//记录补贴扣款
+ (void)requestAddWorkrecordWithParam:(id)paramer
                           withHandle:(response)responseHandle;
@end




