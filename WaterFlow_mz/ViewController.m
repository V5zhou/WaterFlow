//
//  ViewController.m
//  WaterFlow_mz
//
//  Created by zmz on 15/10/27.
//  Copyright © 2015年 tentinet. All rights reserved.
//

#import "ViewController.h"
#import "WaterFlowLayout.h"
#import "UIView+MZwebCache.h"

@interface
ViewController ()<WaterFlowLayoutDelegate, UICollectionViewDataSource> {
    NSInteger lines;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController
/*************屏幕尺寸**************/
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    WaterFlowLayout *flowOut = [[WaterFlowLayout alloc] init];
    flowOut.delegate = self;

    self.collectionView =
      [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40)
                         collectionViewLayout:flowOut];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"MainCell" bundle:nil]
      forCellWithReuseIdentifier:@"MainCell"];

    //
    lines = 2;
    UISegmentedControl *segment = [[UISegmentedControl alloc]
      initWithItems:@[ @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8" ]];
    segment.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
    segment.selectedSegmentIndex = 1;
    [self.view addSubview:segment];
    [segment addTarget:self
                action:@selector(changeLines:)
      forControlEvents:UIControlEventValueChanged];

    //
    [self prepareData];
}

- (void)prepareData {
    NSArray *imagArray = @[     //去百度随便贴了点图
                           @"http://f.hiphotos.baidu.com/image/w%3D230/sign=0c9aab1334d3d539c13d08c00a86e927/2e2eb9389b504fc210123be8e7dde71191ef6d8a.jpg",
                           @"http://b.hiphotos.baidu.com/image/w%3D230/sign=3d85e1028fb1cb133e693b10ed5556da/4610b912c8fcc3cecad043de9045d688d53f20ce.jpg",
                           @"http://b.hiphotos.baidu.com/image/w%3D230/sign=95bc4fc238292df597c3ab168c305ce2/71cf3bc79f3df8dcd052057ccf11728b461028eb.jpg",
                           @"http://d.hiphotos.baidu.com/image/w%3D230/sign=0ad1d51334d3d539c13d08c00a86e927/2e2eb9389b504fc2165945e8e7dde71191ef6ddd.jpg",
                           @"http://b.hiphotos.baidu.com/image/w%3D230/sign=2aa64056a41ea8d38a227307a70b30cf/38dbb6fd5266d016107869c5952bd40734fa35fd.jpg",
                           
                           @"http://f.hiphotos.baidu.com/image/w%3D230/sign=847d16318813632715edc530a18ea056/2934349b033b5bb55c48aa1334d3d539b700bc44.jpg",
                           @"http://b.hiphotos.baidu.com/image/w%3D230/sign=ca80bc927af0f736d8fe4b023a57b382/6f061d950a7b02081a10b50c60d9f2d3562cc806.jpg",
                           @"http://a.hiphotos.baidu.com/image/w%3D230/sign=494c2900a344ad342ebf8084e0a30c08/f11f3a292df5e0fe414a02ec5e6034a85fdf7289.jpg",
                           @"http://d.hiphotos.baidu.com/image/w%3D310/sign=38b94db9a41ea8d38a227205a70a30cf/80cb39dbb6fd5266db55c616a918972bd40736b1.jpg",
                           @"http://f.hiphotos.baidu.com/image/pic/item/c995d143ad4bd113d69bc42a58afa40f4bfb0557.jpg",
                           
                           @"http://a.hiphotos.baidu.com/image/pic/item/9c16fdfaaf51f3de74ce436696eef01f3a2979b0.jpg",
                           @"http://a.hiphotos.baidu.com/image/pic/item/314e251f95cad1c8ef3da6267d3e6709c93d5128.jpg",];
    self.dataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 550; i++) {
        MainModel *model = [[MainModel alloc] init];
        model.imageUrl = imagArray[i % imagArray.count];
        [_dataArray addObject:model];
    }
}

//更改列数
- (void)changeLines:(UISegmentedControl *)segment {
    lines = segment.selectedSegmentIndex + 1;
    [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

#pragma mark - UICollectionView DataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    MainCell *cell = (MainCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"MainCell"
                                                                            forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = _dataArray[indexPath.row];
    cell.sizeChanged = ^() {
#warning 这里每次加载完图片后，得到图片的比例会再次调用刷新此item，重新计算位置，会导致效率低。最优做法是服务器返回图片宽高比例；其次把加载完成后的宽高数据也缓存起来。
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    };
    return cell;
}

#pragma mark - UICollectionView Delegate Methods
- (CGFloat)collectionView:(UICollectionView *)collectionView
                               layout:(UICollectionViewLayout *)collectionViewLayout
  minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                                    layout:(UICollectionViewLayout *)collectionViewLayout
  minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//返回每个小方块宽高，但由于是在WaterFlowLayout处理，我只取了高，宽是由列数平均分
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainModel *model = _dataArray[indexPath.row];
    NSInteger lineNum = [self collectionView:_collectionView numberOfLineForSection:0];
    CGFloat width = ((SCREEN_WIDTH - 10) - (lineNum - 1) * 5) / lineNum;
    if (model.imageSize.width > 0) {
        CGSize imageSize = model.imageSize;
        return CGSizeMake(width, width / imageSize.width * imageSize.height);
    }
    return CGSizeMake(width, 100);
}

- (void)collectionView:(UICollectionView *)collectionView
  didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSLog(@"点击了第%ld个", indexPath.row);
}

#pragma mark - WaterFlowout代理，请填入返回多少列
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfLineForSection:(NSInteger)section {
    return lines;
}

@end

@implementation MainCell

- (void)setModel:(MainModel *)model {
    _model = model;
    __weak typeof(self) weakSelf = self;
    [_mainImgv setImageWithUrl:[NSURL URLWithString:model.imageUrl] placeHolder:[UIImage imageNamed:@"loading.jpg"] completion:^(UIImage *image, BOOL bFromCache, NSError *error) {
        if (!error && image) {
            if (model.imageSize.width < 0.0001) {
                model.imageSize = image.size;
                if (weakSelf.sizeChanged) {
                    weakSelf.sizeChanged();
                }
            }
        }
    }];
}

@end

@implementation MainModel

@end
