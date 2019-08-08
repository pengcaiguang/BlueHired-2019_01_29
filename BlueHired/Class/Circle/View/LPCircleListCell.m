//
//  LPCircleListCell.m
//  BlueHired
//
//  Created by peng on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPCircleListCell.h"
#import "LPReportVC.h"
#import "LPReportContentVC.h"
#import <CoreText/CoreText.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/PHPhotoLibrary.h>
#import "LPPraiseListVC.h"
#import "UIImageView+AFNetworking.h"
#import "MenuVIew.h"
#import <UIView+SDAutoLayout.h>
#import "LPMoodDetailVC.h"
#import "LPCommentListModel.h"

//弹框监听
NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";


#define TextFont 13
@interface LPCircleListCell ()<UIScrollViewDelegate,YBAttributeTapActionDelegate>
{
    MenuVIew *_operationMenu;
    

}
@property(nonatomic,strong)LZImageBrowserManger *imageBrowserManger;
@property(nonatomic,assign) BOOL TapAction;

@end
@implementation LPCircleListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userUrlImgView.layer.masksToBounds = YES;
    self.userUrlImgView.layer.cornerRadius = 20;
    self.imageViewsRectArray = [NSMutableArray array];
    self.moodDetailsLabel.copyable = YES;
    self.moodDetailsLabel.TouchBlock = ^(void){
        [self TouchCellSelect:nil];
    };
    self.userUrlImgView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *TapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchUpInside:)];
    [self.userUrlImgView addGestureRecognizer:TapGestureRecognizer];
    
    UITapGestureRecognizer *TapGestureRecognizerimageBg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchCellSelect:)];
