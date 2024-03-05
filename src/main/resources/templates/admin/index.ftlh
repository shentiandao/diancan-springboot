<!-- src/main/resources/templates/admin/index.ftlh -->
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
                <#if (canEdit)!false>
                    <!-- 显示修改表单 -->
                    <form role="form" method="post" action="/diancan/admin/save" onsubmit="return validateForm()">
                        <div class="form-group">
                            <label>账号</label>
                            <input id="username" name="username" type="text" class="form-control"
                                   value="${(adminInfo.username)!''}"/>
                        </div>
                        <div class="form-group">
                            <label>联系方式</label>
                            <input id="phone" name="phone" type="text" class="form-control"
                                   value="${(adminInfo.phone)!''}"/>
                        </div>
                        <div class="form-group">
                            <label>密码</label>
                            <input id="password" name="password" type="text" class="form-control"
                                   value="${(adminInfo.password)!''}"/>
                        </div>
                        <div class="form-group">
                            <label>权限设置</label>
                            <select name="adminType" class="form-control">
                                <#list enums as val>
                                    <#if val.getCode() != 0> <!-- 如果不是超级管理员 -->
                                        <option value="${val.getCode()}"
                                                <#if (adminInfo.adminType)?? && adminInfo.adminType == val.getCode()>
                                                    selected
                                                </#if>
                                        >${val.getMessage()}
                                        </option>
                                    </#if>
                                </#list>
                            </select>
                        </div>
                        <input hidden type="text" name="adminId"value="${(adminInfo.adminId)!''}">
                        <button type="submit" class="btn btn-info">提交</button>
                        <button type="button" class="btn btn-warning text-white my-3"
                                onclick="window.parent.location.href='/diancan/admin/list';">
                            返回
                        </button>
                        </form>
                <#else>
                <!-- 显示没有权限的消息 -->
                <h2 class="text-danger m-5">你无权访问，3秒后返回</h2>
                <script>
                    setTimeout(function() {
                        window.location.href = '/diancan/admin/list';
                    }, 3000); // 3秒后重定向
                </script>
                </#if>
            </div>
        </div>
    </div>
</div>
<script>
    function validateForm() {
        var username = document.getElementById("username").value;
        var phone = document.getElementById("phone").value;
        var password = document.getElementById("password").value;

        if (username === "" || phone === "" || password === "") {
        alert("请填写账号、手机号/微信和密码");
        return false;
        }
}
</script>
</body>
</html>