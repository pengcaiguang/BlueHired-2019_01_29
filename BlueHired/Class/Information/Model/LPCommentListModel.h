//
//  LPCommentListModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/1.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPCommentListDataModel;
@interface LPCommentListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPCommentListDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPCommentListDataModel : NSObject

@property (nonatomic, copy) NSString *commentDetails;
@property (nonatomic, copy) NSNumber *commentId;
@property (nonatomic, copy) NSNumber *commentType;
@property (nonatomic, copy) NSString *grading;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSArray  <LPCommentListDataModel *>*commentList;


@end



