//
//  LPCityCell.h
//  BlueHired
//
//  Created by peng on 2018/9/4.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPCityModel.h"


typedef void(^LPCityCellBlock)(LPCityModel *model);

@interface LPCityCell : UITableViewCell

@property(nonatomic,strong) NSArray <LPCityModel *>*array;
@property (nonatomic,copy) LPCityCellBlock block;

@end
