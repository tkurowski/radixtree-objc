//
//  RadixTreeDescriptor.h
//  Playground
//
//  Created by Tommy on 10/02/15.
//  Copyright (c) 2015 Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RadixTree;

@interface RadixTreeDescriptor : NSObject

@property (nonatomic, readonly) NSString *key;
@property (nonatomic, readonly) id data; // shortcut to self.node.data
//@property (nonatomic, readonly) id<NSFastEnumeration> children; 'data' of node.children

- (id)initWithKey:(NSString *)key node:(RadixTree *)node parent:(RadixTree *)parent;

@end