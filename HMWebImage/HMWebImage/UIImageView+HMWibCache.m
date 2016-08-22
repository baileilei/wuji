//
//  UIImageView+HMWibCache.m
//  HMWebImage
//
//  Created by GD on 16/8/22.
//  Copyright © 2016年 geduo. All rights reserved.
//

#import "UIImageView+HMWibCache.h"
#import "HMDownloaderManager.h"

#import <objc/runtime.h>

@implementation UIImageView (HMWibCache)


-(NSString *)lastURLStr{
    return objc_getAssociatedObject(self, @"lastURL");
}

-(void)setLastURLStr:(NSString *)lastURLStr{

    objc_setAssociatedObject(self, @"lastURL", lastURLStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


-(void)HM_setImageWithURLString:(NSString *)urlStr{
//判断本次地址和上次地址是否一样   如果不一样,就取消上次的下载操作
    if (![urlStr isEqualToString:self.lastURLStr] && self.lastURLStr) {
        [[HMDownloaderManager sharedManager] cancelWithLastURLString:self.lastURLStr];
    }

    self.lastURLStr = urlStr;
    
    [[HMDownloaderManager sharedManager] downLoadWithImageURL:urlStr finishBlock:^(UIImage *image) {
        self.image = image;
    }];
}


@end
