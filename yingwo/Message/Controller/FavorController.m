//
//  FavorController.m
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "FavorController.h"

#import "YWMessageCell.h"
#import "YWImageMessageCell.h"

#import "MessageViewModel.h"

#import "MessageEntity.h"

@interface FavorController ()<UITableViewDelegate,UITableViewDataSource,YWMessageCellDelegate>

@property (nonatomic, strong) UITableView      *tableView;

@property (nonatomic, strong) MessageViewModel *viewModel;

@property (nonatomic, strong) RequestEntity    *requestEntity;

@property (nonatomic, strong) NSMutableArray   *messageArr;

@end

static NSString *noImageCellidentifier = @"noImage";
static NSString *imageCellidentifier   = @"hasImage";

static int start_id = 0;

@implementation FavorController

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView                 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset    = UIEdgeInsetsMake(0, 0, 60, 0);
        
        [_tableView registerClass:[YWMessageCell class] forCellReuseIdentifier:noImageCellidentifier];
        [_tableView registerClass:[YWImageMessageCell class] forCellReuseIdentifier:imageCellidentifier];
        
    }
    
    return _tableView;
    
}

- (MessageViewModel *)viewModel {
    
    if (_viewModel == nil) {
        _viewModel = [[MessageViewModel alloc] init];
    }
    
    return _viewModel;
    
}

- (RequestEntity *)requestEntity {
    if (_requestEntity == nil) {
        _requestEntity            = [[RequestEntity alloc] init];
        _requestEntity.requestUrl = MESSAGE_REPLY_AND_COMMENT_URL;
        _requestEntity.start_id   = 0;
    }
    return _requestEntity;
}

- (NSMutableArray *)messageArr {
    if (_messageArr == nil) {
        _messageArr = [[NSMutableArray alloc] init];
    }
    return _messageArr;
}

- (void)layoutSubview {
    
    [self.view addSubview:self.tableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"点赞";
    
    [self layoutSubview];
    
    __weak FavorController *weakSelf = self;
    
    self.tableView.mj_header           = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //偏移量开始为0
        self.requestEntity.start_id        = start_id;
        
        [weakSelf loadDataWithRequestEntity:self.requestEntity];
    }];
    
    self.tableView.mj_footer    = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMoreDataWithRequestEntity:self.requestEntity];
        
    }];
    
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = -65;
    
    
    [self.tableView.mj_header beginRefreshing];
    
    
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
    [[self.viewModel.fecthTieZiEntityCommand execute:requestEntity] subscribeNext:^(NSArray *messages) {
        @strongify(self);
        
        //这里是倒序获取前10个
        if (messages.count > 0) {
            
            if (type == 1) {
                //   NSLog(@"tiezi:%@",tieZis);
                self.messageArr = [messages mutableCopy];
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            }else {
                
                [self.messageArr addObjectsFromArray:messages];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
            
            
            //获得最后一个帖子的id,有了这个id才能向前继续获取model
            MessageEntity *lastObject           = [messages objectAtIndex:messages.count-1];
            self.requestEntity.start_id = lastObject.tieZi_id;
            
        }
        else
        {
            //没有任何数据
            if (messages.count == 0 && requestEntity.start_id == 0) {
                
                self.messageArr = nil;
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                
            }
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}




#pragma mark tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self.viewModel idForRowByModel:self.messageArr[indexPath.row]];
    
    YWMessageCell *cell      = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                               forIndexPath:indexPath];
    [self.viewModel setupModelOfCell:cell model:self.messageArr[indexPath.row]];
    
    cell.delegate            = self;
    cell.messageEntity       = self.messageArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self.viewModel idForRowByModel:self.messageArr[indexPath.row]];
    
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier
                                    cacheByIndexPath:indexPath
                                       configuration:^(id cell) {
                                           
                                           [self.viewModel setupModelOfCell:cell
                                                                      model:self.messageArr[indexPath.row]];
                                       }];
    
}

//查看回复或评论的贴子
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([self.delegate respondsToSelector:@selector(didSelectMessageWith:)]) {
        
        MessageEntity *messageEntity = [self.messageArr objectAtIndex:indexPath.row];
        messageEntity.type           = MessageTieZi;
        //将source_id改成follow_id
        messageEntity.tieZi_id       = messageEntity.reply_id;
        messageEntity.type           = MessageTieZi;
        
        [self.delegate didSelectMessageWith:messageEntity];
    }
    
}

/**
 *  查看原贴
 *
 *  @return
 */
#pragma mark YWMessageCellDelegate

- (void)didSelectedTieZi:(MessageEntity *)messageEntity {
    
    if ([self.delegate respondsToSelector:@selector(didSelectMessageWith:)]) {
        
        [self.delegate didSelectMessageWith:messageEntity];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end