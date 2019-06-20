//
//  LPInformationMoreCell.m
//  BlueHired
//
//  Created by peng on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInformationMoreCell.h"
#import "LPInformationMoreImageCollectionViewCell.h"

static NSString *LPInformationMoreImageCollectionViewCellID = @"LPInformationMoreImageCollectionViewCell";

@interface LPInformationMoreCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) NSArray *imageArray;

@end

@implementation LPInformationMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.imgeBgView.layer.cornerRadius = 6;
    [self.imgeBgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imgeBgView);
    }];
    
}
-(void)setModel:(LPEssaylistDataModel *)model{
    _model = model;
    self.essayNameLabel.text = model.essayName;
    self.essayAuthorLabel.text = model.essayAuthor;
    self.viewLabel.text = model.view ? [model.view stringValue] : @"0";
    self.commentTotalLabel.text = model.commentTotal ? [model.commentTotal stringValue] : @"0";
    self.praiseTotalLabel.text = model.praiseTotal ? [model.praiseTotal stringValue] : @"0";
   
    self.imageArray = [model.essayUrl componentsSeparatedByString:@";"];

//    NSArray *a = [model.essayUrl componentsSeparatedByString:@";"];
//    NSMutableArray *m = [NSMutableArray arrayWithArray:a];
//    [m addObjectsFromArray:m];
//    self.imageArray = [m mutableCopy];
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPInformationMoreImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPInformationMoreImageCollectionViewCellID forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:self.imageArray[indexPath.row]  placeholderImage:[UIImage imageNamed:@"NoImage"]];
    cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH-20-28)/3 , 76);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - lazy
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        // layout.minimumInteritemSpacing = 10;// 垂直方向的间距
        layout.minimumLineSpacing = 10; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:LPInformationMoreImageCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:LPInformationMoreImageCollectionViewCellID];
        //        [_collectionView registerNib:[UINib nibWithNibName:JWMarketSellCollectionViewCellId bundle:nil] forCellWithReuseIdentifier:JWMarketSellCollectionViewCellId];
        
    }
    return _collectionView;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
