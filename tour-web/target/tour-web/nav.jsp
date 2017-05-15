<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" href="resources/css/jqModal.css">
<link rel="stylesheet" href="resources/css/nav.css"/>
<link rel="stylesheet" href="resources/css/login.css"/>
<script src="resources/js/jqModal.min.js"></script>

<script>

    $(function () {
        initHead();
        initModal();
        loginClick();
        logoutClick();
        signinBtnClick();
    });

    /**
     * 初始化导航栏，鼠标滑动时的样式
     */
    function initHead() {
        $('.head-nav').find('div').each(function () {
//            $(this).click(function () {
//                $(this).removeClass('head-nav-hover');
//                $(this).addClass('head-nav-active');
//                $('.head-nav').find('div').not($(this)).removeClass('head-nav-active');
//            });
            $(this).hover(
                    function () {
                        if ($(this).hasClass('head-nav-active')) {
                            return;
                        }
                        $(this).addClass('head-nav-hover');
                        $('.head-nav').find('div').not($(this)).removeClass('head-nav-hover');
                    },
                    function () {
                        $(this).removeClass('head-nav-hover');
                    }
            );
        });
    }

    /**
     * 登录模态窗口初始化
     */
    function initModal() {
        $('.login-modal').jqm({
            modal: true,
            overlay: 20
        });
    }

    /**
     * 点击登录时弹出登陆窗口
     */
    function loginClick() {
        $('#login').click(function () {
            $('.login-modal').jqmShow();
        });
    }

    /**
     * 点击退出时回到主页面
     */
    function logoutClick() {
        $('#logout').click(function () {
            $.ajax({
                type: "POST",
                url: "/tour/logout",
                async: false,
                success: function (data) {
                    window.location.href = 'http://localhost:8081/tour';
                }
            });
        });
    }

    /**
     * 登录按钮点击事件
     * @returns {boolean}
     */
    function signinBtnClick() {
        $('#signin').click(function () {
            if (validate()) {
                $.ajax({
                    type: "POST",
                    url: "/tour/login",
                    data: $('#form').serialize(),
                    async: false,
                    success: function (data) {
                        if (data) {
                            location.reload();
                        } else {
                            $('#tip-content').html('用户名或密码不正确');
                        }
                    }
                });
            }
        });
    }

    /**
     * 登录时验证
     * private
     * @returns {boolean}
     */
    function validate() {
        if ($('#email').val() == '') {
            $('#tip-content').html('请输入用户名');
            return false;
        }
        if ($('#password').val() == '') {
            $('#tip-content').html('请输入密码');
            return false;
        }
        return true;
    }

</script>

<!--导航栏-->
<div class="header-content">
    <div class="header-wrap">
        <div class="head-logo">
            <img src="holder.js/136x33" alt=""/>
        </div>
        <div class="head-nav">
            <a href="/tour">
                <div class="head-nav-index">首页</div>
            </a>
            <a href="/tour/travels.jsp">
                <div class="head-nav-travel">旅行游记</div>
            </a>
            <a href="/tour/hotels.jsp">
                <div class="head-nav-hotel">酒店</div>
            </a>
            <a href="/tour/spots">
                <div class="head-nav-addr">景点</div>
            </a>
        </div>

        <c:choose>
            <c:when test="${user != null}">
                <div class="login-out">
                    <a href="personal.jsp" title="点击查看个人信息">${user.nick}</a>
                    <span class="split">|</span>
                    <a id="logout" href="#">退出</a>
                </div>
            </c:when>
            <c:when test="${user == null}">
                <div class="login-out">
                    <a id="login" href="#" title="登录">登录</a>
                    <span class="split">|</span>
                    <a href="register.html" title="注册账号">注册</a>
                </div>
            </c:when>
        </c:choose>

    </div>
</div>

<!-- 登录窗口  jquery modal 插件-->
<div class="login-modal">

    <div class="login-close">
        <span class="glyphicon glyphicon-remove jqmClose"></span>
    </div>

    <div class="login-form">
        <div class="login-title">
            <h4>登录途悠游</h4>
        </div>
        <div class="err-tip">
            <span id="tip-content"></span>
        </div>
        <form id="form" method="post">
            <div class="input-group login-input-email">
                <div class="input-group-addon"><span class="glyphicon glyphicon-user"></span></div>
                <input class="form-control" type="text" id="email" placeholder="您的邮箱" name="email"/>
            </div>
            <div class="input-group login-input-password">
                <div class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></div>
                <input class="form-control" type="password" id="password" placeholder="您的密码" name="password"/>
            </div>
            <div class="login-btn">
                <span class="forget-password"><a href="forgetpass.html">忘记密码？</a></span>
                <button type="button" id="signin" class="btn btn-warning btn-sm sign-in">登录</button>
            </div>
        </form>
    </div>

    <div class="login-img">
        <img style="width:100%" src="resources/img/login-img.jpeg" alt=""/>
    </div>

</div>
