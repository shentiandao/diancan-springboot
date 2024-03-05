<html>
<#include "../zujian/top.ftlh">
<body>

<div class="container">
    <div class="row justify-content-center align-items-center" style="height: 100vh;">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h4 class="mb-0">操作成功!</h4>
                </div>
                <div class="card-body">
                    <p class="card-text">${msg!""}</p>
                    <a href="${url}" class="btn btn-success">3s后自动跳转</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>

<script>
    setTimeout('location.href="${url}"', 3000);
</script>

</html>