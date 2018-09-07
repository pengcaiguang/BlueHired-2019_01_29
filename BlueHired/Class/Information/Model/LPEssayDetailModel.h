//
//  LPEssayDetailModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/1.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPEssayDetailDataModel;
@interface LPEssayDetailModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPEssayDetailDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end


@interface LPEssayDetailDataModel : NSObject

@property (nonatomic, copy) NSString *choiceStatus;
@property (nonatomic, copy) NSString *collectionStatus;
@property (nonatomic, copy) NSNumber *commentTotal;
@property (nonatomic, copy) NSString *essayAuthor;
@property (nonatomic, copy) NSString *essayDetails;
@property (nonatomic, copy) NSString *essayName;
@property (nonatomic, copy) NSString *essayUrl;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSNumber *labelId;
@property (nonatomic, copy) NSString *likeStatus;
@property (nonatomic, copy) NSNumber *praiseTotal;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSNumber *view;
@end
