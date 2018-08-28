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
//配置信息
+ (void)requestWorklistWithParam:(id)paramer
                      withHandle:(response)responseHandle;

@end



