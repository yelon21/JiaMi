//
//  ViewController.m
//  JiaMi
//
//  Created by yelon on 14-12-2.
//  Copyright (c) 2014年 yelon. All rights reserved.
//

#import "ViewController.h"
//#import "ThreeDES.h"
#import "YL3DES.h"
#import "NSString+_DES.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"iii";
    
    NSLog(@"xor == %c",'0'^'1');
    NSLog(@"xor == %c",'\0'^'1');
    NSLog(@"xor == %c",'F'^'1');
    
    NSLog(@"xor == %c",'0'^1);
    NSLog(@"xor == %c",'\0'^1);
    NSLog(@"xor == %c",'F'^1);
    
    NSLog(@"UTF8String == %@",[NSString stringWithCString:"12345678FF000234" encoding:NSASCIIStringEncoding]);
    
    int jinzhi  = 16;
    for (int i = 0; i<16; i++) {
        
        NSLog(@"i == %d|%x",i,jinzhi - i%jinzhi);
    }
    
    NSLog(@"xor == %@",[@"12345678FF000234" xorString]);
    
    unsigned char *a = "12345678FF000234";
    unsigned char *b = (unsigned char*)malloc(16*sizeof(char));
    xor_(a,b,16);
    NSString* data = @"12345678FF000234EDCBA98700FFFDCB";
    NSString* key = @"FEF3B0FC826689E010C5E6A5E9C16B63";
    NSString* result = @"AAACDEB3310ED703771369A83C93E199";
    
    [self triDes:data key:key enc:YES];
    
    [self triDes:result key:key enc:NO];
}

- (NSString *)triDes:(NSString *)data key:(NSString *)key enc:(BOOL)enc{

    int dataLength = [data length];
    int keyLength = [key length];
    
    if (dataLength%16 != 0) {
        
        NSLog(@"data长度不是16倍数");
        return @"";
    }
    if (keyLength != 32) {
        
        NSLog(@"key长度不是32");
        return @"";
    }
    
    unsigned char *dataAsc = (unsigned char*)malloc(dataLength*sizeof(char));
    unsigned char *keyAsc = (unsigned char*)malloc(keyLength*sizeof(char));

    unsigned char *dataResult = (unsigned char*)malloc(dataLength*sizeof(char));
    
    BOOL dataFlag  = [data hex2Asc:dataAsc];
    
    BOOL keyFlag   = [key hex2Asc:keyAsc];
    
    
    if (!keyFlag||!dataFlag) {
        
        NSLog(@"hex2Asc 失败");
        return @"";
    }
    
    NSLog(@"dataAsc==%lu",strlen((const char*)dataAsc));
    NSLog(@"dataAsc==%s",dataAsc);
    
    NSLog(@"keyAsc==%lu",strlen((const char*)keyAsc));
    NSLog(@"keyAsc==%s",keyAsc);
    
    int byteCount = dataLength/16;
    
    for (int i = 0; i < byteCount; i++) {
        
        if (enc) {
            
            TriDes(dataAsc+8*i, dataResult+8*i, keyAsc);
        }
        else{
        
            UnTriDes(dataAsc+8*i, dataResult+8*i, keyAsc);
        }
    }
    
    free(dataAsc);
    dataAsc=NULL;
    free(keyAsc);
    keyAsc = NULL;
    
    NSLog(@"dataAsc==%lu",strlen((const char*)dataResult));
    NSLog(@"dataAsc==%s",dataResult);
    
    NSString *dataHex = [NSString asc2Hex:dataResult length:dataLength/2];
    NSLog(@"dataHex==%@",dataHex);
    free(dataResult);
    dataResult = NULL;
    
    return dataHex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
