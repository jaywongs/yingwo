//
//  YWDetailTableViewCell.m
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWDetailTableViewCell.h"

@implementation YWDetailTableViewCell


- (void)createSubview {

    self.backgroundView                     = [[UIView alloc] init];
    self.backgroundColor                    = [UIColor clearColor];
    self.backgroundView.backgroundColor     = [UIColor whiteColor];
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius  = 10;
    
    
    self.topView                    = [[YWDetailTopView alloc] init];
    self.masterView                 = [[YWDetailMasterView alloc] init];
    self.contentLabel               = [[YWContentLabel alloc] initWithFrame:CGRectZero];
    self.bgImageView                = [[UIView alloc] init];

    self.contentLabel.font          = [UIFont systemFontOfSize:15];
    self.contentLabel.numberOfLines = 0;

    [self.contentView addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.topView];
    [self.backgroundView addSubview:self.masterView];
    [self.backgroundView addSubview:self.contentLabel];
    [self.backgroundView addSubview:self.bgImageView];
        
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 2.5, 10));
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_top).offset(5);
        make.left.equalTo(self.backgroundView.mas_left).offset(10);
        make.right.equalTo(self.backgroundView.mas_right).offset(-10);
        make.height.equalTo(@30);
    }];
    

    [self.masterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(10);
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.top.equalTo(self.topView.mas_bottom).offset(10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.masterView.mas_bottom).offset(10);
        make.left.equalTo(self.masterView.mas_left);
        make.right.equalTo(self.masterView.mas_right);
    }];
    
    [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentLabel);
        make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-20).priorityLow();
    }];
    
}

- (void)addImageViewByImageArr:(NSMutableArray *)entities {
    
    UIImageView *lastView;
    
    for (int i = 0; i < entities.count; i ++) {
        
        ImageViewEntity *entity           = [entities objectAtIndex:i];
        CGFloat imageHeight               = (SCREEN_WIDTH - 60)/entity.width *entity.height;
        
        UIImageView *imageView            = [[UIImageView alloc] init];
        imageView.tag                     = i+1;
        imageView.userInteractionEnabled  = YES;
        imageView.contentMode             = UIViewContentModeScaleAspectFit;
        

        //添加单击放大事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapEnlarge:)];
        singleTap.numberOfTouchesRequired = 1;
        singleTap.numberOfTapsRequired    = 1;
        
        [imageView addGestureRecognizer:singleTap];
                
        imageView.mas_key                 = [NSString stringWithFormat:@"DetailImageView%d:",i+1];
    
        [self.bgImageView addSubview:imageView];
        
        if (!lastView) {
            
            [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
                make.left.equalTo(self.bgImageView.mas_left);
                make.right.equalTo(self.bgImageView.mas_right);
                make.height.equalTo(@(imageHeight)).priorityHigh();
            }];
            lastView = imageView;
            
        }else {
            [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(lastView);
                make.top.equalTo(lastView.mas_bottom).offset(10).priorityHigh();
                make.height.equalTo(@(imageHeight)).priorityHigh();
            }];
            lastView = imageView;
        }
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:entity.imageName]
                     placeholderImage:[UIImage imageNamed:@"ying"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                entity.isDownload = YES;
                            }];    }
    
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-20).priorityLow();
    }];
    
}

- (void)singleTapEnlarge:(UITapGestureRecognizer *)gesture {
    
    UIImageView *imageView = (UIImageView *)gesture.view;

    [self convertImageViewArr];
    
    self.imageTapBlock(imageView,self.imagesItem);
    
}

#pragma mark private method

- (void)convertImageViewArr {
    
    [self.imagesItem.imageViewArr removeAllObjects];
    
    [self.imagesItem.URLArr enumerateObjectsUsingBlock:^(UIImageView *obj,
                                                         NSUInteger idx,
                                                         BOOL * stop) {
        
        //保存imageView在cell上的位置
        UIImageView *oldImageView = [self viewWithTag:idx+1];
        
        //oldImageView有可能是空的，只是个占位imageView
        if (oldImageView.image == nil) {
            return;
        }
        UIImageView *newImageView = [[UIImageView alloc] init];
        newImageView.image        = oldImageView.image;
        newImageView.tag          = oldImageView.tag;
        newImageView.frame        = [oldImageView.superview convertRect:oldImageView.frame
                                                                 toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        [self.imagesItem.imageViewArr addObject:newImageView];
    }];
}

@end
