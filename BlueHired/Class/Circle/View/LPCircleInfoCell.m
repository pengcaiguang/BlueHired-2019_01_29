//
//  LPCircleInfoCell.m
//  BlueHired
//
//  Created by iMac on 2019/4/17.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPCircleInfoCell.h"
#import "LPMoodListModel.h"
#import "LPReportVC.h"

@implementation LPCircleInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.UserImage.layer.cornerRadius = 20;
    
    UITapGestureRecognizer *TapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchUpInside:)];
    [self.UserImage addGestureRecognizer:TapGestureRecognizer];
    self.UserImage.userInteractionEnabled=YES;

}

-(void)setModel:(LPInfoListDataModel *)model{
    _model = model;
    [self.UserImage sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
 
    self.UserName.text = model.userName;
    self.Date.text = [NSString timeStringWithTimeInterval:[NSString stringWithFormat:@"%@",model.time]];
    self.gradingImage.image = [UIImage imageNamed:model.grading];
    self.PlayImage.hidden = YES;
    if (model.moodUrl.length) {
        NSArray *imageArray = [model.moodUrl componentsSeparatedByString:@";"];
        
        self.LayoutContraint_MoodImage_width.constant = 50;
        NSString *imageStr =  imageArray[0];

        if ([model.moodUrl containsString:@".mp4"]) {
            self.PlayImage.hidden = NO;
            imageStr =[NSString stringWithFormat:@"%@?vframe/png/offset/0.001",imageStr];
          }else{
            imageStr = [NSString stringWithFormat:@"%@?imageView2/3/w/100/h/100/q/100",imageStr];
         }
        [self.MoodImage yy_setImageWithURL:[NSURL URLWithString:[imageStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                               placeholder:[UIImage imageNamed:@"NoImage"]
                                   options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation
                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                      
                                  }
                                 transform:^UIImage *(UIImage *image, NSURL *url) {
                                     return  image  ;
                                 }
                                completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                    if (stage == YYWebImageStageFinished) {
                                        
                                    }
                                }];
        
    }else{
        self.LayoutContraint_MoodImage_width.constant = 0;
    }
    
    if (model.informationDetails.length) {
        self.informationDetails.text = model.informationDetails;
        self.PraiseImage.hidden = YES;
    }else{
        self.informationDetails.text = @"点赞了我的动态";
        self.PraiseImage.hidden = YES;
    }
    
    
}


-(void)TouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    LPMoodListDataModel *Moodmodel = [[LPMoodListDataModel alloc] init];
 
    Moodmodel.userId = @(self.model.sendUserId.integerValue);
    Moodmodel.userName = self.model.userName;
    Moodmodel.identity = self.model.identity;
    
    LPReportVC *vc = [[LPReportVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.MoodModel = Moodmodel;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
