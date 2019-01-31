//
//  LPEssayLabelModel.h
//  BlueHired
//
//  Created by iMac on 2019/1/5.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPEssayLabelDataModel;
@interface LPEssayLabelModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPEssayLabelDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end


@interface LPEssayLabelDataModel : NSObject
@property (nonatomic, strong) NSString *choiceStatus;
@property (nonatomic, strong) NSString *collectionStatus;
@property (nonatomic, strong) NSString *commentTotal;
@property (nonatomic, strong) NSString *essayAuthor;
@property (nonatomic, strong) NSString *essayDetails;
@property (nonatomic, strong) NSString *essayName;
@property (nonatomic, strong) NSString *essayUrl;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *labelId;
@property (nonatomic, strong) NSString *likeStatus;
@property (nonatomic, strong) NSString *praiseTotal;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *view;

@end

NS_ASSUME_NONNULL_END
