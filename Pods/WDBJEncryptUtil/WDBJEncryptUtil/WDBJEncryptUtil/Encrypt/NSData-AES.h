//
//  NSData-AES.h
//  Encryption
//
//  Created by Jeff LaMarche on 2/12/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

// Supported keybit values are 128, 192, 256
#define KEYBITS		128
#define AESEncryptionErrorDescriptionKey	@"description"

@interface NSData (AES)

- (NSData *)AESEncryptWithPassphrase:(NSData*)pass;
- (NSData *)AESDecryptWithPassphrase:(NSData*)pass;
- (NSString *)base64Encoding;

@end
