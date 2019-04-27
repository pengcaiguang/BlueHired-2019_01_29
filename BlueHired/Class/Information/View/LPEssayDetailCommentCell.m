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

@interface LPEssayDetailCommentCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

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
    self.commentDetailsLabel.copyable = YES;
    
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
    if (model.commentList.count > 0) {
    
        [self.replyBgView addSubview:self.tableview];
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
//        self.replyBgView_constraint_height.constant = 27 * (model.commentList.count > 3 ? 3 : model.commentList.count);
        
        //计算tableviewheight
        CGFloat RowHeight = 0;
        for (int i = 0 ;i < model.commentList.count;i++) {
            RowHeight +=[self calculateRowHeight:[NSString stringWithFormat:@"%@:  %@",model.commentList[i].userName,model.commentList[i].commentDetails]
                                        fontSize:13 Width:SCREEN_WIDTH-78]+11;
        }
        self.replyBgView_constraint_height.constant = RowHeight;
        [self.tableview reloadData];
    }else{
        self.replyBgView_constraint_height.constant = 0;
    }
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.model.commentList.count > 3 ? 3 : self.model.commentList.count;
    return self.model.commentList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPEssayDetailCommentReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:LPEssayDetailCommentReplyCellID];
//    if (indexPath.row <= 1) {
//        cell.nameLabel.text = [NSString stringWithFormat:@"%@:",self.model.commentList[0].userName];
    cell.nameLabel.text = @"";
    NSString *str = [NSString stringWithFormat:@"%@: %@ ",self.model.commentList[indexPath.row].userName,self.model.commentList[indexPath.row].commentDetails];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.lineBreakMode = NSLineBreakByCharWrapping;
    [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold],
                            NSParagraphStyleAttributeName:paraStyle01,
                            NSForegroundColorAttributeName:[UIColor baseColor]}
                    range:NSMakeRange(0, self.model.commentList[indexPath.row].userName.length+1)];
//    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold] range:NSMakeRange(0, self.model.commentList[indexPath.row].userName.length+1)];//设置Text这四个字母的字体为粗体

    cell.contentLabel.attributedText = string;//切记使用富文本，颜色可以自由发挥了
    cell.contentLabel.numberOfLines = 0;
    cell.contentLabel.font = [UIFont systemFontOfSize:13];//这个很重要,必须写在富文本下面
//    }else{
//        cell.nameLabel.text = @"";
//        cell.contentLabel.text = [NSString stringWithFormat:@"查看全部%ld条回复➡️",self.model.commentList.count];
//    }
    
    LPCommentListDataModel *m = self.model.commentList[indexPath.row];
    cell.contentLabel.copyable  = YES;
    if (m.userId.integerValue == kUserDefaultsValue(LOGINID).integerValue) {
        cell.contentLabel.Deleteable = YES;
        WEAK_SELF()
        cell.contentLabel.DeleteBlock = ^(UILabel *Label){
            NSLog(@"删除评论 %@",Label.text);
            if (weakSelf.DeleteBlock) {
                weakSelf.DeleteBlock([NSString stringWithFormat:@"%@",m.id]);
            }
            //            [weakSelf requestQueryDeleteComment:weakSelf.model.id];
        };
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 2) {
        NSLog(@"查看全部");
//        LPCommentDetailVC *vc = [[LPCommentDetailVC alloc]init];
//        vc.commentListDatamodel = self.model;
//        vc.superTabelView = self.tableview;
//        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//    }
}

//-(void)addReply{
//    [self.replyView addSubview:self.nameLabel];
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(5);
//        make.top.mas_equalTo(5);
//    }];
//
//    [self.replyView addSubview:self.contentLabel];
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(5);
//        make.right.mas_equalTo(-5);
//        make.bottom.mas_equalTo(-5);
//        make.left.equalTo(self.nameLabel.mas_right).offset(5);
//    }];
//    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];  //设置水平方向抗压缩优先级高 水平方向可以正常显示
//    [self.contentLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];  //设置垂直方向挤压缩优先级高 垂直方向可以正常显示
//
//}


#pragma mark - lazy
//-(UIView *)replyView{
//    if (!_replyView) {
//        _replyView = [[UIView alloc]init];
//    }
//    return _replyView;
//}
//
//-(UILabel *)nameLabel{
//    if (!_nameLabel) {
//        _nameLabel = [[UILabel alloc]init];
//        _nameLabel.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
//        _nameLabel.font = [UIFont systemFontOfSize:13];
//    }
//    return _nameLabel;
//}
//-(UILabel *)contentLabel{
//    if (!_contentLabel) {
//        _contentLabel = [[UILabel alloc]init];
//        _contentLabel.textColor = [UIColor colorWithHexString:@"#444444"];
//        _contentLabel.font = [UIFont systemFontOfSize:13];
//        _contentLabel.numberOfLines = 0;
//    }
//    return _contentLabel;
//}


- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.scrollEnabled = NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPEssayDetailCommentReplyCellID bundle:nil] forCellReuseIdentifier:LPEssayDetailCommentReplyCellID];

    }
    return _tableview;
}

- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize Width:(CGFloat) W
{
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paraStyle01};
    /*计算高度要先指定宽度*/
    CGRect rect = [string boundingRectWithSize:CGSizeMake(W, 0) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return ceil(rect.size.height);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
