//
//  NewTopicController.h
//  yingwo
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "TopicController.h"

@interface NewTopicController : BaseViewController

@property (nonatomic, strong) UITableView     *homeTableview;
@property (nonatomic, strong) UIScrollView     *topicSrcView;

@property (nonatomic, assign) int topic_id;
@property (nonatomic, assign) id<TopicControllerDelegate>delegate;


@end
