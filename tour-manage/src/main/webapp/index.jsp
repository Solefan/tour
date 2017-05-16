<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

    <title>首页</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">

    <link rel="stylesheet" type="text/css" href="resources/css/common.css">
    <link rel="stylesheet" type="text/css" href="resources/js/jquery-easyui-1.2.6/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="resources/js/jquery-easyui-1.2.6/themes/icon.css">

    <script type="text/javascript" src="resources/js/jquery-easyui-1.2.6/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="resources/js/jquery-easyui-1.2.6/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="resources/js/jquery-easyui-1.2.6/locale/easyui-lang-zh_CN.js"></script>

    <style>
        #loginModal {
            padding: 20px 60px 20px 60px;
        }

        #tipDiv {
            height: 20px;
            color: red;
            text-align: center
        }

        #email {
            width: 100%;
            height: 30px;
            padding: 8px
        }

        #password {
            width: 100%;
            height: 30px;
            padding: 8px
        }

        #verifyCode {
            width: 50%;
            height: 30px;
            padding: 8px
        }

        #verifyCodeImg {
            margin: 0 0 0 3px;
            vertical-align: middle;
            height: 26px;
        }

        #verifyCodeImg:hover {
            cursor: pointer;
        }
    </style>

    <script type="text/javascript">
        $(function() {

            initTab();

            //初始化登录窗口
            initLoginModal();

            //点击验证码图片事件
            verifyCodeImgClick();

            //模态框中登录按钮点击事件
            signInClick();

            //退出登录按钮点击事件
            signOutClick();

        });

        /**
         * 点击列表出现tab
         */
        function initTab() {
            $("a[title]").click(function() {
                var src = $(this).attr("title");
                var title = $(this).html();
                if ($("#tabs").tabs('exists', title)) {
                    $("#tabs").tabs('select', title);
                } else {
                    $("#tabs").tabs('add', {
                        title : title,
                        content : '<iframe frameborder=0 src=' + src + ' style=width:100%;height:100%></iframe>',
                        closable : true
                    });
                }
            });
        }

        /**
         * 初始化登录窗口
         */
        function initLoginModal() {
            $('#loginModal').window({
                modal: true,
                title: "请先登录",
                closed: false,
                maximizable: false,
                minimizable: false,
                collapsible: false,
                resizable: false,
                draggable: false,
                closable: false
            });
        }

        function verifyCodeImgClick() {
            $('#verifyCodeImg').click(function () {
                $.ajax({
                    type: "POST",
                    url: "/manage/verifyCode",
                    async: false,
                    success: function () {
                        $('#verifyCodeImg').attr('src', '/manage/verifyCode?' + new Date());
                    }
                });
            });
        }

        function signInClick() {
            $('#signIn').click(function () {
                if (validate()) {
                    $.ajax({
                        type: "POST",
                        url: "/manage/login",
                        data: $('#form').serialize(),
                        async: false,
                        success: function (data) {
                            if (data == "success") {
                                window.location.href = 'http://localhost:8082/manage';
                            } else if (data == "verifyCodeError") {
                                $('#tip-content').html('验证码错误');
                                $('#verifyCodeImg').click();
                            } else {
                                $('#tip-content').html('用户名或密码错误');
                                $('#verifyCodeImg').click();
                            }
                        }
                    });
                }
            });
        }

        function validate() {
            if ($.trim($('#email').val()) == '') {
                $('#tip-content').html('请输入邮箱');
                $('#email').val('');
                return false;
            }
            if ($.trim($('#password').val()) == '') {
                $('#tip-content').html('请输入密码');
                $('#password').val('');
                return false;
            }
            if ($.trim($('#verifyCode').val()) == '') {
                $('#tip-content').html('请输入验证码');
                $('#verifyCode').val('');
                return false;
            }
            return true;
        }

        /**
         * 点击退出时回到主页面
         */
        function signOutClick() {
            $('#signOut').click(function () {
                $.ajax({
                    type: "POST",
                    url: "/manage/logout",
                    async: false,
                    success: function (data) {
                        window.location.href = 'http://localhost:8082/manage';
                    }
                });
            });
        }

    </script>

