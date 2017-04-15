<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>攻略 - 途悠游</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <link rel="stylesheet" href="resources/css/bootstrap.min.css">

    <script src="resources/js/jquery.min.js"></script>
    <script src="resources/js/bootstrap.min.js"></script>
    <script src="resources/js/holder.min.js"></script>

    <style>
        
        textarea {
            resize: none;
        }

        .container {
            width: 80%;
        }

        h1 {
            display: inline;
            margin-right: 10px;
            font-weight: normal;
            font-size: 30px;
            color: #333;
        }

        .split {
            width: 100%;
            height: 1px;
            background-color: #eee;
            margin-top: 20px;
        }

        .travel-head {
            width: 100%;
            height: 400px;
            overflow: hidden;
            margin-bottom: -80px;
        }

        .travel-head img {
            width: 100%;
        }

        .travel-title {
            position: relative;
        }

        .user-avatar {
            width: 120px;
            height: 120px;
            margin-right: 40px;
            border-radius: 60px;
            overflow: hidden;
            float: left;
        }

        .user-avatar img {
            width: 100%;
            height: 100%;
        }

        .title-name {
            width: 700px;
            float: left;
            margin-top:20px;
            color: white;
            font-size: 25px;
            overflow: hidden;
        }

        .travel-user {
            height: 30px;
            width: auto;
            margin-top: 45px;
        }

        .user-name {
            margin-right: 30px;
            float: left;
            color: #ff7200;
            font-size: 14px;
        }

        .write-time {
            padding-top: 3px;
            color: #aaa;
            font-size: 13px;
        }

        .content-div {
            padding-bottom: 50px;
            border-bottom: 1px solid #e5e5e5;
        }

        .travel-content {
            width: 70%;
            height: auto;
            float: left;
            margin-right: 6%;
            margin-top: 50px;
            color: #666;
            line-height: 25px;
            font-size: 16px;
        }

        .travel-content img {
            margin-top: 10px;
            margin-bottom: 10px;
            width: 100%;
            height: auto;
        }

        .travel-recommend {
            float: right;
            height: 520px;
            width: 24%;
            margin-top: 50px;
        }

        .travel-recommend p {
            font-size: 16px;
            color: #ff9d00;
        }

        .travel-recommend-div {
            width: 100%;
            height: 30%;
            border-radius: 5px;
            overflow: hidden;
            margin-bottom: 25px;
        }

        .travel-recommend-div img {
            width: 120%;
            height: 100%;
        }

        .travel-recommend-div .recommend-title {
            margin: -40px auto;
            padding: 10px;
            position:relative;
            color: white;
            font-weight: 500;
            text-align: center;
        }

        .travel-recommend-div .recommend-title:hover {
            color: #ff9d00;
        }

        .footer {
            width: 100%;
            height: 50px;
        }

    </style>

    <script>
        $(function () {

            initHeadTravel();
            limitTitle();
            ajaxFirstComment();
            addCommentBtnClick();

        });

        /**
         * 更新顶部导航栏
         */
        function initHeadTravel() {
            $('.head-nav').find('div').removeClass('head-nav-active');
            $('.head-nav').find('.head-nav-travel').addClass('head-nav-active');
        }

        /**
         * 限制相关游记标题的字数
         */
        function limitTitle() {
            $('.recommend-title').each(function(i) {
                var title = $(this).html();
                if (title.length > 15) {
                    title = title.substring(0, 15) + "...";
                }
                $(this).html(title);
            });
        }

        /**
         * 验证评论输入
         * private
         */
        function validateContent() {
            var content = $.trim($('#content').val());
            if (content == null || content == '') {
                $('.tip').html("客官，请输入评论内容");
                $('#modal').modal('show');
                $('#content').val("");
                return false;
            }
            return true;
        }

        /**
         * 获取第一页comment
         */
        function ajaxFirstComment() {
            $.ajax({
                type: "POST",
                url: "/tour/travelComment",
                data: {"travelId": $('#travelid').val(), "pageNum": 1, "size": $('#size').val()},
                success: function (data) {
                    addCommentDiv(data);
                    setPage(data);
                }
            });
        }

        /**
         * 添加评论列表
         * private
         * @param data
         */
        function addCommentDiv(data) {
            var comment = "";
            var maplist = data.maplist;
            var userId = "${user.id}";            //登录用户
            var authorId = "${json.user.id}";     //游记作者
            for (var i = 0; i < maplist.length; i++) {
                var trashDiv = "";
                var newDate = new Date(maplist[i].comment.time);
                if (userId == authorId) {
                    trashDiv += "<div class='comment-operate'><span class='glyphicon glyphicon-trash'><input type='hidden' value='" + maplist[i].comment.id + "' /></span></div>";
                }
                comment += "<div class='media'>" +
                                "<div class='media-left '>" +
                                    "<img src='" + maplist[i].user.avatar + "' class='img-circle'>" +
                                "</div>" +
                                "<div class='media-body'>" +
                                    "<h5 class='media-heading'>" + maplist[i].user.nick + "</h5>" + maplist[i].comment.content +
                                    trashDiv +
                                    "<div class='comment-time'>" + newDate.toLocaleString() + "</div>" +
                                "</div>" +
                            "</div>";
            }
            $('.comment-body').empty();
            $('.comment-body').append(comment);
            trashClick();
        }

        /**
         * 评论删除点击事件
         * private
         */
        function trashClick() {
            $('.glyphicon-trash').each(function(i) {
                $(this).click(function() {
                    var commentId = $(this).find('input').val();
                    $('#dialog').modal('show');
                    confirmBtnClick(commentId);
                });
            });
        }

        /**
         * 确认删除按钮点击事件
         */
        function confirmBtnClick(id) {
            $('#confirm').click(function() {
                $.ajax({
                    type: "POST",
                    url: "/tour/delTravelComment",
                    data: {"id": id},
                    async: true,
                    success: function (data) {
                        ajaxFirstComment();
                        $('.tip').html("删除成功");
                        $('#modal').modal('show');
                    }
                });
            });
        }


        /**
         * 设置分页属性
         * private
         * @param data
         */
        function setPage(data) {
            var firstPage = data.pageinfor.firstPage;
            var prePage = data.pageinfor.prePage;
            var nextPage = data.pageinfor.nextPage;
            var lastPage = data.pageinfor.lastPage;
            var pageNum = data.pageinfor.pageNum;
            var pages = data.pageinfor.pages;

            $('#total').html(data.pageinfor.total);
            $('#firstPage').attr('value', firstPage);
            $('#prePage').attr('value', prePage);
            $('#nextPage').attr('value', nextPage);
            $('#lastPage').attr('value', lastPage);
            $('#pageNum').html(pageNum);
            $('#pages').html(pages);

            //设置分页样式
            $('.pager li').removeClass('disabled');
            if (prePage == 0) {
                $('#prePage').parent().addClass('disabled');
            }
            if (nextPage == 0) {
                $('#nextPage').parent().addClass('disabled');
            }
            if (pageNum == 1) {
                $('#firstPage').parent().addClass('disabled');
            }
            if (pageNum == pages) {
                $('#lastPage').parent().addClass('disabled');
            }
            pageClick();        //绑定事件
        }

        /**
         * 分页按钮绑定事件
         * private
         */
        function pageClick() {
            $('.pager a').each(function (i) {
                $(this).off('click');
                if ($(this).parent().attr('class') != 'disabled') {
                    $(this).click(function () {
                        var pageNum = $(this).attr('value');
                        $.ajax({
                            type: "POST",
                            url: "/tour/travelComment",
                            data: {"travelId": $('#travelid').val(), "pageNum": pageNum, "size": $('#size').val()},
                            success: function (data) {
                                addCommentDiv(data);
                                setPage(data);
                            }
                        });
                    });
                }
            });
        }

        /**
         * 添加评论
         */
        function addCommentBtnClick() {
            $('#addCommentBtn').click(function () {
                var userId = '${user.id}';
                if (userId == '') {
                    $('.tip').html("您还没有登录哦");
                    $('#modal').modal('show');
                    $('#content').val("");
                    return;
                }
                var content = $.trim($('#content').val());
                if (validateContent()) {
                    $.ajax({
                        type: "POST",
                        url: "/tour/addTravelComment",
                        data: {"travelId": $('#travelid').val(), "content": content, "toUid":$('#touid').val()},
                        async: true,
                        success: function (data) {
                            $('.tip').html("感谢您的评论");
                            $('#modal').modal('show');
                            $('#content').val("");
                            ajaxFirstComment();
                        }
                    });
                }
            });
        }

    </script>

