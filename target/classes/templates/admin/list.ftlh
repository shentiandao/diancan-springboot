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
    <h2 class="bg-primary text-white p-3  text-right" ><div class="dropdown">
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
    <#if msg??>
        <div class="alert alert-danger">${msg}</div>
    </#if>
    <#if !isAdmin??>
        <h2 class="text-danger m-5">您不是管理员，没有管理权限</h2>
    <#else >
        <div id="page-content-wrapper" class="container">
            <#--添加管理员-->
            <button class="btn btn-warning text-white my-3"
                    onclick="window.parent.location.href='/diancan/admin/index';">
                添加
            </button>

            <div class="row clearfix">
                <div class="col-md-12 column">
                    <table class="table table-bordered table-hover">
                        <thead>
                        <tr class="table-info">
                            <th>id</th>
                            <th>账号</th>
                            <th>密码</th>
                            <th>联系方式</th>
                            <th>身份</th>
                            <th>创建时间</th>
                            <th>修改时间</th>
                            <th colspan="2">操作</th>
                        </tr>
                        </thead>
                        <tbody>

                        <#list adminList as adminBean>
                            <tr>
                                <td>${adminBean.adminId}</td>
                                <td>${adminBean.username}</td>
                                <td><#--                        ${adminBean.password}-->
<#--创建一个空字符串stars，然后使用<#list>指令循环adminBean.password?length次，
   每次循环都将一个星号添加到stars字符串中。最后，输出stars字符串。-->
                                    <#assign stars = "" />
                                    <#list 1..adminBean.password?length as i>
                                        <#assign stars = stars + "*" />
                                    </#list>
                                    ${stars}
                                </td>
                                <td>${adminBean.phone}</td>
                                <td>${adminBean.getAdminStatusEnum().message}</td>
                                <td>${adminBean.createTime}</td>
                                <td>${adminBean.updateTime}</td>
                                <td><a href="/diancan/admin/index?adminId=${adminBean.adminId}">修改</a>
                                <td><a href="javascript:void(0);" onclick="deleteAdmin(${adminBean.adminId})">删除</a></td>
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
<script>
    // function deleteAdmin(adminId) {
        //     fetch('/diancan/admin/delete/' + adminId, {
        //         method: 'DELETE',
        //     })
        //         .then(() => {
        //             location.href = '/diancan/admin/list';
        //         })
        //         .catch((error) => {
        //             console.error('Error:', error);
        //         });
        // }
        function deleteAdmin(adminId) {
            fetch('/diancan/admin/delete/' + adminId, {
                method: 'DELETE',
            })
                .then(response => {
                    if (!response.ok) {
                        // 如果服务器返回了一个错误状态码，抛出一个错误
                        throw new Error('Network response was not ok');
                    }
                    // 如果服务器返回了一个成功状态码，重定向到管理员列表页面
                    location.href = '/diancan/admin/list';
                })
                .catch((error) => {
                    console.error('Error:', error);
                    // 如果捕获到一个错误，重定向到错误页面
                    location.href = '/diancan/Tip/error';
                });
        }

        
</script>
</html>