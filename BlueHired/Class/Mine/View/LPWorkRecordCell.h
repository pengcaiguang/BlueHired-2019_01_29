//
//  LPWorkRecordCell.h
//  BlueHired
//
//  Created by iMac on 2019/10/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorkRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPWorkRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *WorkName;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *WorkPost;
@property (weak, nonatomic) IBOutlet UILabel *WorkStatus;


@property (nonatomic, strong) LPWorkRecordDataModel *model;
@end

NS_ASSUME_NONNULL_END
