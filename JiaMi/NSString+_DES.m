//
//  NSString+_DES.m
//  JiaMi
//
//  Created by yelon on 14-12-6.
//  Copyright (c) 2014年 yelon. All rights reserved.
//

#import "NSString+_DES.h"

@implementation NSString (_DES)

- (BOOL)hex2Asc:(unsigned char *)asc{

    self = [self uppercaseString];
    int length = [self length];
    
    if (length%2 == 1) {
        
        return NO;
    }
    
    for (int i = 0; i<length; i++) {
        
        if (![self isValidHex:[self characterAtIndex:i]]) {
            
            return NO;
        }
    }
    
    int pos = 0;
    for (int i = 0; i < length; i += 2)
    {
        unsigned char tmp = [self hexValue:[self characterAtIndex:i]] * 16 + [self hexValue:[self characterAtIndex:i+1]];
        
        NSLog(@"i==%d",i);
//        NSLog(@"tmpd==%d",tmp);
//        NSLog(@"tmpx==%x",tmp);
//        NSLog(@"tmpc==%c",tmp);
        
        asc[pos++] = tmp;
    }

    return YES;
}

+ (NSString *)asc2Hex:(unsigned char *)strasc length:(int)length {
    
    // strasc中的元素不存在合不合法的情况，所以不做检测
    
    NSMutableArray *hexArray = [[NSMutableArray alloc]init];
    
    int i = 0;
    for (i = 0; i < length; ++i)
    {
        [hexArray addObject:[NSString stringWithFormat:@"%c",[NSString valHex:strasc[i] / 16]]];
        [hexArray addObject:[NSString stringWithFormat:@"%c",[NSString valHex:strasc[i] % 16]]];
    }
    
    NSString *hex = [hexArray componentsJoinedByString:@""];
    NSLog(@"hex == %@",hex);
    return hex;
}

+ (unsigned char)valHex:(int)val
{
    if (val >= 0 && val <= 9)
    {
        return val + '0';
    }
    else if (val >= 10 && val <= 15)
    {
        return val - 10 + 'A';
    }
    else
    {
        return '$';
    }
}

- (int)hexValue:(char)ch{

    if (ch >= '0' && ch <= '9')
    {
        return ch - '0';
    }
    else if (ch >= 'A' && ch <= 'F')
    {
        return 10 + ch - 'A';
    }
    else if (ch >= 'a' && ch < 'f')
    {
        return 10 + ch - 'a';
    }
    else
    {
        return -1;
    }
}

- (BOOL)isValidHex:(char)ch{

    return (ch >= '0' && ch <= '9') || (ch >= 'A' && ch <= 'F') || (ch >= 'a' && ch <= 'f');
}

- (NSString *)xorString{

    int length = [self length];
    
    char *result = (char*)malloc(length*sizeof(char));
    
    for (int i = 0 ; i < length; i++) {
        result[i]='\0';
    }
    
    for (int i = 0 ; i < length; i++) {
        
        NSLog(@"result==%c",result[i]);
        char c = [self characterAtIndex:i];
        NSLog(@"c==%c",c);
        NSLog(@"c ^ c==%c",result[i]^c);
        result[i] ^= c;
        NSLog(@"c ^ c==%c",result[i]);
    }
    NSLog(@"==%s",result);
    NSString *value = [NSString stringWithCString:result encoding:NSUTF8StringEncoding];
    return value;
}
@end
