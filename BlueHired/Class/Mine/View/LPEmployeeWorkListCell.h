//
//  LPEmployeeWorkListCell.h
//  BlueHired
//
//  Created by iMac on 2019/8/28.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMechanismcommentMechanismlistModel.h"
#import "LPLPEmployeeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPEmployeeWorkListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Workimage;
@property (weak, nonatomic) IBOutlet UILabel *WorkName;
@property (weak, nonatomic) IBOutlet UILabel *PostType;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn;
@property(nonatomic,strong) LPLPEmployeeDataModel *Empmodel;

@property (nonatomic,strong)LPMechanismcommentMechanismlistDataModel *model;

@end

NS_ASSUME_NONNULL_END
