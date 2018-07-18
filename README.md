# wls-patch-install
### 【工具说明】  
这是基于WebLogic Server（下文简称：WLS） SmartUpdate组件制作的一个自动化补丁安装工具，类似的工具还有suwrapper（Oracle内部的一个基于SmartUpdate制作的一个打补丁的工具）。

### 【适用范围】  
WLS 10.3.3 - 12.1.1 on any suitable os platform.

### 【工具特点】
+ 未指定WL_HOME路径的情况下，自动扫描本机上所有的WLS 10.3.3 - 12.1.1软件路径，并对扫描到的WebLogic软件安装补丁；
+ 该工具自动读取${WL_HOME}/.product.properties文件中的JAVA_HOME属性值，不需要单独安装JDK；
+ 自动检测WLS 10.3.3 - 10.3.5版本软件环境SmartUpdate的版本，低于3.3.0版本时自动升级至3.3.0（3.3.0与3.2.0版本打补丁操作稍有不同），方便自动化安装补丁；
+ 自动安装Smart Update tool enhancement v3.0增强补丁包，提升安装及卸载补丁时检测操作的性能，缩短打补丁的时间；
+ 自动检测解压原始补丁文件（从My Oracle Support中下载下来的、未经改名或解压等操作的）并拷贝到该工具检测到的SmartUpdate的PatchDownloadDir（个别用户那里的SmartUpdate补丁下载路径不是默认的${BSU_HOME}/cache_dir，如果直接拷贝到${BSU_HOME}/cache_dir默认目录下安装补丁，将无法检测到已安装的补丁，也更会因为有冲突的补丁而安装失败）；
+ 自动检测是否已经安装过补丁、已经安装的补丁与即将安装的补丁是否存在冲突；
+ 安装补丁前，自动卸载冲突的补丁；
+ 补丁安装完，输出安装结果，（无论安装成功与否）自动检测${user-home}/bea目录、${wl-home}/server/lib目录下的uddiexplorer和wls-wsat相关的文件、该工具产生的临时文件，如果存在则自动删除；

