# TouTiaoIm-Final
仿照今日头条写的一个沉浸式新闻资讯类APP，成果可见预览图。


如果预报编译失败，
报错：PhaseScriptExecution的话就看这篇[文章](https://blog.csdn.net/qq_40697071/article/details/99055070),
> 在Xcode菜单栏选择File -> Workspace Setting -> Build System 选择Legacy Build System 重新运行即可。

如果报错sh: Permission denied xcode就看这篇[文章](https://blog.csdn.net/lc_gaga/article/details/103890161)，
> cd 到podfile 目录
> 终端执行：
> 
> rm -rf Pods/ Podfile.lock
> 
> pod install
