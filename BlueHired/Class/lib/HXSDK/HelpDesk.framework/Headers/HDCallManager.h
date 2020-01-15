//
//  HDCall.h
//  helpdesk_sdk
//
//  Created by afanda on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDCallLocalView.h"
#import "HDCallRemoteView.h"
#import <Hyphenate/EMOptions.h>
#import "HDError.h"
#import "HDCallOptions.h"
#import "HDCallEnum.h"
#import "HDCallLocalView.h"
#import "HDCallManagerDelegate.h"
#import "HDCallRemoteView.h"
#import "HDCallEntities.h"

#import "HDCallManager.h"

@interface HDCallManager : NSObject

+ (instancetype)shareInstance;

#pragma mark - Options

/*!
 *  \~chinese
 *  设置设置项
 *
 *  @param aOptions  设置项
 *
 *  \~english
 *  Set setting options
 *
 *  @param aOptions  Setting options
 */
- (void)setCallOptions:(HDCallOptions *)aOptions;

/*!
 *  \~chinese
 *  获取设置项
 *
 *  @result 设置项
 *
 *  \~english
 *  Get setting options
 *
 *  @result Setting options
 */
- (HDCallOptions *)getCallOptions;

/*!
 *  \~chinese
 *  获取已经加入的members
 *
 *  @result 已经加入的成员
 *
 *  \~english
 *  Get has joined members
 *
 *  @result has joined members
 */
- (NSArray *)hasJoinedMembers;

#pragma mark - Delegate

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     执行代理方法的队列
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     The queue of call delegate method
 */
- (void)addDelegate:(id<HDCallManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 *  \~english
 *  Remove delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)removeDelegate:(id<HDCallManagerDelegate>)aDelegate;

#pragma mark - answer and end session

/**
 接受视频会话

 @param completion 完成回调
 */
- (void)acceptCallCompletion:(void(^)(id obj,HDError *error))completion;


/**
 接受视频会话

 @param nickname 传递自己的昵称到对方
 @param completion 完成回调
 */
- (void)acceptCallWithNickname:(NSString *)nickname completion:(void (^)(id, HDError *))completion;

/**
 结束视频会话
 */
- (void)endCall;


/**
 订阅视频
 */
- (void)subscribeStreamId:(NSString *)streamId
                     view:(HDCallRemoteView *)view
               completion:(void(^)(id obj,HDError *error))completion;


- (void)unSubscribeStreamId:(NSString *)streamId
                 completion:(void(^)(id obj,HDError *error))completion;


/**
 更新显示窗口
 */
- (void)updateSubscribeStreamId:(NSString *)streamId
                           view:(HDCallRemoteView *)view
                     completion:(void (^)(id, HDError *))completion;
#pragma mark - Control Camera
- (void)switchCameraPosition:(BOOL)aIsFrontCamera __attribute__((deprecated("已过期, 请使用switchCamera")));

/**
    切换摄像头
 */
- (void)switchCamera;

#pragma mark - Control Stream

/*!
 *  \~chinese
 *  暂停语音数据传输
 *
 *  \~english
 *  Suspend voice data transmission
 */
- (void)pauseVoice;

/*!
 *  \~chinese
 *  恢复语音数据传输
 *
 *  @result 错误
 *
 *  \~english
 *  Resume voice data transmission
 *
 *  @result Error
 */
- (void)resumeVoice;

/*!
 *  \~chinese
 *  暂停视频图像数据传输
 *
 *  \~english
 * Suspend video data transmission
 */
- (void)pauseVideo;

/*!
 *  \~chinese
 *  恢复视频图像数据传输
 *
 *  \~english
 *  Resume video data transmission
 */
- (void)resumeVideo;

/**
 * 构造视频邀请消息，消息发出后，客服会收到申请，客服同意后，会自动给访客拨过来。
 */
- (HDMessage *)creteVideoInviteMessageWithImId:(NSString *)aImId
                                      content:(NSString *)aContent;


/**
 * 取消视频邀请
 */
- (void)asyncCancelVideoInviteWithImId:(NSString *)aImId
                            completion:(void(^)(HDError *error))aCompletion;

/**
 * 共享桌面 其中为rootView
 */
- (void)publishWindow:(UIView *)view completion:(void (^)(id, HDError *))completion;
/**
 *  取消共享桌面
 */
-(void)unPublishWindowWithCompletion:(void (^)(id, HDError *))completion;


/**
 * 发送自定义视频数据
 */
- (void)inputCustomVideoSampleBuffer:(CMSampleBufferRef)aSampleBuffer
                      rotation:(UIDeviceOrientation)aRotation
                     publishId:(NSString *)aPublishId
                    completion:(void(^)(HDError *error))aCompletion;


@end







