//
//  MyTopicController.m
//  yingwo
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MyTopicController.h"
#import "TopicController.h"
#import "MyTopicViewModel.h"
#import "SMPagerTabView.h"

@interface MyTopicController ()<SMPagerTabViewDelegate,TopicListControllerDelegate>

@property (nonatomic, strong) SMPagerTabView   *topicPgaeView;
@property (nonatomic, strong) UIView           *topicSectionView;

@property (nonatomic, strong) NSMutableArray   *catalogVcArr;

@property (nonatomic, strong) MyTopicViewModel *viewModel;

@end

@implementation MyTopicController

- (instancetype)initWithUserId:(int)userId title:(NSString *)title {
    self = [super init];
    
    if (self) {
        self.userId = userId;
        self.title = title;
    }
    return self;
}

- (SMPagerTabView *)topicPgaeView {
    if (_topicPgaeView == nil) {
        
        _topicPgaeView          = [[SMPagerTabView alloc] initWithFrame:CGRectMake(0,
                                                                         40,
                                                                         SCREEN_WIDTH,
                                                                         SCREEN_HEIGHT)];
        _topicPgaeView.delegate = self;

        
        [self.catalogVcArr addObject:self.oneFieldVc];
        [self.catalogVcArr addObject:self.twoFieldVc];
        [self.catalogVcArr addObject:self.threeFieldVc];

        //开始构建UI
        [_topicPgaeView buildUI];
        //起始选择一个tab
        [_topicPgaeView selectTabWithIndex:0 animate:NO];

    }
    return _topicPgaeView;
}

- (UIView *)topicSectionView {
    if (_topicSectionView == nil) {
        _topicSectionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     SCREEN_WIDTH,
                                                                     40)];
        
        [_topicSectionView addSubview:self.topicPgaeView.tabView];
    }
    return _topicSectionView;
}


- (NSMutableArray *)catalogVcArr {
    if (_catalogVcArr == nil) {
        _catalogVcArr = [[NSMutableArray alloc] init];
    }
    return _catalogVcArr;
}

- (TopicListController *)oneFieldVc {
    if (_oneFieldVc == nil) {
        _oneFieldVc           = [[TopicListController alloc] init];
        _oneFieldVc.delegate  = self;

        _oneFieldVc.title     = @"校园生活";
        _oneFieldVc.field_id  = 1;
        _oneFieldVc.isMyTopic = YES;
        _oneFieldVc.viewModel.user_id = self.userId;

    }
    return _oneFieldVc;
}

- (TopicListController *)twoFieldVc {
    if (_twoFieldVc == nil) {
        _twoFieldVc           = [[TopicListController alloc] init];
        _twoFieldVc.delegate  = self;

        _twoFieldVc.title     = @"兴趣爱好";
        _twoFieldVc.field_id  = 2;
        _twoFieldVc.isMyTopic = YES;
        _twoFieldVc.viewModel.user_id = self.userId;

    }
    return _twoFieldVc;
}

- (TopicListController *)threeFieldVc {
    if (_threeFieldVc == nil) {
        _threeFieldVc           = [[TopicListController alloc] init];
        _threeFieldVc.delegate  = self;

        _threeFieldVc.title     = @"学科专业";
        _threeFieldVc.field_id  = 3;
        _threeFieldVc.isMyTopic = YES;
        _threeFieldVc.viewModel.user_id = self.userId;

    }
    return _threeFieldVc;
}

-(MyTopicViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[MyTopicViewModel alloc] init];
    }
    return _viewModel;
}

- (void)layoutSubviews {
    
    [self.view addSubview:self.topicPgaeView];
    [self.view addSubview:self.topicSectionView];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = self.leftBarItem;
}

- (void)resetFrameAndContentSize {
    
    if (self.oneFieldVc.topicArr.count != 0) {
        
        self.oneFieldVc.topicScrollView.contentSize       = CGSizeMake(SCREEN_WIDTH,
                                                                       self.oneFieldVc.topicArr.count * 82 + 150 );
        
        self.oneFieldVc.topicTableView.frame              = CGRectMake(10,
                                                                       10,
                                                                       SCREEN_WIDTH - 20,
                                                                       self.oneFieldVc.topicArr.count * 82 );
    }
    
    if (self.twoFieldVc.topicArr.count != 0) {
        
        self.twoFieldVc.topicScrollView.contentSize       = CGSizeMake(SCREEN_WIDTH,
                                                                       self.twoFieldVc.topicArr.count * 82 + 150 );
        
        self.twoFieldVc.topicTableView.frame              = CGRectMake(10,
                                                                       10,
                                                                       SCREEN_WIDTH - 20,
                                                                       self.twoFieldVc.topicArr.count * 82 );
        
    }
    
    if (self.threeFieldVc.topicArr.count != 0) {
        
        self.threeFieldVc.topicScrollView.contentSize     = CGSizeMake(SCREEN_WIDTH,
                                                                       self.threeFieldVc.topicArr.count * 82 + 150 );
        
        self.threeFieldVc.topicTableView.frame            = CGRectMake(10,
                                                                       10,
                                                                       SCREEN_WIDTH - 20,
                                                                       self.threeFieldVc.topicArr.count * 82 );
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    
    return [self.catalogVcArr count];
}
- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    
    UIViewController *vc = self.catalogVcArr[number];
    
    return vc;
}

- (void)whenSelectOnPager:(NSUInteger)number {
    NSLog(@"页面 %lu",(unsigned long)number);
}


#pragma mark TopicListControllerDelegate

- (void)didSelectTopicListWith:(int)topicId{
    
    TopicController *topicVc = [[TopicController alloc] initWithTopicId:topicId];
    [self.navigationController pushViewController:topicVc animated:YES];
    
    
}

#pragma mark private method

/**
 *  获取领域
 */
- (void)loadFieldList {
    
    WeakSelf(self);
    [self.viewModel setSuccessBlock:^(NSArray *fieldArr) {
        
        [weakself.view addSubview:weakself.topicPgaeView];
        [weakself.view addSubview:weakself.topicSectionView];

    } errorBlock:^(id error) {
        
    }];
    
}



@end
