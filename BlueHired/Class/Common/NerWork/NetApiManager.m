//
//  NetApiManager.m
//  RedPacket
//
//  Created by peng on 2018/6/8.
//  Copyright © 2018年 peng. All rights reserved.
//

#import "NetApiManager.h"
#import "AppDelegate.h"
#import "NetRequestManager.h"
#import "NetInstance.h"
#import "QiniuSDK.h"
#import "DSBaActivityView.h"


static QNUploadManager *upManager = NULL;

@interface NetApiManager()


@end;

@implementation NetApiManager



+(QNUploadManager *)initupManager{
    if (upManager == NULL) {
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
//            NSArray *ips = [QNZone zone0].up.ips;
//            QNServiceAddress *s1 = [[QNServiceAddress alloc] init:@"http://up-z2.qiniup.com" ips:ips];
//            QNServiceAddress *s2 = [[QNServiceAddress alloc] init:@"http://up-z2.qiniup.com" ips:ips];
//            builder.zone = [[QNZone alloc] initWithUp:s1 upBackup:s2];
            builder.zone = [QNFixedZone zone2];
        }];
        upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    }
    return upManager;
}

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
                                  IsShowActiviTy:(BOOL) show
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // something
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            if (show) {
                //                [DSBeiAnimationLoading showInView:[UIApplication sharedApplication].keyWindow];
                [DSBaActivityView showActiviTy];
            }
        });
    });
    
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

/**
 *  上传图片---七牛云
 *
 *  @param imgArr 上传的图片
 *  @param BlockInfo  返回的是否成功和失败 和图片的Url
 */
+(void)getUploadTempImages:(NSArray*)imgArr andBlock:(UploadImageTempBlock)BlockInfo{
    
    [NetApiManager requestQueryGetQiniuParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            NSMutableArray *imgAdd = [[NSMutableArray alloc] init];
            
            for (int i =0 ; i<imgArr.count; i++) {

            NSString *fileName = [NSString stringWithFormat:@"%.f_%d_",[[NSDate date] timeIntervalSince1970],i];
            fileName = [fileName stringByAppendingString:CurrentDeviceSn];
            fileName = [fileName stringByAppendingString:@"_ios.jpg"];
            NSData *data = UIImageJPEGRepresentation(imgArr[i],0.000001);
            NSString *token = responseObject[@"data"];
                QNUploadOption *opt;
                if (opt == nil) {
                    opt = [[QNUploadOption alloc] initWithMime:@"image/jpeg" progressHandler:nil params:nil checkCrc:YES cancellationSignal:nil];
                }
      
                upManager = [self initupManager];
             [upManager putData:data key:fileName token:token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          NSLog(@"%@", info);
                          NSLog(@"%@", resp);
//                          BlockInfo(YES,[QiNiuBaseUrl stringByAppendingString:key]);
                          [imgAdd addObject:[QiNiuBaseUrl stringByAppendingString:key]];
                          if (imgArr.count == imgAdd.count)
                          {
                              NSLog(@"图片上传完成");
                              if (imgAdd.count>1) {     //数据排序
//                                  for (int j = 0; j < imgAdd.count; j++) {
//                                      NSString *QiNiustrName = [[imgAdd objectAtIndex:j] componentsSeparatedByString:@"_"][1];
//                                      NSLog(@"QiNiustrName = %@",QiNiustrName);
//                                  }
                                [imgAdd  sortUsingSelector:@selector(caseInsensitiveCompare:)];
                              }
                              
                                BlockInfo(YES,imgAdd);
                          }
                      } option:opt];
            }
        }else{
//            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
    
    
    
    
}



/**
 *  上传视频---七牛云
 *
 *  @param VideoUrl 上传的视频路径
 *  @param BlockInfo  返回的是否成功和失败 和图片的Url
 */
