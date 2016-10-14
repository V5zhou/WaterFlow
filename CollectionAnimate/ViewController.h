//
//  ViewController.h
//  CollectionAnimate
//
//  Created by zmz on 16/8/29.
//  Copyright © 2016年 tentinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

@interface MainCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImgv;
@property (nonatomic, copy) NSString *imageName;

@end

