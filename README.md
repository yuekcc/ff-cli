# ff-cli

基于 fzf 和 open-win 的 everything 代替品。

`fzf --bind "enter:execute(open-win {})"`


- [fzf](https://github.com/junegunn/fzf) 是一个快速的文件查找命令行工具，经常用作 vim 插件
- [open-win](./open-win/) 是 mac 下 open 命令的代替品

## 使用

1. 将 bin 目录下的 *.exe 放置到系统 PATH 中的目录中
2. 在 ~/.bashrc 中增加配置 `alias ff='fzf --bind "enter:execute(open-win {})"'`

完成上面的设置后，可以在 git bash 中使用 ff 命令，快速查找当前目录下的文件。

## LICENSE

open-win 采用 MIT 协议。
