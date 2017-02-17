//
//  BaseViewController.h
//  yingwo
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  这个类是代替ViewController的基础类
 *  所有Controller基本都继承这个类
 *  所有新创建的ViewController都应该继承这个类
 */
@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIBarButtonItem *leftBarItem;

// three abstact methods, you should implements they  when you need
- (void)createSubviews;

- (void)layoutSubviews;

- (void)addAction;

- (void)initDataSourceBlock;

- (void)backToFarword ;

@end
