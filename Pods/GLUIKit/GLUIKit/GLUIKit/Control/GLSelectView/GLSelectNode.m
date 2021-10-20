//
//  GLSelect.m
//  WDPlugin_CRM
//
//  Created by xiaofengzheng on 12/26/15.
//  Copyright © 2015 baoyuanyong. All rights reserved.
//

#import "GLSelectNode.h"

@implementation GLSelectNode


#pragma mark- 查出有多少层
+ (NSInteger)checkLayer:(GLSelectNode *)rootNode
{
    if (rootNode) {
        if (rootNode.subArray.count > 0) {
            NSMutableArray *sizeArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < rootNode.subArray.count; i++) {
                NSInteger count = [self checkLayer:(GLSelectNode *)[rootNode.subArray objectAtIndex:i]];
                [sizeArray addObject:[NSNumber numberWithInteger:count]];
            }
            return 1 + [self getMax:sizeArray];
        } else {
            return 1;
        }
    } else {
        return 0;
    }
}


+ (NSInteger)getMax:(NSArray *)array
{
    NSMutableArray *sortArray = [NSMutableArray arrayWithArray:array];
    [sortArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger a = [(NSNumber *)obj1 integerValue];
        NSInteger b = [(NSNumber *)obj2 integerValue];
        if (a > b) {
            return NSOrderedDescending;
        } else if (a == b) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    
#ifdef DEBUG
    NSLog(@"%@",sortArray);
#endif
    
    return [(NSNumber *)sortArray.lastObject integerValue];
    
}




#pragma mark- 递归解析
+ (GLSelectNode *)parseCityTree:(NSArray *)array
{
    // 根
    GLSelectNode *rootNode = [[GLSelectNode alloc] init];
    if (array.count > 0) {
        
        NSMutableArray *selectArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dic = [array objectAtIndex:i];
            GLSelectNode *node = [GLSelectNode parseNode:dic];
            [selectArray addObject:node];
        }
        rootNode.subArray = selectArray;
    }
    return rootNode;
}


+ (GLSelectNode *)parseNode:(NSDictionary *)dic
{
    if (dic) {
        GLSelectNode *node    = [[GLSelectNode alloc] init];
        node.title        = dic[@"des"];
        node.currentID    = dic[@"rID"];
        node.parentID     = dic[@"pID"];
        
        NSArray *subDicArray =  dic[@"son"];
        if (subDicArray.count > 0) {
            NSMutableArray *subArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < subDicArray.count; i++) {
                NSDictionary *subDic = [subDicArray objectAtIndex:i];
                GLSelectNode *subNode = [self parseNode:subDic];
                [subArray addObject:subNode];
            }
            node.subArray = subArray;
        }
        return node;
    } else {
        return nil;
    }
}

#pragma mark- 查出同样的节点的跟节点
+ (GLSelectNode *)findeSameNode:(GLSelectNode *)findeNode inArray:(NSArray *)array isRelation:(BOOL)isRelation
{
    for (int i = 0; i < array.count; i++) {
        GLSelectNode *currentNode = [array objectAtIndex:i];
        
        if (isRelation) {
            if ([currentNode.currentID isEqualToString:findeNode.currentID] &&
                [currentNode.parentID isEqualToString:findeNode.parentID]) {
                currentNode.index = i;
                return currentNode;
            }
        } else {
            // 非关系
            if ([currentNode.currentID isEqualToString:findeNode.currentID]) {
                currentNode.index = i;
                return currentNode;
            }
        }
    }
    return nil;
}



@end
