//
//  LPRecreationVideoCell.m
//  BlueHired
//
//  Created by iMac on 2019/11/13.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPRecreationVideoCell.h"
#import "LPMainSearchVC.h"
@implementation LPRecreationVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.WorkBtn.layer.cornerRadius = LENGTH_SIZE(9);
    self.WorkBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.WorkBtn.layer.borderWidth = LENGTH_SIZE(0.5);
    self.VideoImage.layer.cornerRadius = LENGTH_SIZE(6);
    
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_normal2"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_selected2"] forState:UIControlStateSelected];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPRecreationVideoListModel *)model{
    _model = model;
    self.VideoName.text = model.videoName;
    [self.VideoImage yy_setImageWithURL:[NSURL URLWithString:model.videoImage] placeholder:[UIImage imageWithColor:[UIColor colorWithHexString:@"#E0E0E0"]]];
 
    self.WorkBtn.hidden = model.mechanismName.length>0?NO:YES;
    self.TopMaskImage.hidden = self.WorkBtn.hidden;

    if (model.collectionStatus.integerValue == 0  && AlreadyLogin) {
        self.CommonBtn.selected = YES;
    }else{
        self.CommonBtn.selected = NO;
    }
    
}

- (IBAction)TouchWorkBtn:(id)sender {
    if (self.model.mechanismName.length>0) {
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
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        sender.selected = !sender.selected;
        [self requestSetCollection];
    }
}

- (IBAction)TouchPlayBtn:(id)sender {
    if (self.selectStatus) {
        return;
    }
     LSPlayerView* playerView = [LSPlayerView playerView];
        playerView.index=self.index;
        playerView.currentFrame= CGRectMake(LENGTH_SIZE(13),
                                            self.frame.origin.y+LENGTH_SIZE(6),
                                            SCREEN_WIDTH - LENGTH_SIZE(26),
                                            LENGTH_SIZE(200));
    playerView.layer.cornerRadius = LENGTH_SIZE(6);
    playerView.clipsToBounds = YES;
    //    必须先设置tempSuperView在设置videoURL
    //    UITableView *tableview=self.superview;
    //    if (![tableview isKindOfClass:[UITableView class]]) {
    //        tableview=tableview.superview;
    //    }
        playerView.model = self.model;
        playerView.tempSuperView = self.superTableView;
        playerView.videoURL = self.model.videoUrl;
    if (self.playerBlock) {
        self.playerBlock(playerView);
    }
} 

- (IBAction)touchSelectButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}


-(void)setSelectStatus:(BOOL)selectStatus{
    _selectStatus = selectStatus;
    if (selectStatus) {
        self.selectButton.hidden = NO;
        self.label_contraint_width.constant = LENGTH_SIZE(60) ;
    }else{
        self.selectButton.hidden = YES;
        self.label_contraint_width.constant = LENGTH_SIZE(13);
    }
}

-(void)setSelectAll:(BOOL)selectAll{
    self.selectButton.selected = selectAll;
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
                        [LPTools AlertCollectView:@""];
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
