//
//  HMDownloaderManager.h
//  HMWebImage
//
//  Created by GD on 16/8/22.
//  Copyright © 2016年 geduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDownloaderManager : NSObject


+(instancetype)sharedManager;



-(void)downLoadWithImageURL:(NSString *)imageURL finishBlock:(void(^)(UIImage *image))finishBlock;



-(void)cancelWithLastURLString:(NSString *)lastURLString;

@end
