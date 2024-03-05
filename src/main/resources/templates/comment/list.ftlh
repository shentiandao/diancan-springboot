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
    <div id="page-content-wrapper" class="container-fluid">
        <div class="row clearfix">
            <div class="col-md-12 column">
                <table class="table  table-striped table-bordered table-sm">
                    <thead>
                    <tr class="table-info">
                        <th>评价id</th>
                        <th>订单id</th>
                        <th>用户名</th>
                        <th>评价内容</th>
                        <th>评价星级</th>
                        <th>评价时间</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list commentPage.content as comment>
                        <tr>
                            <td>${comment.commentId}</td>
                            <#--添加日期:2024年1月13日，内容:comment.orderId-->
                            <td>
                            <#if comment.orderId??>
                                <a href="http://localhost:8080/diancan/adminOrder/detail?orderId=${comment.orderId}">${comment.orderId}</a>
                            <#else>
                                无订单ID
                            </#if>
                            </td>
                            <td>${comment.name}</td>
                            <td>${comment.content}</td>
                            <#-- 添加日期:2023年11月22日，内容:comment.star-->
                            <td><#-- 循环5次，对应5颗星星 -->
                                <#list 1..5 as i>
                                    <#-- 如果当前星星的索引小于等于评价星级，则显示实心星星 -->
                                    <#if i lte comment.star>
                                    &#9733; <!-- 实心星星的HTML实体 -->
                                    <#else>
                                    &#9734; <!-- 空心星星的HTML实体 -->
                                    </#if>
                                </#list>
                            </td>
                            <td>${comment.createTime}</td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
            <#--分页-->
            <div class="col-md-12 column">
                <ul class="pagination">
                    <#if currentPage lte 1>
                        <li class="page-item disabled"><a class="page-link" href="#">上一页</a></li>
                    <#else>
                        <li class="page-item"><a class="page-link"
                                                 href="/diancan/comment/list?page=${currentPage - 1}&size=${size}">上一页</a>
                        </li>
                    </#if>
                    <#--分页模块-->
                    <#--这段代码使用了FreeMarker模板语言（FTL）来生成分页链接。通过遍历1到commentPage.getTotalPages()，生成相应页码的链接。
                    其中，commentPage是一个分页对象，currentPage代表当前页码，index表示遍历到的页码。在生成链接时，使用了href属性来指定链接的URL，
                    其中的${index}表示页码，${size}表示每页的记录数。-->
                    <#list 1..commentPage.getTotalPages() as index>
                        <#if currentPage == index>
                            <li class="page-item disabled"><a class="page-link" href="#">${index}</a></li>
                        <#else>
                            <li class="page-item"><a class="page-link"
                                                     href="/diancan/comment/list?page=${index}&size=${size}">${index}</a>
                            </li>
                        </#if>
                    </#list>

                    <#if currentPage gte commentPage.getTotalPages()>
                        <li class="page-item disabled"><a class="page-link" href="#">下一页</a></li>
                    <#else>
                        <li class="page-item"><a class="page-link"
                                                 href="/diancan/comment/list?page=${currentPage + 1}&size=${size}">下一页</a>
                        </li>
                    </#if>
                </ul>
            </div>
        </div>
    </div>
</div>
</body>
</html>
