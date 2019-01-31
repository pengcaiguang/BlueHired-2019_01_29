//
//  LPFirmCell.h
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPFirmModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPAddRecordBlock)(LPFirmDataModel *M);

@interface LPFirmCell : UITableViewCell
@property (nonatomic,strong) LPFirmDataModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *useriamge;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *seurtel;
@property (weak, nonatomic) IBOutlet UILabel *isStatus;
@property (nonatomic,copy) LPAddRecordBlock BlockTL;


@end

NS_ASSUME_NONNULL_END
