//
//  TieZi.h
//  yingwo
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  贴子的模型类
 */
@interface TieZi : NSObject

//贴子的id
@property (nonatomic, assign) int       tieZi_id;
//话题ID 0 是新鲜事
@property (nonatomic, assign) int       topic_id;
//用户id
@property (nonatomic, assign) int       user_id;

@property (nonatomic, assign) int       user_sex;

//创建时间戳
@property (nonatomic, assign) int       create_time;
//贴子的所属标签
@property (nonatomic, copy  ) NSString  *topic_title;
//用户昵称
@property (nonatomic, copy  ) NSString  *user_name;

@property (nonatomic, copy  ) NSString  *academy_name;

//贴子内容
@property (nonatomic, copy  ) NSString  *content;
//图片
@property (nonatomic, copy  ) NSString  *img;
//用户头像
@property (nonatomic, copy  ) NSString  *user_face_img;

//点赞数
@property (nonatomic, copy  ) NSString  *like_cnt;

//回复数
@property (nonatomic, copy  ) NSString  *reply_cnt;

@property (nonatomic, copy  ) NSString  *visitor_cnt;

//用户是否点赞
@property (nonatomic, assign) int       user_post_like;

//楼层
@property (nonatomic, assign) int       floor;

//这个是将img解析后的images url 数组
@property (nonatomic, strong) NSArray   *imageURLArr;

//这个是将img解析后的images url 数组,ImageEntity(带长宽)
@property (nonatomic, strong) NSArray   *imageUrlEntityArr;

@end
