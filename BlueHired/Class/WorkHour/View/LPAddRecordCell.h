//
//  LPAddRecordCell.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/13.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LPAddRecordCellBlock)(void);

typedef void(^LPAddRecordCellDicBlock)(NSDictionary *dic);

@interface LPAddRecordCell : UITableViewCell

@property (nonatomic,copy) LPAddRecordCellBlock block;
@property (nonatomic,copy) LPAddRecordCellDicBlock dicBlock;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *addTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_constraint_height;
@property(nonatomic,strong) UIButton *addButton;

@property(nonatomic,strong) NSArray *textArray;
@property(nonatomic,strong) NSMutableArray *valueArray;

@property(nonatomic,strong) NSDictionary *dic;

@end
