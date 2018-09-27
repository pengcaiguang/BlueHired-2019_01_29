//
//  LPBusinessReviewDetailCell.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMechanismcommentDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPBusinessReviewDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userUrlImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *workEnvironScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *sleepEnvironScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodEnvironScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *manageEnvironScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyEnvironScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBgView_constraint_height;


@property(nonatomic,strong) LPMechanismcommentDetailDataModel *model;


@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIImageView *touchImage;
@property (nonatomic,assign) CGRect imageRect;
@property (nonatomic,strong) NSMutableArray <UIImageView *>*imageViewsRectArray;

@end

NS_ASSUME_NONNULL_END