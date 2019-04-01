//
//  FQHorizontalBarItem.h
//  FQ_ChartView
//
//  Created by fanqi on 2018/12/4.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FQHorizontalBarItem : NSObject
/**
 x轴左侧的文本描述
 */
@property (nonatomic, copy) NSString *xLeftAxisStr;

@property (nonatomic, copy) NSString *contentStr;

@property (nonatomic, copy) NSString *barTopStr;

@property (nonatomic, copy) NSString *xRightAxisStr;
//展示主要的参考的数据
@property (nonatomic, strong) NSNumber * valueData;

@property (nonatomic, assign) BOOL isSelect;

@end

