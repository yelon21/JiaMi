//
//  NSString+_DES.h
//  JiaMi
//
//  Created by yelon on 14-12-6.
//  Copyright (c) 2014年 yelon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (_DES)

- (BOOL)hex2Asc:(unsigned char *)asc;
+ (NSString *)asc2Hex:(unsigned char *)strasc length:(int)length;
- (NSString *)xorString;
@end
