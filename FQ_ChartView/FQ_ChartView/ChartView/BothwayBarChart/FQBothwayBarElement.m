//
//  FQBothwayBarElement.m
//  FQ_ChartView
//
//  Created by 范奇 on 2019/3/28.
//  Copyright © 2019 fanqi. All rights reserved.
//

#import "FQBothwayBarElement.h"

@implementation FQBothwayBarElement

-(instancetype)init
{
    if (self = [super init]) {
        _dateTextFont = [UIFont systemFontOfSize:12] ;
        _dateTextColor = UIColor.lightTextColor;
        _leftDataTextFont = [UIFont systemFontOfSize:12];
        _leftDataTextColor = UIColor.blueColor;
        _rightDataTextFont = [UIFont systemFontOfSize:12];
        _rightDataTextColor = UIColor.redColor;
        _leftBarColors = @[(id)UIColor.blueColor.CGColor,(id)UIColor.redColor.CGColor];
        _rightBarColors = @[(id)UIColor.redColor.CGColor,(id)UIColor.blueColor.CGColor];
        _descTextColor = UIColor.lightTextColor;
        _descTextFont = [UIFont systemFontOfSize:10];
        _bothwayTopMargin = 10;
        _bothwayMidContentW = 28;
        _bothwayBarH = 6;
        _bothwayBarMargin = 14;
        _bothwayTextBarMargin = 5;
        _barLeftMargin = 52;
        _barRightMargin = 52;
    }
    return self;
}

@end