+(void)getUploadTempVideo:(NSString *)VideoUrl andBlock:(UploadImageTempBlock)BlockInfo{
    
    [NetApiManager requestQueryGetQiniuParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            NSMutableArray *imgAdd = [[NSMutableArray alloc] init];

                NSString *fileName = [NSString stringWithFormat:@"%.f_video_",[[NSDate date] timeIntervalSince1970]];
                fileName = [fileName stringByAppendingString:CurrentDeviceSn];
                fileName = [fileName stringByAppendingString:@"_ios.mp4"];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:VideoUrl]];
                NSString *token = responseObject[@"data"];
                QNUploadOption *opt;
                if (opt == nil) {
                    opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:nil params:nil checkCrc:YES cancellationSignal:nil];
                }
                upManager = [self initupManager];
                [upManager putData:data key:fileName token:token
                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                              NSLog(@"%@", info);
                              NSLog(@"%@", resp);
                              //                          BlockInfo(YES,[QiNiuBaseUrl stringByAppendingString:key]);
                              [imgAdd addObject:[QiNiuBaseUrl stringByAppendingString:key]];
                                  NSLog(@"图片上传完成");
                                  BlockInfo(YES,imgAdd);
                          } option:opt];
        }else{
            //            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}





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
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查询所有行业/工种
+ (void)requestMechanismlistWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/query_mechanismlist";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//招聘详情
+ (void)requestWorkDetailWithParam:(id)paramer
                        withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/query_workdetail";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle                                                  IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//收藏接口
+ (void)requestSetCollectionWithParam:(id)paramer
                           withHandle:(response)responseHandle
                       IsShowActivity:(BOOL) IsShow{
    NSString * appendURLString = @"social/set_collection";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:IsShow];
    [NetRequestManager requestWithEnty:enty];
}

//查询是否报名/收藏公司/实名认证
+ (void)requestIsApplyOrIsCollectionWithParam:(id)paramer
                                   withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/query_isApplyOrIsCollection";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//入职报名
