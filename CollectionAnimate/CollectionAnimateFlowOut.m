//
//  CollectionAnimateFlowOut.m
//  WaterFlow_mz
//
//  Created by zmz on 16/8/29.
//  Copyright © 2016年 tentinet. All rights reserved.
//

#import "CollectionAnimateFlowOut.h"

@interface CollectionAnimateFlowOut ()

@property (nonatomic, assign) NSInteger itemNum;            ///< 单元格数量

@end

@implementation CollectionAnimateFlowOut

-  (void)prepareLayout {
    [super prepareLayout];
    self.itemSize = CGSizeMake(self.collectionView.frame.size.width - 30, self.collectionView.frame.size.height - 40 - 30);
    self.minimumLineSpacing = 30;
    self.minimumInteritemSpacing = 30;
    self.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //数据源数量
    if (self.collectionView.dataSource && [self.collectionView.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        _itemNum = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    }
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width * _itemNum, self.collectionView.frame.size.height - 40);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;     //当前偏移中心
    for (UICollectionViewLayoutAttributes *attrs in attributes) {
        CGFloat cubeOffsetX = attrs.center.x - centerX;                                             //此方格居偏移中心位置（负为左，正为右）
        CGFloat cubeOffsetX_W = cubeOffsetX / self.collectionView.frame.size.width;                 //此方格居偏移中心除以collection宽度得到的小数值
        
        if (_style == CollectionAnimateScale) {
            CGFloat scale = 1 - ABS(cubeOffsetX_W);
            attrs.transform = CGAffineTransformMakeScale(scale, scale);
        }
        else if (_style == CollectionAnimateSlante) {
            CATransform3D trans = CATransform3DIdentity;
            trans.m34 = 0.004;
            trans = CATransform3DRotate(trans, M_PI_4*(cubeOffsetX_W), 0.0, 1, 0.0);
            attrs.transform3D = trans;
        }
        else if (_style == CollectionAnimateRotate) {
            CATransform3D trans = CATransform3DIdentity;
            trans = CATransform3DTranslate(trans, cubeOffsetX, 0, 0);
            trans = CATransform3DRotate(trans, M_PI_2*(cubeOffsetX_W), 0.0, 0.0, 1);
            attrs.transform3D = trans;
        }
        else if (_style == CollectionAnimateFlip) {
            CATransform3D trans = CATransform3DIdentity;
            trans = CATransform3DTranslate(trans, -cubeOffsetX, 0, 0);
            trans = CATransform3DRotate(trans, M_PI*(cubeOffsetX_W), 0.0, 1, 0.0);
            attrs.transform3D = trans;
            NSLog(@"%lf", fabs(cubeOffsetX_W));
            attrs.alpha = fabs(cubeOffsetX_W) < 0.5;
        }
    }
    return  attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
