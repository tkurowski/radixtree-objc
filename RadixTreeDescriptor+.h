//
//  RadixTreeDescriptor+.h
//  Playground
//
//  Created by Tommy on 10/02/15.
//  Copyright (c) 2015 Tommy. All rights reserved.
//

#ifndef Playground_RadixTreeDescriptor__h
#define Playground_RadixTreeDescriptor__h


// I'm putting this extension in a separate file because it includes non-public
// stuff that is still allowed to be seen and used by 'friends'
@interface RadixTreeDescriptor ()

@property (nonatomic, readonly) RadixTree *node, *parent;
@property (nonatomic) NSString *key;

@end

#endif
