//
//  CryptUtil.m
//  RSSReader
//
//  Created by hanchao on 10-7-19.
//  Copyright 2010 Tencent. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <zlib.h>
#include <string>
#import "CryptUtil.h"


@implementation CryptUtil


#pragma mark -
#pragma mark cpp methods

char sz_buffer[5 * 1024];

bool gzipCompress(const char *src, size_t length, std::string &buffer)
{
    buffer.clear();
	
	z_stream stream;
	stream.zalloc = Z_NULL;
	stream.zfree  = Z_NULL;
	stream.opaque = Z_NULL;
	
	if (deflateInit2(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, -MAX_WBITS, MAX_MEM_LEVEL, Z_DEFAULT_STRATEGY) != Z_OK)
    {
		return false;
    }
	
    static char gz_simple_header[] = {'\037', '\213', '\010', '\000', '\000',
		'\000', '\000', '\000', '\002', '\377'};
	
    size_t destLen   = sizeof(gz_simple_header) + length*2;
    char *out        = new char[destLen];
    
	stream.next_out  = (Bytef *)out;
	stream.avail_out = (uInt)destLen;
	
    stream.next_in   = (Bytef *)src;
	stream.avail_in  = (uInt)length;
	
	memcpy(stream.next_out, gz_simple_header, sizeof(gz_simple_header));
	stream.next_out  += sizeof(gz_simple_header);
	stream.avail_out -= sizeof(gz_simple_header);
	
	int r = deflate(&stream, Z_FINISH);
	if (r != Z_STREAM_END)
    {
        delete[] out;
		return false;
    }
	
	destLen = destLen - stream.avail_out;
	
	uLong  crc = crc32(0,Z_NULL,0);
	
	crc = crc32(crc, (const Bytef*)src, (uInt)length);
	
	memcpy(out + destLen, &crc, 4);
	
	memcpy(out + destLen + 4 , &length, 4);
	
	destLen += 8;
	
    buffer.assign(out, destLen);
	
    delete[] out;
	
    deflateEnd(&stream);    
	
    return true;
}

bool gzipUncompress(const char *src, size_t length, std::string &buffer)
{
    buffer.clear();
	
    z_stream strm;
	
    /* allocate inflate state */
    strm.zalloc   = Z_NULL;
    strm.zfree    = Z_NULL;
    strm.opaque   = Z_NULL;
    strm.avail_in = 0;
    strm.next_in  = Z_NULL;
    
    int ret = inflateInit2(&strm, 47);
    
    if (ret != Z_OK)
        return false;
    
    strm.avail_in = (uInt)length;
    strm.next_in  = (unsigned char*)src;
	
    static size_t CHUNK = 1024*256;
    unsigned char *out  = new unsigned char[CHUNK];
	
    /* run inflate() on input until output buffer not full */
    do 
    {
        strm.avail_out = (uInt)CHUNK;
        strm.next_out  = out;
		
        ret = inflate(&strm, Z_NO_FLUSH);
		
        assert(ret != Z_STREAM_ERROR); /* state not clobbered */
        switch (ret) 
        {
			case Z_NEED_DICT:
//				ret = Z_DATA_ERROR; /* and fall through */
			case Z_DATA_ERROR:
			case Z_MEM_ERROR:
				inflateEnd(&strm);
				delete[] out;
				return false;
        }
        buffer.append((char*)out, CHUNK - strm.avail_out);
		
    } while (strm.avail_out == 0);
    
    /* clean up and return */
    inflateEnd(&strm);
    delete[] out;
	
    return (ret == Z_STREAM_END); 
}


#pragma mark -
#pragma mark oc methods

+ (NSData*)gzipCompress:(NSData*)inData {
	std::string comOut;
    gzipCompress((const char*)[inData bytes], [inData length], comOut);
	
	return [NSData dataWithBytes:comOut.data() length:comOut.size()];
}


+ (NSData*)gzipExtract:(NSData*)inData {
	std::string extOut;
    gzipUncompress((const char*)[inData bytes], [inData length], extOut);
	
	return [NSData dataWithBytes:extOut.data() length:extOut.size()];
}


+ (NSString*)md5:(NSString*)str {
    if ([str length] <= 0) {
        return str;
    }
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

+ (NSString *)md5WithBytes:(char *)bytes length:(NSUInteger)length
{
    unsigned char result[16];
    CC_MD5( bytes, (CC_LONG)length, result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString*)md5WithData:(NSData*)data {   
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [CryptUtil md5:str];
}
+ (NSData*)md5Data:(NSData*)data {
    return [[CryptUtil md5WithData:data] dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)getJsonStringWithObject:(id)object{
    NSString *jsonStr;
    if (object && [NSJSONSerialization isValidJSONObject:object]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        if (!error && jsonData) {
            jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    return jsonStr;
}

@end
