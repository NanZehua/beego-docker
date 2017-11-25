package controllers

import (
	"github.com/astaxie/beego"
	"github.com/beego/i18n"
	"fmt"
)

type MainController struct {
	BaseController
}

type BaseController struct {
	beego.Controller
	i18n.Locale
}

func (b *BaseController) Prepare()  {
    lang := b.GetString("lang")
    fmt.Println(lang)
	if lang == "zh-CN" {
		b.Lang = lang
	} else {
		b.Lang = "en-US"
	}
}

func (c *MainController) Get() {
	c.Data["Website"] = "beego.me"
	c.Data["Email"] = "astaxie@gmail.com"
	c.Data["Hi"] = c.Tr("hi")
	c.Data["Bye"] = c.Tr("bye")
	c.TplName = "index.tpl"
}
