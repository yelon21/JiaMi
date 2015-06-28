//
//  YL3DES.m
//  JiaMi
//
//  Created by yelon on 14-12-4.
//  Copyright (c) 2014年 yelon. All rights reserved.
//

#import "YL3DES.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

@implementation YL3DES

static    unsigned char Key[64];
static	  unsigned char input[64],output[64];
static    unsigned char Kn[16][48];

unsigned char T1_1[] = {
    57,49,41,33,25,17, 9, 1,
    59,51,43,35,27,19,11, 3,
    61,53,45,37,29,21,13, 5,
    63,55,47,39,31,23,15, 7,
    56,48,40,32,24,16, 8, 0,
    58,50,42,34,26,18,10, 2,
    60,52,44,36,28,20,12, 4,
    62,54,46,38,30,22,14, 6
};

unsigned char T2_1[] = {
    39, 7,47,15,55,23,63,31,
    38, 6,46,14,54,22,62,30,
    37, 5,45,13,53,21,61,29,
    36, 4,44,12,52,20,60,28,
    35, 3,43,11,51,19,59,27,
    34, 2,42,10,50,18,58,26,
    33, 1,41, 9,49,17,57,25,
    32, 0,40, 8,48,16,56,24
};

unsigned char T3_1[] = {
    31, 0, 1, 2, 3, 4,
    3, 4, 5, 6, 7, 8,
    7, 8, 9,10,11,12,
    11,12,13,14,15,16,
    15,16,17,18,19,20,
    19,20,21,22,23,24,
    23,24,25,26,27,28,
    27,28,29,30,31, 0
};

unsigned char T5_1[] = {
    15, 6,19,20,
    28,11,27,16,
    0,14,22,25,
    4,17,30, 9,
    1, 7,23,13,
    31,26, 2, 8,
    18,12,29, 5,
    21,10, 3,24
};

unsigned char T7_1_2_1[56] =
{
    56,48,40,32,24,16, 8,
    0,57,49,41,33,25,17,
    9, 1,58,50,42,34,26,
    18,10, 2,59,51,43,35,
    
    62,54,46,38,30,22,14,
    6,61,53,45,37,29,21,
    13, 5,60,52,44,36,28,
    20,12, 4,27,19,11, 3
};

unsigned char T8_1[] =
{
    0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0
};

unsigned char T9_1[] =
{
    13,16,10,23, 0, 4,
    2,27,14, 5,20, 9,
    22,18,11, 3,25, 7,
    15, 6,26,19,12, 1,
    40,51,30,36,46,54,
    29,39,50,44,32,47,
    43,48,38,55,33,52,
    45,41,49,35,28,31
};

unsigned char T6_1[][64] =
{
    /* S1 */
    {
        14, 4,13, 1, 2,15,11, 8, 3,10, 6,12, 5, 9, 0, 7,
        0,15, 7, 4,14, 2,13, 1,10, 6,12,11, 9, 5, 3, 8,
        4, 1,14, 8,13, 6, 2,11,15,12, 9, 7, 3,10, 5, 0,
        15,12, 8, 2, 4, 9, 1, 7, 5,11, 3,14,10, 0, 6,13
    },
    
    /* S2 */
    {
        15, 1, 8,14, 6,11, 3, 4, 9, 7, 2,13,12, 0, 5,10,
        3,13, 4, 7,15, 2, 8,14,12, 0, 1,10, 6, 9,11, 5,
        0,14, 7,11,10, 4,13, 1, 5, 8,12, 6, 9, 3, 2,15,
        13, 8,10, 1, 3,15, 4, 2,11, 6, 7,12, 0, 5,14, 9
    },
    
    /* S3 */
    {
        10, 0, 9,14, 6, 3,15, 5, 1,13,12, 7,11, 4, 2, 8,
        13, 7, 0, 9, 3, 4, 6,10, 2, 8, 5,14,12,11,15, 1,
        13, 6, 4, 9, 8,15, 3, 0,11, 1, 2,12, 5,10,14, 7,
        1,10,13, 0, 6, 9, 8, 7, 4,15,14, 3,11, 5, 2,12
    },
    
    /* S4 */
    {
        7,13,14, 3, 0, 6, 9,10, 1, 2, 8, 5,11,12, 4,15,
        13, 8,11, 5, 6,15, 0, 3, 4, 7, 2,12, 1,10,14, 9,
        10, 6, 9, 0,12,11, 7,13,15, 1, 3,14, 5, 2, 8, 4,
        3,15, 0, 6,10, 1,13, 8, 9, 4, 5,11,12, 7, 2,14
    },
    
    /* S5 */
    {
        2,12, 4, 1, 7,10,11, 6, 8, 5, 3,15,13, 0,14, 9,
        14,11, 2,12, 4, 7,13, 1, 5, 0,15,10, 3, 9, 8, 6,
        4, 2, 1,11,10,13, 7, 8,15, 9,12, 5, 6, 3, 0,14,
        11, 8,12, 7, 1,14, 2,13, 6,15, 0, 9,10, 4, 5, 3
    },
    
    /* S6 */
    {
        12, 1,10,15, 9, 2, 6, 8, 0,13, 3, 4,14, 7, 5,11,
        10,15, 4, 2, 7,12, 9, 5, 6, 1,13,14, 0,11, 3, 8,
        9,14,15, 5, 2, 8,12, 3, 7, 0, 4,10, 1,13,11, 6,
        4, 3, 2,12, 9, 5,15,10,11,14, 1, 7, 6, 0, 8,13
    },
    
    /* S7 */
    {
        4,11, 2,14,15, 0, 8,13, 3,12, 9, 7, 5,10, 6, 1,
        13, 0,11, 7, 4, 9, 1,10,14, 3, 5,12, 2,15, 8, 6,
        1, 4,11,13,12, 3, 7,14,10,15, 6, 8, 0, 5, 9, 2,
        6,11,13, 8, 1, 4,10, 7, 9, 5, 0,15,14, 2, 3,12
    },
    
    /* S8 */
    {
        13, 2, 8, 4, 6,15,11, 1,10, 9, 3,14, 5, 0,12, 7,
        1,15,13, 8,10, 3, 7, 4,12, 5, 6,11, 0,14, 9, 2,
        7,11, 4, 1, 9,12,14, 2, 0, 6,10,13,15, 3, 5, 8,
        2, 1,14, 7, 4,10, 8,13,15,12, 9, 0, 3, 5, 6,11
    }
};

