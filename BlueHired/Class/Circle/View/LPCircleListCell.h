//
//  LPCircleListCell.h
//  BlueHired
//
//  Created by peng on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMoodListModel.h"

@protocol SDTimeLineCellDelegate <NSObject>

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;
- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell with:(NSIndexPath *)indexPath;

@end

typedef void (^LPCircleListCellBlock)(void);
typedef void (^LPCircleListCellPraiseBlock)(void);
typedef void (^LPCircleListCellVideoBlock)(NSString *VideoUrl,UIImageView *view);

@interface LPCircleListCell : UITableViewCell
@property (nonatomic, weak) id<SDTimeLineCellDelegate> delegate;
@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow, NSIndexPath *indexPath);
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIImageView *userUrlImgView;
@property (weak, nonatomic) IBOutlet UIImageView *gradingiamge;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *AddressImage;

@property (weak, nonatomic) IBOutlet UILabel *moodDetailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *AllDetailsBt;

@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTotalLabel;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (weak, nonatomic) IBOutlet UIButton *ReportBt;

@property (weak, nonatomic) IBOutlet UIButton *isConcernBt;
@property (weak, nonatomic) IBOutlet UIButton *LikeBt;
@property (weak, nonatomic) IBOutlet UIButton *CommentBt;

@property (nonatomic,copy) LPCircleListCellBlock Block;
@property (nonatomic,copy) LPCircleListCellPraiseBlock PraiseBlock;
@property (nonatomic,copy) LPCircleListCellVideoBlock VideoBlock;

@property (weak, nonatomic) IBOutlet UIButton *operationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBgView_constraint_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBgView_constraint_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBgView_constraint_Top;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Address_constraint_height;


@property(nonatomic,strong) LPMoodListDataModel *model;


@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIImageView *touchImage;
@property (nonatomic,assign) CGRect imageRect;
@property (nonatomic,strong) NSMutableArray <UIImageView *>*imageViewsRectArray;

@property (nonatomic,assign) NSInteger ContentType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CommentView_constraint_height;
@property (weak, nonatomic) IBOutlet UIView *CommentView;

@property(nonatomic,strong) NSMutableArray <LPMoodListDataModel *>*moodListArray;
@property(nonatomic,strong) UITableView *SuperTableView;
@property (nonatomic,assign) NSInteger ClaaViewType;

@end
