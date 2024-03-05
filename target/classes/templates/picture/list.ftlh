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
        <div id="page-content-wrapper">
            <#--添加轮播图-->
            <button class="btn btn-warning text-white my-3 offset-md-1"
                    onclick="window.parent.location.href='/diancan/picture/index';">
                添加轮播图
            </button>
            <div class="row clearfix">
                <div class="col-md-10 offset-md-1 column">
                    <table class="table table-bordered table-hover">
                        <thead>
                        <tr class="table-info">
                            <th>图片id</th>
                            <th>图片描述</th>
                            <th>图片</th>
                            <th>图片url</th>
                            <th>创建时间</th>
                            <th colspan="2">操作</th>
                        </tr>
                        </thead>
                        <tbody>

                        <#list categoryList as category>
                            <tr>
                                <td>${category.picId}</td>
                                <td>${category.picMessage}</td>
                                <td><img height="50" width="50" src="${category.picUrl}" alt=""></td>
                                <td>${category.picUrl}</td>
                                <td>${category.createTime}</td>
                                <td><a href="/diancan/picture/index?picId=${category.picId}">修改</a></td>
                                <td><a href="/diancan/picture/remove?picId=${category.picId}">删除</a></td>
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
