一、接入方式<br />
    pod 'WDUT',     :git => 'ssh://git@gitlab.vdian.net:60022/mobile/WDUT.git'
    
二、工程配置<br />
    引入系统库：libstdc++.tbd、libsqlite3.tbd、libz.tbd

三、接口说明<br />
    startWithAppkey：<br />
        启动WDUT(必须要尽可能早的开启，避免遗漏统计，appKey需要统一申请)<br />
    startWithAppkey:reportPolicy:channelId:<br />
        带上上报策略和渠道号<br />
    setAppVersion：<br />
        设置app版本（hotpatch版本可能需要用到）<br />
    setChannelId：<br />
        设置渠道号（hotpatch版本可能需要用到）<br />
    enableUT：<br />
        WDUT开关（关闭后，日志收集和上报全部停止）<br />
    commitEvent：<br />
        不带业务参数的自定义统计（eventID元数据需要申请）<br />
    commitEvent:segmentation:<br />
        带上业务参数的自定义统计<br />
    commitEvent:pageName:arg1:arg2:arg3:args:<br />
        带上详细业务参数的自定义统计（主要是性能统计需要用到）<br />
    commitCtrlClickedEvent:segmentation:<br />
        控件统计（业务参数可以为空）<br />
    updateViewController:pageName:<br />
        设置页面别名（设置后会覆盖sdk内部hook的页面名称）<br />
    updateViewController:pageName:segmentation:<br />
        设置页面别名，并且传递页面业务参数<br />
    userLogin:userName:phoneNumber:<br />
        用户登录统计（以及后面的用户注册，用户注销）<br />
    setLogRecordEventEnabled:<br />
        是否开启控制台打印日志（主要是调试用，release包自动关闭）<br />
    setEncryptEnabled:<br />
        日志是否加密上报（主要是调试用，目前暂未生效）<br />
    enableCrashReporting:<br />
        开启崩溃日志捕获（默认开启）<br />
    getWDUDID:<br />
        获取设备唯一标示（后面所有其他业务需要用到设备唯一标示的时候都通过这个接口获取）<br />

四、注意事项<br />
    1、WDUT与其他业务hook逻辑冲突时候，可以考虑统一用WDUTMethodSwizzle简单hook方式（比如第三方Aspect做的太多）<br />
    2、永远应该先执行startWithAppkey然后才能调用其他接口。<br />

五、使用方式<br />
    可以参考WDUTDemo