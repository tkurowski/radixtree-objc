//
//  RadixTreeDescriptor.m
//  Playground
//
//  Created by Tommy on 10/02/15.
//  Copyright (c) 2015 Tommy. All rights reserved.
//

#import "RadixTreeDescriptor.h"
#import "RadixTreeDescriptor+.h"
#import "RadixTree.h"



@implementation RadixTreeDescriptor

- (id)init {
    assert(FALSE); // should never be called
    return nil;
}

- (id)initWithKey:(NSString *)key node:(RadixTree *)node parent:(RadixTree *)parent {
    if (self = [super init]) {
        _key = key;
        _node = node;
        _parent = parent;
    }
    return self;
}

- (id)data {
    return self.node.data;
}

@end