//    TapGestureRecognizerimageBg.delegate = self;
     [self.imageBgView addGestureRecognizer:TapGestureRecognizerimageBg];
   
    self.TriangleView.transform = CGAffineTransformMakeRotation(45 *M_PI / 180.0);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kSDTimeLineCellOperationButtonClickedNotification object:nil];
    _operationMenu = [MenuVIew new];
    __weak typeof(self) weakSelf = self;
    [_operationMenu setLikeButtonClickedOperation:^{
        [weakSelf touchPraise:nil];
        if ([weakSelf.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
//            [weakSelf.delegate didClickLikeButtonInCell:weakSelf];
        }
    }];
 
    [_operationMenu setCommentButtonClickedOperation:^{
//        if ([weakSelf.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:with:)]) {
//                        [weakSelf.delegate didClickcCommentButtonInCell:weakSelf with:weakSelf.indexPath];
//        }
        if (!AlreadyLogin) {
            [LPTools AlertMessageCommentLoginView];
            return ;
        }
            
        [XHInputView showWithStyle:InputViewStyleLarge configurationBlock:^(XHInputView *inputView) {
            /** 请在此block中设置inputView属性 */
            /** 代理 */
            //        inputView.delegate = self;
            
            /** 占位符文字 */
            inputView.placeholder = @"请输入评论...";
            /** 设置最大输入字数 */
            inputView.maxCount = 300;
            /** 输入框颜色 */
            inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
            
            /** 更多属性设置,详见XHInputView.h文件 */
            
        } sendBlock:^BOOL(NSString *text) {
            if(text.length){
                [weakSelf requestCommentAddcomment:text
                                       CommentType:2
                                         CommentId:[NSString stringWithFormat:@"%@",weakSelf.model.id]
                                  selectCommentRow:0
                                       ReplyUserId:@""];
                return YES;//return YES,收起键盘
            }else{
                NSLog(@"显示提示框-请输入要评论的的内容");
                return NO;//return NO,不收键盘
            }
        }];
        
        
    }];
    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_operationMenu];

    [self.AllDetailsBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    
    _operationMenu.sd_layout
    .rightSpaceToView(_operationButton, 10)
    .heightIs(30)
    .centerYEqualToView(_operationButton)
    .widthIs(0);
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    /**
     *判断如果点击的是tableView的cell，就把手势给关闭了 不是点击cell手势开启
     **/
    NSLog(@"ouch.view class %@",[touch.view class]);
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (IBAction)TouchCellSelect:(id)sender {
    LPMoodDetailVC *vc = [[LPMoodDetailVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.moodListDataModel = self.model;
    vc.moodListArray = self.moodListArray;
    vc.SuperTableView = self.SuperTableView;
    
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}
-(void)ToCommentuchUpInside:(UITapGestureRecognizer *)recognizer{
    
    
}

-(void)TouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    //    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
    if (self.ContentType == 0) {
        LPReportVC *vc = [[LPReportVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.MoodModel = self.model;
        vc.SupermoodListArray = self.moodListArray;
        vc.SuperTableView = self.SuperTableView;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)TouchUpInsidePraise:(UITapGestureRecognizer *)recognizer{
    LPPraiseListVC *vc = [[LPPraiseListVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.Moodmodel = self.model;
    vc.SupermoodListArray = self.moodListArray;
    vc.SuperTableView = self.SuperTableView;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
  
}
- (IBAction)touchReport:(id)sender {
    
    UIAlertController *alertCont = [UIAlertController  alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *BlackAction = [UIAlertAction actionWithTitle:@"屏蔽该用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        if ([LoginUtils validationLogin:[UIWindow visibleViewController]]){
            if ([self.model.userId integerValue] ==[kUserDefaultsValue(LOGINID) integerValue]){
                [[UIWindow visibleViewController].view showLoadingMeg:@"不能屏蔽自己" time:MESSAGE_SHOW_TIME];
                return ;
            }
            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:[NSString stringWithFormat:@"是否屏蔽“%@”用户？",self.model.userName] message:nil textAlignment:0 buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                if (buttonIndex) {
                    NSLog(@"点击屏蔽用户");
                    [self requestQueryDefriendPullBlack];
                }
            }];
            [alert show];
        }
     }];
    UIAlertAction *ReportAction = [UIAlertAction actionWithTitle:@"举报内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        if ([LoginUtils validationLogin:[UIWindow visibleViewController]]){
            if ([self.model.userId integerValue] ==[kUserDefaultsValue(LOGINID) integerValue]){
                [[UIWindow visibleViewController].view showLoadingMeg:@"不能举报自己" time:MESSAGE_SHOW_TIME];
                return ;
            }
            LPReportContentVC *vc = [[LPReportContentVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.MoodModel = self.model;
            [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        }
    }];
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCont addAction:BlackAction];
    [alertCont addAction:ReportAction];
    [alertCont addAction:CancelAction];

    [[UIWindow visibleViewController] presentViewController:alertCont animated:YES completion:nil];
    
}

- (IBAction)touchPraise:(UIButton *)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        [self requestSocialSetlike];
    }
}

-(void)setModel:(LPMoodListDataModel *)model{
    _model = model;
    [self.userUrlImgView sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
    self.userNameLabel.text = model.userName;
    self.gradingLabel.text = [NSString stringWithFormat:@"(%@)",model.grading];
    self.timeLabel.text = [NSString compareCurrentTime:[model.time stringValue]];
    self.moodDetailsLabel.text = model.moodDetails;
    if ([[LPTools isNullToString:model.address] isEqualToString:@""] || [model.address isEqualToString:@"保密"]) {
        self.AddressLabel.text = @"";
        self.AddressImage.hidden = YES;
        self.Address_constraint_height.constant = 15;
    }else{
        self.AddressLabel.text = model.address;
        self.AddressImage.hidden = NO;
        self.Address_constraint_height.constant = 33;
    }
//    self.AddressLabel.text = model.address;
    self.viewLabel.text = model.view ? [model.view stringValue] : @"0";
    self.praiseTotalLabel.text = model.praiseTotal ? [model.praiseTotal stringValue] : @"0";
    self.commentTotalLabel.text = model.commentTotal ? [model.commentTotal stringValue] : @"0";
    self.moodDetailsLabel.lineBreakMode = NSLineBreakByClipping;
    self.praiseBt.selected = !model.isPraise.integerValue;
    self.gradingiamge.image = [UIImage imageNamed:model.grading];
//
//    if (model.score.integerValue >=0 && model.score.integerValue <3000) {
//        self.gradingiamge.image = [UIImage imageNamed:@"见习职工"];
//
//    }else if (model.score.integerValue >= 3000 && model.score.integerValue < 6000){
//        self.gradingiamge.image = [UIImage imageNamed:@"初级职工"];
//
//    }else if (model.score.integerValue >= 6000 && model.score.integerValue < 12000){
//        self.gradingiamge.image = [UIImage imageNamed:@"中级职工"];
//
//    }else if (model.score.integerValue >= 12000 && model.score.integerValue < 18000){
//        self.gradingiamge.image = [UIImage imageNamed:@"高级职工"];
//
//    }else if (model.score.integerValue >= 18000 && model.score.integerValue < 24000){
//        self.gradingiamge.image = [UIImage imageNamed:@"部门精英"];
//
//    }else if (model.score.integerValue >= 24000 && model.score.integerValue < 30000){
//        self.gradingiamge.image = [UIImage imageNamed:@"部门经理"];
//
//    }else if (model.score.integerValue >= 30000 && model.score.integerValue < 36000){
//        self.gradingiamge.image = [UIImage imageNamed:@"区域经理"];
//
//    }else if (model.score.integerValue >= 36000 && model.score.integerValue < 45000){
//        self.gradingiamge.image = [UIImage imageNamed:@"总经理"];
//
//    }else{
//        self.gradingiamge.image = [UIImage imageNamed:@"董事长"];
//
//    }
    
    self.moodDetailsLabel.lineBreakMode = NSLineBreakByCharWrapping;

     NSArray *array = [self getSeparatedLinesFromLabel:self.moodDetailsLabel];
     if (array.count>5) {
     
         self.AllDetailsBt.hidden = NO;
         self.imageBgView_constraint_Top.constant = 38;
         if (model.isOpening) { // 如果需要展开
              self.moodDetailsLabel.numberOfLines = 0;
             [self.AllDetailsBt setTitle:@"收起" forState:UIControlStateNormal];
         } else {
//             _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
             self.moodDetailsLabel.numberOfLines = 5;
             [self.AllDetailsBt setTitle:@"全文" forState:UIControlStateNormal];
         }
     }else{
         self.AllDetailsBt.hidden = YES;
         self.imageBgView_constraint_Top.constant = 8;
     }

    
    
    if ([model.userId integerValue] ==[kUserDefaultsValue(LOGINID) integerValue]){
        self.ReportBt.hidden = YES;
    }else{
        self.ReportBt.hidden = NO;
    }
    
    for (UIView *view in self.imageBgView.subviews) {
        [view removeFromSuperview];
    }
 
    if (kStringIsEmpty(model.moodUrl)) {
        self.imageBgView.hidden = YES;
        self.imageBgView_constraint_height.constant = 0;
    }else{
        self.imageViewsRectArray = [NSMutableArray array];
        self.imageBgView.hidden = NO;
        NSArray *imageArray = [model.moodUrl componentsSeparatedByString:@";"];
        CGFloat imgw = (SCREEN_WIDTH-70 - 10)/3;
        CGFloat imageHeight = 250.0;
        for (int i = 0; i < imageArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = imageArray.count ==1?CGRectMake(0,0,imageHeight,imageHeight): CGRectMake((imgw + 5)* (i%3), floor(i/3)*(imgw + 5), imgw, imgw);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
 
            NSInteger  downWidth= imageView.frame.size.width +100;
            NSString *imageStr;
            if (imageArray.count ==1) {
                imageStr = [NSString stringWithFormat:@"%@",imageArray[i]];

                if ([imageStr containsString:@".mp4"]) {
                    imageStr =[NSString stringWithFormat:@"%@?vframe/png/offset/0.001",imageStr];
                }
            }else{
               imageStr = [NSString stringWithFormat:@"%@?imageView2/3/w/%ld/h/%ld/q/100",imageArray[i],(long)downWidth,(long)downWidth];
            }
            
            if ([imageStr containsString:@".mp4"]) {
                UIImageView *palyBTImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlayImage"]];
                [imageView addSubview:palyBTImage];
                [palyBTImage mas_makeConstraints:^(MASConstraintMaker *make){
                    make.width.height.mas_offset(58);
                    make.center.equalTo(imageView);
                }];
            }
            
                [imageView yy_setImageWithURL:[NSURL URLWithString:[imageStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                  placeholder:[UIImage imageNamed:@"NoImage"]
                                      options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                                         NSLog(@"接收的当前接收大小%ld  总大小%ld",(long)receivedSize,expectedSize);
                                     }
                                    transform:^UIImage *(UIImage *image, NSURL *url) {
                                        return  image  ;
                                    }
                                   completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                       if (stage == YYWebImageStageFinished) {
                                           
                                       }
                                   }];
     
            
            [self.imageBgView addSubview:imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
            [imageView addGestureRecognizer:tap];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [self.imageViewsRectArray addObject:imageView];
            
        }
        self.imageArray = imageArray;
        if (imageArray.count ==1)
        {
            self.imageBgView_constraint_height.constant = imageHeight;
            self.imageBgView_constraint_right.constant = SCREEN_WIDTH-250-60;
        }
        else
        {
            self.imageBgView_constraint_height.constant = ceil(imageArray.count/3.0)*imgw + floor(imageArray.count/3)*5;
            if (imageArray.count<=2) {
                self.imageBgView_constraint_right.constant = SCREEN_WIDTH-imgw*imageArray.count-60;
            }else{
                self.imageBgView_constraint_right.constant = 11;
            }
        }
        
         LZImageBrowserManger *imageBrowserManger = [LZImageBrowserManger imageBrowserMangerWithUrlStr:self.imageArray originImageViews:self.imageViewsRectArray originController:[UIWindow visibleViewController] forceTouch:NO forceTouchActionTitles:@[] forceTouchActionComplete:^(NSInteger selectIndex, NSString *title) {
            NSLog(@"当前选中%ld--标题%@",(long)selectIndex, title);
        }];
        _imageBrowserManger = imageBrowserManger;
        
    }
    
    CGFloat CommentViewHeight = 0.0;
    
    //评价和点赞view
    for (UIView *view in self.CommentView.subviews) {
        if (view != self.TriangleView) {
            [view removeFromSuperview];
        }
    }
    
    //   点赞人名称
    NSString *PraiseStr = @"";
    if (model.praiseList.count) {
        PraiseStr = @"♡ ";
        if (model.praiseList.count>10) {
            for (int i = 0 ;i <10 ;i++ ) {
                PraiseStr = [NSString stringWithFormat:@"%@%@、",PraiseStr,model.praiseList[i].userName];
            }
        }else{
            for (LPMoodPraiseListDataModel *Pmodel in model.praiseList ) {
                PraiseStr = [NSString stringWithFormat:@"%@%@、",PraiseStr,Pmodel.userName];
            }
        }
        PraiseStr = [PraiseStr substringToIndex:PraiseStr.length -1];
        
        
        UILabel *label = [[UILabel alloc]init];
        label.tag = 10000;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.text =[PraiseStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
         if (model.praiseList.count>10) {
            NSString *PingStr = [NSString stringWithFormat:@"等%lu人觉得很赞",(unsigned long)model.praiseList.count];
 
            NSString *LabelShowText;
 
            LabelShowText = [NSString stringWithFormat:@"%@%@", PraiseStr, PingStr];

            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:LabelShowText];
            NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
            paraStyle01.lineBreakMode = NSLineBreakByCharWrapping;

            [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],
                                    NSParagraphStyleAttributeName:paraStyle01,
                                    NSForegroundColorAttributeName:[UIColor baseColor]
                                    }
                            range:NSMakeRange(0, string.length-PingStr.length)];

            label.attributedText = string;//切记使用富文本，颜色可以自由发挥了
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:TextFont];//这个很重要,必须写在富文本下面
            [self.CommentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(7);
                make.left.mas_equalTo(7);
                make.right.mas_equalTo(-7);
            }];

            NSMutableArray *ClickedArray = [[NSMutableArray alloc] init];
            for (LPMoodPraiseListDataModel *Pmodel in model.praiseList ) {
                [ClickedArray addObject:Pmodel.userName];
            }
            WEAK_SELF()
            [label yb_addAttributeTapActionWithStrings:@[LabelShowText] tapClicked:^(UILabel *label,NSString *string, NSRange range, NSInteger index) {
                NSLog(@"string = %@  index = %ld ",string,(long)index );
                LPPraiseListVC *vc = [[LPPraiseListVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.Moodmodel = weakSelf.model;
                vc.SupermoodListArray = weakSelf.moodListArray;
                vc.SuperTableView = weakSelf.SuperTableView;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }];
            label.enabledTapEffect = NO;

            
           CommentViewHeight += [self hideLabelLayoutHeight:PraiseStr withTextFontSize:13]+7;
            
        }else{
//            PraiseStr = [PraiseStr substringToIndex:PraiseStr.length-1];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:PraiseStr];
            NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];  paraStyle01.lineBreakMode = NSLineBreakByCharWrapping;

            [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],
                                    NSParagraphStyleAttributeName:paraStyle01,
                                    NSForegroundColorAttributeName:[UIColor baseColor]}
                            range:NSMakeRange(0, string.length)];
            
            label.attributedText = string;//切记使用富文本，颜色可以自由发挥了
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:TextFont];//这个很重要,必须写在富文本下面
            [self.CommentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(7);
                make.left.mas_equalTo(7);
                make.right.mas_equalTo(-7);
            }];
            
            NSMutableArray *ClickedArray = [[NSMutableArray alloc] init];
            for (LPMoodPraiseListDataModel *Pmodel in model.praiseList ) {
                [ClickedArray addObject:Pmodel.userName];
            }
            WEAK_SELF()
            [label yb_addAttributeTapActionWithStrings:@[PraiseStr] tapClicked:^(UILabel *label,NSString *string, NSRange range, NSInteger index) {
                LPPraiseListVC *vc = [[LPPraiseListVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.Moodmodel = weakSelf.model;
                vc.SupermoodListArray = weakSelf.moodListArray;
                vc.SuperTableView = weakSelf.SuperTableView;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }];
            label.enabledTapEffect = NO;

            CommentViewHeight += [self hideLabelLayoutHeight:PraiseStr withTextFontSize:13] +7;

        }
 
        
     }else{
        
    }
    
    //评论
    if (model.commentModelList.count) {
        UILabel *label = [self.CommentView viewWithTag:10000];
        label.enabledTapEffect = NO;
        if (label) {//加线
            UIView *lineView = [[UIView alloc] init];
            [self.CommentView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label.mas_bottom).offset(7);
                make.left.mas_equalTo(7);
                make.right.mas_equalTo(-7);
                make.height.mas_offset(0.5);
            }];
            lineView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.9];
        }
        
        UILabel *TopComment ;
        for (int i =0; i < model.commentModelList.count; i++) {
            LPMoodCommentListDataModel   *CModel = model.commentModelList[i];
            
            UILabel *commentLabel = [[UILabel alloc] init];
            commentLabel.tag = 1000+i;
            commentLabel.copyable = YES;
            //评论复制处理
            WEAK_SELF()
            commentLabel.CopyBlock = ^(UILabel *Label){
                UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
                pastboard.string = weakSelf.model.commentModelList[Label.tag-1000].commentDetails;
            };
 
            if (CModel.userId.integerValue == kUserDefaultsValue(LOGINID).integerValue) {
                commentLabel.Deleteable = YES;
                
                commentLabel.DeleteBlock = ^(UILabel *Label){
                    NSLog(@"删除评论 %@",Label.text);
                    [weakSelf requestQueryDeleteComment:weakSelf.model.commentModelList[Label.tag-1000].id];
                };
            }

            NSString *CommentStr;
            
            if (CModel.toUserName) {        //回复
                CommentStr = [NSString stringWithFormat:@"%@ 回复 %@:%@",CModel.userName,CModel.toUserName,CModel.commentDetails];
             }else{      //评论
                 CommentStr = [NSString stringWithFormat:@"%@:%@",CModel.userName,CModel.commentDetails];
            }
           
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:CommentStr];
            NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
            paraStyle01.lineBreakMode = NSLineBreakByCharWrapping;
            if (CModel.toUserName) {
                [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],
                                        NSParagraphStyleAttributeName:paraStyle01,
                                        NSForegroundColorAttributeName:[UIColor baseColor]}
                                range:NSMakeRange(0, CModel.userName.length)];
                
                [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],
                                        NSParagraphStyleAttributeName:paraStyle01,
                                        NSForegroundColorAttributeName:[UIColor baseColor]}
                                range:NSMakeRange(CModel.userName.length+4, CModel.toUserName.length+1)];
                
            }else{
                [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],
                                        NSParagraphStyleAttributeName:paraStyle01,
                                        NSForegroundColorAttributeName:[UIColor baseColor]}
                                range:NSMakeRange(0, CModel.userName.length+1)];
            }

            
            commentLabel.attributedText = string;//切记使用富文本，颜色可以自由发挥了
            commentLabel.numberOfLines = 0;
            commentLabel.font = [UIFont systemFontOfSize:TextFont];//这个很重要,必须写在富文本下面
            [self.CommentView addSubview:commentLabel];
            
            if (label) {
                [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (i==0) {
                        make.top.equalTo(label.mas_bottom).offset(14);
                    }else{
                        make.top.equalTo(TopComment.mas_bottom).offset(7);
                    }
                    make.left.mas_equalTo(7);
                    make.right.mas_equalTo(-7);
                }];
            }else{
                [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (i==0) {
                        make.top.mas_equalTo(7);
                    }else{
                        make.top.equalTo(TopComment.mas_bottom).offset(7);
                    }
                    make.left.mas_equalTo(7);
                    make.right.mas_equalTo(-7);
                }];
            }
            
            


            
            NSArray *ClickArray;
            if (CModel.toUserName) {        //回复
                ClickArray = @[CModel.userName,CModel.toUserName];
            }else{      //评论
                ClickArray = @[CModel.userName];
            }
            
            [commentLabel yb_addAttributeTapActionWithStrings:ClickArray delegate:self];
 
            
            UITapGestureRecognizer *TapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchUpInsidecommentLabel:)];
            //            TapGestureRecognizer.delegate = self;
            TapGestureRecognizer.cancelsTouchesInView = NO;
            //            commentLabel.userInteractionEnabled = YES;
            [commentLabel addGestureRecognizer:TapGestureRecognizer];

            