### 【准备工作】 
+ 从本项目的[release页面](https://github.com/tdy218/wls-patch-install/releases)下载最新的脚本程序包；
+ 将下载下来的程序包(例如：wls-patch-install.20180509.tar.gz)上传到一台Linux or Unix操作系统的主机（主要是为了保持权限）上, 然后解压得到wls-patch-install；
+ 把将要安装的补丁上传到该补丁对应的WebLogic版本的补丁目录(wls-patch-install/patch/x.x.x.x，例如：wls-patch-install/patch/10.3.6.0)下（注意补丁上传时使用的用户与程序包解压后文件的属主用户保持一致）；
+ 以当前日期作为版本标示重新打包（$ tar zcvf wls-patch-install.20180510.tar.gz wls-patch-install）；

### 【安装补丁】  
注意：下面的方法2选1执行即可。
+ <b>对于可以使用root用户的，且不同主机上WebLogic软件安装位置不固定的环境，可使用这种方法.</b>  
```
root# tar zxvf wls-patch-install.20180510.tar.gz
root# cd wls-patch-install
root# ./main_launix.sh  （Windows环境, 解压后直接双击里面的main_windows.bat脚本即可）      
```
脚本执行后，会find本机上所有的WebLogic软件, 并都装上PSU.

+ <b>对于只能提供WebLogic软件属主的用户来说, 且WebLogic软件安装位置已知晓的情况下, 可选用这种方法.</b>  
```
weblogic$ tar zxvf wls-patch-install.20171229.tar.gz
weblogic$ cd wls-patch-install
weblogic$ ./install_psu.sh <WL_HOME变量值>  （例如: ./install_psu.sh  /weblogic/wls1036/wlserver_10.3）  
```

### 【注意事项】  
+ 该脚本目前一次仅支持安装一个补丁(多个补丁安装时比较费JVM堆内存，并且较慢，暂不支持同时安装多个补丁，并非技术上无法实现，后续如果需要此功能的用户多，则考虑支持).

### 【脚本执行样例】
```
[weblogic@aliecs-nc5 wls-patch-install]$ ./install_patch.sh /weblogic/wls1036/wlserver_10.3
The java developer's kit's version is:
-----------------------------------------
java version "1.7.0_181"
Java(TM) SE Runtime Environment (build 1.7.0_181-b09)
Java HotSpot(TM) 64-Bit Server VM (build 24.181-b09, mixed mode)

Begin to apply weblogic patch by smart update...

Buildfile: /weblogic/wls-patch-install/xml/wls-patch-install.xml

smartupdate-version-check:
     [echo] Check the embedded smart update version...
     [echo] The smart update version is: 3.3.0.0
     [echo] It's no need to be upgraded, apply weblogic server patches immediately.

smartupdate-enhancement-patch-apply:
     [echo] Copy the weblogic common jar patch file to /weblogic/wls1036/modules directory.
     [copy] Copying 1 file to /weblogic/wls1036/modules
     [echo] Copy the smart update client patch files to /weblogic/wls1036/modules/features directory.
     [copy] Copying 2 files to /weblogic/wls1036/modules/features

wls-patch-applying-prepare:
     [echo] Get the weblogic version : 10.3.6.0
     [echo] Patchlist archive file is found in /weblogic/wls-patch-install/patch/10.3.6.0.
    [unzip] Expanding: /weblogic/wls-patch-install/patch/10.3.6.0/p27395085_1036_Generic_psu20180418.zip into /weblogic/wls-patch-install/tmp/p27395085_1036_Generic_psu20180418
     [echo] The patch which id is GFWX will be installed.
     [copy] Copying 2 files to /weblogic/wls1036/utils/bsu/cache_dir

wls-installed-patch-check:
     [echo] Check whether the weblogic had been applied any patch previously.
     [echo] The weblogic had been applied patchlist which is FMJJ.

wls-conflicting-patch-detect:
     [echo] Begin to detect conflict before applying patch id GFWX, Wait for a moment please...
     [echo] Conflicting patchlist FMJJ was detected, it would be removed before GFWX installation!

wls-conflicting-patch-remove:
     [echo] Remove the conflicting patchlist FMJJ, wait for a moment please...
     [echo] Begin to remove the conflicting patch FMJJ...
     [echo] The conflicting patch FMJJ had been removed successfully.
     [echo] The conflicting patchlist FMJJ was removed successfully.

wls-patch-applying-begin:
     [echo] Apply the patch id GFWX by smart update, wait for a moment please...

wls-patch-applying-check:
     [echo] Verify the applying result of patch id GFWX.
     [echo] The weblogic server patch id GFWX had been applied successfully.

installation-clean-and-exit:
     [echo] Clean the files which generated in previous operation.
     [echo] The uddi explorer related files was found, and it would be deleted.
   [delete] Deleting /weblogic/wls1036/wlserver_10.3/server/lib/uddiexplorer.war
   [delete] Deleting directory /weblogic/bea
   [delete] Deleting directory /weblogic/wls-patch-install/tmp

BUILD SUCCESSFUL
Total time: 8 minutes 47 seconds
```

### 【故障诊断】  
在使用本工具时如果遇到问题，可首先查看wls-patch-install/logs下面相应的日志文件自行Debug，也可以在本项目的[Issues页面](https://github.com/tdy218/wls-patch-install/issues)提问、在“中国中间件用户组”微信群中提问。
+ smartupdate-upgrading.${user-name}.${timestamp}.log 文件记录着SmartUpdate升级的日志，没有升级则无此日志文件。
+ patch-install.${user-name}.${timestamp}.log 文件记录着补丁安装的日志，没有安装补丁则无此日志文件。
+ remove-conflicting-patchlist.${user-name}.${timestamp}.log 记录着卸载冲突补丁的日志，没有卸载冲突补丁则无此日志文件。
