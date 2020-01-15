//
//  LPShanDWLIistModel.h
//  BlueHired
//
//  Created by iMac on 2019/11/12.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPShanDWLIistDataModel;

@interface LPShanDWLIistModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPShanDWLIistDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end
@interface LPShanDWLIistDataModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *screen;
@property (nonatomic, copy) NSString *sub;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *bIcon;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *play;
@property (nonatomic, copy) NSString *vPv;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *tip;
@property (nonatomic, copy) NSString *vStar;
@property (nonatomic, copy) NSString *gift;
@property (nonatomic, copy) NSString *iIcon;
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *time;

@end
NS_ASSUME_NONNULL_END