//            [commentLabel yb_addAttributeTapActionWithStrings:ClickArray tapClicked:^(NSString *string, NSRange range, NSInteger index) {
//                NSLog(@"%@ %ld",string,(long)commentLabel.tag);
//
//                NSInteger ControllerCount = 0 ;
//                 for (RTContainerController *v in [UIWindow visibleViewController].navigationController.viewControllers) {
//                    if ([v.contentViewController isKindOfClass:[LPReportVC class]]) {
//                        ControllerCount +=1;
//                    }
//                }
//                if (ControllerCount >= 3) {
//                    [LPTools AlertMessageView:@"当前页面跳转过深，请回退！"];
//                    return;
//                }
//
//                LPMoodListDataModel *Moodmodel = [[LPMoodListDataModel alloc] init];
//                LPMoodCommentListDataModel *CModel = weakSelf.model.commentModelList[commentLabel.tag -1000];
//                     if (index == 0) {
//                        Moodmodel.userId = @(CModel.userId.integerValue);
//                        Moodmodel.userName = CModel.userName;
//                        Moodmodel.identity = CModel.identity;
//                    }else{
//                        Moodmodel.userId = @(CModel.toUserId.integerValue);
//                        Moodmodel.userName = CModel.toUserName;
//                        Moodmodel.identity = CModel.toUserIdentity;
//                    }
//                LPReportVC *vc = [[LPReportVC alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                vc.MoodModel = Moodmodel;
//                vc.SupermoodListArray = self.moodListArray;
//                vc.SuperTableView = self.SuperTableView;
//                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//
//            }];
            TopComment = commentLabel;
            commentLabel.enabledTapEffect = NO;

            CommentViewHeight += [self hideLabelLayoutHeight:CommentStr withTextFontSize:13] +7;

        }
        
        if (model.commentModelList.count>=5) {
            UILabel *commentAllLabel = [[UILabel alloc] init];
            [self.CommentView addSubview:commentAllLabel];
            [commentAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(TopComment.mas_bottom).offset(7);
                make.left.mas_equalTo(7);
                //                    make.right.mas_equalTo(-7);
            }];
            commentAllLabel.font = [UIFont systemFontOfSize:13];
            commentAllLabel.text = @"查看所有评论";
            commentAllLabel.textColor = [UIColor baseColor];
            UIImageView *CommentAllImage = [[UIImageView alloc] init];
            [self.CommentView addSubview:CommentAllImage];
            [CommentAllImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(commentAllLabel);
                make.left.equalTo(commentAllLabel.mas_right).offset(6);
                make.height.mas_equalTo(10);
                make.width.mas_equalTo(10);
            }];
            CommentAllImage.image = [UIImage imageNamed:@"CommentAllImage"];
            CommentViewHeight += 23;
            [commentAllLabel yb_addAttributeTapActionWithStrings:@[@"查看所有评论"] tapClicked:^(UILabel *label,NSString *string, NSRange range, NSInteger index) {
                LPMoodDetailVC *vc = [[LPMoodDetailVC alloc]init];
                 vc.hidesBottomBarWhenPushed = YES;
                vc.moodListDataModel = model;
                vc.moodListArray = self.moodListArray;
                vc.SuperTableView = self.SuperTableView;
                
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                
            }];
            
            commentAllLabel.enabledTapEffect = NO;

        }
        CommentViewHeight += 7;
    }else{
        
    }
   
