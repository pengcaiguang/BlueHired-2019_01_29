//
//  LPLPFirmDetailsCell.h
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPLPFirmDetailsCellBlock)(NSString *string,NSInteger row);

@interface LPLPFirmDetailsCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (nonatomic,assign) NSInteger Row;

@property (nonatomic,copy) LPLPFirmDetailsCellBlock block;

@end

NS_ASSUME_NONNULL_END