+ (void)requestEntryApplyWithUrl:(NSString *)urlString
                       withParam:(id)paramer
                      withHandle:(response)responseHandle{
    NetRequestEnty * enty = [self createEntyWithAppendURLString:urlString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//取消报名
+ (void)requestCancleApplyWithUrl:(NSString *)urlString
                        withParam:(id)paramer
                       withHandle:(response)responseHandle{
    NetRequestEnty * enty = [self createEntyWithAppendURLString:urlString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//查询面试预约列表
+ (void)requestWorkorderlistWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/query_workorderlist";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//删除面试预约
+ (void)requestDelWorkorderWithParam:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/del_workorder";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
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
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//资讯列表
+ (void)requestEssaylistWithParam:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"essay/get_essay_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//资讯详情
+ (void)requestEssayWithParam:(id)paramer
                   withHandle:(response)responseHandle{
    NSString * appendURLString = @"essay/get_essay";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//新闻推荐列表
+ (void)requestEssay_LabelWithParam:(id)paramer
                   withHandle:(response)responseHandle{
    NSString * appendURLString = @"essay/get_essay_label";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//增加新闻浏览量
+ (void)requestSetEssayViewWithParam:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"essay/set_essay_view";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//获取评论列表
+ (void)requestCommentListWithParam:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"comment/get_comment_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//点赞（取消）
+ (void)requestSocialSetlikeWithParam:(id)paramer
                           withHandle:(response)responseHandle
                       IsShowActiviTy:(BOOL) IsShow{
    NSString * appendURLString = @"social/set_like";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:IsShow];
    [NetRequestManager requestWithEnty:enty];
}
//添加评论
+ (void)requestCommentAddcommentWithParam:(id)paramer
                               withHandle:(response)responseHandle{
    NSString * appendURLString = @"comment/add_comment";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
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
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查看圈子列表
+ (void)requestMoodListWithParam:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"mood/get_mood_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//获取圈子详情
+ (void)requestGetMoodWithParam:(id)paramer
                     withHandle:(response)responseHandle{
    NSString * appendURLString = @"mood/get_mood";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//增加圈子浏览量
+ (void)requestSetMoodViewWithParam:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"mood/set_mood_view";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//添加圈子
+ (void)requestAddMoodWithParam:(id)paramer
                     withHandle:(response)responseHandle{
    NSString * appendURLString = @"mood/add_mood";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//删除圈子
+ (void)requestDeleteMoodWithParam:(id)paramer
                     withHandle:(response)responseHandle{
    NSString * appendURLString = @"mood/del_mood_by_ids";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}


// 视频上传
+ (void)requestPublishVideo:(id)parameters
                   VideoUrl:(NSString *) VideoUrl
                     response:(response)response{
 
    [NetApiManager getUploadTempVideo:VideoUrl andBlock:^(BOOL sussess,NSMutableArray *array)  {
        
        NSDictionary *dic = @{@"data":array
                              };
        response(sussess,dic);
    }];
}


// 多张图片上传
+ (void)requestPublishArticle:(id)parameters
                   imageArray:(NSArray*)imageArray
               imageNameArray:(NSArray*)imageNameArray
                     response:(response)response{
//    NSString * appendURLString = @"platform/upload_image_list";
//    NetRequestEnty *enty = [self createEntyWithAppendURLString:appendURLString
//                                               withRequestEnty:RequestTypeUploadImagesArray
//                                                     withParam:parameters
//                                                    withHandle:response];
//    enty.imagesArray = imageArray;
//    enty.imageNamesArray = imageNameArray;
//    [NetRequestManager requestWithEnty:enty];
  
    [NetApiManager getUploadTempImages:imageArray andBlock:^(BOOL sussess,NSMutableArray *array)  {
    
        
        NSDictionary *dic = @{@"data":array
                              };
        response(sussess,dic);
    }];
}
// 单张图片上传
+ (void)avartarChangeWithParamDict:(id)paramer
                       singleImage:(UIImage *)image
                   singleImageName:(NSString *)imageName
                        withHandle:(response)responseHandle{
    
    NSArray *array =@[image];
    
    [NetApiManager getUploadTempImages:array andBlock:^(BOOL sussess,NSMutableArray *array)  {
        NSDictionary *dic = @{@"data":array.count?array[0]:@""
                              };
        responseHandle(sussess,dic);
    }];
    
    
//    NSString * appendURLString = @"platform/upload_image";
//    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
//                                                withRequestEnty:RequestTypeUploadSingleImage
//                                                      withParam:paramer
//                                                     withHandle:responseHandle];
//    enty.singleImage = image;
//    enty.singleImageName = imageName;
//    [NetRequestManager requestWithEnty:enty];
}
//人员关注
+ (void)requestSetUserConcernWithParam:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"userConcern/set_user_concern";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
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
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//退出登陆
+ (void)requestSignoutWithParam:(id)paramer
                     withHandle:(response)responseHandle{
    NSString * appendURLString = @"login/user_sign_out";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//注册接口
+ (void)requestAddUserWithParam:(id)paramer
                     withHandle:(response)responseHandle{
    NSString * appendURLString = @"login/add_user";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//找回密码
+ (void)requestSetPswWithParam:(id)paramer
                    withHandle:(response)responseHandle{
    NSString * appendURLString = @"login/set_psw";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//发送手机验证码
+ (void)requestSendCodeWithParam:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"login/send_code";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//验证验证码及手机
+ (void)requestMateCodeWithParam:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"login/mate_code";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//修改密码
+ (void)requestModifyPswWithParam:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"login/modify_psw";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//修改手机号
+ (void)requestUpdateUsertelWithParam:(NSString *)appendURLString
                            WithParam:(id)paramer
                           withHandle:(response)responseHandle{
//    NSString * appendURLString = @"userMaterial/update_usertel";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
#pragma mark - 消息中心
/************************************************************/
//*  消息中心
/************************************************************/
//查询未读消息数
+ (void)requestQueryUnreadNumWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"info/query_unreadNum";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}


//查询消息列表
+ (void)requestQueryInfolistWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"info/query_infolist";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//删除消息
+ (void) requestDelInfosWithParam:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"info/del_infos";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//消息详情
+ (void)requestQueryInfodetailWithParam:(id)paramer
                             withHandle:(response)responseHandle{
    NSString * appendURLString = @"info/query_infodetail";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//接受或者拒绝店主邀请A
+ (void)requestQueryAccept_invite:(id)paramer
                             withHandle:(response)responseHandle{
    NSString * appendURLString = @"assistant/accept_invite";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
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
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查询用户个人资料
+ (void)requestUserMaterialSelectMechanism:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"userMaterial/select_mechanism";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//查询当天是否签到
+ (void)requestSelectCurIsSignWithParam:(id)paramer
                             withHandle:(response)responseHandle{
    NSString * appendURLString = @"userSign/selectCurIsSign";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查询是否允许借支
+ (void)requestQueryIsLendWithParam:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"lendmoney/query_isLend";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//借支记录
+ (void)requestQueryCheckrecordWithParam:(id)paramer
                              withHandle:(response)responseHandle{
    NSString * appendURLString = @"lendmoney/query_checkrecord";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//借支
+ (void)requestAddLendmoneyWithParam:(id)paramer
                              withHandle:(response)responseHandle{
    NSString * appendURLString = @"lendmoney/add_lendmoney";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//离职通知
+ (void)requestGetNoticeWithParam:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"dimission/get_notice";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//申请离职,发送离职通知
+ (void)requestAddDimissionWithParam:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"dimission/add_dimission";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//邀请奖励
+ (void)requestGetRegisterWithParam:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"invite/get_register";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//邀请奖励详情
+ (void)requestGetOnWorkWithParam:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"invite/get_on_work";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//邀请注册奖励列表添加备注
+ (void)requestUpdateRelationReg:(id)paramer
                       URLString:(NSString *)URLString
                       withHandle:(response)responseHandle{
    NSString * appendURLString = URLString;
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}


//查询绑定银行卡
+ (void)requestSelectBindbankcardWithParam:(id)paramer
                                withHandle:(response)responseHandle{
    NSString * appendURLString = @"userbank/select_bindbankcard";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//绑定/变更银行卡
+ (void)requestBindunbindBankcardWithParam:(id)paramer
                                withHandle:(response)responseHandle{
    NSString * appendURLString = @"userbank/bindunbind_bankcard";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
// 查询身份证号是否被占用
+ (void)requestCardNOoccupy:(id)paramer
                                withHandle:(response)responseHandle{
    NSString * appendURLString = @"userbank/query_cardnoaccupy";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//提现密码验证
+ (void)requestUpdateDrawpwdWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"userbank/update_drawpwd";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//我的客服
+ (void)requestQueryProblemWithParam:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"customerser/query_problem";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查询问题
+ (void)requestQueryProblemDetailWithParam:(id)paramer
                                withHandle:(response)responseHandle{
    NSString * appendURLString = @"customerser/query_problem_detail";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//问题关键字搜索
+ (void)requestQueryProblemDetailWithParamKey:(id)paramer
                                withHandle:(response)responseHandle{
    NSString * appendURLString = @"customerser/query_problem_key";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//招聘收藏
+ (void)requestGetWorkCollectionWithParam:(id)paramer
                               withHandle:(response)responseHandle{
    NSString * appendURLString = @"collection/get_work_collection";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//资讯收藏
+ (void)requestGetEssayCollectionWithParam:(id)paramer
                                withHandle:(response)responseHandle{
    NSString * appendURLString = @"collection/get_essay_collection";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//批量删除收藏信息
+ (void)requestDeleteCollectionWithParam:(id)paramer
                              withHandle:(response)responseHandle{
    NSString * appendURLString = @"collection/delete_collection";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//意见反馈
+ (void)requestProblemAddWithParam:(id)paramer
                        withHandle:(response)responseHandle{
    NSString * appendURLString = @"problem/add";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//查询签到
+ (void)requestSelectSignInfoWithParam:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"userSign/selectSignInfo";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//签到
+ (void)requestUserSignAddWithParam:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"userSign/add";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//修改用户个人资料
+ (void)requestSaveOrUpdateWithParam:(NSString *)urlString
                           withParam:(id)paramer
                          withHandle:(response)responseHandle{
    NetRequestEnty * enty = [self createEntyWithAppendURLString:urlString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//账单
+ (void)requestQueryBillrecordWithParam:(id)paramer
                             withHandle:(response)responseHandle{
    NSString * appendURLString = @"billrecord/query_billrecord";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//提现
+ (void)requestQueryBankcardwithDrawWithParam:(id)paramer
                                   withHandle:(response)responseHandle{
    NSString * appendURLString = @"billrecord/query_bankcardwithDraw";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//提现余额
+ (void)requestQueryBankcardwithDrawDepositWithParam:(NSString *)appendURLString
                                    WithParam:(id)paramer
                                   withHandle:(response)responseHandle{
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查询账单详情及提现进度
+ (void)requestQueryBankcardwithWithdrawreCordWithParam:(NSString *)appendURLString
                                           WithParam:(id)paramer
                                          withHandle:(response)responseHandle{
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
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
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//企业点评详情
+ (void)requestMechanismcommentDeatilWithParam:(id)paramer
                                    withHandle:(response)responseHandle{
    NSString * appendURLString = @"mechanismcomment/query_deatil";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查询用户就过职、曾经就职的企业
+ (void)requestCheckIsmechanismWithParam:(id)paramer
                              withHandle:(response)responseHandle{
    NSString * appendURLString = @"mechanismcomment/check_ismechanism";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
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
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//查询工时记录详情
+ (void)requestSelectWorkhourWithParam:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"workhour/select_workhour";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查询当天工时记录
+ (void)requestQueryCurrecordWithParam:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"workhour/query_currecord";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查询已记录工时
+ (void)requestQueryNormalrecordWithParam:(id)paramer
                               withHandle:(response)responseHandle{
    NSString * appendURLString = @"workhour/query_normalrecord";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//删除加班记录
+ (void)requestDeleteAddtimeWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"workhour/delete_addtime";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//记录补贴扣款
+ (void)requestAddWorkrecordWithParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"workhour/add_workrecord";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
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
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查询工资明细详情
+ (void)requestQuerySalarydetailWithParam:(id)paramer
                               withHandle:(response)responseHandle{
    NSString * appendURLString = @"billrecord/query_salarydetail";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//晒工资
+ (void)requestQueryBusinessWageParam:(id)paramer
                               withHandle:(response)responseHandle{
    NSString * appendURLString = @"mechanismcomment/add_salary";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//获取七牛云token
+ (void)requestQueryGetQiniuParam:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"platform/get_token";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//查询招聘列表及详情
+ (void)requestQueryWorkList:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"resident/query_work_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//更新招聘信息
+ (void)requestQueryUpdateWorkList:(id)paramer
                        withHandle:(response)responseHandle{
    
    NSString * appendURLString = @"resident/update_work_details";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//查询借支列表
+ (void)requestQueryLandMoneyList:(id)paramer
                  withHandle:(response)responseHandle{
    NSString * appendURLString = @"resident/query_lend_money_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//审核借支状态
+ (void)requestQueryUpdateLandMoneyList:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"resident/update_lend_money_status";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//借支详情
+ (void)requestQueryUpdateLandMoneyDetail:(id)paramer
                             withHandle:(response)responseHandle{
    NSString * appendURLString = @"resident/query_lendmoney_detail";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//入职员工信息列表
+ (void)requestQueryWorkOrderList:(id)paramer
                               withHandle:(response)responseHandle{
    NSString * appendURLString = @"resident/query_work_order";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//修改面试预约状态
+ (void)requestQueryUodateWorkOrderList:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"resident/update_work_order_status";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//面试通过
+ (void)requestQueryupdate_interview:(id)paramer
                             withHandle:(response)responseHandle{
    NSString * appendURLString = @"resident/update_interview";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//设置入职时间
+ (void)requestQueryUodateWorkDate:(id)paramer
                             withHandle:(response)responseHandle{
    NSString * appendURLString = @"resident/set_entry_date";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//查询企业员工管理列表
+ (void)requestQueryCompanyStaff:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"resident/query_company_staff";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//查询企业员工管理详细列表
+ (void)requestQueryUserRegistration:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"resident/query_user_registration";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//更新查询企业员工管理详细列表
+ (void)requestQueryUpdateUserRegistration:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"resident/insert_user_work_record";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//查询店主下劳务工信息
+ (void)requestQuerylabourlist:(id)paramer
                                withHandle:(response)responseHandle{
    NSString * appendURLString = @"shopkeeper/query_labourlist";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//查询店员下劳务工信息
+ (void)requestQueryassistantlabourlist:(id)paramer
                    withHandle:(response)responseHandle{
    NSString * appendURLString = @"assistant/query_labourlist";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//查询门店信息  店主
+ (void)requestQueryshopkeeperinfo:(id)paramer
                    withHandle:(response)responseHandle{
    NSString * appendURLString = @"shopkeeper/query_shopkeeperinfo";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//查询门店信息  店员
+ (void)requestQueryassistantshopkeeperinfo:(id)paramer
                        withHandle:(response)responseHandle{
    NSString * appendURLString = @"assistant/query_shopassistantinfo";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//查询门店收支明细

+ (void)requestQueryshopincome:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"shopkeeper/query_shopincome";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//查询门店下员工信息
+ (void)requestQueryshopuserlist:(id)paramer
                        withHandle:(response)responseHandle{
    NSString * appendURLString = @"shopkeeper/query_shopuserlist";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//辞退店员
+ (void)requestQueryshopdismiss:(id)paramer
                     withHandle:(response)responseHandle{
    NSString * appendURLString = @"shopkeeper/dismiss_shopUser";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//邀请店员
+ (void)requestQueryinviteshopUser:(id)paramer
                     withHandle:(response)responseHandle{
    NSString * appendURLString = @"shopkeeper/invite_shopUser";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//查询门店业绩详情
+ (void)requestQueryBonusDetail:(id)paramer
                    withHandle:(response)responseHandle{
    NSString * appendURLString = @"shopkeeper/query_bonusdetail";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}


//设置返费
+ (void)requestQueryadd_overseer:(id)paramer
                     withHandle:(response)responseHandle{
    NSString * appendURLString = @"shopkeeper/add_overseer";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//设置上架/下架
+ (void)requestQueryset_workwatchstatus:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"shopkeeper/set_workwatchstatus";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//提醒店主设置返费
+ (void)requestQueryremind_shopkeeper:(id)paramer
                             withHandle:(response)responseHandle{
    NSString * appendURLString = @"assistant/remind_shopkeeper";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}


//查询用户个人资料
+ (void)requestQueryUserMaterialSelect:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"userMaterial/select";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}


//信息举报接口
+ (void)requestQueryReportAdd:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"report/add";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//屏蔽用户  传参identity,type(1屏蔽2取消屏蔽)
+ (void)requestQueryDefriendPullBlack:(id)paramer
                   withHandle:(response)responseHandle{
    NSString * appendURLString = @"defriend/pull_black_user";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//获取屏蔽用户列表
+ (void)requestQueryDefriendPullBlackUserList:(id)paramer
                   withHandle:(response)responseHandle{
    NSString * appendURLString = @"defriend/get_pull_black_user_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}


//获取系统版本号
+ (void)requestQueryDownload:(id)paramer
                                   withHandle:(response)responseHandle{
    NSString * appendURLString = @"platform/get_download";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//获取视频列表, 
+ (void)requestQueryGetVideoList:(id)paramer
                  withHandle:(response)responseHandle{
    NSString * appendURLString = @"video/get_video_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//获取视频浏览量
+ (void)requestQuerySetVideoView:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"video/set_video_view";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//获取视频
+ (void)requestQueryGetVideo:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"video/get_video";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//获取视频分类
+ (void)requestQueryGetVideoType:(id)paramer
                  withHandle:(response)responseHandle{
    NSString * appendURLString = @"video/get_video_type";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//视频收藏列表
+ (void)requestQueryGetVideoCollection:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"collection/get_video_collection";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//获取红包
+ (void)requestQueryGetRedPacket:(id)paramer
                  withHandle:(response)responseHandle{
    NSString * appendURLString = @"redPacket/get_red_packet";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//获取时间
+ (void)requestQueryGetRedPacketStatus:(id)paramer
                   withHandle:(response)responseHandle{
    NSString * appendURLString = @"redPacket/get_red_status";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//查询是否第一次微信登入
+ (void)requestQueryWXUserStatus:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"wx_user/get_status";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//微信手机绑定
+ (void)requestQueryWXSetPhone:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"wx_user/set_phone";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//查询公司列表（h5）
+ (void)requestQueryLendMoneyMechanism:(id)paramer
                    withHandle:(response)responseHandle{
    NSString * appendURLString = @"lendmoney/query_mechanism";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查询是否允许借支（h5）
+ (void)requestQueryLendApi:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"lendmoney/query_isLend_api";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//添加借支（h5）
+ (void)requestQueryAddLendApi:(NSString *)urlString
                     withParam:(id)paramer
                    withHandle:(response)responseHandle{
     NetRequestEnty * enty = [self createEntyWithAppendURLString:urlString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//是否需要驻厂电话审核。  1 为 需要   2为不需要驻厂电话号码
+ (void)requestQueryLendMoneyType:(id)paramer
                 withHandle:(response)responseHandle{
    NSString * appendURLString = @"lendmoney/get_lend_money_type";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}


//获取点赞列表
+ (void)requestQueryPraiseList:(id)paramer
                 withHandle:(response)responseHandle{
    NSString * appendURLString = @"mood/query_praise_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//查询驻厂管理的厂列表
+ (void)requestQueryTeacherMechanism:(id)paramer
                    withHandle:(response)responseHandle{
    NSString * appendURLString = @"resident/query_teacher_mechanism";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//获取活动列表
+ (void)requestQueryActivityList:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"activity/get_activity_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//获取广告弹框
+ (void)requestQueryActivityadvert:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"activity/get_activity_advert";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//更新，修改企业底薪加班倍数
+ (void)requestQueryUpdateBaseSalary:(id)paramer
                        withHandle:(response)responseHandle{
    NSString * appendURLString = @"yset/insert_or_update_base_salary";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//获取加班倍数及金额，以及小时工单价列表
+ (void)requestQueryGetYsetMulList:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"yset/get_mul_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//添加、更新记加班记录
+ (void)requestQueryGetOvertime:(id)paramer
                        withHandle:(response)responseHandle{
    NSString * appendURLString = @"overtime/add_or_update_overtime";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//查询具体某一天记加班详情
+ (void)requestQueryGetOvertimeRecordBy:(id)paramer
                     withHandle:(response)responseHandle{
    NSString * appendURLString = @"overtime/get_overtime_record_by";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//添加更新考勤周期内月工资详情
+ (void)requestQueryGetOvertimeAddMonthWage:(id)paramer
                             withHandle:(response)responseHandle{
    NSString * appendURLString = @"overtime/add_or_update_month_wage";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//首页展示
+ (void)requestQueryGetOvertimeGetMonthWage:(id)paramer
                                 withHandle:(response)responseHandle{
    NSString * appendURLString = @"overtime/get_month_wage";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}


//首页获取记账本与工作记录
+ (void)requestQueryGetOvertimeAccount:(id)paramer
                                 withHandle:(response)responseHandle{
    NSString * appendURLString = @"overtime/get_overtime_account";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//添加修改删除记账本
+ (void)requestQueryUpdateAccount:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"account/add_or_update_account";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//查询记加班时长，请假时长详情列表
+ (void)requestQueryGetOvertimeGetDetails:(id)paramer
                                 withHandle:(response)responseHandle{
    NSString * appendURLString = @"overtime/get_overtime_details";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//查询考勤周期内消费金额分类统计
+ (void)requestQueryGetAccountPrice:(id)paramer
                               withHandle:(response)responseHandle{
    NSString * appendURLString = @"account/count_account_price";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//查询消费详情列表
+ (void)requestQueryGetAccountList:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"account/get_account_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查询月工资详情
+ (void)requestQueryGetMonthWageDetail:(id)paramer
                        withHandle:(response)responseHandle{
    NSString * appendURLString = @"overtime/get_month_wage_detail";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//月综合工资详情-工时列表
+ (void)requestQueryGetHoursWorkList:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"overtime/get_hours_work_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查询用户设置的企业底薪
+ (void)requestQueryGetHoursWorkBaseSalary:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"yset/get_base_salary";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//查询用户考勤周期和正常工作日
+ (void)requestQueryGetHoursWorkYset:(id)paramer
                                withHandle:(response)responseHandle{
    NSString * appendURLString = @"yset/get_yset";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}


//添加修改用户考勤周期和正常工作日
+ (void)requestQuerySetHoursWorkYset:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"yset/insert_or_update_yset";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//记加班日历列表查看
+ (void)requestQueryGetCalenderList:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"overtime/get_calender_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//月综合详情中-查询班次补贴金额和班次天数
+ (void)requestQueryGetSubsidy:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"overtime/get_subsidy";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//记加班初始化用户设置
+ (void)requestQueryYsetInit:(id)paramer
                    withHandle:(response)responseHandle{
    NSString * appendURLString = @"yset/init_yset";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//综合记加班-查询月工作小时数
+ (void)requestQueryGetMonthHours:(id)paramer
                  withHandle:(response)responseHandle{
    NSString * appendURLString = @"yset/get_month_hours";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//综合记加班-添加更新月工作小时数
+ (void)requestQueryUpdateMonthHours:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"yset/add_or_update_month_hours";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//查询小时工单价列表
+ (void)requestQueryGetPriceName:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"yset/get_price_name";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//添加更新小时工单价列表
+ (void)requestQueryUpdatePriceName:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"yset/insert_or_update_price";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}


//查询计件中用户设置的产品列表
+ (void)requestQueryGetProList:(id)paramer
                      withHandle:(response)responseHandle{
    NSString * appendURLString = @"yset/get_pro_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//计件中添加更新删除产品信息
+ (void)requestQueryUpdateProList:(id)paramer
                    withHandle:(response)responseHandle{
    NSString * appendURLString = @"yset/add_or_update_pro";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//计件模式计件详情
+ (void)requestQueryGetProRecordList:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"overtime/get_pro_record_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}



//计件模式-添加修改删除计件记录
+ (void)requestQueryUpdateProRecord:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"overtime/add_or_update_pro_record";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}


//获取百度图像识别token
+ (void)requestQueryGetBiaduBankAccessToken:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"userbank/get_bank_access_token";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}


//获取百度图像识别
+ (void)requestQueryGetBiaduUserBankScan:(id)paramer
                                   URLString:(NSString *)URLString
                                 withHandle:(response)responseHandle{
    NSString * appendURLString = URLString;
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
//    enty.singleImage = image;
//    enty.singleImageName = @"image";
    [NetRequestManager requestWithEnty:enty];
}

//删除评论信息
+ (void)requestQueryDeleteComment:(id)paramer
                        URLString:(NSString *)URLString
                                 withHandle:(response)responseHandle{
//    NSString * appendURLString = @"comment/update_comment";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:URLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//粉丝、关注列表
+ (void)requestQueryUserConcernList:(id)paramer
                                 withHandle:(response)responseHandle{
    NSString * appendURLString = @"userConcern/get_user_concern_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//招聘详情中推荐招聘信息接口
+ (void)requestQueryWorkRecommend:(id)paramer
                         withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/query_recommend_work";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//查询拒绝申请借支天数  get请求
+ (void)requestQueryGetRefuseLendDay:(id)paramer
                       withHandle:(response)responseHandle{
    NSString * appendURLString = @"lendmoney/get_refuse_lend_day";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}


//查询幸运球开奖记录列表
+ (void)requestQueryGetPrizeRecordList:(id)paramer
                          withHandle:(response)responseHandle{
    NSString * appendURLString = @"prize/get_lucky_ball_record_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}
//一键清空圈子消息
+ (void)requestQueryDeleteInfoMood:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"info/update_info_mood";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//查询密保问题列表  post 请求  无参数
+ (void)requestQueryGetUserProdlemList:(id)paramer
                        withHandle:(response)responseHandle{
    NSString * appendURLString = @"userMaterial/get_user_problem_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//添加更新密保问题
+ (void)requestQueryUpdateUserProdlemList:(id)paramer
                            withHandle:(response)responseHandle{
    NSString * appendURLString = @"userMaterial/update_user_problem";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}
//校验密保正确性   post请求  参数
+ (void)requestQueryVerifyUserProdlemList:(id)paramer
                               withHandle:(response)responseHandle{
    NSString * appendURLString = @"userMaterial/get_user_problem";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//查询客服电话 get请求
+ (void)requestQueryGetCustomerTel:(id)paramer
                               withHandle:(response)responseHandle{
    NSString * appendURLString = @"customerser/get_customer_tel";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//工资领取消息
+ (void)requestQueryGetBillRecordList:(id)paramer
                        withHandle:(response)responseHandle{
    NSString * appendURLString = @"billrecord/get_bill_record_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//获取企业岗位
+ (void)requestQueryGetMechanismTypeList:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"mechanismcomment/get_mechanism_type_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

//获取电话号码
+ (void)requestQueryGetUserConcernTel:(id)paramer
                              withHandle:(response)responseHandle{
    NSString * appendURLString = @"userConcern/get_user_concern_tel_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypePost
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//获取入职评价列表
+ (void)requestQueryGetWorkOrderRemarkList:(id)paramer
                           withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/get_work_order_remark_list";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:YES];
    [NetRequestManager requestWithEnty:enty];
}

//首页获取弹框入职评价
+ (void)requestQueryGetWorkOrderRemarkMain:(id)paramer
                                withHandle:(response)responseHandle{
    NSString * appendURLString = @"work/get_work_order_remark";
    NetRequestEnty * enty = [self createEntyWithAppendURLString:appendURLString
                                                withRequestEnty:RequestTypeGet
                                                      withParam:paramer
                                                     withHandle:responseHandle
                                                 IsShowActiviTy:NO];
    [NetRequestManager requestWithEnty:enty];
}

@end
