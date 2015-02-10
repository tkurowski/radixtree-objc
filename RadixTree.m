//
//  RadixTree.m
//  Playground
//
//  Created by Tommy on 16/01/15.
//  Copyright (c) 2015 Tommy. All rights reserved.
//

#import "RadixTree.h"
#import "RadixTreeDescriptor.h"
#import "RadixTreeDescriptor+.h"

typedef int KeyMatch;

#define KEY_MATCH_NONE 0
#define KEY_MATCH_STARTS_WITH -1
#define KEY_MATCH_IS_BEGINING_OF -2
#define KEY_MATCH_EXACT -3
// all others: KEY_MATCH_COMMON_PREFIX

static KeyMatch key_match(NSString *key, NSString *other) {
    NSUInteger len = MIN(key.length, other.length);

    for (int i = 0; i < len; i++) {
        if ([key characterAtIndex:i] != [other characterAtIndex:i]) {
            return i; // KEY_MATCH_COMMON_PREFIX
        }
    }
    // empty string is a special case
    if (key.length < other.length) return KEY_MATCH_IS_BEGINING_OF;
    if (key.length > other.length) return KEY_MATCH_STARTS_WITH;
    return KEY_MATCH_EXACT;
}


@interface RadixTree ()

@property (nonatomic) NSMutableArray *children;
@property (nonatomic) NSString *key;

@end


@implementation RadixTree

- (id)initWithKey:(NSString *)key data:(id)data {
    if (self = [super init]) {
        _key = key;
        _data = data;
    }
    return self;
}

- (id)initWithKey:(NSString *)key {
    return [self initWithKey:key data:nil];
}

// only the root can (and *must*) have empty key
- (id)init {
    self = [self initWithKey:@""];
    return self;
}

// only on root?
- (void)setData:(id)data atKey:(NSString *)key {
    RadixTreeDescriptor *closest = [self closestNodeForKey:key isCommonPrefixOK:YES];

    KeyMatch keyMatch = key_match(closest.key, key);
    switch (keyMatch) {
        case KEY_MATCH_EXACT:
            closest.node.data = data;
            break;
        case KEY_MATCH_IS_BEGINING_OF:
            [closest.node addChildWithKey:[key substringFromIndex:closest.key.length] data:data];
            break;
        case KEY_MATCH_NONE:
            assert(FALSE); // it's because self is root with key=@"" that matches everything!
            break;
        case KEY_MATCH_STARTS_WITH: {
            assert(closest.parent); // are you sure root node has empty key?
            RadixTree *node = [[RadixTree alloc]
                               initWithKey:[key
                                            substringFromIndex:
                                            closest.key.length - closest.node.key.length]
                               data:data];
            [closest.parent insertNode:node inPlaceOf:closest.node];
            break;
        }
        default: { // KEY_MATCH_COMMON_PREFIX
            /*
             key =              |**********++----|
             closest.key =      |**********++xxx|
             closest.node.key =           |++xxx|
             match =            |**********++|
             branchingKey =               |++|
             newNode.key =                  |----|
             */
            RadixTree *branchingNode = [[RadixTree alloc]
                                        initWithKey:[closest.node.key substringToIndex:
                                                     keyMatch - closest.key.length + closest.node.key.length]];
            // insert new node to the branch
            [branchingNode addChildWithKey:[key substringFromIndex:keyMatch] data:data];
            // insert the branch in place of found node (will attach the node to the branch)
            [closest.parent insertNode:branchingNode inPlaceOf:closest.node];
            break;
        }
    }

}

- (void)insertNode:(RadixTree *)newNode inPlaceOf:(RadixTree *)childNode {
    assert(self.children);
    assert(key_match(newNode.key, childNode.key) == KEY_MATCH_IS_BEGINING_OF);

    NSUInteger inx = [self.children indexOfObjectIdenticalTo:childNode];
    assert(inx != NSNotFound);

    // replace currentNode with newNode
    [self.children replaceObjectAtIndex:inx withObject:newNode];

    // insert detached node as the child of the newNode
    childNode.key = [childNode.key substringFromIndex:newNode.key.length];
    [newNode addChild:childNode];
}


- (void)addChildWithKey:(NSString *)key data:(id)data {
    [self addChild:[[RadixTree alloc] initWithKey:key data:data]];
}

- (void)addChild:(RadixTree *)node {
    if (!self.children) self.children = [NSMutableArray arrayWithObject:node];
    else [self.children addObject:node];
}


- (RadixTreeDescriptor *)descriptor:(RadixTree *)parent {
    return [[RadixTreeDescriptor alloc] initWithKey:self.key node:self parent:parent];
}

// only on root?
- (RadixTreeDescriptor *)closestNodeForKey:(NSString *)key {
    return [self closestNodeForKey:key isCommonPrefixOK:NO];
}

// only on root?
- (RadixTreeDescriptor *)closestNodeForKey:(NSString *)key isCommonPrefixOK:(BOOL)isCommonPrefixOK {
    return [self closestNodeForKey:key parent:nil isCommonPrefixOK:isCommonPrefixOK];
}

- (RadixTreeDescriptor *)closestNodeForKey:(NSString *)key parent:(RadixTree *)parent isCommonPrefixOK:(BOOL)isCommonPrefixOK {

    switch (key_match(self.key, key)) {
        case KEY_MATCH_NONE:
            return nil;
        case KEY_MATCH_IS_BEGINING_OF: {
            NSString *keyEnding = [key substringFromIndex:self.key.length];
            RadixTreeDescriptor *found;
            for (RadixTree *node in self.children) {
                found = [node closestNodeForKey:keyEnding parent:self isCommonPrefixOK:NO];
                if (found) {
                    found.key = [self.key stringByAppendingString:found.key];
                    return found;
                }
            }
            return [self descriptor:parent];
        }
        case KEY_MATCH_EXACT:
        case KEY_MATCH_STARTS_WITH:
            return [self descriptor:parent];
        default: // KEY_MATCH_COMMON_PREFIX
            return isCommonPrefixOK ? [self descriptor:parent] : nil;
    }
}


@end
