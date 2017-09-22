(function() {
    // 配置
    var envir = 'online';
    var configMap = {
        test: {
            appkey: '17d22031cc40154f92ab1b6e7880cf38',
            url:'https://apptest.netease.im'
        },

        pre:{
		    appkey: '17d22031cc40154f92ab1b6e7880cf38',
		    url:'http://preapp.netease.im:8184'
        },
        online: {
           appkey: '17d22031cc40154f92ab1b6e7880cf38',
           url:'https://app.netease.im'
        }
    };
    window.CONFIG = configMap[envir];
    // 是否开启订阅服务
    window.CONFIG.openSubscription = true
}())