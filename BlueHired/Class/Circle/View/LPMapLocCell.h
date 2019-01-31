//
//  LPMapLocCell.h
//  BlueHired
//
//  Created by iMac on 2018/11/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPMapLocCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *AddName;
@property (weak, nonatomic) IBOutlet UILabel *AddDetail;
@property (weak, nonatomic) IBOutlet UIButton *SelectBt;

@end

NS_ASSUME_NONNULL_END