unsigned char TE1[][4] =
{
    {0,0,0,0},
    {0,0,0,1},
    {0,0,1,0},
    {0,0,1,1},
    {0,1,0,0},
    {0,1,0,1},
    {0,1,1,0},
    {0,1,1,1},
    {1,0,0,0},
    {1,0,0,1},
    {1,0,1,0},
    {1,0,1,1},
    {1,1,0,0},
    {1,1,0,1},
    {1,1,1,0},
    {1,1,1,1}
};

void fonction(unsigned char *Knn, unsigned char *r, unsigned char *s)
{
    
    unsigned char x[32];
    unsigned long *px;
    int i, l;
    unsigned char c;
    unsigned char t;
    
    for (i = 0, l = 0, px = (unsigned long *) x; i < 8;)
    {
        c = 32 * (r[T3_1[l]] ^ Knn[l]);
        l++;
        c += 8 * (r[T3_1[l]] ^ Knn[l]);
        l++;
        c += 4 * (r[T3_1[l]] ^ Knn[l]);
        l++;
        c += 2 * (r[T3_1[l]] ^ Knn[l]);
        l++;
        c += 1 * (r[T3_1[l]] ^ Knn[l]);
        l++;
        c += 16 * (r[T3_1[l]] ^ Knn[l]);
        l++;
        t = T6_1[i][c];
        i++;
        *px = *(long *)TE1[t];
        px++;
    }
    for (i = 0; i < 32; i++)
    {
        s[i] = x[T5_1[i]];
    }
}
void eclater(unsigned char *buf_bit, unsigned char *byte)
{
    int i;
    unsigned char m;
    
    for (i = 0; i < 8; i++)
    {
        for (m = 0x80; m != 0;	)
        {
            if ((buf_bit[i] & m) != 0)
                *byte = 1;
            else
                *byte = 0;
            byte++;
            m=m/2 ;
        }
    }
    
}
void Ks(unsigned char *Key, unsigned char Kn[16][48])
{
    unsigned char cd[56];
    
    unsigned char possta[60] ;
    
    int n;
    unsigned char tmp11, tmp12, tmp21, tmp22;
    int i;
    unsigned char *Knn;
    
    
    for (i = 0; i < 56; i++)
    {
        cd[i] = Key[T7_1_2_1[i]];
    }
    
    for (n = 0; n < 16; n++)
    {
        if (T8_1[n] == 0)
        {
            tmp11 = cd[0];
            tmp21 = cd[28];
            memcpy( possta , &cd[1] , 55 );
            memcpy( cd , possta 	, 55 );
            cd[27] = tmp11;
            cd[55] = tmp21;
        }
        else
        {
            tmp11 = cd[0];
            tmp12 = cd[1];
            tmp21= cd[28];
            tmp22 = cd[29];
            
            memcpy( possta , &cd[2] , 54 );
            memcpy( cd , possta 	, 54 );
            
            cd[26] = tmp11;
            cd[27] = tmp12;
            cd[54] = tmp21;
            cd[55] = tmp22;
        }
        Knn = Kn[n];
        for (i = 0; i < 48; i++)
        {
            Knn[i] = cd[T9_1[i]];
        }
    }
}
void permutation(unsigned char *org, unsigned char *tab)
{
    unsigned char tmp[64];
    int i;
    
    
    memcpy(tmp, org, 64);
    for (i = 0; i < 64; i++)
    {
        org[i] = tmp[tab[i]];
    }
}
void chiffrement(unsigned char *xi, unsigned char *xo, unsigned char Kn[16][48])
{
    unsigned char r[32], l[32];
    unsigned char rp[32], lp[32];
    
    int i;
    int n;
    
    memcpy(l, &xi[0], 32);
    memcpy(r, &xi[32], 32);
    
    for (n = 0; n < 16; n++)
    {
        memcpy(lp, r, 32);
        
        fonction(Kn[n], r, rp);
        for (i = 0; i < 32; i++)
        {
            r[i] =( ( l[i]) ^ (rp[i] )  ) ;
        }
        memcpy(l, lp, 32);
    }
    memcpy(&xo[0], r, 32);
    memcpy(&xo[32], l, 32);
    
}
void compacter(unsigned char *byte, unsigned char *buf_bit)
{
    int i;
    unsigned char m, n;
    
    for (i = 0; i < 8; i++)
    {
        n = 0;
        for (m = 0x80; m != 0; )
        {
            if (*byte++)
                n = n | m;
            m=m/2 ;
            
        }
        buf_bit[i] = n;
    }
}

