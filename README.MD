
The Programming Language Lua and OpenResty
-----------------------------------------------


复杂系统 => Kernel & Configuration

Kernel -> 
    核心功能和内部实现，提供调用配置接口
    - 编译型语言
    - 静态语言
    - 注重性能

Configuration ->
    调用和配置 Kernel ，丰富和定制系统
    - 脚本语言
    - 动态语言
    - 注重业务逻辑

C++   -> OC -> Lua
C/C++ -> Lua API

-----------------------------------------------


应用

使用lua开发的游戏
- 魔兽世界
- 梦幻西游
- 愤怒的小鸟（Wax）
...

游戏插件
- 魔兽争霸（自定义皮肤界面）
- Dota2 （RPG地图编辑器脚本）
...

-----------------------------------------------

其他应用
- MySQL Proxy Scripting（连接池管理，查询过滤，读写分离，负载均衡）
- Wireshark Lua API 
- OpenWrt Lua UCI API (LuCI)
- Adobe Lightroom

Web框架
- Sailor! A Lua MVC Framework
- Lapis (Web Framework OpenResty && Lua)
- aLiLua | A High-Performance Lua Web Framework

-----------------------------------------------

Lua is a powerful, fast, lightweight, embeddable scripting language.

- 语法简单，代码可读性强
- 完整解析器不到200K，可嵌入宿主程序
- 最快的脚本语言，JIT，协程
- 跨平台 ASCII C实现(C API)
- 自动内存管理（GC 标记清除法）

* 接口语言 、嵌入式语言、胶水语言  

-----------------------------------------------

Isomorphic JS  => Isomorphic Lua ?  
JS   run on both the client and the server  
Lua  200K => JS lua parser  

"Write once, run anywhere" (WORA)  
Java        JVM(JIT inside)  
JavaScript  V8 engine(JIT inside)  
Lua         Ascii C / 200K / JIT / Embedded  

c++, php, python...
x86/x64, ARM, MIPS, PPC, even => STM32, C51...
-----------------------------------------------

语法
Lua vs JS
全局变量, 匿名函数, 函数一等公民...
面向对象, 
Lua => 元表
JS  => 原型
标准库

-----------------------------------------------


OpenResty & Lua  

nginx + perl ?  
    ngx_http_perl_module  
nginx + javascript ?  
    ngx_http_js_module  
nginx + 第三方模块  
主要：  
LuaJIT (Just-In-Time Compiler for the Lua programming language. )  
HttpLuaModule (ngx_lua - Embed the power of Lua into Nginx)  
LuaRestyCoreLibrary(lua-resty-core - New FFI-based Lua API for the ngx_lua module)  

-----------------------------------------------

ngx_lua   

init_by_lua   
init_worker_by_lua   
set_by_lua   
rewrite_by_lua   
access_by_lua   
content_by_lua   
header_filter_by_lua   
body_filter_by_lua   
log_by_lua  


-----------------------------------------------

其他扩展模块

lua­resty­memcached  
lua­resty­redis   
lua­resty­mysql  
lua­resty­dns   
lua­resty­upload   
lua­resty­websocket   
lua­resty­lock   
lua­resty­upstream­healthcheck  

-----------------------------------------------

Nginx HTTP 请求生命周期  
http://tengine.taobao.org/book/_images/chapter-2-2.PNG  

-----------------------------------------------

nginx请求处理流程  
配置文件『声明性的』，而非『过程性的』  

-----------------------------------------------

Lua + Nginx API for Lua + ngx.shared.DICT / memcache / redis / mysql / postgresql 

应用实例：  
防止DDos,清洗流量  
XSS filter  
upstream节点健康检查  
图片处理  

-----------------------------------------------

- I/O multiplexing
- Connections Pool
- noBlocking!

non-blocking MySQL
ngx_libdrizzle

-----------------------------------------------


"Light threads" based on Lua coroutines

--发起同步非阻塞请求
ngx.location.capture("/foo") 
ngx.location.capture_multi{ {"/foo"}, "/bar"}}

-- 数据字典操作，可以在nginx不同 worker 的 pool 间共享
--lua_shared_dict dogs 10m;
local dogs = ngx.shared.dogs 
dogs:add("Tom", 5) 
dogs:set("Tom", 7) 
dogs:incr("Tom", 1) 
dogs:delete("Tom", 1)

-- 延时执行
local function do_job() 
    ...
end
local ok, err = ngx.timer.at(1.5, do_job)

-----------------------------------------------


Construct fully RESTful queries in a single location

location ~ '^/cat/(\d+)' {
    set $id $1;
    set_form_input $name; set_quote_sql_str $quoted_name $name;

    postgres_query GET "select * from cats where id=$id";
    postgres_query DELETE "delete from cats where id=$id";
    postgres_query POST "insert into cats (id, name) values($id, $quoted_name)";

    postgres_pass my_pg_backend; 
}

-----------------------------------------------


nginx.conf scripting

server
{
        listen 80;
        server_name openresty.dev;

        error_log   /home/wwwlogs/openresty.dev.error.log error;
        access_log  /home/wwwlogs/openresty.dev.access.log  access;

        #use ngx_echo_module
        location = '/halo' {
                add_header Content-Type text/html;
                echo "halo, $arg_person!";
                break;
        }

        #use ngx_http_lua_module
        location ~* ^/test(.*)$ {
            #lua_code_cache off;
            content_by_lua "
                ngx.send_headers({'Content-Type:text/html'})
                ngx.say('tester')
                ngx.exit(200)
            ";
        }

        #use ngx_http_lua_module
        location ~* ^/test(.*)$ {
            #lua_code_cache off;
            content_by_lua_file "
                ngx.send_headers({'Content-Type:text/html'})
                ngx.say('tester')
                ngx.exit(200)
            ";
        }
}

http://openresty.dev/halo?person=rmingwang
halo, rmingwang!

http://openresty.dev/test
tester

-----------------------------------------------


Any questions?


-----------------------------------------------


**OpenResty**

- [Lua简明教程](http://coolshell.cn/articles/10739.html) 
- [agentzh's home](http://agentzh.org/#Presentations)
- [agentzh 的 Nginx 教程](https://openresty.org/download/agentzh-nginx-tutorials-zhcn.html) 
- [nginx的模块化体系结构](http://tengine.taobao.org/book/chapter_02.html#id12)
- [Nginx HTTP 请求生命周期](http://tengine.taobao.org/book/_images/chapter-2-2.PNG)
- [17173 Ngx_Lua使用分享](http://17173ops.com/2013/11/01/17173-ngx-lua-manual.shtml)
- [awesome-resty](https://github.com/bungle/awesome-resty)

**Lua language**

- [Lua 5.3 参考手册](http://cloudwu.github.io/lua53doc/manual.html)
- [Lua vs. JavaScript](http://stackoverflow.com/questions/1022560/subtle-differences-between-javascript-and-lua)
- [Lua: Good, bad, and ugly parts](http://notebook.kulchenko.com/programming/lua-good-different-bad-and-ugly-parts)
- [Lua 为什么在游戏编程领域被广泛运用？](http://www.zhihu.com/question/21717567)
- [云风的 BLOG: lua与虚拟机 Archives](http://blog.codingnow.com/eo/luaoeeeaeau/)

**Books**

- [Lua程序设计](Lua程序设计 http://book.luaer.cn/)
- [《Programming In Lua》](http://www.baidu.com/s?wd=%E3%80%8AProgramming%20In%20Lua%E3%80%8B)

 






  
  




