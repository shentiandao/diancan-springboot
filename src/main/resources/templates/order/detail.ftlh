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
        <div class="container">
            <div class="row clearfix">
                <#--订单详情表数据-->
                <div class="col-md-12 column">
                    <table class="table table-bordered">
                        <thead>
                        <tr class="table-info">
                            <th>总订单id</th>
                            <#--                            <th>订单总金额</th>-->
                            <th>单个订单id</th>
                            <th>商品名称</th>
                            <th>单价</th>
                            <th>数量</th>
                            <th>总额</th>
                            <#if isAdmin??>
                                <th colspan="2">操作</th>
                            </#if>
                        </tr>
                        </thead>
                        <tbody>
                        <#list orderDTO.orderDetailList as orderDetail>
                            <tr>
                                <td>${orderDTO.orderId}</td>
                                <#--                                <td>${orderDTO.orderAmount}</td>-->
                                <td>${orderDetail.detailId}</td>
                                <td>${orderDetail.foodName}</td>
                                <td>${orderDetail.foodPrice}</td>
                                <td>${orderDetail.foodQuantity}</td>
                                <td>${orderDetail.foodQuantity * orderDetail.foodPrice}</td>
                                <#if isAdmin??>
                                    <td><a href="/diancan/adminOrder/tuicai?orderId=${orderDetail.orderId!''}&detailId=${orderDetail.detailId!''}">退菜</a></td>
                                </#if>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>

                <#--操作-->
                <div class="col-md-12 column">
                    <#if orderDTO.getOrderStatus() == 0||orderDTO.getOrderStatus()== 1>
                        <a href="/diancan/adminOrder/finish?orderId=${orderDTO.orderId}" type="button"
                           class="btn  btn-info btn-primary">订单完成</a>
                        <a href="/diancan/adminOrder/cancel?orderId=${orderDTO.orderId}" type="button"
                           class="btn  btn-info btn-danger">取消订单</a>
                    </#if>
                </div>
            </div>
        </div>
    </div>
</div>


</body>
</html>
