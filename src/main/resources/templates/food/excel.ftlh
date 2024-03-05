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
    <div class="container-fluid">
        <div class="row clearfix">
            <div class="col-md-8 offset-1 column">
                <div class="card mt-5">
                    <div class="card-header">
                        <h2 class="text-center">上传Excel文件</h2>
                    </div>
                    <div class="card-body">
                        <form action="/diancan/food/uploadExcel" method="post"
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
                        <img class="img-fluid" src="/diancan/img/shangpin.png"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>