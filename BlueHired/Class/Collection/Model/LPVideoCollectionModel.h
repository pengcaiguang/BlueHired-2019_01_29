//
//  LPVideoCollectionModel.h
//  BlueHired
//
//  Created by iMac on 2018/12/12.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPVideoCollectionDataModel;
@interface LPVideoCollectionModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPVideoCollectionDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end


@interface LPVideoCollectionDataModel : NSObject
@property (nonatomic, copy) NSString *collectId;
@property (nonatomic, copy) NSString *collectionStatus;
@property (nonatomic, copy) NSString *commentTotal;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *labelId;
@property (nonatomic, copy) NSString *labelUrl;
@property (nonatomic, copy) NSString *likeStatus;
@property (nonatomic, copy) NSString *praiseTotal;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *videoImage;
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *view;


@end

NS_ASSUME_NONNULL_END
