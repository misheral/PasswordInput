# PasswordInput

用于支付时输入六位密码，弹出试图、或者present一个VC，两种处理方式。

资源和部分内容来自https://github.com/chernyog/CYPasswordView。

目的为做一个可用于弹出的alert 类似的密码输入框，大体功能实现.

可以直接调用如下代码:

```
PasswordAlert *alert = [[PasswordAlert alloc] init];
alert.finish = ^(NSString *password){
  NSLog(@"输入密码为：%@",password);
};
[alert show];

```
