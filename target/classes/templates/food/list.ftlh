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
        <div id="page-content-wrapper" class="container-fluid">
            <#--添加菜品-->
            <button class="btn btn-warning text-white my-3"
                    onclick="window.parent.location.href='/diancan/food/index';">
                添加单个菜品
            </button>
            <#--批量导入菜品-->
            <button class="btn btn-info text-white my-3" onclick="window.parent.location.href='/diancan/food/excel';">
                批量导入菜品
            </button>
            <#--批量导出菜品-->
            <button class="btn btn-info text-white my-3" onclick="window.parent.location.href='/diancan/food/export';">
                导出菜品到excel
            </button>
            <div class="row clearfix">
                <div class="col-md-12 column">
                    <table class="table  table-striped table-bordered table-sm">
                        <thead>
                        <tr class="table-info">
                            <th>菜品id</th>
                            <th>菜品名</th>
                            <th>单价</th>
                            <th>库存</th>
                            <th>菜品描述</th>
                            <th>类目</th>
                            <th>图片</th>
                            <th>创建时间</th>
                            <th>修改时间</th>
                            <th colspan="3">操作</th>
                        </tr>
                        </thead>
                        <tbody>

                        <#list foodPage.content as food>
                            <tr>
                                <td>${food.foodId}</td>
                                <td>${food.foodName}</td>
                                <td>${food.foodPrice}</td>
                                <td>${food.foodStock}</td>
                                <td>${food.foodDesc}</td>
                                <td>${food.leimuType}</td>
                                <td><img height="50" width="50" src="${food.foodIcon}" alt=""></td>
                                <td>${food.createTime!''}</td>
                                <td>${food.updateTime!''}</td>
                                <td><a href="/diancan/food/index?foodId=${food.foodId}">修改</a>
                                </td>
                                <td>
                                    <#if (food.getFoodStatus() ==0)>
                                        <a href="/diancan/food/off_sale?foodId=${food.foodId}">下架</a>
                                    <#else>
                                        <a href="/diancan/food/on_sale?foodId=${food.foodId}">上架</a>
                                    </#if>
                                </td>
                                <td><a href="/diancan/food/remove?foodId=${food.foodId}">删除</a>
                                </td>
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
                                                     href="/diancan/food/list?page=${currentPage - 1}&size=${size}">上一页</a>
                            </li>
                        </#if>

                        <#list 1..foodPage.getTotalPages() as index>
                            <#if currentPage == index>
                                <li class="page-item disabled"><a class="page-link" href="#">${index}</a></li>
                            <#else>
                                <li class="page-item"><a class="page-link"
                                                         href="/diancan/food/list?page=${index}&size=${size}">${index}</a>
                                </li>
                            </#if>
                        </#list>

                        <#if currentPage gte foodPage.getTotalPages()>
                            <li class="page-item disabled"><a class="page-link" href="#">下一页</a></li>
                        <#else>
                            <li class="page-item"><a class="page-link"
                                                     href="/diancan/food/list?page=${currentPage + 1}&size=${size}">下一页</a>
                            </li>
                        </#if>
                    </ul>
                </div>
            </div>
        </div>
    </#if>
</div>
</body>
</html>
