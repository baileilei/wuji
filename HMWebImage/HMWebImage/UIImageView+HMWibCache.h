//
//  UIImageView+HMWibCache.h
//  HMWebImage
//
//  Created by GD on 16/8/22.
//  Copyright © 2016年 geduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HMWibCache)


-(void)HM_setImageWithURLString:(NSString *)urlStr;

@property (nonatomic,copy) NSString *lastURLStr;

@end
