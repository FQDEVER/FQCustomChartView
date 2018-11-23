//
//  FQSeriesElement.m
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQSeriesElement.h"

@implementation FQSeriesElement

-(instancetype)init
{
    if (self = [super init]) {
        _lineWidth = 2;
        _mainColor = [UIColor blackColor];
        _fillLayerBackgroundColor = rgba(0, 0, 0, 0.2);
        _barPlaceholderColor = rgba(240, 240, 240, 1.0);
        _averageLineColor = [UIColor clearColor];
    }
    return self;
}

//如果用户传入的是纯碎的数据也可以
-(void)setOrginNumberDatas:(NSArray<NSNumber *> *)orginNumberDatas
{
    _orginNumberDatas = orginNumberDatas;
    
    //将其转化为FQXAxisItem类型的数据
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i = 0; i < orginNumberDatas.count; ++i) {
        NSNumber * valueNum = orginNumberDatas[i];
        FQXAxisItem * xAxisItem = [[FQXAxisItem alloc]init];
        xAxisItem.dataValue = valueNum;
        xAxisItem.dataNumber = @(i);
        [muArr addObject:xAxisItem];
    }
    _orginDatas = muArr;
}
@end
