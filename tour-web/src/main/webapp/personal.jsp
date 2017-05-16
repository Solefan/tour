<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>个人信息 - 途悠游</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

    <link rel="stylesheet" href="resources/css/bootstrap.min.css">

    <script src="resources/js/jquery.min.js"></script>
    <script src="resources/js/bootstrap.min.js"></script>
    <script src="resources/js/holder.min.js"></script>

    <link rel="stylesheet" href="resources/fileinput/css/fileinput.min.css">
    <script src="resources/fileinput/js/fileinput.min.js"></script>
    <script src="resources/fileinput/js/locales/zh.js"></script>

    <style>

        textarea {
            resize: none;
        }

        .container {
            width: 80%;
        }

        .split {
            width: 100%;
            height: 1px;
            background-color: #eee;
            margin-top: 20px;
        }

        .personal-head {
            width: 100%;
            height: 300px;
            overflow: hidden;
        }

        .personal-head img {
            width: 100%;
            height: 100%;
        }

        .personal-nav {
            width: 100%;
            height: 58px;
            background-color: #f8f8f8;
            border-bottom: #d6d6d6 1px solid;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.12);
        }

        .center {
            width: 80%;
            height: 100%;
            margin: 0 auto;
            position: relative;
        }

        .avatar {
            text-align: center;
            font-size: 14px;
            position: absolute;
            left: 5%;
            top: -180%;
        }

        .avatar-img {
            width: 120px;
            height: 120px;
            position: relative;
            margin: 0 auto;
            border-radius: 50%;
            overflow: hidden;
        }

        .avatar-img img {
            width: 100%;
            height: 100%;
        }

        .avatar-nick {
            color: #fff;
            font-size: 16px;
            margin-top: 3px;
            color: #ff9d00;
        }

        .nav-content {
            width: 70%;
            height: 100%;
            text-align: center;
            font-size: 14px;
            float: right;
        }

        .personal-item:hover {
            color: #ff9d00;
        }

        .infor, .travel, .msg {
            text-align: center;
            width: 20%;
            height: 100%;
            float: left;
            padding-top: 17px;
            cursor: pointer;
            font-size: 18px;
        }

        .item-active {
            border-bottom: 3px solid #ff9d00;
            color: #ff9d00;
        }

        .personal-content {
            margin-top: 5%;
        }

        .write-travel {
            width: 70%;
            height: 300px;
            text-align: center;
            background-color: #fafafa;
            margin-left: 35px;
            padding: 10px;
            color: #888;
        }

        .write-travel:hover {
            cursor: pointer;
        }

        .item-glyphicon {
            padding-top: 20px;
            font-size: 90px;
            color: #ccc;
        }

        .item-glyphicon:hover {
            color: #999;
        }

        .form-label {
            text-align: right;
            color: #777;
            font-size: 15px;
            height: 30px;
            padding-top: 5px
        }

        .form-sex {
            height: 30px;
            padding-top: 5px;
        }

        .form-sex div {
            margin-top: -19px;
            margin-left: 18px;
        }

        .empty-travel {
            width: 70%;
            color: #e0e0e0;
            font-size: 20px;
            text-align: center;
        }

        .travel-div {
            width: 70%;
            margin-bottom: 15px;
        }

        .travel-div:hover {
            background-color: #fafafa;
        }

        .travel-title {
            float: left;
            width: 95%;
            cursor: pointer;
        }

        .travel-title a {
            color: #ff9d00;
        }

        .travel-operate:hover {
            color: #ff9d00;
            cursor: pointer;
        }

        .msg-div {
            width: 100%;
            margin-bottom: 10px;
            border-radius: 10px;
            border: 1px solid #eee;
        }

        .media {
            padding: 20px;
            padding-bottom: 15px;
            height: auto;
        }

        .media-left img {
            width: 64px;
            height: 64px;
        }

        .media-body {
            color: #666;
            font-size: 13px;
            letter-spacing: 1px;
            line-height: 23px;
            width: 100%;
            padding-lefts: 10px;
        }

        .personal-msg a {
            color: #ff9d00;
        }

        .msg-div:hover {
            background-color: #eee;
        }

        .msg-title {
            width: 100%;
            height: 28px;
        }

        .msg-from {
            float: left;
            color: #ff9d00;
            font-size: 13px;
            font-weight: 400;
        }

        .msg-time {
            float: right;
            color: #999;
        }

        .msg-close {
            float: right;
            font-size: 20px;
            margin-left: 20px;
            margin-top: -3px;
        }

        .msg-close:hover {
            cursor: pointer;
        }

        .msg-content {
            min-height: 40px;
            max-height: auto;
        }

        .msg-reply {
            font-size: 5px;
            float: right;
            color: #ff9d00;
            cursor: pointer;
            margin-top: 5px;
            height: 20px;
        }

        .msg-reply-div {
            display: none;
            width: 100%;
        }

        .msg-reply-div input {
            margin-top: 10px;
            margin-right: 10px;
        }

        .btn-style {
            background-color: #ff9d00;
            color: white;
        }

        .btn-style:hover {
            background-color: #ff8d00;
            color: white;
        }

        .footer {
            width: 100%;
            height: 100px;
        }

        .err-tip {
            color: red;
            margin-top: 5px;
            font-size: 10px;
            display: none;
        }

    </style>

    <script>
        $(function () {
            initHeadAddr();
            setPersonalNav();
            loadTravel();
            loadMsg();
            fileInput($('#uploadnick'));
            saveBtnClick();
            trashClick();
        });

        /**
         * 更新顶部导航栏
         */
        function initHeadAddr() {
            $('.head-nav').find('div').removeClass('head-nav-active');
        }

        /**
         * 个人中心导航栏
         */
        function setPersonalNav() {
            $('.nav-content').find('div').each(function (i) {
                $(this).click(function () {
                    $('.nav-content').find('div').removeClass('item-active');
                    $(this).addClass('item-active');
                    var v = $(this).attr('id');
                    $('.col-md-8').hide();
                    $('.' + v).show();
                });
            });
        }

        /**
         * ajax请求游记列表
         */
        function loadTravel() {
            $.ajax({
                type: "POST",
                url: "/tour/mytravels",
                async: true,
                success: function (data) {
                    addTravelAsync(data);
                }
            });
        }

        /**
         * 添加列表div
         * @param data
         */
        function addTravelAsync(data) {
            $('.personal-travel').empty();
            var inner = "";
            if (data.length == 0) {
                inner += "<div class='empty-travel'>您还没有添加任何游记哦<div>";
            } else {
                for (var i = 0; i < data.length; i++) {
                    var j = i + 1;
                    inner += "<div class='travel-div'>" +
                            "<div class='travel-title'>" + j + "、<a href='/tour/travel?id=" + data[i].id + "' target='_blank'>" + data[i].title + "</a></div>" +
                            "<div class='travel-operate'><span class='glyphicon glyphicon-trash'><input type='hidden' value='" + data[i].id + "' /></span></div>" +
                            "</div>";
                }
            }
            $('.personal-travel').append(inner);
            trashClick();
        }

        /**
         * 删除事件
         */
        function trashClick() {
            $('.glyphicon-trash').each(function (i) {
                $(this).click(function () {
                    var travelid = $(this).find('input').val();
                    $('#dialog').modal('show');
                    confirmBtnClick(travelid);
                });
            });
        }

        /**
         * ajax请求消息列表
         */
        function loadMsg() {
            $.ajax({
                type: "POST",
                url: "/tour/messages",
                async: true,
                success: function (data) {
                    addMsgAsync(data);
                }
            });
        }

        /**
         * 添加消息列表
         */
        function addMsgAsync(data) {
            $('.personal-msg').empty();
            var inner = "";
            if (data.length == 0) {
                inner += "<div class='empty-travel'>您还没有任何新消息哦<div>";
            } else {
                for (var i = 0; i < data.length; i++) {
                    var msgReply = "<div class='msg-reply'>回复</div>";
                    if (data[i].user.permission == 1) {
                        msgReply = "";
                    }
                    var newDate = new Date(data[i].message.time);
                    inner += "<div class='msg-div'>" +
                                "<div class='media'>" +
                                    "<div class='media-left'>" +
                                        "<img src='" + data[i].user.avatar + "' class='img-circle'>" +
                                    "</div>" +
                                    "<div class='media-body'>" +
                                        "<div class='msg-title'>" +
                                            "<div class='msg-from'>" + data[i].user.nick + "</div>" +
                                            "<div class='msg-close'>&times;</div>" +
                                            "<input type='hidden' class='messageid' value='" + data[i].message.id + "' />" +
                                            "<div class='msg-time'>" + newDate.toLocaleString() + "</div>" +
                                        "</div>" +
                                        "<div class='msg-content'>" + data[i].message.content + "</div>" +
                                        msgReply +
                                    "</div>" +
                                    "<div class='msg-reply-div'>" +
                                        "<input class='touid' type='hidden' value='" + data[i].message.fromUid + "' />" +
                                        "<textarea class='form-control reply-content' rows='5' placeholder='回复 :'></textarea>" +
                                        "<input type='button' class='btn btn-style btn-warning btn-sm reply' value='回复'>" +
                                        "<input type='button' class='btn btn-default btn-sm cancel' value='收起'>" +
                                    "</div>" +
                                "</div>" +
                            "</div>";
                }
            }
            $('.personal-msg').append(inner);
            closeClick();
            cancelBtnClick();
            reply();
            replyBtnClick();
        }

        /**
         * 点击消息关闭按钮
         */
        function closeClick() {
            $('.msg-close').each(function (i) {
                $(this).click(function () {
                    var messageid = $(this).parent().find('.messageid').val();
                    $(this).parents('.msg-div').slideUp();
                    $.ajax({
                        url: "/tour/updateMsg",
                        type: "POST",
                        data: {"id": messageid},
                        success: function () {
                            loadMsg();
                        }
                    });
                });
            });
        }

        /**
         * 点击回复，出现回复输入框
         */
        function reply() {
            $('.msg-reply').each(function () {
                $(this).click(function () {
                    $('.cancel').click();
                    $(this).parent().next().slideDown("fast");
                    $(this).html("");
                });
            });
        }

        /**
         * 点击取消按钮时间，恢复之前的样子
         */
        function cancelBtnClick() {
            $(".cancel").each(function () {
                $(this).click(function () {
                    $(this).parent().slideUp("fast");
                    $(this).parent().prev().find('.msg-reply').html("回复");
                });
            });
        }

        /**
         * 点击回复按钮事件
         */
        function replyBtnClick() {
            $('.reply').each(function () {
                $(this).click(function () {
                    var textarea = $(this).parent().find('textarea');
                    var content = $.trim(textarea.val());
                    var touid = $(this).parent().find('.touid').val();
                    if (validateContent(textarea)) {
                        $.ajax({
                            type: "POST",
                            url: "/tour/sendMessage",
                            data: {"toUid": touid, "content": content},
                            async: true,
                            success: function () {
                                $('.tip').html("回复成功");
                                $('#modal').modal('show');
                            }
                        });
                    }
                    $(this).next().click();
                    textarea.val("");
                });
            });

        }

        /**
         * 验证回复消息输入
         * private  obj=$('')
         */
        function validateContent(obj) {
            var content = $.trim(obj.val());
            if (content == null || content == '') {
                $('.tip').html("客官，请输入评论内容");
                $('#modal').modal('show');
                obj.val("");
                return false;
            }
            return true;
        }

        /**
         * 渲染文件上传框
         */
        function fileInput(obj) {
            obj.fileinput({
                language: 'zh',
                uploadUrl: "uploadNick",
                enctype: 'multipart/form-data',
                showCaption: false,
                showPreview: true,
                showUploadedThumbs: true,
                showBrowse: true,
                uploadAsync: true,
                browseClass: "btn btn-style btn-warning",
                allowedFileExtensions: ['jpg', 'gif', 'png', 'jpeg'],
                dropZoneEnabled: false
            }).on('fileuploaded', function (event, data, previewId, index) {
                var res = data.response;
                $('.avatar-img img').attr("src", res.src);
            });
        }

        /**
         * 确认删除按钮点击事件
         */
        function confirmBtnClick(id) {
            $('#confirm').click(function () {
                $.ajax({
                    type: "POST",
                    url: "/tour/deltravel",
                    data: {"id": id},
                    async: true,
                    success: function (data) {
                        loadTravel();
                        $('.tip').html("删除成功");
                        $('#modal').modal('show');
                    }
                });
            });
        }

        /**
         * 点击保存事件
         */
        function saveBtnClick() {
            $('#saveBtn').click(function () {
                if (validateUser()) {
                    var gender = $('input:checked').val();
                    var nick = $.trim($('#nick').val());
                    $.ajax({
                        type: "POST",
                        url: "/tour/updateUser",
                        data: {"nick": nick, "gender": gender},
                        async: true,
                        success: function (data) {
                            $('.err-tip').hide();
                            $('.tip').html("保存成功");
                            $('#modal').modal('show');
                        }
                    });
                }
            });
        }

        /**
         * 校验输入框
         * @returns {boolean}
         */
        function validateUser() {
            var nick = $.trim($('#nick').val());
            if (nick == null || nick == '') {
                $('.err-tip').show();
                return false;
            }
            return true;
        }

    </script>

