package main

import (
	_ "hello/routers"
	"github.com/astaxie/beego"
	"github.com/beego/i18n"
)

func main() {

	i18n.SetMessage("en-US", "conf/locale_en-US.ini")
	i18n.SetMessage("zh-CN", "conf/locale_zh-CN.ini")

	beego.Run()
}