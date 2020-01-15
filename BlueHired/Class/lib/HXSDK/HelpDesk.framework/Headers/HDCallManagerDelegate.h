//
//  HDCallManagerDelegate.h
//  helpdesk_sdk
//
//  Created by afanda on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDCallEntities.h"

/*!
 *  \~chinese
 *  实时语音/视频相关的回调
 *
 *  \~english
 *  Callbacks of real time voice/video
 */
@protocol HDCallManagerDelegate <NSObject>
@optional
/**
 接收到视频请求
 */
- (void)onCallReceivedNickName:(NSString *)nickName;

/**
 成员进入会话

 @param member member
 */
- (void)onMemberJoin:(HDCallMember *)member;


/**
 成员离开会话

 @param member member
 */
- (void)onMemberExit:(HDCallMember *)member;

/**
 视频流加入

 @param stream stream
 */
- (void)onStreamAdd:(HDCallStream *)stream;

/**
 视频流被移除

 @param stream stream
 */
- (void)onStreamRemove:(HDCallStream *)stream;

/**
 会话结束

 @param reason 原因
 @param desc 描述
 */
- (void)onCallEndReason:(int)reason desc:(NSString *)desc;

/**
 视频流更新

 @param stream stream
 */
- (void)onStreamUpdate:(HDCallStream *)stream;
    
- (void)onNotice:(HDMediaNoticeCode)code arg1:(NSString *)arg1 arg2:(NSString *)arg2 arg3:(id)arg3;

@end
