//
//  WaterFlowLayout.m
//  Gray_main
//
//  Created by zmz on 15/10/20.
//  Copyright © 2015年 tentinet. All rights reserved.
//

#import "WaterFlowLayout.h"

@interface
WaterFlowLayout ()

//用于瀑布流减少高低差,每个数组里都存了一个section,section内部才是对应意义值
@property (nonatomic, strong) NSMutableArray *eachLineBottomRect; //每列底部rect值
@property (nonatomic, assign) NSInteger shortestLine;             //最矮的列
@property (nonatomic, assign) CGFloat shortestHeight;             //最矮的列高
@property (nonatomic, assign) CGFloat tallestHeight;              //最高的列高

@property (nonatomic, assign) NSInteger lineNum;       //列数
@property (nonatomic, assign) NSInteger eachLineWidth; //每列宽度，现平均，以后再扩展

//用于计算frame
@property (nonatomic, assign) CGFloat horizontalSpace; //水平间距
@property (nonatomic, assign) CGFloat verticalSpace;   //竖直间距
@property (nonatomic, assign) UIEdgeInsets edgeInset;  //边距

//所有frame
@property (nonatomic, strong) NSMutableArray *layoutArray; //保存每个Frame值

@end

@implementation WaterFlowLayout

- (void)prepareLayout {
    [super prepareLayout];

    //水平间距
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:
                                                                                  layout:
                                                     minimumLineSpacingForSectionAtIndex:)]) {
        _horizontalSpace = [_delegate collectionView:self.collectionView
                                              layout:self
                 minimumLineSpacingForSectionAtIndex:0];
    }

    //竖直间距
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:
                                                                                       layout:
                                                     minimumInteritemSpacingForSectionAtIndex:)]) {
        _verticalSpace = [_delegate collectionView:self.collectionView
                                            layout:self
          minimumInteritemSpacingForSectionAtIndex:0];
    }

    //边距
    if (_delegate &&
        [_delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        _edgeInset =
          [_delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:0];
    }

    //最低行和行高
    _shortestLine = 0;
    _shortestHeight = 0;
    _eachLineBottomRect = [NSMutableArray array];
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:
                                                     numberOfLineForSection:)]) { //获取竖行数
        _lineNum = [_delegate collectionView:self.collectionView numberOfLineForSection:0];
        _eachLineWidth = (self.collectionView.frame.size.width - _edgeInset.left -
                          _edgeInset.right - _horizontalSpace * (_lineNum - 1)) /
                         _lineNum;
        for (NSInteger i = 0; i < _lineNum; i++) {
            [_eachLineBottomRect
              addObject:[NSValue
                          valueWithCGRect:CGRectMake(_edgeInset.left +
                                                       (_edgeInset.left + _eachLineWidth) * i,
                                                     0, _eachLineWidth, 0)]];
        }
    }

    //准备每行frame数据
    [self prepareLayoutArray];
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, _tallestHeight + _edgeInset.bottom);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _layoutArray;
}

//拼凑每个方块的显示样式
- (void)prepareLayoutArray {

    _layoutArray = [NSMutableArray array];
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [_layoutArray addObject:[self makeEachLayoutAttributesAtIndexPath:indexPath]];
    }
}

- (UICollectionViewLayoutAttributes *)makeEachLayoutAttributesAtIndexPath:(NSIndexPath *)path {
    UICollectionViewLayoutAttributes *attributes =
      [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    //取出最低列的高度
    CGRect shortestRect = [_eachLineBottomRect[_shortestLine] CGRectValue];
    //取出本row的高度
    CGSize rowSize;
    if (_delegate &&
        [_delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        rowSize =
          [_delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:path];
    }
    //计算最终值
    CGRect newRect = CGRectMake(shortestRect.origin.x, _shortestHeight + _verticalSpace,
                                _eachLineWidth, rowSize.height);

    //替换最新rect数组
    [_eachLineBottomRect replaceObjectAtIndex:_shortestLine
                                   withObject:[NSValue valueWithCGRect:newRect]];

    //查找最高和最低值
    [self resetTallestAndShortestLineIndex];

    attributes.frame = newRect;
    return attributes;
}

//查找最低列和最高列
- (void)resetTallestAndShortestLineIndex {

    if (_eachLineBottomRect.count < 1)
        return;

    for (NSInteger i = 0; i < _eachLineBottomRect.count; i++) {
        CGRect rect = [_eachLineBottomRect[i] CGRectValue];
        CGFloat rectMaxY = CGRectGetMaxY(rect);

        if (i == 0) {
            _tallestHeight = rectMaxY;
            _shortestHeight = rectMaxY;
            _shortestLine = 0;
        } else {
            if (rectMaxY > _tallestHeight) {
                _tallestHeight = rectMaxY;
            } else if (rectMaxY < _shortestHeight) {
                _shortestHeight = rectMaxY;
                _shortestLine = i;
            }
        }
    }
}

@end
