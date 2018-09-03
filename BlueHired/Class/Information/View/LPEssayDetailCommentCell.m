//
//  LPEssayDetailCommentCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/3.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPEssayDetailCommentCell.h"
#import "LPEssayDetailCommentReplyCell.h"

static NSString *LPEssayDetailCommentReplyCellID = @"LPEssayDetailCommentReplyCell";

@interface LPEssayDetailCommentCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) UIView *replyView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *contentLabel;
@end

@implementation LPEssayDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.replyButton.layer.borderWidth = 0.5;
    self.replyButton.layer.borderColor = [UIColor colorWithHexString:@"#939393"].CGColor;
}
- (IBAction)touchReplyButton:(id)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        
    }
}

-(void)setModel:(LPCommentListDataModel *)model{
    _model = model;
    [self.userUrlImgView sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"cricle_headimg_placeholder"]];
    self.userNameLabel.text = model.userName;
    self.commentDetailsLabel.text = model.commentDetails;
    self.timeLabel.text = [NSString compareCurrentTime:[model.time stringValue]];
    
    if (model.commentList.count > 0) {
    
        [self.replyBgView addSubview:self.tableview];
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        self.replyBgView_constraint_height.constant = 27 * (model.commentList.count > 3 ? 3 : model.commentList.count);
        
        [self.tableview reloadData];

        
//        for (int i = 0; i< model.commentList.count; i++) {
//            if (i == 0) {
//                [self.replyBgView addSubview:self.replyView];
//                [self addReply];
//                [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.mas_equalTo(0);
//                    make.left.mas_equalTo(0);
//                    make.right.mas_equalTo(0);
//                    make.bottom.mas_equalTo(0);
//                }];
//
//                self.nameLabel.text = [NSString stringWithFormat:@"%@:",model.commentList[0].userName];
//                //            self.contentLabel.text = model.commentList[0].commentDetails;
//                self.contentLabel.text = @"是你发互粉撒的身份萨达说 广安市广东省个挥洒胡歌萨达高送蛋糕。USA官方代购噶送蛋糕";
//            }else if (i == 1){
//                [self.replyBgView addSubview:self.replyView];
//                [self addReply];
//                [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.mas_equalTo(0);
//                    make.right.mas_equalTo(0);
//
//                    make.top.mas_equalTo(50);
//                    make.bottom.mas_equalTo(0);
//                }];
//
//                self.nameLabel.text = [NSString stringWithFormat:@"%@:",model.commentList[0].userName];
//                //            self.contentLabel.text = model.commentList[0].commentDetails;
//                self.contentLabel.text = @"是你发互粉撒的身份萨达说 广安市广东省个挥洒胡歌萨达高送蛋糕。USA官方代购噶送蛋糕";
//            }else{
//                return;
//            }
//        }
    
    }
    
//    self.replyBgView_constraint_height.constant = 50;
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.commentList.count > 3 ? 3 : self.model.commentList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPEssayDetailCommentReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:LPEssayDetailCommentReplyCellID];
    if (indexPath.row <= 1) {
        cell.nameLabel.text = [NSString stringWithFormat:@"%@:",self.model.commentList[0].userName];
        cell.contentLabel.text = self.model.commentList[indexPath.row].commentDetails;
    }else{
        cell.nameLabel.text = @"";
        cell.contentLabel.text = [NSString stringWithFormat:@"查看全部%ld条回复➡️",self.model.commentList.count];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
        NSLog(@"查看全部");
    }
}

-(void)addReply{
    [self.replyView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(5);
    }];
    
    [self.replyView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-5);
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
    }];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];  //设置水平方向抗压缩优先级高 水平方向可以正常显示
    [self.contentLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];  //设置垂直方向挤压缩优先级高 垂直方向可以正常显示
    
}


#pragma mark - lazy
-(UIView *)replyView{
    if (!_replyView) {
        _replyView = [[UIView alloc]init];
    }
    return _replyView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
        _nameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nameLabel;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#444444"];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}


- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPEssayDetailCommentReplyCellID bundle:nil] forCellReuseIdentifier:LPEssayDetailCommentReplyCellID];

    }
    return _tableview;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
