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
//查询所有行业/工种
+ (void)requestMechanismlistWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/query_mechanismlist";
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

//收藏接口
+ (void)requestSetCollectionWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"social/set_collection";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}

//查询是否报名/收藏公司/实名认证
+ (void)requestIsApplyOrIsCollectionWithParam:(id)paramer
                                   withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/query_isApplyOrIsCollection";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//入职报名
+ (void)requestEntryApplyWithUrl:(NSString *)urlString
                       withParam:(id)paramer
                      withHandle:(response)responseHandle{
    NetRequestEnty * enty = [self createEntyWithAppendURLString:urlString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//取消报名
+ (void)requestCancleApplyWithUrl:(NSString *)urlString
                        withParam:(id)paramer
                       withHandle:(response)responseHandle{
    NetRequestEnty * enty = [self createEntyWithAppendURLString:urlString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//查询面试预约列表
+ (void)requestWorkorderlistWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/query_workorderlist";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//删除面试预约
+ (void)requestDelWorkorderWithParam:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/del_workorder";
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
//点赞（取消）
+ (void)requestSocialSetlikeWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"social/set_like";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//添加评论
+ (void)requestCommentAddcommentWithParam:(id)paramer
                               withHandle:(response)responseHandle{
    NSString * appendURLString = @"comment/add_comment";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
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
//获取圈子详情
+ (void)requestGetMoodWithParam:(id)paramer
                     withHandle:(response)responseHandle{
    NSString * appendURLString = @"mood/get_mood";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//增加圈子浏览量
+ (void)requestSetMoodViewWithParam:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"mood/set_mood_view";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//添加圈子
+ (void)requestAddMoodWithParam:(id)paramer
                     withHandle:(response)responseHandle{
    NSString * appendURLString = @"mood/add_mood";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
// 多张图片上传
+ (void)requestPublishArticle:(id)parameters
                   imageArray:(NSArray*)imageArray
               imageNameArray:(NSArray*)imageNameArray
                     response:(response)response{
    NSString * appendURLString = @"platform/upload_image_list";
    NetRequestEnty *enty = [self createEntyWithAppendURLString:appendURLString
                                               withRequestEnty:RequestTypeUploadImagesArray
                                                     withParam:parameters
                                                    withHandle:response];
    enty.imagesArray = imageArray;
    enty.imageNamesArray = imageNameArray;
    [NetRequestManager requestWithEnty:enty];
}
// 单张图片上传
+ (void)avartarChangeWithParamDict:(id)paramer
                       singleImage:(UIImage *)image
                   singleImageName:(NSString *)imageName
                        withHandle:(response)responseHandle{
    NSString * appendURLString = @"platform/upload_image";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeUploadSingleImage
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    enty.singleImage = image;
    enty.singleImageName = imageName;
    [NetRequestManager requestWithEnty:enty];
}
//人员关注
+ (void)requestSetUserConcernWithParam:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"userConcern/set_user_concern";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
#pragma mark - 登陆注册
/************************************************************/
//*  登陆注册
/************************************************************/
//登陆
+ (void)requestLoginWithParam:(id)paramer
                   withHandle:(response)responseHandle{
    NSString * appendURLString = @"login/login";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//退出登陆
+ (void)requestSignoutWithParam:(id)paramer
                     withHandle:(response)responseHandle{
    NSString * appendURLString = @"login/user_sign_out";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//注册接口
+ (void)requestAddUserWithParam:(id)paramer
                     withHandle:(response)responseHandle{
    NSString * appendURLString = @"login/add_user";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//找回密码
+ (void)requestSetPswWithParam:(id)paramer
                    withHandle:(response)responseHandle{
    NSString * appendURLString = @"login/set_psw";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//发送手机验证码
+ (void)requestSendCodeWithParam:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"login/send_code";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//验证验证码及手机
+ (void)requestMateCodeWithParam:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"login/mate_code";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//修改密码
+ (void)requestModifyPswWithParam:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"login/modify_psw";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//修改手机号
+ (void)requestUpdateUsertelWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"userMaterial/update_usertel";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
#pragma mark - 消息中心
/************************************************************/
//*  消息中心
/************************************************************/
//查询消息列表
+ (void)requestQueryInfolistWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"info/query_infolist";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//删除消息
+ (void)requestDelInfosWithParam:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"info/del_infos";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//消息详情
+ (void)requestQueryInfodetailWithParam:(id)paramer
                             withHandle:(response)responseHandle{
    NSString * appendURLString = @"info/query_infodetail";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
#pragma mark - 我的
/************************************************************/
//*  我的
/************************************************************/
//查询用户个人资料
+ (void)requestUserMaterialWithParam:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"userMaterial/select";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//查询当天是否签到
+ (void)requestSelectCurIsSignWithParam:(id)paramer
                             withHandle:(response)responseHandle{
    NSString * appendURLString = @"userSign/selectCurIsSign";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//查询是否允许借支
+ (void)requestQueryIsLendWithParam:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"lendmoney/query_isLend";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//借支记录
+ (void)requestQueryCheckrecordWithParam:(id)paramer
                              withHandle:(response)responseHandle{
    NSString * appendURLString = @"lendmoney/query_checkrecord";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//借支
+ (void)requestAddLendmoneyWithParam:(id)paramer
                              withHandle:(response)responseHandle{
    NSString * appendURLString = @"lendmoney/add_lendmoney";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//离职通知
+ (void)requestGetNoticeWithParam:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"dimission/get_notice";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//申请离职,发送离职通知
+ (void)requestAddDimissionWithParam:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"dimission/add_dimission";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//邀请奖励
+ (void)requestGetRegisterWithParam:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"invite/get_register";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//邀请奖励详情
+ (void)requestGetOnWorkWithParam:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"invite/get_on_work";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//查询绑定银行卡
+ (void)requestSelectBindbankcardWithParam:(id)paramer
                                withHandle:(response)responseHandle{
    NSString * appendURLString = @"userbank/select_bindbankcard";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//绑定/变更银行卡
+ (void)requestBindunbindBankcardWithParam:(id)paramer
                                withHandle:(response)responseHandle{
    NSString * appendURLString = @"userbank/bindunbind_bankcard";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//提现密码验证
+ (void)requestUpdateDrawpwdWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"userbank/update_drawpwd";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
#pragma mark - 企业点评
/************************************************************/
//*  企业点评
/************************************************************/
//查询所有企业
+ (void)requestMechanismcommentMechanismlistWithParam:(id)paramer
                                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"mechanismcomment/query_mechanismlist";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}

//企业点评详情
+ (void)requestMechanismcommentDeatilWithParam:(id)paramer
                                    withHandle:(response)responseHandle{
    NSString * appendURLString = @"mechanismcomment/query_deatil";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//查询用户就过职、曾经就职的企业
+ (void)requestCheckIsmechanismWithParam:(id)paramer
                              withHandle:(response)responseHandle{
    NSString * appendURLString = @"mechanismcomment/check_ismechanism";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
#pragma mark - 工时记录
/************************************************************/
//*  工时记录
/************************************************************/
//记录/修改工时
+ (void)requestSaveorupdateWorkhourWithParam:(id)paramer
                                  withHandle:(response)responseHandle{
    NSString * appendURLString = @"workhour/saveorupdate_workhour";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//查询工时记录详情
+ (void)requestSelectWorkhourWithParam:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"workhour/select_workhour";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//查询当天工时记录
+ (void)requestQueryCurrecordWithParam:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"workhour/query_currecord";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//查询已记录工时
+ (void)requestQueryNormalrecordWithParam:(id)paramer
                               withHandle:(response)responseHandle{
    NSString * appendURLString = @"workhour/query_normalrecord";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//删除加班记录
+ (void)requestDeleteAddtimeWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"workhour/delete_addtime";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//记录补贴扣款
+ (void)requestAddWorkrecordWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"workhour/add_workrecord";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
#pragma mark - 工资明细
/************************************************************/
//*  工资明细
/************************************************************/
//查询工资明细
+ (void)requestQuerySalarylistWithParam:(id)paramer
                             withHandle:(response)responseHandle{
    NSString * appendURLString = @"billrecord/query_salarylist";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
//查询工资明细详情
+ (void)requestQuerySalarydetailWithParam:(id)paramer
                               withHandle:(response)responseHandle{
    NSString * appendURLString = @"billrecord/query_salarydetail";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle];
    [NetRequestManager requestWithEnty:enty];
}
@end
