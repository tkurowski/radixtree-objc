//
//  RadixTree.h
//  Playground
//
//  Created by Tommy on 16/01/15.
//  Copyright (c) 2015 Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RadixTreeDescriptor.h" // rather than @class RadixTreeDescriptor;
                                // so as not to force clients to always ipmort both headers

@interface RadixTree : NSObject

@property (nonatomic) id data;

- (void)setData:(id)data atKey:(NSString *)key;
- (RadixTreeDescriptor *)closestNodeForKey:(NSString *)key;

@end

