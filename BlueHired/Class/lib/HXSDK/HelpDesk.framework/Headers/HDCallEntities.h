//
//  HDCallEntities.h
//  helpdesk_sdk
//
//  Created by afanda on 8/22/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HDCallStreamType) {
    HDCallStreamTypeNormal,  //正常消息
    HDCallStreamTypeDeskTop  //桌面分享
};

@interface HDCallMember : NSObject
@property (nonatomic, readonly) NSString * memberName;
@property (nonatomic, readonly) NSDictionary * extension;
@end

@interface HDCallStream : NSObject
@property (nonatomic, readonly) NSString * streamId;
@property (nonatomic, readonly) NSString * streamName;
@property (nonatomic, readonly) NSString * memberName;
@property (nonatomic, readonly) HDCallStreamType streamType;
@property (nonatomic, readonly) BOOL videoOff;
@property (nonatomic, readonly) BOOL audioOff;
@property (nonatomic, readonly) NSString * extension;
@end