//    self.CommentView_constraint_height.constant = floor(CommentViewHeight);

        self.CommentView_constraint_height.constant = floor([self calculateCommentHeight:model]-14);

    if (self.CommentView_constraint_height.constant >0) {
        self.TriangleView.hidden = NO;
     }else{
         self.TriangleView.hidden = YES;
     }
}


#pragma mark - YBAttributeTapActionDelegate
- (void)yb_tapAttributeInLabel:(UILabel *)label string:(NSString *)string range:(NSRange)range index:(NSInteger)index{
    NSLog(@"%@",string);
//    [XHInputView bgViewClick];
    self.TapAction = YES;
            NSInteger ControllerCount = 0 ;
             for (RTContainerController *v in [UIWindow visibleViewController].navigationController.viewControllers) {
                if ([v.contentViewController isKindOfClass:[LPReportVC class]]) {
                    ControllerCount +=1;
                }
            }
            if (ControllerCount >= 3) {
                [LPTools AlertMessageView:@"当前页面跳转过深，请回退！"];
                return;
            }

            LPMoodListDataModel *Moodmodel = [[LPMoodListDataModel alloc] init];
            LPMoodCommentListDataModel *CModel = self.model.commentModelList[label.tag -1000];
                 if (index == 0) {
                    Moodmodel.userId = @(CModel.userId.integerValue);
                    Moodmodel.userName = CModel.userName;
                    Moodmodel.identity = CModel.identity;
                }else{
                    Moodmodel.userId = @(CModel.toUserId.integerValue);
                    Moodmodel.userName = CModel.toUserName;
                    Moodmodel.identity = CModel.toUserIdentity;
                }
            LPReportVC *vc = [[LPReportVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.MoodModel = Moodmodel;
            vc.SupermoodListArray = self.moodListArray;
            vc.SuperTableView = self.SuperTableView;
            [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}




-(void)TouchUpInsidecommentLabel:(UITapGestureRecognizer *)recognizer{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)recognizer;
    UILabel *commentLabel = (UILabel *)[singleTap view];
    
    self.TapAction = NO;
    LPMoodCommentListDataModel   *CModel = self.model.commentModelList[commentLabel.tag - 1000];
    
    commentLabel.backgroundColor = [UIColor colorWithHexString:@"#d1d1d1"];
    WEAK_SELF()
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        commentLabel.backgroundColor = [UIColor clearColor];
        if (weakSelf.TapAction == NO) {
         
            if (!AlreadyLogin) {
                [LPTools AlertMessageCommentLoginView];
                return ;
            }
            
                [XHInputView showWithStyle:InputViewStyleLarge configurationBlock:^(XHInputView *inputView) {
                    
                    /** 占位符文字 */
                    inputView.placeholder = [NSString stringWithFormat:@"回复 %@:",CModel.userName];
                    /** 设置最大输入字数 */
                    inputView.maxCount = 300;
                    /** 输入框颜色 */
                    inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
                    
                } sendBlock:^BOOL(NSString *text) {
                    if(text.length){
                        [weakSelf requestCommentAddcomment:text
                                               CommentType:3
                                                 CommentId:CModel.commentType.integerValue==2? CModel.id:CModel.commentId
                                          selectCommentRow:commentLabel.tag - 1000
                                               ReplyUserId:CModel.userId];
                        return YES;//return YES,收起键盘
                    }else{
                        NSLog(@"显示提示框-请输入要评论的的内容");
                        return NO;//return NO,不收键盘
                    }
                }];

            
        }
        
    });

}


