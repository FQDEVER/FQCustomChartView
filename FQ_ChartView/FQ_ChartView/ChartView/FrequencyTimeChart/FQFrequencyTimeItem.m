//
//  FQFrequencyTimeItem.m
//  FQ_ChartView
//
//  Created by 范奇 on 2019/4/1.
//  Copyright © 2019 fanqi. All rights reserved.
//

#import "FQFrequencyTimeItem.h"

@implementation FQFrequencyTimeItem

-(instancetype)init
{
    if (self = [super init]) {
        self.dataItemArr = [NSArray array];
        self.itemColors = @[(id)UIColor.redColor.CGColor,(id)UIColor.blueColor.CGColor] ;
    }
    return self;
}

@end
