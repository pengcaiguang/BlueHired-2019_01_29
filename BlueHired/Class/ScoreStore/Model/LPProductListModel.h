//
//  LPProductListModel.h
//  BlueHired
//
//  Created by iMac on 2019/9/25.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPProductListListModel;
@class LPProductListDataModel;

@interface LPProductListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPProductListListModel *data;
@property (nonatomic, copy) NSString *msg;
@end


@interface LPProductListListModel : NSObject
@property (nonatomic, copy) NSArray <LPProductListDataModel *> *list;
@property (nonatomic, copy) NSArray <LPProductListDataModel *> *slideList;

@end


@interface LPProductListDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *productSn;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *publishStatus;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *sale;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;

@end


NS_ASSUME_NONNULL_END
