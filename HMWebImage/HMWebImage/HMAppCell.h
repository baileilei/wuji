//
//  HMAppCell.h
//  HMWebImage
//
//  Created by GD on 16/8/20.
//  Copyright © 2016年 geduo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMAppModel;
@interface HMAppCell : UITableViewCell

@property (nonatomic,strong) HMAppModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end
