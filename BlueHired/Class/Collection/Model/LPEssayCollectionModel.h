//
//  LPEssayCollectionModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPEssayCollectionDataModel;
@interface LPEssayCollectionModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPEssayCollectionDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPEssayCollectionDataModel : NSObject
@property (nonatomic, copy) NSNumber *choiceStatus;
@property (nonatomic, copy) NSNumber *collectId;
@property (nonatomic, copy) NSNumber *collectionStatus;
@property (nonatomic, copy) NSNumber *commentTotal;
@property (nonatomic, copy) NSString *essayAuthor;
@property (nonatomic, copy) NSString *essayDetails;
@property (nonatomic, copy) NSString *essayName;
@property (nonatomic, copy) NSString *essayUrl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSNumber *labelId;
@property (nonatomic, copy) NSNumber *likeStatus;
@property (nonatomic, copy) NSNumber *praiseTotal;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSNumber *view;
@end

NS_ASSUME_NONNULL_END
