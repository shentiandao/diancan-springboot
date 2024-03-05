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
        </div>
    </h2>
    <#--左边栏-->
    <#include "../zujian/left.ftlh">
    <#--主要内容content-->
    <#if !isAdmin??>
        <h2 class="text-danger m-5">您不是管理员，没有管理权限</h2>
    <#else >
        <div class="main">
        <h1>MQTT Web Client</h1>
    <label for="serverInput">Server:</label>
    <#--2023年12月7日-->
    <input type="password" id="passwordInput" placeholder="请输入密码" />
    <button id="checkPasswordButton" onclick="checkPassword()" class="btn btn-warning text-white my-3">验证密码</button>
    <input type="text" id="serverInput" value="ws://broker.emqx.io:8083/mqtt" style="display: none;"/>
    <button onclick="connect()" class="btn btn-warning text-white my-3" id="connectButton" style="display: none;">连接服务器</button>
    <button onclick="disconnect()" class="btn btn-warning text-white my-3" id="disconnectButton" style="display: none;">断开服务器</button>
    <span id="ljzt" style="display: none;">连接状态:</span>
    <span id="connectionStatus" style="display: none;"></span>
    <span id="countdown" class="highlight" style="display: none;"></span>
    <span id="yanzheng" style="display: none;">秒后需重新验证</span>
    <br>
    <!-- <label for="publishTopicInput">Publish Topic:</label> -->

    <label>操作按键:</label>
    <!-- 前进 -->
    <input type="text" id="publishTopicInput" value="robot/movement" style="display: none;"/>
    <input type="text" id="messageInput" value="1" style="display: none;"/>
    <button onclick="publish()" class="btn btn-warning text-white my-3">向前</button>
    <!-- 后退 -->
    <input type="text" id="publishTopicInput2" value="robot/movement" style="display: none;"/>
    <input type="text" id="messageInput2" value="2" style="display: none;"/>
    <button onclick="publish1()" class="btn btn-warning text-white my-3">后退</button>
    <!-- 左转 -->
    <input type="text" id="publishTopicInput3" value="robot/movement" style="display: none;"/>
    <input type="text" id="messageInput3" value="3" style="display: none;"/>
    <button onclick="publish2()" class="btn btn-warning text-white my-3">左转</button>
    <!-- 右转 -->
    <input type="text" id="publishTopicInput4" value="robot/movement" style="display: none;"/>
    <input type="text" id="messageInput4" value="4" style="display: none;"/>
    <button onclick="publish3()" class="btn btn-warning text-white my-3">右转</button>
    <!-- 调头 -->
    <input type="text" id="publishTopicInput6" value="robot/movement" style="display: none;"/>
    <input type="text" id="messageInput6" value="5" style="display: none;"/>
    <button onclick="publish5()" class="btn btn-warning text-white my-3">调头</button>
    <!-- 暂停 -->
    <input type="text" id="publishTopicInput5" value="robot/movement" style="display: none;"/>
    <input type="text" id="messageInput5" value="0" style="display: none;"/>
    <button onclick="publish4()" class="btn btn-warning text-white my-3">暂停</button>
    <br>
    <label for="subscribeTopicInput">Subscribe Topic:</label>
    <input type="text" id="subscribeTopicInput" value="robot/movement" style="display: none;"/>
    <button onclick="subscribe()" class="btn btn-warning text-white my-3">订阅</button>

    <div id="log"><button class="btn btn-primary" onclick="clearTable()">清空表格</button>订阅的消息:</div>
    <div class="row clearfix">
    <div class="col-md-12 column">
        <table class="table table-bordered " id="messageTable">
            <thead>
            <tr class="table-info">
                <th>客户端ID</th>
                <th>时间</th>
                <th>主题</th>
                <th>消息</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
            </div>
        </div>
    </div>
</div>
    </#if>


</body>
<script>
    //清空订阅表格
    function clearTable() {
        const tableBody = document.querySelector('#messageTable tbody');
        tableBody.innerHTML = '';
    }

    //2023年12月7日
    function checkPassword() {
        const passwordInput = document.getElementById('passwordInput').value;
        const date = new Date();
        const hours = date.getHours().toString().padStart(2, '0');
        const minutes = date.getMinutes().toString().padStart(2, '0');
        const correctPassword = hours + minutes;

        if (passwordInput === correctPassword) {
            document.getElementById('passwordInput').style.display = 'none';
            document.getElementById('checkPasswordButton').style.display = 'none';
            document.getElementById('connectButton').style.display = 'inline';
            document.getElementById('disconnectButton').style.display = 'inline';
            document.getElementById('ljzt').style.display = 'inline';
            document.getElementById('connectionStatus').style.display = 'inline';
            document.getElementById('countdown').style.display = 'inline';
            document.getElementById('yanzheng').style.display = 'inline';

            let countdown = 20 * 60;  // 20分钟
            const countdownElement = document.getElementById('countdown');
            const timerId = setInterval(function() {
                countdown--;
                const minutes = Math.floor(countdown / 60);
                const seconds = countdown % 60;
                countdownElement.textContent = minutes + ':' + seconds.toString().padStart(2, '0');

                if (countdown <= 0) {
                    clearInterval(timerId);
                    document.getElementById('passwordInput').style.display = 'inline';
                    document.getElementById('checkPasswordButton').style.display = 'inline';
                    document.getElementById('connectButton').style.display = 'none';
                    document.getElementById('disconnectButton').style.display = 'none';
                    document.getElementById('ljzt').style.display = 'none';
                    document.getElementById('connectionStatus').style.display = 'none';
                    document.getElementById('countdown').style.display = 'none';
                    document.getElementById('yanzheng').style.display = 'none';
                    disconnect();  // 自动断开服务器
                }
            }, 1000);
        } else {
            alert('密码错误');
        }
    }
</script>
</html>
