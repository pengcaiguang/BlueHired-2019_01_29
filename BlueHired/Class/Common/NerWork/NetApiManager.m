//
//  NetApiManager.m
//  RedPacket
//
//  Created by 邢晓亮 on 2018/6/8.
//  Copyright © 2018年 邢晓亮. All rights reserved.
//

#import "NetApiManager.h"
#import "AppDelegate.h"
#import "NetRequestManager.h"
#import "NetInstance.h"

@implementation NetApiManager
#pragma mark - 获取网络状态
//获取网络状态
+ (BOOL) getNetStaus
{
    if([kAppDelegate.moninNet getNetState] == AFNetworkReachabilityStatusNotReachable)
    {
        return FALSE;
    }
    return TRUE;
}
#pragma mark - 公用请求DLCRequestEnty
//公用请求DLCRequestEnty
+(NetRequestEnty *)createEntyWithAppendURLString:(NSString *)appendURLString
                                 withRequestEnty:(RequestType)requestType
                                       withParam:(id)paramer
                                      withHandle:(response)responseHandle
{
    NetRequestEnty * enty = [[NetInstance shareInstance] commonRequestEnty:requestType withAppendUrlString:appendURLString];  //通用请求配置
    NSMutableDictionary *params = [[[NetInstance shareInstance] basicParameter] mutableCopy];                          //公共请求参数
    if(!ISNIL(paramer)){
        [params addEntriesFromDictionary:paramer];
    }
    enty.params = params;
    enty.responseHandle = responseHandle;
    
    
//    NSMutableDictionary *paramsDict = [[[DLCNetInstance shareInstance] basicParameter] mutableCopy];                          //公共请求参数
//    if(!kDictIsEmpty(paramer)){
//        [paramsDict addEntriesFromDictionary:paramer];
//    }
//    enty.params = paramsDict;
//    enty.responseHandle = responseHandle;
//
//    return enty;
    
    
    return enty;
}


/***********************************************************
 
 *
 * 请求示例
 *
 
 //请求首页数据 GET
 + (void)requestHomePageDataWithParamDict:(id)paramer
 withHandle:(response)responseHandle
 {
 NSString * appendURLString = @"/App/Gym/index";
 DLCRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
 withRequestEnty:RequestTypeGet
 withParamDict:paramer
 withHandle:responseHandle];
 [DLCRequestManager requestWithEnty:enty];
 }
 
 //首页-获取健身房相关课程 POST
 + (void)requestGetgymsclWithParamDict:(id)paramer
 withHandle:(response)responseHandle
 {
 NSString * appendURLString = @"/App/order";
 DLCRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
 withRequestEnty:RequestTypePost
 withParamDict:paramer
 withHandle:responseHandle];
 [DLCRequestManager requestWithEnty:enty];
 }
 
 //修改头像  RequestTypeUploadSingleImage 单张图片上传
 + (void)avartarChangeWithParamDict:(id)paramer
 singleImage:(UIImage *)image
 singleImageName:(NSString *)imageName
 withHandle:(response)responseHandle
 {
 NSString * appendURLString = @"/App/User/";
 DLCRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
 withRequestEnty:RequestTypeUploadSingleImage
 withParamDict:paramer
 withHandle:responseHandle];
 enty.singleImage = image;
 enty.singleImageName = imageName;
 [DLCRequestManager requestWithEnty:enty];
 }
 
 //发布帖子 RequestTypeUploadImagesArray 多张图片上传
 + (void)requestPublishArticle:(id)parameters
 imageArray:(NSArray*)imageArray
 imageNameArray:(NSArray*)imageNameArray
 response:(response)response
 {
 NSString * appendURLString = @"/App/Gym/api";
 DLCRequestEnty *enty = [self createEntyWithAppendURLString:appendURLString
 withRequestEnty:RequestTypeUploadImagesArray
 withParamDict:parameters
 withHandle:response];
 enty.imagesArray = imageArray;
 enty.imageNamesArray = imageNameArray;
 [DLCRequestManager requestWithEnty:enty];
 }
 
 ***********************************************************/

#pragma mark - 首页
/************************************************************/
//*  首页
/************************************************************/
//首页列表
+ (void)requestWorklistWithParam:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/query_worklist";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}

//招聘详情
+ (void)requestWorkDetailWithParam:(id)paramer
                        withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/query_workdetail";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}

#pragma mark - 资讯
/************************************************************/
//*  资讯
/************************************************************/
//资讯分类
+ (void)requestLabellistWithParam:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"platform/get_label_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//资讯列表
+ (void)requestEssaylistWithParam:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"essay/get_essay_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//资讯详情
+ (void)requestEssayWithParam:(id)paramer
                   withHandle:(response)responseHandle{
    NSString * appendURLString = @"essay/get_essay";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//增加新闻浏览量
+ (void)requestSetEssayViewWithParam:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"essay/set_essay_view";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//获取评论列表
+ (void)requestCommentListWithParam:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"comment/get_comment_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}

#pragma mark - 圈子
/************************************************************/
//*  圈子
/************************************************************/
//查看圈子种类
+ (void)requestMoodTypeWithParam:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"mood/get_mood_type";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//查看圈子列表
+ (void)requestMoodListWithParam:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"mood/get_mood_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}



@end
