//
//  YL3DES.h
//  JiaMi
//
//  Created by yelon on 14-12-4.
//  Copyright (c) 2014年 yelon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YL3DES : NSObject

void fonction(unsigned char *Knn, unsigned char *r, unsigned char *s);

void eclater(unsigned char *buf_bit, unsigned char *byte);

void Ks(unsigned char *Key, unsigned char Kn[16][48]);

void permutation(unsigned char *org, unsigned char *tab);

void chiffrement(unsigned char *xi, unsigned char *xo, unsigned char Kn[16][48]);

void compacter(unsigned char *byte, unsigned char *buf_bit);

void dechiffrement(unsigned char *xi, unsigned char *xo, unsigned char Kn[16][48]);

/**
 *  *@brief　　des加密
 *   *@param   binput    需要加密的数据 (8字节)
 *    *@param   boutput   加密后的数据(8字节)
 *     *@param   bkey   　　加密所用的密钥 (8字节)
 *      */

void Des(unsigned char *binput, unsigned char *boutput, unsigned char *bkey);
/**
 *  *@brief　对des加密的密文进行解密
 *   *@param   binput    需要解密的数据(8字节
 *    *@param   boutput   解密后的数据(8字节)
 *     *@param   bkey   　解密所用的密钥 (8字节)
 *      */
void Desm(unsigned char *binput, unsigned char *boutput, unsigned char *bkey);
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

void TriDes(unsigned char *in_, unsigned char *out_, unsigned char *key);

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

void UnTriDes(unsigned char *in_, unsigned char *out_, unsigned char *key);

/**
 **@brief　字符串１按位与字符串２进行异或
 **@param   a    字符串１的地址
 **@param   b    字符串2的地址
 **@param   lg   异或的长度（指定）
 **/
void xor_(unsigned char *a,unsigned char *b,int lg);

// 检测ch是否为十六进制字符
bool IsHex(unsigned char ch);
int HexVal(unsigned char ch);
unsigned char ValHex(int val);
int HexToAsc(unsigned char* strhex, unsigned char* strasc, int length);
int AscToHex(unsigned char* strasc, unsigned char* strhex, int length);
@end
