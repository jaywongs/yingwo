//
//  MyTieZiController.m
//  yingwo
//
//  Created by apple on 16/10/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MyTieZiController.h"
#import "DetailController.h"
#import "TopicController.h"

#import "TieZi.h"
#import "YWDropDownView.h"
#import "YWPhotoCotentView.h"

#import "YWGalleryCellOfOne.h"
#import "YWGalleryCellOfTwo.h"
#import "YWGalleryCellOfThree.h"
#import "YWGalleryCellOfFour.h"
#import "YWGalleryCellOfSix.h"
#import "YWGalleryCellOfNine.h"
#import "YWGalleryCellOfMoreNine.h"

//刷新的初始值
static int start_id = 0;

@interface MyTieZiController ()

@property (nonatomic, strong) RequestEntity     *requestEntity;

@end

@implementation MyTieZiController

- (instancetype)initWithUserId:(int)userId title:(NSString *)title {
    
    self = [super init];
    
    if (self) {
        
        self.requestEntity.user_id = userId;
        self.title = title;
    }
    return self;
}
#pragma mark 懒加载

- (RequestEntity *)requestEntity {
    if (_requestEntity  == nil) {
        _requestEntity            = [[RequestEntity alloc] init];
        //贴子请求url
        _requestEntity.URLString = MY_TIEZI_URL;
        //请求的事新鲜事
        _requestEntity.filter     = AllThingModel;
        //偏移量开始为0
        _requestEntity.start_id   = start_id;
        
    }
    return _requestEntity;
}

- (void)addRefreshForTableView {
    
    [self showLoadingViewOnFrontView:self.tableView];
    
    WeakSelf(self);
    self.tableView.mj_header        = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //偏移量开始为0
        self.requestEntity.start_id  = start_id;
        
        [weakself loadDataWithRequestEntity:self.requestEntity];
    }];
    
    self.tableView.mj_footer    = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakself loadMoreDataWithRequestEntity:self.requestEntity];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addRefreshForTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = self.leftBarItem;
}


/**
 *  下拉刷新
 */
- (void)loadDataWithRequestEntity:(RequestEntity *)requestEntity {

    [self loadForType:1 RequestEntity:requestEntity];
    
    [self.tableView.mj_footer resetNoMoreData];
}

/**
 *  上拉刷新
 */
- (void)loadMoreDataWithRequestEntity:(RequestEntity *)requestEntity {
    
    [self loadForType:2 RequestEntity:requestEntity];
}

/**
 *  下拉、上拉刷新
 *
 *  @param type  上拉or下拉
 *  @param model 刷新类别：所有帖、新鲜事、好友动态、关注的话题
 */
- (void)loadForType:(int)type RequestEntity:(RequestEntity *)requestEntity {
    
    @weakify(self);
    [[self.viewModel.fecthTieZiEntityCommand execute:requestEntity] subscribeNext:^(NSArray *tieZis) {
        @strongify(self);
        
        [self showFrontView:self.tableView];
        
        //这里是倒序获取前10个
        if (tieZis.count > 0) {
            
            self.emptyRemindView.hidden = YES;
            
            if (type == 1) {
                //   NSLog(@"tiezi:%@",tieZis);
                self.tieZiList = [tieZis mutableCopy];
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            }else {
                
                [self.tieZiList addObjectsFromArray:tieZis];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
            
            
            //获得最后一个帖子的id,有了这个id才能向前继续获取model
            TieZi *lastObject           = [tieZis objectAtIndex:tieZis.count-1];
            self.requestEntity.start_id = lastObject.tieZi_id;
            
        }
        else
        {
            //没有任何数据
            if (tieZis.count == 0 && requestEntity.start_id == 0) {
                
                self.tieZiList = nil;
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                self.emptyRemindView.hidden = NO;
                
            }
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
        //错误的情况下停止刷新（网络错误）
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
