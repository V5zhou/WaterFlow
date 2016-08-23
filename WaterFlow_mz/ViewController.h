//
//  ViewController.h
//  WaterFlow_mz
//
//  Created by zmz on 15/10/27.
//  Copyright © 2015年 tentinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainModel;
@interface ViewController : UIViewController

@end

typedef void (^ImageSizeChanged)(void);
@interface MainCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImgv;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) MainModel *model;
@property (nonatomic, copy) ImageSizeChanged sizeChanged;

@end

@interface MainModel : NSObject

@property (nonatomic, copy)     NSString *imageUrl;
@property (nonatomic, assign)   CGSize imageSize;               //图片尺寸，记录下来方便布局

@end