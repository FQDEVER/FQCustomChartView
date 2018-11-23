//
//  FQChartConfiguration.m
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQChartConfiguration.h"

@implementation FQChartConfiguration

-(instancetype)init
{
    if (self = [super init]) {
        [self creatDefaultConofiguration];
    }
    return self;
}

-(void)creatDefaultConofiguration{
    
    _drawWithAnimation = YES;
    _xAxisLabelsTitleColor = _yAxisLabelsTitleColor = _yAxisRightTitleColor = _yAxisLeftTitleColor = [UIColor blackColor];
    _xAxisLabelsTitleFont = _yAxisLabelsTitleFont = _yAxisRightTitleFont = _yAxisLeftTitleFont = [UIFont systemFontOfSize:12];
    _gridLineWidth = 0.5;
    _gridLineColor = rgba(0, 0, 0, 0.2);
    _gridRowCount = 10;
    _gridColumnCount = 10;
    _gestureEnabel = YES;
    _minimumPressDuration = 0.5f;
    _drawAnimationDuration = 0.0f;
    _hiddenLeftYAxis = YES;
    _hiddenRightYAxis = YES;
    _xAxisIsBottom = YES;
    _currentLineColor = [UIColor blackColor];
    _popContentBackColor = [UIColor blackColor];
    _mainContainerBackColor = [UIColor clearColor];
    _isShowPopView = YES;
    _isShowSelectPoint = YES;
    _selectPointColor = [UIColor redColor];
    _isSelectPointBorder = YES;
    _chartBackLayerEdgeInsets = UIEdgeInsetsZero;
    _chartBackLayerColor = [UIColor whiteColor];
    _kDefaultYAxisNames = 5;
    _kXAxisLabelTop = 5.0;
    _kYAxisLabelMargin = 5.0;
    _kYAxisChartViewMargin = 10.0;
    _kYTitleLabelBot = 10.0;
    _kChartViewWidthMargin = 40.0;
    _kChartViewHeightMargin = 40.0;
    
}

@end
