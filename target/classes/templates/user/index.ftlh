<html>
<#include "../zujian/top.ftlh">
<style>
.highlight {
color: red; /* 登录账号颜色 */
}
</style>
<body>
<div id="wrapper" class="toggled">
    <#--内容区域头部样式-->
    <h2 class="bg-primary text-white p-3  text-right"><div class="dropdown">
  <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
    当前用户<span class="highlight">${admin.username}</span>
  </button>
  <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
    <a class="dropdown-item btn btn-danger" href="/diancan/logoutAdmin">退出登录</a>
  </div>
</div></h2>
    <#--左边栏-->
    <#include "../zujian/left.ftlh">
    <#--主要内容content-->
    <div id="page-content-wrapper" class="container">
        <div class="row clearfix">
            <div class="col-md-12 column">
                <form role="form" method="post" action="/diancan/adminUser/save">
                    <div class="form-group">
                        <label>名字</label>
                        <input name="username" type="text" class="form-control"
                               value="${(userInfo.username)!''}"/>
                    </div>
                    <div class="form-group">
                        <label>手机号/微信</label>
                        <input name="phone" type="text" class="form-control"
                               value="${(userInfo.phone)!''}"/>
                    </div>
                    <div class="form-group">
                        <label>余额还剩(${(userInfo.money)!''})元</label>
                        <input name="money" type="number" class="form-control"
                               value="${(userInfo.money)!''}"/>
                    </div>

                    <input hidden type="text" name="openid"
                           value="${(userInfo.openid)!''}">
                    <button type="submit" class="btn  btn-info">提交</button>
                </form>
            </div>
        </div>
    </div>

</div>
</body>
</html>