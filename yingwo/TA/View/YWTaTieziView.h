//
//  YWTaTieziView.h
//  yingwo
//
//  Created by 王世杰 on 2016/10/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryViewModel.h"
@interface YWTaTieziView : UIView

@property (nonatomic, strong) UITableView             *homeTableview;

@property (nonatomic, strong) GalleryViewModel          *viewModel;
@property (nonatomic, strong) NSMutableArray          *rowHeightArr;

@end
