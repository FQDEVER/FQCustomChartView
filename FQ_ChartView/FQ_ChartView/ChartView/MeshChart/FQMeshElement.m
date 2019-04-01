//
//  FQMeshElement.m
//  FQ_ChartView
//
//  Created by 范奇 on 2019/3/27.
//  Copyright © 2019 fanqi. All rights reserved.
//

#import "FQMeshElement.h"

@implementation FQMeshElement

-(instancetype)init
{
    if (self = [super init]) {
        _borderLineCount = 5;
        _maxRadius = [UIScreen mainScreen].bounds.size.width * 0.21;
        _nameFont = [UIFont systemFontOfSize:14];
        _nameColor = [UIColor blackColor];
        _descFont = [UIFont systemFontOfSize:10];
        _descColor = [UIColor blueColor];
        _valueFont = [UIFont systemFontOfSize:12];
        _valueColor = [UIColor lightTextColor];
        _fillLayerHidden = NO;
        _fillLayerBackgroundColor = [UIColor lightGrayColor];
        _fillLineColor = [UIColor grayColor];
    }
    return self;
}

-(void)setOrginDatas:(NSArray<FQMeshItem *> *)orginDatas
{
    _orginDatas = orginDatas;
    
    CGFloat maxNum = CGFLOAT_MIN;
    CGFloat minNum = CGFLOAT_MAX;
    for (FQMeshItem * element in orginDatas) {
        if (element.value.floatValue > maxNum) {
            maxNum = element.value.floatValue;
        }
        
        if (element.value.floatValue < minNum) {
            minNum = element.value.floatValue;
        }
    }
    self.maxValue = maxNum;
    self.minValue = minNum;
}

@end
