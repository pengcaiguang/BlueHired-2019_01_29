//
//  LPCityDataManager.h
//  BlueHired
//
//  Created by peng on 2018/9/4.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPCityDataManager : NSObject


+ (LPCityDataManager *)shareInstance;

- (void)areaSqliteDBData;
- (NSArray*)getCity;
-(NSArray *)query:(NSString *)string;

@end
