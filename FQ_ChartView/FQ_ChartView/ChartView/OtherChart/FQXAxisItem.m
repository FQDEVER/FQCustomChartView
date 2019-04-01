//
//  FQBarItem.m
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQXAxisItem.h"

@implementation FQXAxisItem

/**
 设置数据item
 
 @param dataNumber (NSNumber *)dataNumber
 @param dataValue (NSNumber *)dataValue
 @return instancetype
 */
- (instancetype)initWithDataNumber:(NSNumber*)dataNumber
                         dataValue:(NSNumber*)dataValue
{
    if (self = [super init]) {
        self.dataNumber = dataNumber;
        self.dataValue = dataValue;
    }
    return self;
}

@end
