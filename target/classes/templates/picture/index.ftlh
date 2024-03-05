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
                <form role="form" method="post" action="/diancan/picture/save">
                    <div class="form-group">
                        <label>图片url</label>
                        <input name="picUrl" type="text" class="form-control"
                               value="${(category.picUrl)!''}"/>
                    </div>
                    <div class="form-group">
                        <label>图片描述</label>
                        <input name="picMessage" type="text" class="form-control"
                               value="${(category.picMessage)!''}"/>
                    </div>
                    <input hidden type="text" name="picId"
                           value="${(category.picId)!''}">
                    <button type="submit" class="btn  btn-info">提交</button>
                </form>
                <#else>
                    <!-- 显示没有权限的消息 -->
                    <h2 class="text-danger m-5">你无权访问，3秒后返回</h2>
                    <script>
                        setTimeout(function() {
                            window.location.href = '/diancan/picture/list';
                        }, 3000); // 3秒后重定向
                    </script>
                </#if>
            </div>
        </div>
    </div>

</div>
</body>
</html>