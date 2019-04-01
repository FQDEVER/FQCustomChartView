//
//  FQBothwayBarItem.h
//  FQ_ChartView
//
//  Created by 范奇 on 2019/3/28.
//  Copyright © 2019 fanqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FQBothwayBarItem : NSObject

/**
 日期
 */
@property (nonatomic, copy) NSString *dateStr;

/**
 左侧数据
 */
@property (nonatomic, copy) NSString *leftData;

/**
 右侧数据
 */
@property (nonatomic, copy) NSString * rightData ;


-(instancetype)initWithDict:(NSDictionary *)dict;

+(NSArray *)getBothwayItemArrWithDictArr:(NSArray<NSDictionary *> *)dictArr;

@end

