



//
//  LSPlayerMaskView.m
//  LSPlayer
//
//  Created by ls on 16/3/8.
//  Copyright © 2016年 song. All rights reserved.
//

#import "LSPlayerMaskView.h"
#import "LPMainSearchVC.h"

@interface LSPlayerMaskView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressCenterY;

@end

@implementation LSPlayerMaskView

+(instancetype)playerMaskView
{
    LSPlayerMaskView *playerMaskView=[[[NSBundle mainBundle]loadNibNamed:@"LSPlayerMaskView" owner:nil options:nil]lastObject];
    return playerMaskView;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
//    [self.closeButton setImage:[UIImage imageNamed:LSPlayerViewSrcName(@"close_btn_normal")] forState:UIControlStateNormal];
    // 设置slider
    
    [self.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
//    self.slider.minimumTrackTintColor = [UIColor whiteColor];
//    self.slider.maximumTrackTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.6];
    self.progressView.progressTintColor = [UIColor colorWithRed:0.727 green:0.934 blue:0.871 alpha:0.517];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.userInteractionEnabled=NO;
//    self.progressCenterY.constant=-0.5;//调整偏差
    self.progressView.layer.cornerRadius=1.2;
    self.progressView.clipsToBounds=YES;

    
    [self.playButton setImage:[UIImage imageNamed:@"video_stop"] forState:UIControlStateHighlighted|UIControlStateSelected];
    
    [self.playButton setImage:[UIImage imageNamed:@"video_stop"] forState:UIControlStateSelected];
    [self.playButton setImage:[UIImage imageNamed:@"PlayImage"] forState:UIControlStateNormal];
    
    [self.fullButton setImage:[UIImage imageNamed:@"full"] forState:UIControlStateNormal];
    [self.fullButton setImage:[UIImage imageNamed:@"full"] forState:UIControlStateHighlighted|UIControlStateNormal];
    [self.fullButton setImage:[UIImage imageNamed:@"shrink"] forState:UIControlStateSelected];
     [self.fullButton setImage:[UIImage imageNamed:@"shrink"] forState:UIControlStateHighlighted|UIControlStateSelected];
    
    self.WorkBtn.layer.cornerRadius = LENGTH_SIZE(12);
    self.WorkBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.WorkBtn.layer.borderWidth = LENGTH_SIZE(1);
    
    self.WorkBtn2.layer.cornerRadius = LENGTH_SIZE(9);
    self.WorkBtn2.layer.borderColor = [UIColor whiteColor].CGColor;
    self.WorkBtn2.layer.borderWidth = LENGTH_SIZE(0.5);
    
}

- (void)setModel:(LPRecreationVideoListModel *)model{
    _model = model;
    self.VideoName.text = model.videoName;
//    self.WorkBtn2.hidden = model.mechanismName.length>0?NO:YES;
    if (model.collectionStatus.integerValue == 0  && AlreadyLogin) {
          self.CommonBtn.selected = YES;
      }else{
          self.CommonBtn.selected = NO;
      }
    
}


- (IBAction)TouchWorkBtn:(id)sender {
    if (self.model.mechanismName.length>0) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];

        LPMainSearchVC *vc = [[LPMainSearchVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.searchWord = self.model.mechanismName;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];

    }
    
}

- (IBAction)TouchShareBtn:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@resident/#/video?videoCover=%@&videoTitle=%@",BaseRequestWeiXiURL,self.model.videoUrl,self.model.videoName];
    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    [LPTools ClickShare:encodedUrl Title:self.model.videoName];
}

- (IBAction)TouchCommonBtn:(UIButton *)sender {
    if (AlreadyLogin) {
        sender.selected = !sender.selected;
        [self requestSetCollection];
    }else{
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        [LoginUtils validationLogin:[UIWindow visibleViewController]];
    }
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
//    self.currentOrientation = orientation;
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        NSInteger val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
 
}

-(void)requestSetCollection{
    NSDictionary *dic = @{
                          @"type":@(5),
                          @"id":self.model.id,
                          @"collectionStatus":self.CommonBtn.selected?@"0":@"1"
                          };

    [NetApiManager requestSetCollectionWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                    if ([responseObject[@"data"] integerValue] == 0) {
                        self.model.collectionStatus = @"0";
                    }else if ([responseObject[@"data"] integerValue] == 1) {
                        self.model.collectionStatus = @"1";
                    }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    } IsShowActivity:NO];
}


@end
