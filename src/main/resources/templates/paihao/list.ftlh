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
    <div id="page-content-wrapper">
        <button class="btn btn-warning text-white my-3 offset-md-1">
            小桌排号管理
        </button>
        <div class="row clearfix">
            <div class="col-md-10 offset-md-1 column">
                <table class="table table-bordered table-hover">
                    <thead>
                    <tr class="table-info">
                        <th>客户排号</th>
                        <th>排号开始时间</th>
                        <th colspan="1">操作</th>
                    </tr>
                    </thead>
                    <tbody>

                    <#list listSmall as category>
                        <tr>
                            <td>${category.num}</td>
                            <td>${category.createTime}</td>
                            <td><a href="/diancan/adminPaihao/ruzhuo?id=${category.id}">可入座</a></td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </div>
        <button class="btn btn-warning text-white my-3 offset-md-1">
            大桌排号管理
        </button>
        <div class="row clearfix">
            <div class="col-md-10 offset-md-1 column">
                <table class="table table-bordered table-hover">
                    <thead>
                    <tr class="table-info">
                        <th>客户排号</th>
                        <th>排号开始时间</th>
                        <th colspan="2">操作</th>
                    </tr>
                    </thead>
                    <tbody>

                    <#list listBig as category>
                        <tr>
                            <td>${category.num}</td>
                            <td>${category.createTime}</td>
                            <td><a href="/diancan/adminPaihao/ruzhuo?id=${category.id}">可入座</a></td>
                            <td><a href="/diancan/adminPaihao/reject?id=${category.id}">拒绝入座</a></td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </div>
        <button class="btn btn-warning text-white my-3 offset-md-1">
            历史排号管理
        </button>
        <div class="row clearfix">
            <div class="col-md-10 offset-md-1 column">
                <table class="table table-bordered table-hover">
                <thead>
                <tr class="table-info">
                    <th>id</th>
                    <th>排号创建时间</th>
                    <th>当天的号源</th>
                    <th>桌型</th>
                    <th>openid</th>
                    <th>是否已经叫号</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <#list paihaoPage.content as paihao>
                    <tr>
                        <td>${paihao.id}</td>
                        <td>${paihao.createTime}</td>
                        <td>${paihao.num}</td>
                        <td>${paihao.type}</td>
                        <td>${paihao.openid}</td>
                        <td>${paihao.ruzuo?string("是", "否")}</td>
                        <td>
                            <!-- 添加操作链接 -->
                        </td>
                    </tr>
                </#list>
                </tbody>
            </table>
                <ul class="pagination">
                    <#if currentPage lte 1>
                        <li class="page-item disabled"><a class="page-link" href="#">上一页</a></li>
                    <#else>
                        <li class="page-item"><a class="page-link"
                                                 href="/diancan/adminPaihao/list?page=${currentPage - 1}&size=${size}">上一页</a>
                        </li>
                    </#if>

                    <#list 1..paihaoPage.getTotalPages() as index>
                        <#if currentPage == index>
                            <li class="page-item disabled"><a class="page-link" href="#">${index}</a></li>
                        <#else>
                            <li class="page-item"><a class="page-link"
                                                     href="/diancan/adminPaihao/list?page=${index}&size=${size}">${index}</a>
                            </li>
                        </#if>
                    </#list>

                    <#if currentPage gte paihaoPage.getTotalPages()>
                        <li class="page-item disabled"><a class="page-link" href="#">下一页</a></li>
                    <#else>
                        <li class="page-item"><a class="page-link"
                                                 href="/diancan/adminPaihao/list?page=${currentPage + 1}&size=${size}">下一页</a>
                        </li>
                    </#if>
                </ul>
            </div>
        </div>
    </div>
</div>
</body>
<script type="text/javascript">
  // 假设你已经设置了一个WebSocket连接，连接的名字是socket
  socket.onmessage = function(event) {
    if (event.data == "new paihao") {
      // 当收到新的排号消息时，刷新页面
      location.reload();
    }
  }
</script>
</html>