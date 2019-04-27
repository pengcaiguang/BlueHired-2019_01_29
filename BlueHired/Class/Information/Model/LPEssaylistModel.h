//
//  LPEssaylistModel.h
//  BlueHired
//
//  Created by peng on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPEssaylistDataModel;
@interface LPEssaylistModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPEssaylistDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPEssaylistDataModel : NSObject
@property (nonatomic, copy) NSNumber *choiceStatus;
@property (nonatomic, copy) NSNumber *collectionStatus;
@property (nonatomic, copy) NSNumber *commentTotal;
@property (nonatomic, copy) NSString *essayAuthor;
@property (nonatomic, copy) NSString *essayDetails;
@property (nonatomic, copy) NSString *essayName;
@property (nonatomic, copy) NSString *essayUrl;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSNumber *labelId;
@property (nonatomic, copy) NSNumber *likeStatus;
@property (nonatomic, copy) NSNumber *praiseTotal;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSNumber *view;
@end
