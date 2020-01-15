//
//  LPServiceCommentVC.h
//  BlueHired
//
//  Created by iMac on 2019/11/6.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDIMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LPServiceCommentVCBlock)(NSString *Comment, NSInteger Tag);

@interface LPServiceCommentVC : LPBaseViewController
@property (nonatomic, strong) id<HDIMessageModel> messageModel;
@property (nonatomic, strong) HDConversation *conversation;

@property (nonatomic, strong) LPServiceCommentVCBlock block;

@end

NS_ASSUME_NONNULL_END
