//
//  HDCallRemoteView.h
//  helpdesk_sdk
//
//  Created by afanda on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDCallEnum.h"

@interface HDCallRemoteView : EMCallRemoteView
@property (atomic, assign) long recvFrameCount;
@property (atomic, assign) long renderFrameCount;
@property (nonatomic,assign) HDCallViewScaleMode hScaleMode;

@end
