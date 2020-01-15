//
//  HDClient+call.h
//  helpdesk_sdk
//
//  Created by afanda on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import "HDClient.h"
#import "HDCallManager.h"
@interface HDClient (call)
/*!
 *  \~chinese
 *  实时通讯模块
 *
 *  \~english
 *  call module
 */
@property (nonatomic, strong, readonly) HDCallManager *callManager;

@property (nonatomic, strong, readonly) HDCallManager *call __attribute__((deprecated("已过期, 请使用callManager")));


@end