- (IBAction)TouchAllDetailsBt:(id)sender {
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}


-(void)selectImage:(UITapGestureRecognizer *)sender{
    
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSInteger index = [singleTap view].tag;
    if ([self.imageArray[index] containsString:@".mp4"]) {
        if (self.VideoBlock) {
            self.VideoBlock(self.imageArray[index],(UIImageView *)singleTap.view);
        }
        return;
    }
    _imageBrowserManger.selectPage = singleTap.view.tag;
    [_imageBrowserManger showImageBrowser];
 
    
}
- (UIViewController *)viewController
{
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass:[UIViewController class]])
            return (UIViewController *)responder;
    // If the view controller isn't found, return nil.
    return nil;
}

-(void)DownLoadImage:(UIButton *)sender{
    UIImageView *V =(UIImageView *)[sender.superview viewWithTag:100];
    [self saveImage:V.image];
}

// 处理拖拉手势
- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (view.frame.size.width<=SCREEN_WIDTH) {
        return;
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}
// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}
//保证拖动手势和UIScrollView上的拖动手势互不影响
-(BOOL)gestureRecognizer:(UIGestureRecognizer*) gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer
{
    if ([gestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    NSString *imageStr = self.imageArray[index];
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    [self.touchImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"headPlaceholder"]];
    self.pageControl.currentPage = index;
    if (self.viewController) {
        if ([self.viewController isKindOfClass:[UIViewController class]]) {
            UITableView* tableView = self.tableView;
            UIWindow* window = [UIApplication sharedApplication].keyWindow;
            CGRect rectInbg = [self.imageBgView convertRect:self.imageViewsRectArray[index].frame toView:self];
            // convert rect to self(cell)
            CGRect rectInCell = [self.contentView convertRect:rectInbg toView:self];
            // convert rect to tableview
            CGRect rectInTableView = [self convertRect:rectInCell toView:tableView];//self.superview
            // convert rect to window
            self.imageRect  = [tableView convertRect:rectInTableView toView:window];
        }
    }
}
-(void)closeImageScroll{
    self.touchImage.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.alpha = 0;
        for (UIView *view in self.scrollView.subviews) {
            [view removeFromSuperview];
        }
        self.touchImage.frame = self.imageRect;
        [self.pageControl removeFromSuperview];
        
    } completion:^(BOOL finished) {
        [self.scrollView removeFromSuperview];
        [self.touchImage removeFromSuperview];
    }];
}


