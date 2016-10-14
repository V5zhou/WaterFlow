//
//  CollectionAnimateFlowOut.h
//  WaterFlow_mz
//
//  Created by zmz on 16/8/29.
//  Copyright © 2016年 tentinet. All rights reserved.
//

#import <UIKit/UIKit.h>

/*************屏幕尺寸**************/

typedef NS_ENUM(NSUInteger, CollectionAnimateStyle) {
    CollectionAnimateScale = 0,                         ///< 缩放
    CollectionAnimateSlante,                            ///< 倾斜
    CollectionAnimateRotate,                            ///< 旋转
    CollectionAnimateFlip,                              ///< 翻转
};

@interface CollectionAnimateFlowOut : UICollectionViewFlowLayout

@property (nonatomic, assign) CollectionAnimateStyle style;

@end
