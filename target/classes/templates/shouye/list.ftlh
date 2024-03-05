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
    <div id="page-content-wrapper" class="container-fluid">
        <div class="row">
            <div class="col-md-12 column">
                <#-- 显示管理员的账号 -->
                <h2>欢迎${admin.username}来到后台首页！开始您的工作吧</h2>
                <#-- 2023年11月29日 -->
                <select id="roleSelect">
                    <option value="">所有角色</option>
                    <option value="管理员">管理员</option>
                    <option value="员工">员工</option>
                    <option value="超级管理员">超级管理员</option>
                </select>
                <button class="btn btn-warning text-white my-3 "
                 onclick="filterByRole()">筛选</button>
                开始日期：<input type="date" id="startDate">
                结束日期：<input type="date" id="endDate">
                <button class="btn btn-warning text-white my-3 "
                 onclick="filterByDate()">筛选</button>
                <table class="table table-bordered table-hover">
                    <thead>
                    <tr class="table-info">
                        <th>用户名</th>
                        <th>角色</th>
                        <th>登录时间</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list loginHistoryPage.content as loginHistory>
                        <tr>
                            <td>${loginHistory.username}</td>
                            <td>${loginHistory.role}</td>
                            <td>${loginHistory.loginTime}</td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
                <!-- 分页控件 -->
                <!-- 2023年12月1日 -->
                <ul class="pagination">
                    <#if currentPage lte 1>
                        <li class="page-item disabled"><a class="page-link" href="#">上一页</a></li>
                    <#else>
                        <li class="page-item"><a class="page-link"
                                                href="/diancan/shouye/list?page=${currentPage - 1}&size=${size}<#if role?has_content>&role=${role}</#if><#if start?has_content>&start=${start?string('yyyy-MM-dd')}</#if><#if end?has_content>&end=${end?string('yyyy-MM-dd')}</#if>">上一页</a>
                        </li>
                    </#if>

                    <#list 1..loginHistoryPage.getTotalPages() as index>
                        <#if (index lte 2) || (index gte currentPage - 2 && index lte currentPage + 2) || (index gte loginHistoryPage.getTotalPages() - 1)>
                            <#if currentPage == index>
                                <li class="page-item disabled"><a class="page-link" href="#">${index}</a></li>
                            <#else>
                                <li class="page-item"><a class="page-link"
                                                        href="/diancan/shouye/list?page=${index}&size=${size}<#if role?has_content>&role=${role}</#if><#if start?has_content>&start=${start?string('yyyy-MM-dd')}</#if><#if end?has_content>&end=${end?string('yyyy-MM-dd')}</#if>">${index}</a>
                                </li>
                            </#if>
                        </#if>
                    </#list>

                    <#if currentPage gte loginHistoryPage.getTotalPages()>
                        <li class="page-item disabled"><a class="page-link" href="#">下一页</a></li>
                    <#else>
                        <li class="page-item"><a class="page-link"
                                                href="/diancan/shouye/list?page=${currentPage + 1}&size=${size}<#if role?has_content>&role=${role}</#if><#if start?has_content>&start=${start?string('yyyy-MM-dd')}</#if><#if end?has_content>&end=${end?string('yyyy-MM-dd')}</#if>">下一页</a>
                        </li>
                    </#if>
                    <!-- 2023年12月1日 -->
                    <div>
                        跳转到：<input type="text" id="goToPage" />
                        <button class="btn btn-warning text-white my-3" onclick="goToPage()">确定</button>
                    </div>
                </ul>
            </div>
        </div>
    </div>

</div>
</body>
//2023年11月29日
<script>
    //2023年12月1日
    var currentRole = "";
    var currentStartDate = "";
    var currentEndDate = "";

    function filterByRole() {
        var role = document.getElementById("roleSelect").value;
        var currentPage = 1;//选择角色后默认跳转的第一页
        currentRole = role;//2023年12月1日
        window.location.href = "/diancan/shouye/list?page=" + currentPage + "&size=10&role=" + encodeURIComponent(role);
    }
    function filterByDate() {
        var role = document.getElementById("roleSelect").value;
        var start = document.getElementById("startDate").value;
        var end = document.getElementById("endDate").value;
        var url = "/diancan/shouye/list?page=1&size=10";
        if (role !== "") {//原:role !== "all"
            url += "&role=" + encodeURIComponent(role);
        }
        if (start && end) {
            url += "&start=" + encodeURIComponent(start) + "&end=" + encodeURIComponent(end);
        }
        currentRole = role;//2023年12月1日
        currentStartDate = start;//2023年12月1日
        currentEndDate = end;//2023年12月1日
        window.location.href = url;
    }

    function goToPage() {
        var page = document.getElementById("goToPage").value;
        window.location.href = "/diancan/shouye/list?page=" + page + "&size=10<#if role?has_content>&role=${role}</#if><#if start?has_content>&start=${start?string('yyyy-MM-dd')}</#if><#if end?has_content>&end=${end?string('yyyy-MM-dd')}</#if>";
    }
</script>

</html>