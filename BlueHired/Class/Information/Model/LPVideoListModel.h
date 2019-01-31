//
//  LPVideoListModel.h
//  BlueHired
//
//  Created by iMac on 2018/11/20.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPVideoListDataModel;
@interface LPVideoListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPVideoListDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPVideoListDataModel : NSObject
@property (nonatomic, strong) NSString *collectionStatus;
@property (nonatomic, strong) NSString *commentTotal;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *labelId;
@property (nonatomic, strong) NSString *labelUrl;
@property (nonatomic, strong) NSString *likeStatus;
@property (nonatomic, strong) NSString *praiseTotal;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userUrl;
@property (nonatomic, strong) NSString *videoImage;
@property (nonatomic, strong) NSString *videoName;
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSString *view;

@end

NS_ASSUME_NONNULL_END