</head>

<body>

<div class="easyui-layout" fit=true style="width:100%;height:100%">

    <div region="north" title="后台管理系统"  split="false" style="height:100px;">
        <div style="float: right; margin-top:40px; margin-right: 20px">
            您好！ ${user.nick}
            <a href="javascript:void(0);" class="easyui-linkbutton" id="signOut">
                <span>退出</span>
            </a>
        </div>
    </div>

    <div region="west" iconCls="icon-ok" split="false" title="导航菜单" style="width:200px">

        <div class="easyui-accordion" >
            <div title="用户管理" style="overflow:auto;" collapsed="true" selected="true" >
                <ul>
                    <li><a title="jsp/user.jsp" class="easyui-linkbutton">用户列表</a></li>
                </ul>
            </div>

            <div title="航班管理" style="overflow:auto">
                <ul>
                    <li><a title="jsp/flight.jsp" class="easyui-linkbutton">航班列表</a></li>
                </ul>
            </div>

            <div title="景点管理" style="overflow:auto">
                <ul>
                    <li><a title="jsp/spot.jsp" class="easyui-linkbutton">景点列表</a></li>
                </ul>
            </div>

            <div title="景点图片管理" style="overflow:auto">
                <ul>
                    <li><a title="jsp/spotImg.jsp" class="easyui-linkbutton">景点图片列表</a></li>
                </ul>
            </div>

            <div title="景点评论管理" style="overflow:auto">
                <ul>
                    <li><a title="jsp/spotComment.jsp" class="easyui-linkbutton">景点评论列表</a></li>
                </ul>
            </div>

            <div title="酒店管理" style="overflow:auto">
                <ul>
                    <li><a title="jsp/hotel.jsp" class="easyui-linkbutton">酒店列表</a></li>
                </ul>
            </div>

            <div title="房间类型管理" style="overflow:auto">
                <ul>
                    <li><a title="jsp/roomType.jsp" class="easyui-linkbutton">房间类型列表</a></li>
                </ul>
            </div>

            <div title="酒店评论管理" style="overflow:auto">
                <ul>
                    <li><a title="jsp/hotelComment.jsp" class="easyui-linkbutton">酒店评论列表</a></li>
                </ul>
            </div>

            <div title="路线管理" style="overflow:auto">
                <ul>
                    <li><a title="jsp/path.jsp" class="easyui-linkbutton">路线列表</a></li>
                </ul>
            </div>

            <div title="游记审核" style="overflow:auto">
                <ul>
                    <li><a title="jsp/travel.jsp" class="easyui-linkbutton">待审核游记列表</a></li>
                </ul>
            </div>

        </div>

    </div>

    <div region="center" style="padding:0px;">
        <div id="tabs" class="easyui-tabs" fit=true >
            <div title="欢迎" closable=true >
                <img src="resources/img/welcome.gif" style="width:100%; height:100%" />
            </div>
        </div>
    </div>

</div>

<c:choose>
    <c:when test="${user == null}">
        <div id="loginModal" class="easyui-window">

            <form id="form">

            <div id="tipDiv">
                <span id="tip-content"></span>
            </div>

            <div style="margin-bottom:10px">
                <input id="email" name="email" type="text" placeholder="登录邮箱" />
            </div>

            <div style="margin-bottom:10px">
                <input id="password" name="password" type="password" placeholder="密码" />
            </div>

            <div style="margin-bottom:10px;">
                <input type="text" id="verifyCode" placeholder="验证码" name="verifyCode" />
                <img id="verifyCodeImg" src="verifyCode" />
            </div>

            </form>

            <div style="float: right">
                <a href="javascript:void(0);" class="easyui-linkbutton" id="signIn">
                    <span>登录</span>
                </a>
            </div>

        </div>
    </c:when>
</c:choose>

</body>

</html>
