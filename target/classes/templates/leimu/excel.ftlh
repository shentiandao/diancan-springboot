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
                <div class="card mt-5">
                    <div class="card-header">
                        <h2 class="text-center">上传Excel文件</h2>
                    </div>
                    <div class="card-body">
                        <form action="/diancan/leimu/uploadExcel" method="post"
                              enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="file">选择文件</label>
                                <input type="file" class="form-control-file" id="file" name="file">
                            </div>
                            <button type="submit" class="btn btn-success btn-lg btn-block mt-2">提交</button>
                        </form>
                    </div>
                </div>
                <div class="card mt-5">
                    <div class="card-header">
                        <h2 class="text-center">注意事项</h2>
                    </div>
                    <div class="card-body">
                        <p>1，文件必须是excel</p>
                        <p>2，excel内容的列必须和下图一一对应，下图仅供参考</p>
                        <img class="img-responsive img-xs" src="/diancan/img/leimu.png"/>
                    </div>
                </div>
                <#else>
                    <!-- 如果没有权限，显示无权限的消息 -->
                    <h2 class="text-danger m-5">你本无权限，3秒后退回</h2>
                    <script>
                        setTimeout(function() {
                            window.location.href = '/diancan/leimu/list';
                        }, 3000); // 3秒后重定向
                    </script>
                </#if>
            </div>
        </div>
    </div>
</div>
</body>
</html>