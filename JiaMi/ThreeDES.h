//
//  ThreeDES.h
//  JiaMi
//
//  Created by yelon on 14-12-2.
//  Copyright (c) 2014年 yelon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@interface ThreeDES : NSObject
+ (NSString *)encode:(NSString *)data key:(NSString *)key;
+ (NSString *)TripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString *)encryptOrDecryptKey;
@end
