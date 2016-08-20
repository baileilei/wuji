//
//  HMAppCell.m
//  HMWebImage
//
//  Created by GD on 16/8/20.
//  Copyright © 2016年 geduo. All rights reserved.
//

#import "HMAppCell.h"
#import "HMAppModel.h"
//#import "UIImageView+WebCache.h"


@interface HMAppCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *downLoadLabel;
@end

@implementation HMAppCell


-(void)setModel:(HMAppModel *)model{
    _model = model;
    
    
    self.nameLabel.text = model.name;
    
    self.downLoadLabel.text = model.download;
    
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