void dechiffrement(unsigned char *xi, unsigned char *xo, unsigned char Kn[16][48])
{
    unsigned char r[32], l[32], rp[32], lp[32];
    
    int i;
    int n;
    
    memcpy(l, &xi[0], 32);
    memcpy(r, &xi[32], 32);
    
    for (n = 0; n < 16; n++)
    {
        memcpy(lp, r, 32);
        fonction(Kn[15 - n], r, rp);
        for (i = 0; i < 32; i++)
        {
            r[i] =( ( l[i] ) ^ ( rp[i] )) ;
        }
        memcpy(l, lp, 32);
    }
    
    memcpy(&xo[0], r, 32);
    memcpy(&xo[32], l, 32);
}






/**
 *  *@brief　　des加密
 *   *@param   binput    需要加密的数据 (8字节)
 *    *@param   boutput   加密后的数据(8字节)
 *     *@param   bkey   　　加密所用的密钥 (8字节)
 *      */

void Des(unsigned char *binput, unsigned char *boutput, unsigned char *bkey)
{
    
    eclater(binput, input);
    eclater(bkey, Key);
    Ks(Key, Kn);
    
    permutation(input, T1_1);
    chiffrement(input, output, Kn);
    
    permutation(output, T2_1);
    compacter(output, boutput);
}
/**
 *  *@brief　对des加密的密文进行解密
 *   *@param   binput    需要解密的数据(8字节
 *    *@param   boutput   解密后的数据(8字节)
 *     *@param   bkey   　解密所用的密钥 (8字节)
 *      */
void Desm(unsigned char *binput, unsigned char *boutput, unsigned char *bkey)
{
    
    eclater(binput, input);
    eclater(bkey, Key);
    Ks(Key, Kn);
    
    permutation(input, T1_1);
    dechiffrement(input, output, Kn);
    permutation(output, T2_1);
    compacter(output, boutput);
    
}
/**
 *  *@brief　 3 des加密
 *  *@param   in    需要解密的数据(8字节)
 *  *@param   out   解密后的数据(8字节)
 *  *@param   key   　解密所用的密钥 (16字节)
 *  *@attention  加密密钥必须为16字节
 * - 加密算法
 * -#　先用密钥前8字节对数据进行des加密得密文A
 * -#　再用密钥后8字节对上密文A数据进行desm解密得密文B
 * -#　再用密钥前8字节对密文B进行des加密得密文为加密结果
 * */

void TriDes(unsigned char *in_, unsigned char *out_, unsigned char *key)
{
    
    Des(in_,out_,key);
    Desm(out_,out_,&key[8]);
    Des(out_,out_,key);
}


/**
 * *@brief　 3 des解密
 * *@param   in    需要解密的数据(8字节)
 * *@param   out   解密后的数据(8字节)
 * *@param   key   解密所用的密钥 (16字节)
 * *@attention  解密密钥必须为16字节
 * - 解密算法
 * -#　先用密钥前8字节对数据进行desm解密得密文A
 * -#　再用密钥后8字节对上密文A数据进行des加密得密文B
 * -#　再用密钥前8字节对密文B进行desm解密得密文为解密结果
 */

