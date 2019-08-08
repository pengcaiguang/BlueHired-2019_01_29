//
//  LPUserInfoCell.h
//  BlueHired
//
//  Created by iMac on 2019/7/24.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPUserMaterialModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPUserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ArrowsImage;
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UITextField *NameTF;

@property (nonatomic, strong) LPUserMaterialDataModel *Model;


@end

NS_ASSUME_NONNULL_END
