//
//  FQBothwayBarItem.m
//  FQ_ChartView
//
//  Created by 范奇 on 2019/3/28.
//  Copyright © 2019 fanqi. All rights reserved.
//

#import "FQBothwayBarItem.h"

@implementation FQBothwayBarItem

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}

+(NSArray *)getBothwayItemArrWithDictArr:(NSArray<NSDictionary *> *)dictArr
{
    NSMutableArray * muArr = [NSMutableArray array];
    for (NSDictionary * dict in dictArr) {
        FQBothwayBarItem * bothwayItem = [[FQBothwayBarItem alloc] initWithDict:dict];
        [muArr addObject:bothwayItem];
    }
    return muArr.copy;
}


@end
