//
//  LPRecreationInformationCell.h
//  BlueHired
//
//  Created by iMac on 2019/11/13.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPRecreationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPRecreationInformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *InformationImage;
@property (weak, nonatomic) IBOutlet UILabel *InformationName;
@property (weak, nonatomic) IBOutlet UILabel *Time;

@property (nonatomic, strong) LPRecreationEssayListModel *model;



@end

NS_ASSUME_NONNULL_END
