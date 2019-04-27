//
//  LPConcerNumCell.h
//  BlueHired
//
//  Created by iMac on 2019/4/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPConcernModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPConcerNumCellBlock)(void);

@interface LPConcerNumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *geadingImage;
@property (weak, nonatomic) IBOutlet UIButton *ConerBT;
@property(nonatomic,strong) LPConcernDataModel *model;;
@property (nonatomic,assign) NSInteger Type;

@property (nonatomic,copy) LPConcerNumCellBlock Block;

@end

NS_ASSUME_NONNULL_END
