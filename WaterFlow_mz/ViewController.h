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

typedef void (^ImageLoadFinish)(void);
@interface MainCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImgv;
@property (nonatomic, strong) MainModel *model;
@property (nonatomic, copy) ImageLoadFinish loadFinishBlock;

@end

@interface MainModel : NSObject

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIImage *image;

@end