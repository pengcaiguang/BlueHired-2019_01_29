//
//  LPStoreAssistantCell.h
//  BlueHired
//
//  Created by iMac on 2018/10/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPAssistantModel.h"
typedef void(^LPAddRecordCellDicBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface LPStoreAssistantCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userimage;
@property (weak, nonatomic) IBOutlet UILabel *userTel;
@property (weak, nonatomic) IBOutlet UIButton *dismissBt;
@property (weak, nonatomic) IBOutlet UIButton *detailBt;
@property (nonatomic,copy) LPAddRecordCellDicBlock Block;

@property (nonatomic,strong) LPAssistantDataModel *model;

@end

NS_ASSUME_NONNULL_END
