//
//  LPMine2Cell.h
//  BlueHired
//
//  Created by iMac on 2019/1/5.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPUserMaterialModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPMine2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *user_nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *user_urlImgView;
@property (weak, nonatomic) IBOutlet UIView *user_ImgViewBg;
@property (weak, nonatomic) IBOutlet UILabel *LoginLabel;

@property (weak, nonatomic) IBOutlet UIImageView *user_sexImgView;
@property (weak, nonatomic) IBOutlet UIImageView *gradingiamge;

@property (weak, nonatomic) IBOutlet UILabel *moodNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *concernNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *workStatusLabel; //工作状态0待业1在职2入职中

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *showMoneyButton;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *redactButton;
@property (weak, nonatomic) IBOutlet UIButton *MessageButton;

@property (weak, nonatomic) IBOutlet UIView *BackView1;
@property (weak, nonatomic) IBOutlet UIView *backView2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BackView1_Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Edit_Top;

@property (weak, nonatomic) IBOutlet UISlider *Slider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Slider_right;
@property (weak, nonatomic) IBOutlet UILabel *scoreCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scoreImage;



@property(nonatomic,strong) LPUserMaterialModel *userMaterialModel;
@property(nonatomic,assign) BOOL signin;
@end

NS_ASSUME_NONNULL_END
