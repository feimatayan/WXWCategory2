//
//  NSData-AES.m
//  Encryption
//
//  Created by Jeff LaMarche on 2/12/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import "NSData-AES.h"
#import "rijndael.h"
//#import "GTMBase64.h"


@implementation NSData(AES)
- (NSData *)AESEncryptWithPassphrase:(NSData*)pass
{
	NSMutableData *ret = [NSMutableData dataWithCapacity:[self length]];
	unsigned long rk[RKLENGTH(KEYBITS)];
	unsigned char key[KEYLENGTH(KEYBITS)];
	const char *password = [pass bytes];//[pass UTF8String];

    int i = 0;
	for (i = 0; i < sizeof(key); i++)
		key[i] = password != 0 ? *password++ : 0;
	
	int nrounds = rijndaelSetupEncryptInOPS(rk, key, KEYBITS);
	
	unsigned char *srcBytes = (unsigned char *)[self bytes];
	int index = 0;
	
	while (1) 
	{
		unsigned char plaintext[16];
		unsigned char ciphertext[16];
		int j;
		for (j = 0; j < sizeof(plaintext); j++)
		{
			if (index >= [self length])
				break;
			
			plaintext[j] = srcBytes[index++];
		}
		if (j == 0)
			break;
		for (; j < sizeof(plaintext); j++)
			plaintext[j] = ' ';
		
		rijndaelEncryptInOPS(rk, nrounds, plaintext, ciphertext);
		[ret appendBytes:ciphertext length:sizeof(ciphertext)];
	}
	return ret;
}
- (NSData *)AESDecryptWithPassphrase:(NSData*)pass
{
	NSMutableData *ret = [NSMutableData dataWithCapacity:[self length]];
	unsigned long rk[RKLENGTH(KEYBITS)];
	unsigned char key[KEYLENGTH(KEYBITS)];
	const char *password = [pass bytes];//[pass UTF8String];
    
    int i = 0;
	for (i = 0; i < sizeof(key); i++)
		key[i] = password != 0 ? *password++ : 0;

	int nrounds = rijndaelSetupDecryptInOPS(rk, key, KEYBITS);
	unsigned char *srcBytes = (unsigned char *)[self bytes];
	int index = 0;
	while (index < [self length])
	{
		unsigned char plaintext[16];
		unsigned char ciphertext[16];
		int j;
		for (j = 0; j < sizeof(ciphertext); j++)
		{
			if (index >= [self length])
				break;
			
			ciphertext[j] = srcBytes[index++];
		}
		rijndaelDecryptInOPS(rk, nrounds, ciphertext, plaintext);
		[ret appendBytes:plaintext length:sizeof(plaintext)];
		
	}
	return ret;
}

- (NSString*)base64Encoding {
    NSData* data = [self base64EncodedDataWithOptions:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
