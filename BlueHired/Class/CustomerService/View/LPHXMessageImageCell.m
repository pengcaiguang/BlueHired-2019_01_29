//
//  LPHXMessageImageCell.m
//  BlueHired
//
//  Created by iMac on 2019/11/1.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPHXMessageImageCell.h"

@interface LPHXMessageImageCell()
@property(nonatomic,strong)LZImageBrowserManger *imageBrowserManger;

@end

@implementation LPHXMessageImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
    self.leftUserImage.layer.cornerRadius = LENGTH_SIZE(18);
    self.RightUserImage.layer.cornerRadius = LENGTH_SIZE(18);
    self.leftMessageImage.layer.cornerRadius = LENGTH_SIZE(6);
    self.RightMessageImage.layer.cornerRadius = LENGTH_SIZE(6);

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
    [self.leftMessageImage addGestureRecognizer:tap];
    self.leftMessageImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *Rtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
    [self.RightMessageImage addGestureRecognizer:Rtap];
    self.RightMessageImage.userInteractionEnabled = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(id<HDIMessageModel>)model{
    _model = model;
//    发送的消息
    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];

    if (model.isSender) {
        self.leftUserImage.hidden = YES;
        self.leftUserName.hidden = YES;
        self.leftMessageImage.hidden = YES;
        self.RightUserImage.hidden = NO;
        self.RightUserName.hidden = NO;
        self.RightMessageImage.hidden = NO;

        self.RightUserName.text = user.data.user_name;
        [self.RightUserImage sd_setImageWithURL:[NSURL URLWithString:user.data.user_url] placeholderImage:[UIImage imageNamed:@"UserImage"]];
        [self.RightMessageImage sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:@"NoImage"]];
        
        LZImageBrowserManger *imageBrowserManger = [LZImageBrowserManger imageBrowserMangerWithUrlStr:@[model.fileURLPath] originImageViews:@[self.RightMessageImage] originController:[UIWindow visibleViewController] forceTouch:NO forceTouchActionTitles:@[] forceTouchActionComplete:^(NSInteger selectIndex, NSString *title) {
            NSLog(@"当前选中%ld--标题%@",(long)selectIndex, title);
        }];
        _imageBrowserManger = imageBrowserManger;
        
    }else{
        self.leftUserImage.hidden = NO;
        self.leftUserName.hidden = NO;
        self.leftMessageImage.hidden = NO;

        self.RightUserImage.hidden = YES;
        self.RightUserName.hidden = YES;
        self.RightMessageImage.hidden = YES;

        self.leftUserName.text = model.nickname;
        [self.leftUserImage sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:[UIImage imageNamed:@"adv_robot"]];
        [self.leftMessageImage sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:@"NoImage"]];

        LZImageBrowserManger *imageBrowserManger = [LZImageBrowserManger imageBrowserMangerWithUrlStr:@[model.fileURLPath] originImageViews:@[self.leftMessageImage] originController:[UIWindow visibleViewController] forceTouch:NO forceTouchActionTitles:@[] forceTouchActionComplete:^(NSInteger selectIndex, NSString *title) {
            NSLog(@"当前选中%ld--标题%@",(long)selectIndex, title);
        }];
        _imageBrowserManger = imageBrowserManger;
    }
    
    
}

-(void)selectImage:(UITapGestureRecognizer *)sender{
    
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
 
    _imageBrowserManger.selectPage = singleTap.view.tag;
    [_imageBrowserManger showImageBrowser];
 
}

@end
