//
//  FQMeshItem.m
//  FQ_ChartView
//
//  Created by 范奇 on 2019/3/27.
//  Copyright © 2019 fanqi. All rights reserved.
//

#import "FQMeshItem.h"

@implementation FQMeshItem

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.valueStr = [NSString stringWithFormat:@"%.02f%% %@",self.value.floatValue * 100,self.time];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}

+(NSArray *)getMeshItemArrWithDictArr:(NSArray<NSDictionary *> *)dictArr
{
    NSMutableArray * muArr = [NSMutableArray array];
    for (NSDictionary * dict in dictArr) {
        FQMeshItem * meshItem = [[FQMeshItem alloc] initWithDict:dict];
        [muArr addObject:meshItem];
    }
    return muArr.copy;
}


@end
