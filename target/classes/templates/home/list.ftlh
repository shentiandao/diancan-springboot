<html>
<#include "../zujian/top.ftlh">
<style>
.highlight {
color: red; /* 登录账号颜色 */
}
</style>
<#--</script>-->
<script src="https://cdn.jsdelivr.net/npm/apexcharts@3.26.0"></script>
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
        <div id="page-content-wrapper" class="container">
            <div class="row clearfix">
                <!-- 每月收入 -->
                <div class="col-md-10 offset-md-1 column">
                    <div id="incomeChart"></div>
                </div>

                <#--需要补货商品-->
                <div class="col-md-10 offset-md-1 column mt-5">
                    <table class="table table-bordered table-hover">
                        <thead>
                        <tr class="table-danger">
                            <th colspan="2">需要补货的菜品</th>
                        </tr>
                        <tr class="table-info">
                            <th>菜品名</th>
                            <th>库存</th>
                        </tr>
                        </thead>
                        <tbody>
                        <#list foodList as food>
                            <tr>
                                <td>${food.foodName!''}</td>
                                <td>${food.foodStock!''}</td>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </#if>
</div>
<script>
    // 从后端获取收入数据
    var incomeData = [
        <#list totalMoneyList as money>
        {
            x: '${money.time!''}',
            y: ${money.totalMoney!''}
        },
        </#list>
    ];

    // 创建折线图
    var options = {
        series: [{
            name: '收入',
            data: incomeData
        }],
        chart: {
            type: 'line',
            height: 350
        },
        xaxis: {
            type: 'category'
        },
        yaxis: {
            title: {
                text: '收入(元)'
            }
        }
    };
    var chart = new ApexCharts(document.querySelector('#incomeChart'), options);
    chart.render();
    function updateChart(data) {
        // 更新折线图的数据
        chart.updateSeries([{
            name: '收入',
            data: data
        }]);
    }
</script>
</body>
</html>