//
//  FQHorizontalBarElement.m
//  FQ_ChartView
//
//  Created by fanqi on 2018/12/4.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQHorizontalBarElement.h"

@implementation FQHorizontalBarElement

-(instancetype)init
{
    if (self = [super init]) {
        _horizontalBarContentType = ChartHorizontalBarContentType_Inside;
        _isShowXLeftAxisStr = YES;
        _isShowXRightAxisStr = YES;
        _barPlaceholderColor = [UIColor clearColor];
        _titleColor = [UIColor blackColor];
        _titleFont = [UIFont systemFontOfSize:15];
        _xLeftAxisLabFont = [UIFont systemFontOfSize:12];
        _xLeftAxisLabColor = [UIColor grayColor];
        _contentLabFont = [UIFont systemFontOfSize:12];
        _contentLabColor = [UIColor grayColor];
        _chartTopLabFont = [UIFont systemFontOfSize:12];
        _chartTopLabColor = [UIColor grayColor];
        _xRightAxisLabFont = [UIFont systemFontOfSize:12];
        _xRightAxisLabColor = [UIColor grayColor];
        _colors = @[[UIColor blueColor],[UIColor redColor]];
        _mainColor = [UIColor blueColor];
        _horBarHeight = 18;
        _horBarMargin = 2;
        
        _horBarBotDescColor = [UIColor grayColor];
        _horBarBotDescFont = [UIFont systemFontOfSize:12];
        _horBarBotRightDescColor = UIColor.grayColor;
        _horBarBotRightDescFont = [UIFont systemFontOfSize:12];
        _horBarBotLeftDescColor = UIColor.grayColor;
        _horBarBotLeftDescFont = [UIFont systemFontOfSize:12];
        _xLeftAxisSelectLabFont = [UIFont systemFontOfSize:12];
        _xLeftAxisSelectLabColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1.0 alpha:1.0];
         _narrowestW = _horBarHeight * 0.5;
        _barLeftMargin = 5;
        _barRightMargin = 5;
        _barTopStrWidth = 30;
        _barContentMargin = 5;
    }
    return self;
}


@end
