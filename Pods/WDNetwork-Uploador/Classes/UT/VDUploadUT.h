//
//  VDUploadUT.h
//  AFNetworking
//
//  Created by weidian2015090112 on 2018/9/18.
//

#import <Foundation/Foundation.h>


#define kVDUHttpcode            @"http_status_code"
#define kVDUHttpRequestSize     @"http_request_body_size"
#define kVDUHttpResponseSize    @"http_response_body_size"
#define kVDUHttpTime            @"http_time"
#define kVDUHttpUrl             @"http_url"

#define kVDUTraceId             @"trace_id"

#define kVDUCanceled            @"upload_canceled"
#define kVDUFileSize            @"upload_file_size"
#define kVDUKey                 @"upload_key"
#define kVDUId                  @"upload_id"
#define kVDUPartId              @"upload_part_id"
#define kVDUSuccess             @"upload_success"
#define kVDUPolicy              @"upload_policy"
#define kVDUType                @"upload_type"
#define kVDURetry               @"upload_retry"
#define kVDURetryCount          @"upload_retry_count"

#define kVDUChunkIndex          @"chunk_index"
#define kVDUChunkInit           @"chunk_init"
#define kVDUChunkUpload         @"chunk_upload"
#define kVDUChunkFinish         @"chunk_finish"
#define kVDUChunkLast           @"chunk_last"
#define kVDUChunkOffsetFrom     @"chunk_offset_from"
#define kVDUChunkOffsetTo       @"chunk_offset_to"
#define kVDUChunkRetry          @"chunk_retry"
#define kVDUChunkSize           @"chunk_size"
#define kVDUChunkCount          @"chunk_count"

#define kVDUStatusCode          @"status_code"
#define kVDUStatusMessage       @"status_message"
#define kVDUStatusDesc          @"status_desc"
#define kVDUStatusResultState   @"status_result_state"


@class VDUploadResultDO, WDNErrorDO;

@interface VDUploadUT : NSObject

+ (NSString *)getCuid;

+ (void)VDUTDirect:(NSMutableDictionary *)args
            result:(VDUploadResultDO *)result
             error:(WDNErrorDO *)error;

+ (void)VDUTChunk:(NSMutableDictionary *)args
           result:(VDUploadResultDO *)result
            error:(WDNErrorDO *)error;

@end