- (UITableView *)tableView{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - request

-(void)requestQueryDefriendPullBlack{
    NSDictionary *dic = @{@"identity":[LPTools isNullToString:self.model.identity],
                          @"type":@"1"
                          };
    [NetApiManager requestQueryDefriendPullBlack:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] == 1 && [responseObject[@"code"] integerValue] == 0) {
                if (self.Block) {
                    self.Block();
                }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestSocialSetlike{
    NSDictionary *dic = @{
                          @"type":@(2),
                          @"id":self.model.id
                          };
    [NetApiManager requestSocialSetlikeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (!ISNIL(responseObject[@"data"])) {
                    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
                    if ([responseObject[@"data"] integerValue] == 0) {
                        self.praiseBt.selected = YES;
                        self.model.praiseTotal = @(self.model.praiseTotal.integerValue+1);
                        self.model.isPraise = @([responseObject[@"data"] integerValue]);
                        LPMoodPraiseListDataModel *Pmodel = [[LPMoodPraiseListDataModel alloc] init];
                        Pmodel.grading = user.data.grading;
                        Pmodel.role = user.data.role;
                        Pmodel.userId = kUserDefaultsValue(LOGINID);
                        Pmodel.userName = user.data.user_name;
                        Pmodel.userImage = user.data.user_url;
                        Pmodel.phone = user.data.userTel;
                        
                        [self.model.praiseList insertObject:Pmodel atIndex:0];
                        
                    }else if ([responseObject[@"data"] integerValue] == 1) {
                        self.praiseBt.selected = NO;
                        self.model.praiseTotal = @(self.model.praiseTotal.integerValue-1);
                        self.model.isPraise = @([responseObject[@"data"] integerValue]);
                        for (LPMoodPraiseListDataModel *m in self.model.praiseList) {
                            if (m.userId == kUserDefaultsValue(LOGINID)) {
                                [self.model.praiseList removeObject:m];
                                break;
                            }
                        }
                    }
                    
                    for (int i =0 ; i < self.moodListArray.count ; i++) {
                        LPMoodListDataModel *DataModel = self.moodListArray[i];
                        if (DataModel.id.integerValue == self.model.id.integerValue) {
                            DataModel.praiseList = self.model.praiseList;
                            DataModel.isPraise = self.model.isPraise;
                            DataModel.praiseTotal = self.model.praiseTotal;
                            break;
                        }
                    }
                    if (self.SuperTableView) {
                        [self.SuperTableView reloadData];
                    }
                    
                    if (self.PraiseBlock) {
                        self.PraiseBlock();
                    }
                }
            }else{
                [[UIWindow  visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            

        }else{
            [[UIWindow  visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    } IsShowActiviTy:YES];
}



-(void)requestQueryDeleteComment:(NSString *) CommentId{
 
    NSString * appendURLString = [NSString stringWithFormat:@"comment/update_comment?id=%@&moodId=%@&versionType=2.3",CommentId,self.model.id];
    
    [NetApiManager requestQueryDeleteComment:nil URLString:appendURLString withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"][@"result"] integerValue] == 1) {
                    NSMutableArray <LPMoodCommentListDataModel *>*CommArr = [LPMoodCommentListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"commentList"]];
                    self.model.commentModelList =  CommArr;
                    for (int i =0 ; i < self.moodListArray.count ; i++) {
                        LPMoodListDataModel *DataModel = self.moodListArray[i];
                        if (DataModel.id.integerValue == self.model.id.integerValue) {
                            DataModel.commentModelList = CommArr;
                            break;
                        }
                    }
                    if (self.SuperTableView) {
                        [self.SuperTableView reloadData];
                    }
                    
                    if (self.PraiseBlock) {
                        self.PraiseBlock();
                    }
 
                }else{
                    [[UIWindow  visibleViewController].view showLoadingMeg:@"删除失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIWindow  visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow  visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        
    }];
}


-(void)requestCommentAddcomment:(NSString *) commentText
                    CommentType:(NSInteger) commentType
                      CommentId:(NSString *)commentId
               selectCommentRow:(NSInteger) CommentRow
                    ReplyUserId:(NSString *) ReplyUserId{
    
    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
    NSDictionary *dic = @{@"commentDetails": commentText,
                          @"commentType": @(commentType),
                          @"commentId": commentId,
                          @"userName": user.data.user_name,
                          @"userId": kUserDefaultsValue(LOGINID),
                          @"userUrl": user.data.user_url,
                          @"versionType":@"2.1",
                          @"replyUserId":ReplyUserId
                          };
    [NetApiManager requestCommentAddcommentWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSString *StrData = [LPTools isNullToString:responseObject[@"data"]];
                NSArray *DataList = [StrData componentsSeparatedByString:@"-"];
                
                LPCommentListDataModel *m = [LPCommentListDataModel mj_objectWithKeyValues:dic];
                if (DataList.count>=2) {
                    if ([DataList[0] integerValue] ==1) {
                        [LPTools AlertTopCommentView:@""];
                    }else{
                        
                    }
                    m.id = @([[LPTools isNullToString:DataList[1]] integerValue]);
                }
                
                //评价圈子列表里面的评论列表
 
                LPMoodCommentListDataModel *CommentModel = [LPMoodCommentListDataModel mj_objectWithKeyValues:dic];
              
                CommentModel.identity = kUserDefaultsValue(USERIDENTIY);
                CommentModel.id = [LPTools isNullToString:DataList[1]];

                if (commentType == 2) {
                    [self.model.commentModelList insertObject:CommentModel atIndex:0];
                }else if (commentType == 3){
                    LPMoodCommentListDataModel *m = self.model.commentModelList[CommentRow];
                    CommentModel.toUserId = m.userId;
                    CommentModel.toUserName = m.userName;
                    CommentModel.toUserIdentity = m.identity;
//                    [self.model.commentModelList insertObject:CommentModel atIndex:CommentRow+1];
                    for (NSInteger i = 0 ;i<self.model.commentModelList.count;i++ ) {
                        LPMoodCommentListDataModel *m = self.model.commentModelList[i];
                        if ((m.commentType.integerValue == 2 && m.id == CommentModel.commentId) ||
                            (m.commentType.integerValue == 3 && m.commentId == CommentModel.commentId)) {
                            [self.model.commentModelList insertObject:CommentModel atIndex:i];
                            break;
                        }
                    }
                    
                }

            
            if (self.SuperTableView) {
                [self.SuperTableView reloadData];
            }
            
            if (self.PraiseBlock) {
                self.PraiseBlock();
            }
 
            }else{
                if ([responseObject[@"code"] integerValue] == 10045) {
                    [LPTools AlertMessageView:responseObject[@"msg"]];
                }else{
                    [[UIWindow  visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }
            
        }else{
            [[UIWindow  visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


- (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];  paraStyle01.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paraStyle01,
                                  };
    
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
//    NSLog(@"屏幕宽度 = %f,   rect = %f",SCREEN_WIDTH,rect.size.width);
//    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
//    paraStyle01.lineBreakMode = NSLineBreakByCharWrapping;
//    [attStr addAttributes:@{NSParagraphStyleAttributeName:paraStyle01,
//                            NSFontAttributeName:[UIFont systemFontOfSize:15.0],
//                            }range:NSMakeRange(0, attStr.length)];
//    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];

    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CGPathAddRect(path, NULL, CGRectMake(0,0,SCREEN_WIDTH-78,100000));

    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return linesArray;
}


//image是要保存的图片
- (void) saveImage:(UIImage *)image{
     if (image) {
  
             PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
             if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied
                 )
             {
                 // 无权限
                 [LPTools AlertMessageView:@"您没有开启相册访问权限,请您去手机设置页面开启"];
//                 [[UIWindow visibleViewController].view showLoadingMeg:@"您没有开启相册访问权限,请您去手机设置页面开启" time:MESSAGE_SHOW_TIME];
                 return;
             }
 
         UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
     };
 }
//保存完成后调用的方法
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存图片出错%@", error.localizedDescription);
        [[UIWindow visibleViewController].view showLoadingMeg:@"保存图片失败,请稍后再试" time:MESSAGE_SHOW_TIME];
        [LPTools AlertMessageView:@"保存图片失败,请稍后再试"];
    }
    else {
        NSLog(@"保存图片成功");
        [LPTools AlertMessageView:@"保存图片成功"];
     }
}


//点赞弹窗
- (void)operationButtonClicked
{
    [self postOperationButtonClickedNotification];
    _operationMenu.Praise = self.model.isPraise.integerValue;
    _operationMenu.show = !_operationMenu.isShowing;
}
- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSDTimeLineCellOperationButtonClickedNotification object:_operationButton];
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != _operationButton && _operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}



- (NSInteger)hideLabelLayoutHeight:(NSString *)content withTextFontSize:(CGFloat)mFontSize
{
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
////    paragraphStyle.lineSpacing = 10;  // 段落高度
//    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithString:content];
//    [attributes addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:mFontSize] range:NSMakeRange(0, content.length)];
//    [attributes addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
//    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-73-14, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
//    return attSize.height;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:mFontSize]};
    /*计算高度要先指定宽度*/
    CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70-14, 0) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return ceil(rect.size.height);
}
- (CGFloat)calculateCommentHeight:(LPMoodListDataModel *)model
{
    CGFloat Praiseheighe = 0.0;
    if (model.praiseList.count) {
        NSString *PraiseStr = @"♡ ";
        if (model.praiseList.count>10) {
            for (int i = 0 ;i <10 ;i++ ) {
                PraiseStr = [NSString stringWithFormat:@"%@%@、",PraiseStr,model.praiseList[i].userName];
            }
            PraiseStr = [PraiseStr substringToIndex:PraiseStr.length -1];
            PraiseStr = [NSString stringWithFormat:@"%@等%lu人觉得很赞",PraiseStr,model.praiseList.count];
        }else{
            for (LPMoodPraiseListDataModel *Pmodel in model.praiseList ) {
                PraiseStr = [NSString stringWithFormat:@"%@%@、",PraiseStr,Pmodel.userName];
            }
            PraiseStr = [PraiseStr substringToIndex:PraiseStr.length -1];
        }
 
        Praiseheighe = [LPTools calculateRowHeight:PraiseStr fontSize:13 Width:SCREEN_WIDTH-70-14];
//        Praiseheighe = Praiseheighe >48 ?48:Praiseheighe;
        Praiseheighe = Praiseheighe + 14;
    }else{
        Praiseheighe = 0.0;
    }
    
    CGFloat commentheighe = 0.0;
    if (model.commentModelList.count) {
        
        for (int i =0; i < model.commentModelList.count; i++) {
            LPMoodCommentListDataModel   *CModel = model.commentModelList[i];
            NSString *CommentStr;
            if (CModel.toUserName) {        //回复
                CommentStr = [NSString stringWithFormat:@"%@ 回复 %@:%@",CModel.toUserName,CModel.userName,CModel.commentDetails];
            }else{      //评论
                CommentStr = [NSString stringWithFormat:@"%@:%@",CModel.userName,CModel.commentDetails];
            }
            commentheighe += [LPTools calculateRowHeight:CommentStr fontSize:13 Width:SCREEN_WIDTH-70-14]+7;
        }
        if (model.commentModelList.count >=5) {
            commentheighe += 23;
        }
        commentheighe += 7;
    }else{
        commentheighe = 0.0;
    }
    
    if (commentheighe || Praiseheighe) {
        return floor(commentheighe + Praiseheighe +16);
        
    }
    
    
    return floor(commentheighe + Praiseheighe);
}

 
@end
