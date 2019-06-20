//
//  LPEssayDetailCommentCell.m
//  BlueHired
//
//  Created by peng on 2018/9/3.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPEssayDetailCommentCell.h"
#import "LPEssayDetailCommentReplyCell.h"
#import "LPCommentDetailVC.h"

static NSString *LPEssayDetailCommentReplyCellID = @"LPEssayDetailCommentReplyCell";

@interface LPEssayDetailCommentCell ()
//@property (nonatomic, strong)UITableView *tableview;

//@property(nonatomic,strong) UIView *replyView;
//@property(nonatomic,strong) UILabel *nameLabel;
//@property(nonatomic,strong) UILabel *contentLabel;
@end

@implementation LPEssayDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.replyButton.layer.borderWidth = 0.5;
    self.replyButton.layer.borderColor = [UIColor colorWithHexString:@"#939393"].CGColor;
 
    
    self.replyBgView.userInteractionEnabled=YES;
 
    
}
- (IBAction)touchReplyButton:(id)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        if ([self.delegate respondsToSelector:@selector(touchReplyButton:)]) {
            [self.delegate touchReplyButton:self.model];
        }
    }
}



-(void)setModel:(LPCommentListDataModel *)model{
    _model = model;
    [self.userUrlImgView sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
    self.gradingiamge.image = [UIImage imageNamed:model.grading];
     self.userNameLabel.text = model.userName;
    self.commentDetailsLabel.text = model.commentDetails;
    self.timeLabel.text = [NSString compareCurrentTime:[model.time stringValue]];
    
    self.commentDetailsLabel.copyable  = YES;
    self.commentDetailsLabel.Deleteable = NO;
 
    if (model.userId.integerValue == kUserDefaultsValue(LOGINID).integerValue) {
        self.commentDetailsLabel.Deleteable = YES;
        WEAK_SELF()
        self.commentDetailsLabel.DeleteBlock = ^(UILabel *Label){
            NSLog(@"删除评论 %@",Label.text);
            if (weakSelf.DeleteBlock) {
                weakSelf.DeleteBlock([NSString stringWithFormat:@"%@",model.id]);
            }
//            [weakSelf requestQueryDeleteComment:weakSelf.model.id];
         };
    }
    
    for (UIView *view in self.replyBgView.subviews) {
        [view removeFromSuperview];
    }
    if (model.commentModelList.count > 0) {
    
//        [self.replyBgView addSubview:self.tableview];
//        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.top.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.bottom.mas_equalTo(0);
//        }];
//        self.replyBgView_constraint_height.constant = 27 * (model.commentList.count > 3 ? 3 : model.commentList.count);
        
        //计算tableviewheight
        
        NSMutableArray *CommentArray = [[NSMutableArray alloc] init];
        
        CGFloat RowHeight = 0;
        for (int i = 0 ;i < model.commentModelList.count;i++) {
            LPCommentListDataModel *m = model.commentModelList[i];
            UILabel *commentLabel = [[UILabel alloc] init];
            commentLabel.tag = i;
            [self.replyBgView addSubview:commentLabel];
            [CommentArray addObject:commentLabel];
 
            commentLabel.copyable  = YES;
            if (m.userId.integerValue == kUserDefaultsValue(LOGINID).integerValue) {
                commentLabel.Deleteable = YES;
                WEAK_SELF()
                commentLabel.DeleteBlock = ^(UILabel *Label){
                    NSLog(@"删除评论 %@",Label.text);
                    if (weakSelf.DeleteBlock) {
                        weakSelf.DeleteBlock([NSString stringWithFormat:@"%@",m.id]);
                    }
                };
            }
            

            NSString *str = [NSString stringWithFormat:@"%@ 回复 %@: %@ ",
                             m.userName,
                             m.toUserName,
                             m.commentDetails];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
            NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
            paraStyle01.lineBreakMode = NSLineBreakByCharWrapping;
            [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold],
                                    NSParagraphStyleAttributeName:paraStyle01,
                                    NSForegroundColorAttributeName:[UIColor baseColor]}
                            range:NSMakeRange(0, m.userName.length)];
            
            [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0],
                                    NSParagraphStyleAttributeName:paraStyle01,
                                    NSForegroundColorAttributeName:[UIColor baseColor]}
                            range:NSMakeRange(m.userName.length+4, m.toUserName.length+1)];
            
            commentLabel.attributedText = string;   //切记使用富文本，颜色可以自由发挥了
            commentLabel.numberOfLines = 0;
            commentLabel.font = [UIFont systemFontOfSize:13];   //这个很重要,必须写在富文本下面
            UITapGestureRecognizer *TapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchUpInsidecommentLabel:)];
            TapGestureRecognizer.cancelsTouchesInView = NO;
            commentLabel.userInteractionEnabled=YES;
            [commentLabel addGestureRecognizer:TapGestureRecognizer];
            
            
            
            RowHeight +=[LPTools calculateRowHeight:[NSString stringWithFormat:@"%@ 回复 %@: %@ ",
                                                     m.userName,
                                                     m.toUserName,
                                                     m.commentDetails]
                                        fontSize:13 Width:SCREEN_WIDTH-79]+8;
        }
        
        if (CommentArray.count>1) {
            [CommentArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:8 leadSpacing:4 tailSpacing:4];
            [CommentArray mas_makeConstraints:^(MASConstraintMaker *make){
                make.right.mas_offset(-8);
                make.left.mas_offset(8);
            }];
        }else{
            [CommentArray mas_makeConstraints:^(MASConstraintMaker *make){
                make.right.mas_offset(-8);
                make.left.mas_offset(8);
                make.centerY.equalTo(self.replyBgView);
            }];
        }
       
        
        self.replyBgView_constraint_height.constant = RowHeight+8;
