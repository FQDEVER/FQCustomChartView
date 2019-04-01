//
//  FQMeshItem.h
//  FQ_ChartView
//
//  Created by 范奇 on 2019/3/27.
//  Copyright © 2019 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FQMeshItem : NSObject

/**
 昵称
 */
@property (nonatomic, copy) NSString * name ;

/**
 描述
 */
@property (nonatomic, copy) NSString * desc ;

/**
 数据 - 绘制主要参考元素
 */
@property (nonatomic, strong) NSNumber * value ;

/**
 时长
 */
@property (nonatomic, copy) NSString * time ;

/**
 数据加时长
 */
@property (nonatomic, copy) NSString * valueStr ;

/**
 单点的颜色
 */
@property (nonatomic, strong) UIColor * color ;

-(instancetype)initWithDict:(NSDictionary *)dict;

+(NSArray *)getMeshItemArrWithDictArr:(NSArray<NSDictionary *> *)dictArr;

@end