</head>
<body>

<%@ include file="/nav.jsp" %>
<%@ include file="/tip.jsp" %>

<input id="travelid" type="hidden" value="${json.travel.id}"/>
<input id="touid" type="hidden" value="${json.user.id}"/>

<div class="travel-head">
    <img src="${json.travel.img}" />
</div>

<div class="travel-title container">
    <div class="user-avatar">
        <img src="${json.user.avatar}" />
    </div>
    <div class="title-name">
        ${json.travel.title}
        <div class="travel-user">
            <div class="user-name">
                ${json.user.nick}
            </div>
            <div class="write-time">
                ${json.travel.time}
            </div>
        </div>
    </div>
</div>

<div class="split"></div>

<div class="container content-div">

    <div class="travel-content">
        ${json.travel.content}
    </div>

    <div class="travel-recommend">
        <p>相关游记</p>
        <c:forEach items="${json.list}" var="travel" >
            <a href="/tour/travel?id=${travel.id}" target="_blank">
                <div class="travel-recommend-div">
                    <img src="${travel.img}" />
                    <div class="recommend-title">${travel.title}</div>
                </div>
            </a>
        </c:forEach>
    </div>

</div>

<%@ include file="/comment.jsp" %>

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
                <p>你确定要删除该评论吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-style btn-warning" id="confirm" data-dismiss="modal">确认</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>