</head>
<body>

<%@ include file="/nav.jsp" %>
<%@ include file="/tip.jsp" %>

<div class="personal-head">
    <img src="resources/img/bn-reviews.png"/>
</div>

<div class="personal-nav container">
    <div class="center">
        <div class="avatar">
            <div class="avatar-img">
                <c:choose>
                    <c:when test="${user != null}">
                        <img alt="" src="${user.avatar}">
                    </c:when>
                    <c:when test="${user == null}">
                        <img alt="" src="resources/img/default.gif">
                    </c:when>
                </c:choose>
            </div>
            <div class="avatar-nick">
                <span>${user.nick}</span>
            </div>
        </div>

        <div class="nav-content">
            <div class="infor personal-item item-active" id="personal-infor">
                <span>个人信息</span>
            </div>
            <div class="travel personal-item" id="personal-travel">
                <span>我的游记</span>
            </div>
            <div class="msg personal-item" id="personal-msg">
                <span>我的消息</span>
            </div>
        </div>

    </div>
</div>

<div class="container personal-content">
    <div class="row">
        <div class="col-md-4">
            <div class="write-travel panel">
                <h3>写游记</h3>
                <a href="writeTravel.jsp">
                    <div class="item-glyphicon"><span class="glyphicon glyphicon-edit"></span></div>
                </a>
                <div class="item-content">
                    <p>记录旅游的一些好玩的事情，分享给大家吧</p>
                </div>
            </div>
        </div>

        <div class="col-md-8 personal-infor">
            <div class="form-horizontal">

                <div class="form-group">
                    <div class="col-sm-2 form-label">头像:</div>
                    <div class="col-sm-7">
                        <input id="uploadnick" type="file" accept="image/*" name="file" class="file-loading"/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-2 form-label">邮箱:</div>
                    <div class="col-sm-4">
                        <input type="text" class="form-control" value="${user.email}" name="college" readonly/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-2 form-label">昵称:</div>
                    <div class="col-sm-4">
                        <input type="text" class="form-control" value="${user.nick}" name="nick" id="nick"/>
                    </div>
                    <div class="col-sm-2">
                        <div class="err-tip">昵称不能为空</div>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-2 form-label">性别:</div>

                    <div class="col-sm-1 form-sex">
                        <input type="radio" name="gender" ${user.gender == '男'?'checked':''} id="man" value="男">
                        <div>男</div>
                    </div>

                    <div class="col-sm-1 form-sex">
                        <input type="radio" name="gender" ${user.gender == '女'?'checked':''} id="woman" value="女">
                        <div>女</div>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-md-offset-3 col-sm-1">
                        <input id="saveBtn" class="btn btn-style btn-warning" type="button" value="保存"/>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-8 personal-travel" style="display: none"></div>

        <div class="col-md-8 personal-msg" style="display: none"></div>

    </div>
</div>

<div class="footer"></div>

<!-- 弹出框 -->
<div class="modal fade" id="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title">提示</h4>
            </div>
            <div class="modal-body">
                <p>游记是记忆的资产，你确定要删除这份珍贵的回忆吗？呜呜</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-style btn-warning" id="confirm" data-dismiss="modal">狠心删除</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>