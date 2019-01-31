//
//  LPRecruitRequireCell.h
//  BlueHired
//
//  Created by iMac on 2018/10/24.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LPAddRecordCellDicBlock)(NSString *textView);

NS_ASSUME_NONNULL_BEGIN

@interface LPRecruitRequireCell : UITableViewCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *addRow;
@property (nonatomic,copy) LPAddRecordCellDicBlock Block;
@property (nonatomic,strong) NSArray *HintList;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,assign) NSInteger Type;


@end

NS_ASSUME_NONNULL_END
