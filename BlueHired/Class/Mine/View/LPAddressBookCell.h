//
//  LPAddressBookCell.h
//  BlueHired
//
//  Created by iMac on 2019/6/11.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPUserConcernListModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPAddressBookCellBlock)(void);

@interface LPAddressBookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userName2;
@property (weak, nonatomic) IBOutlet UILabel *BookName;
@property (weak, nonatomic) IBOutlet UIButton *Button;

@property (nonatomic, strong) LPUserConcernListDataModel *model;
@property (nonatomic,copy) LPAddressBookCellBlock Block;

@end


NS_ASSUME_NONNULL_END
