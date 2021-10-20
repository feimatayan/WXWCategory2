# WDThorNetworking #


## SDK错误码 ##

| error_code | error_desc | error_message | 备注 |
| ------ | ------ | ------ | ------ |
| 7980100 | url创建失败(url为空) |  |  |
| 7980302 | response json解析失败(加密签名失败) |  |  |
| 7980300 | 解密失败(没有配置AESkey) |  |  |
| 7980200 | http非200响应 |  | |
| <0 | NSError.userInfo[NSLocalizedDescriptionKey] | NSError.debugDescription | 没有处理直接透传给UT |
| 53 |  |  | ios系统之前前后切换的问题 |
| >0 |  |  | thor返回的错误 |

网络问题大部分都是-1005，-1009，-1001

https://vio.vdian.net/dashboard?id=1132


# WDNetworking #
微店网络库
# Thor #
## 一些文档 ##
北京Thor SDK地址：[https://gitlab.vdian.net/iOS/WDThorNetworking](https://gitlab.vdian.net/iOS/WDThorNetworking) <br/>

北京iOS文档地址：[http://docs.vdian.net/pages/viewpage.action?pageId=53215739](http://docs.vdian.net/pages/viewpage.action?pageId=53215739) <br/>

杭州Android文档地址：[http://docs.vdian.net/pages/viewpage.action?pageId=13992753](http://docs.vdian.net/pages/viewpage.action?pageId=13992753) <br/>

中间件文档地址：[http://docs.vdian.net/pages/viewpage.action?pageId=45973539](http://docs.vdian.net/pages/viewpage.action?pageId=45973539) <br/>

<br/>

* UA规范
  <br/> 主要appName，初始化时候业务方传入得
  <br/> 地址: [http://docs.vdian.net/pages/viewpage.action?pageId=13993106](http://docs.vdian.net/pages/viewpage.action?pageId=13993106)
* appkey申请
  <br/>每个业务方申请appKey，appSecret，aesKey
  <br/>日常环境：[http://thor.daily.vdian.net/applyAppkey/show](http://thor.daily.vdian.net/applyAppkey/show)
  <br/>预发环境：[http://thor.pre.vdian.net/applyAppkey/show ](http://thor.pre.vdian.net/applyAppkey/show)
  <br/>线上环境：[http://thor.vdian.net/applyAppkey/show](http://thor.vdian.net/applyAppkey/show)
<br/>
<br/>



## 工程配置 ##
 __buildsetting中改一个配置，设置成YES__
![截图](tmp1.png)

## 初始化 ##
__thorAppCode参考上面给出的链接__<br/>
###初始化例子###
```objectivec
[WDTNNetwrokConfig sharedInstance].isDebugModel = NO;
[WDTNNetwrokConfig sharedInstance].isLogOn = NO;
[WDTNNetwrokConfig sharedInstance].isPrintAllParams = PRINT_LOG_NONE;
[WDTNNetwrokConfig sharedInstance].varHeaderDelegate = self;
[WDTNNetwrokConfig sharedInstance].thorAppCode = [WDNetworkManager shareManager].appName;
    
WDTNThorSecurityItem *envItem = [WDTNThorSecurityItem new];
envItem.thorAppKey = thorKey;
envItem.thorAppSecret = secret;
envItem.thorAesKey = aesKey;
[WDTNNetworkConfig registerSecurityItem:envItem key:WDTNRequestConfigForThorTest];
    
WDTNThorSecurityItem *envItem = [WDTNThorSecurityItem new];
envItem.thorAppKey = thorKey;
envItem.thorAppSecret = secret;
envItem.thorAesKey = aesKey;
[WDTNNetworkConfig registerSecurityItem:envItem key:WDTNRequestConfigForThorPre];
    
WDTNThorSecurityItem *envItem = [WDTNThorSecurityItem new];
envItem.thorAppKey = thorKey;
envItem.thorAppSecret = secret;
envItem.thorAesKey = aesKey;
[WDTNNetworkConfig registerSecurityItem:envItem key:WDTNRequestConfigForThor];
    
[[WDBJRealReachability sharedReachability] startNotifier];
```

###WDTNNetwrokConfig###
```objectivec
// 唤起登录的代理, 升级登录SDK会实现，必须实现
// 业务也可以自己实现
@property (nonatomic, weak) id<WDTNAccountDelegate> accountDelegate;

// 账号信息，升级登录SDK会set,
// 可选
@property (nonatomic, strong) WDTNAccountDO *account;

...

```

## Thor ErrorCode 处理 ##

__重试就是把task重新扔进队列__<br/>

```objectivec
if (code == 0) {
    success = YES;
    
    callback(dict, nil);
} else if (code == 2) {
    if (subCode == 31) {
    	// 刷新token 
        [self thor_completeWithCode2SubCode31:performTask
                                       result:dict
                                  reSendBlock:reSendBlock
                                     callback:callback];
    } else {
    	//登出后，唤起登录界面
        [self thor_completeWithCode2:performTask
                              result:dict
                         reSendBlock:reSendBlock
                            callback:callback];
    }
} else if (code == 40) {
	// 服务器端时间同步
    [[WDTNServerClockProofreader sharedInstance] updateServerTime:serverTime];
    
    if (performTask.verifyTimes < 3) {
        performTask.verifyTimes += 1;
        
        // 重试
        reSendBlock(performTask);
    } else {
        callback(dict, nil);
    }
} else {
    // 服务器端错误
    callback(dict, nil);
}

```
<br/>


# 与AppConfig #
WDNHttpVapHandler的vapProtocolDelegate属性不变: <br/>
    @property (nonatomic, weak) id<WDNVapProtocolDelegate> vapProtocolDelegate;
    
```objectivec
[WDNHttpVapHandler shareHandler]. vapProtocolDelegate = id;
```
    
# 与UT #
不变
# 与HttpDNS #
HttpDNS还有问题一直没有解决，暂时未启用

```objectivec
// 方法未在Thor设置
NSURLSessionConfiguration.protocolClasses = @[NSClassFromString(@"VDDProtocol")];
```

# 版本区别 #
1.5.* 是Vap的版本，<br/>
1.6.* 之后加入了Thor，多了几个北京的库。

## 最新版本 ##
* **1.6.0.0**
  <br/>接入了Thor
  <br/>
  
* **1.5.5.1**
  <br/>多媒体上传做了并发控制，防止上行带宽拥堵，减少上传时间；
  <br/>UT加上了服务器返回的code；
  
  
<br/>

# Author

杨鑫, yangxin02@weidian.com