void UnTriDes(unsigned char *in_, unsigned char *out_, unsigned char *key)
{
    Desm(in_,out_,key);
    Des(out_,out_,&key[8]);
    Desm(out_,out_,key);
}

/**
 **@brief　字符串１按位与字符串２进行异或
 **@param   a    字符串１的地址
 **@param   b    字符串2的地址
 **@param   lg   异或的长度（指定）
 **/
void xor(unsigned char *a,unsigned char *b,int lg)
{
    for (;lg--;){

        *a++ ^= *b++;
    }
}

// 检测ch是否为十六进制字符
bool IsHex(unsigned char ch)
{
    return (ch >= '0' && ch <= '9') || (ch >= 'A' && ch <= 'F') || (ch >= 'a' && ch <= 'f');
}

int HexVal(unsigned char ch)
{
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

unsigned char ValHex(int val)
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

int HexToAsc(unsigned char* strhex, unsigned char* strasc, int length)
{
    //if (length % 2 == 1) // length表示转换strhex的元素个数，如果严格要求只能转换偶数个，这里可以进行判断
    //{
    //    return -1;
    //}
    if (length > strlen((const char*)strhex))
    {
        length = strlen((const char*)strhex);
    }
    
    // 检测strhex是否合法，是否存在非0~9、A~F、a~f字符
    for (auto int i = 0; i != length; ++i)
    {
        if (!IsHex(strhex[i]))
        {
            return -2;
        }
    }
    
    // 以下for-if结构可以同时处理奇偶的情况
    int pos = 0, i = 0;
    for (i = 0; i < length - 1; i += 2)
    {
        unsigned char tmp = HexVal(strhex[i]) * 16 + HexVal(strhex[i + 1]);
        strasc[pos++] = tmp;
    }
//    if (i == length - 1)
//    {
//        unsigned char tmp = HexVal(strhex[i]) * 16;
//        strasc[pos++] = tmp;
//        
//        // 用来标识length的奇偶，这里是奇数
//        strasc[pos++] = 1;
//    }
//    else
//    {
//        // 用来标识length的就，这里偶数
//        strasc[pos++] = 2;
//    }
    strasc[pos++] = 0;
    return 0;
}

int AscToHex(unsigned char* strasc, unsigned char* strhex, int length)
{
    
    int ascL = strlen((const char*)strasc);
    if (length >  ascL) {
        
        length = ascL;
    }

    // strasc中的元素不存在合不合法的情况，所以不做检测
    
    int i = 0, pos = 0;
    for (i = 0; i < length - 1; ++i) // 这里先处理length-1个字符，第length个字符后续处理，因为需要考虑奇偶的情况
    {
        strhex[pos++] = ValHex(strasc[i] / 16);
        strhex[pos++] = ValHex(strasc[i] % 16);
    }
    
    if (strasc[strlen((const char*)strasc) - 1] == 1) // 奇数的情况
    {
        strhex[pos++] = ValHex(strasc[length - 1] / 16);
    }
    else if (strasc[strlen((const char*)strasc) - 1] == 2) // 偶数的情况
    {
        strhex[pos++] = ValHex(strasc[length - 1] / 16);
        strhex[pos++] = ValHex(strasc[length - 1] % 16);
    }
    
    strhex[pos++] = 0;
    return 0;
}

//+ (NSString *)HexTo8421BCD(NSString *)hexValueString{
//
//    for
//}
//unsigned char* HexTo8421BCD(unsigned char* hex){
//
//    int m;
//    char *p, a[50];
//flag:
//    
//    p = a;
//    cout << "输入一个十进制数:\n";
//    cin >> p;
//    cout << "8421码:";
//    while(*p != '\0')
//    {
//        m = *p - 48;
//        switch(m)
//        {
//            case 9:
//                cout << "1001";
//                break;
//            case 8:
//                cout << "1000";
//                break;
//            case 7:
//                cout << "0111";
//                break;
//            case 6:
//                cout << "0110";
//                break;
//            case 5:
//                cout << "0101";
//                break;
//            case 4:
//                cout << "0100";
//                break;
//            case 3:
//                cout << "0011";
//                break;
//            case 2:
//                cout << "0010";
//                break;
//            case 1:
//                cout << "0001";
//                break;
//            case 0:
//                cout << "0000";
//                break;
//        }
//        p++;
//    }
//    cout << endl;
//    goto flag;
//
//}

@end
