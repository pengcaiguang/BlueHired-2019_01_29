//
//  LPCollectionEssayCell.h
//  BlueHired
//
//  Created by peng on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPEssayCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LPCollectionEssayCellBlock)(LPEssayCollectionDataModel *model);

@interface LPCollectionEssayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *essayNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *essayUrlImageView;
@property (weak, nonatomic) IBOutlet UILabel *Time;

@property (weak, nonatomic) IBOutlet UILabel *essayAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseTotalLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_contraint_width;


@property(nonatomic,strong) LPEssayCollectionDataModel *model;
@property (nonatomic,copy) LPCollectionEssayCellBlock selectBlock;

@property(nonatomic,assign) BOOL selectStatus;
@property(nonatomic,assign) BOOL selectAll;
@end

NS_ASSUME_NONNULL_END
