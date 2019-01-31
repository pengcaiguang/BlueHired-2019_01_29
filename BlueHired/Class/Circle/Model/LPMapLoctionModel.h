//
//  LPMapLoctionModel.h
//  BlueHired
//
//  Created by iMac on 2018/11/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMKLocationkit/BMKLocationComponent.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPMapLoctionModel : NSObject
@property (nonatomic, strong) NSString *AddName;
@property (nonatomic, strong) NSString *AddDetail;
@property (nonatomic, assign) BOOL IsSelect;
@property (nonatomic, strong) BMKLocationReGeocode * rgcData;
@end

NS_ASSUME_NONNULL_END
