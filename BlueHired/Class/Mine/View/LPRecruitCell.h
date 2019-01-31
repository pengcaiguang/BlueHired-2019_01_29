//
//  LPRecruitCell.h
//  BlueHired
//
//  Created by iMac on 2018/10/24.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWork_ListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LPRecruitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UILabel *GCName1;
@property (weak, nonatomic) IBOutlet UILabel *Post1;
@property (weak, nonatomic) IBOutlet UILabel *WorkType1;
@property (weak, nonatomic) IBOutlet UITextField *number1;
@property (weak, nonatomic) IBOutlet UIButton *statueBt1;
@property (weak, nonatomic) IBOutlet UIButton *statueBt2;
@property (weak, nonatomic) IBOutlet UIButton *startDate1;
@property (weak, nonatomic) IBOutlet UIButton *endDate1;

@property(nonatomic,strong) LPWork_ListDataModel *model;

@end

NS_ASSUME_NONNULL_END
