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
    <#if !isAdmin??>
        <h2 class="text-danger m-5">您不是管理员，没有管理权限</h2>
    <#else >
        <div id="page-content-wrapper" class="container">
            <div class="row clearfix">
                <div class="col-md-12 column">
                    <table class="table table-bordered table-hover">
                        <thead>
                        <tr class="table-info">
                            <th>openid</th>
                            <th>名字</th>
                            <th>手机号/微信</th>
                            <th>余额</th>
<#--                            <th>会员到期时间</th>-->
                            <th>创建时间</th>
                            <th>修改时间</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>

                        <#list userList as userBean>
                            <tr>
                                <td>${userBean.openid}</td>
                                <td>${userBean.username}</td>
                                <td>${userBean.phone}</td>
                                <td>${userBean.money}</td>
<#--                                <td>${userBean.viptime}</td>-->
                                <td>${userBean.createTime}</td>
                                <td>${userBean.updateTime}</td>
                                <td><a href="/diancan/adminUser/index?openid=${userBean.openid}">修改</a></td>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </#if>

</div>
</body>
</html>