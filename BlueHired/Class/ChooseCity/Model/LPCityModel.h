//
//  LPCityModel.h
//  BlueHired
//
//  Created by peng on 2018/9/4.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPCityModel : NSObject

@property(nonatomic,copy) NSNumber *id;
@property(nonatomic,copy) NSString *c_name;
@property(nonatomic,copy) NSNumber *c_code;
@property(nonatomic,copy) NSString *c_pinyin;
@property(nonatomic,copy) NSString *c_province;
@property(nonatomic,copy) NSString *c_firstLetter;


@end