//        [self.tableview reloadData];
    }else{
        self.replyBgView_constraint_height.constant = 0;
    }
}



-(void)TouchUpInsidecommentLabel:(UITapGestureRecognizer *)recognizer{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)recognizer;
    UILabel *commentLabel = (UILabel *)[singleTap view];
    NSLog(@"+++点击啦第%ld行",(long)commentLabel.tag);
    
    if (!AlreadyLogin) {
        [LPTools AlertMessageCommentLoginView];
        return ;
    }
    
    LPCommentListDataModel *m = self.model.commentModelList[commentLabel.tag];
    
    commentLabel.backgroundColor = [UIColor colorWithHexString:@"#d1d1d1"];
    WEAK_SELF()
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        commentLabel.backgroundColor = [UIColor clearColor];
        
        [XHInputView showWithStyle:InputViewStyleLarge configurationBlock:^(XHInputView *inputView) {
            /** 占位符文字 */
            inputView.placeholder = [NSString stringWithFormat:@"回复 %@:",m.userName];
            /** 设置最大输入字数 */
            inputView.maxCount = 300;
            /** 输入框颜色 */
            inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
            
        } sendBlock:^BOOL(NSString *text) {
            if(text.length){
                [weakSelf requestCommentAddcomment:text
                                       CommentType:3
                                         CommentId:m.commentType.integerValue==2? [NSString stringWithFormat:@"%@",m.id]:[NSString stringWithFormat:@"%@",m.commentId]
                                  selectCommentRow:commentLabel.tag
                                       ReplyUserId:m.userId];
                return YES;//return YES,收起键盘
            }else{
                NSLog(@"显示提示框-请输入要评论的的内容");
                return NO;//return NO,不收键盘
            }
        }];

    });
    
}


#pragma mark - request
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
 
 
                m.identity = kUserDefaultsValue(USERIDENTIY);
                m.id = @([DataList[1] integerValue]);
        
                    LPCommentListDataModel *mComment = self.model.commentModelList[CommentRow];
                    m.toUserId = mComment.userId;
                    m.toUserName = mComment.userName;
                    m.toUserIdentity = mComment.identity;
                    [self.model.commentModelList addObject:m];

                if (self.AddBlock) {
                    self.AddBlock(m);
                }
                
                if (self.SuperTableView) {
                    [self.SuperTableView reloadData];
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

 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
