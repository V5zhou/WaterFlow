//
//  ViewController.m
//  CollectionAnimate
//
//  Created by zmz on 16/8/29.
//  Copyright © 2016年 tentinet. All rights reserved.
//

#import "ViewController.h"
#import "CollectionAnimateFlowOut.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    CollectionAnimateFlowOut *flowOut = [[CollectionAnimateFlowOut alloc] init];
    flowOut.style = 0;
    
    self.collectionView =
    [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 40)
                       collectionViewLayout:flowOut];
    _collectionView.backgroundColor = [UIColor colorWithRed:0.8 green:.8 blue:0.95 alpha:1];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"MainCell" bundle:nil]
      forCellWithReuseIdentifier:@"MainCell"];
    
    //seg
    UISegmentedControl *segment = [[UISegmentedControl alloc]
                                   initWithItems:@[ @"缩放", @"倾斜", @"旋转", @"翻转" ]];
    segment.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 40, [UIScreen mainScreen].bounds.size.width, 40);
    segment.selectedSegmentIndex = 0;
    [self.view addSubview:segment];
    [segment addTarget:self
                action:@selector(changeStyle:)
      forControlEvents:UIControlEventValueChanged];

    //
    [self prepareData];
}

- (void)prepareData {
    self.dataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 9; i++) {
        [_dataArray addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    [_collectionView setContentOffset:CGPointMake(_collectionView.frame.size.width * _dataArray.count, 0)];
}

//更改列数
- (void)changeStyle:(UISegmentedControl *)segment {
    ((CollectionAnimateFlowOut *)_collectionView.collectionViewLayout).style = segment.selectedSegmentIndex;
}

#pragma mark - UICollectionView DataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count * 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCell *cell = (MainCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MainCell" forIndexPath:indexPath];
    cell.imageName = _dataArray[indexPath.item%_dataArray.count];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {       //无限循环的实现（做三倍列表数据，一直显示第二倍部分）
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (offsetX + _collectionView.frame.size.width/2)/_collectionView.frame.size.width;
    if (index < _dataArray.count) {
        [scrollView setContentOffset:CGPointMake(_collectionView.frame.size.width * (index + _dataArray.count), 0) animated:NO];
    }
    else if (index >= _dataArray.count * 2) {
        [scrollView setContentOffset:CGPointMake(_collectionView.frame.size.width * (index - _dataArray.count), 0) animated:NO];
    }
}

@end

@implementation MainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainImgv.layer.cornerRadius = 8;
    self.mainImgv.layer.masksToBounds = YES;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = [imageName copy];
    _mainImgv.image = [UIImage imageNamed:imageName];
}

@end
