<style>
    * {
        margin: 0;
        padding: 0;
    }

    a:hover, a:focus {
        text-decoration: none
    }

    .mobile-nav ul li a {
        color: white;
        font-size: 1.2em;
        display: block;
        padding: 1em 15%;
        border-bottom: 1px solid #6E8B3D;
        transition: all 0.2s ease-out;
        cursor: pointer;
    }

    .mobile-nav {
        position: fixed;
        top: 0;
        left: 0;
        width: 180px;
        height: 100%;
        background-color: rgb(33,37,41);
        z-index: 9999;
        transition: all 0.3s ease-in;
    }

    .mobile-nav ul li a.active {
        background-color: #17A2B8;
        color: #ffffff;
        /*padding: 10px;*/
        /*margin: 20px;*/
    }
</style>

<div id="mobile-menu" class="mobile-nav">
    <ul id="leftRoot">
        <li><a href="javascript:location.reload()" class="bg-primary">缤纷福巷后台</a></li><#--class="bg-primary"-->
        <li><a href="/diancan/shouye/list" id="shouye">系统首页</a></li>
        <li><a href="/diancan/home/homeList" id="statistics">统计信息</a></li>
        <li><a href="/diancan/admin/list" id="admin">餐厅管理员</a></li>
        <li><a href="/diancan/picture/list" id="slideshow">轮播图管理</a></li>
        <li><a href="/diancan/leimu/list" id="category">菜品类目管理</a></li>
        <li><a href="/diancan/food/list" id="food">菜品管理</a></li>
        <li><a href="/diancan/adminOrder/list" id="order">菜品订单</a></li>
        <li><a href="/diancan/adminPaihao/list" id="queue">排号管理</a></li>
        <li><a href="/diancan/comment/list" id="comment">客户评价</a></li>
        <li><a href="/diancan/adminUser/list" id="user">用户管理</a></li>
        <li><a href="/diancan/xiaoche/list" id="car">小车控制</a></li>
<#--        <li><a href="/diancan/logoutAdmin" id="logout">退出登录</a></li>-->
    </ul>
</div>

<script>
    // 获取当前页面的路径
    var currentPath = window.location.pathname;

    // 获取菜单链接的父元素
    var menuLinks = document.querySelectorAll('.mobile-nav ul li a');

    // 遍历菜单链接，判断是否与当前路径匹配
    for (var i = 0; i < menuLinks.length; i++) {
        var link = menuLinks[i];
        var linkPath = link.getAttribute('href');

        // 判断当前路径是否与菜单链接的路径匹配
        if (currentPath === linkPath) {
            link.classList.add('active');
        }
    }


</script>