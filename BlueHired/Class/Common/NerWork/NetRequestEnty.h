//
//  NetRequestEnty.h
//  RedPacket
//
//  Created by peng on 2018/6/8.
//  Copyright © 2018年 peng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^response)(BOOL isSuccess,id responseObj);

@interface NetRequestEnty : NSObject

//请求方式 0:get 1:post 2:上传单张图片 3:上传多张图片
//默认是 0 get ,后面两种方式可能不支持的
@property (nonatomic) int requestType;

//请求地址
@property (nonatomic,copy) NSString * requestUrl;

//请求参数
@property (nonatomic,strong) id params;

//回调block
@property (nonatomic,copy) response responseHandle;


/************************************************************/
//*  上传图片需要额外增加的参数
/*****************************
 
 
 
 
 
 
 
 
 *******************************/

//单张图片实体
@property (nonatomic,strong) UIImage * singleImage;

//单张图片名字
@property (nonatomic,copy) NSString * singleImageName;

//多张图片实体
@property (nonatomic,strong) NSArray * imagesArray;

//多张图片名字
@property (nonatomic,strong) NSArray * imageNamesArray;

@end
