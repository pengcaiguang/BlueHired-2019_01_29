//
//  LPAddRecordCell.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/13.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPAddRecordCell : UITableViewCell

@property(nonatomic,assign) NSInteger index;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *addTextLabel;

@property(nonatomic,strong) NSArray *textArray;

@end
