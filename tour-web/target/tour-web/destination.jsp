<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>目的地</title>
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

        .addr-search {
            margin: 50px auto 0px;
            padding-top: 5px;
        }

        .btn-search {
            background-color: #ff9d00;
            color: white;
        }

        .btn-search:hover {
            background-color: #ffb400;
            color: white;
        }

        h1 {
            display: inline;
            margin-right: 10px;
            font-weight: normal;
            font-size: 30px;
            color: #333;
        }

        .addr-wrap {
            height: auto;
            margin: 20px auto;
        }

        .split {
            width: 100%;
            height: 1px;
            background-color: #eee;
            margin-top: 20px;
        }

        .addr-nav {
            width: 100%;
            height: 59px;
            font-size: 16px;
            border-bottom: 1px solid #eee;
        }

        .addr-nav-general {
            text-align: center;
            width: 100px;
            height: 58px;
            padding-top: 18px;
            cursor: pointer;
            border-bottom: 3px solid #ff9d00;
            color: #ff9d00;
        }

        .addr-nav-comment {
            text-align: center;
            width: 120px;
            height: 58px;
            float: left;
            padding-top: 18px;
            cursor: pointer;
        }

        .addr-img {
            width: 100%;
            height: 450px;
            padding-bottom: 25px;
            border-bottom: 1px solid #e5e5e5;
            margin-bottom: 25px;
            font-size: 16px;
            color: #333;
            line-height: 24px;
        }

        .carousel {
            width: 100%;
            height: 100%;
            overflow: hidden;
        }

        .item img {
            width: 100%;
        }

        .addr-intro {
            padding-bottom: 25px;
            border-bottom: 1px solid #e5e5e5;
            margin-bottom: 25px;
            font-size: 16px;
            color: #666;
            line-height: 24px;
        }

        .addr-help, .addr-loc {
            border-bottom: 1px solid #e5e5e5;
        }

        .help-title {
            margin-bottom: 5px;
        }

        .help-body {
            margin-bottom: 20px;
            color: #888;
        }

        .loc-title {
            font-size: 20px;
            color: #333;
            margin-top: 20px;
            font-weight: normal;
            letter-spacing: 1px;
            margin-bottom: 15px;
        }

        .loc-body {
            color: #999;
        }

        .mapAndPath {
            margin-top: 20px;
            width: 100%;
            height: 250px;
            margin-bottom: 20px;
        }

        .loc-map {
            width: 500px;
            height: 250px;
            float: left;
        }

        .spot-container {
            width: 220px;
            height: 250px;
            margin-left: 20px;
            float: left;
            text-align: center;
        }

        .spot-container .panel-body, .path-container .panel-body {
            height: 83%;
            overflow: scroll;
            color: #666;
        }

        .spot-container .panel {
            height: 30px;
            margin-bottom: 10px;
            padding-top: 5px;
        }

        .spot-container .panel:hover {
            background-color: #f0f0f0;
            cursor: pointer;
        }

        .path-container {
            width: 220px;
            height: 250px;
            margin-left: 20px;
            float: left;
            text-align: center;
            display: none;
        }

        .footer {
            width: 100%;
            height: 50px;
        }

    </style>

    <script>
        $(function () {

            initHeadAddr();
            ajaxAllSpotName();
            spotBtnClick();
            ajaxFirstComment();
            addCommentBtnClick();

        });

        /**
         * 更新顶部导航栏
         */
        function initHeadAddr() {
            $('.head-nav').find('div').removeClass('head-nav-active');
            $('.head-nav').find('.head-nav-addr').addClass('head-nav-active');
        }

        /**
         * 加载除本景点之外的所有景点
         */
        function ajaxAllSpotName() {
            $.ajax({
                type: "POST",
                url: "/tour/getAllSpot",
                async: true,
                success: function(data) {
                    $('.spot-content').empty();
                    var inner = "";
                    var spotId = $('#spotid').val();
                    for (var i = 0; i<data.length; i++) {
                        if (data[i].id != spotId) {
                            inner += "<div class='panel path'>" +
                                        "<input type='hidden' value=" + data[i].id + " />" +
                                        "<span>" + data[i].spotName + "</span>" +
                                     "</div>";
                        }
                    }
                    $('.spot-content').append(inner);
                    pathClick();
                }
            });
        }

        /**
         * 绑定点击景点查询路线的事件
         */
        function pathClick() {
            $('.path').each(function(i) {
                $(this).click(function() {
                    var fromSid = $('#spotid').val();
                    var toSid = $(this).find('input').val();
                    $.ajax({
                        type: "POST",
                        url: "/tour/path",
                        data: {"fromSid": fromSid, "toSid": toSid},
                        async: true,
                        success: function(data) {
                            if (data.length == 0) {
                                $('.path-content').html('暂无此路线');
                            } else {
                                $('.path-content').empty();
                                var inner = "";
                                for (var i = 0; i<data.length; i++) {
                                    if ( i == data.length-1) {
                                        inner += data[i].spotName;
                                    } else {
                                        inner += data[i].spotName + " <span class='glyphicon glyphicon-arrow-right'></span> ";
                                    }
                                }
                                $('.path-content').append(inner);
                                $('.path-container').slideDown();
                            }
                        }
                    });
                });
            });
        }

        /**
         * 景点查询按钮
         */
        function spotBtnClick() {
            $('#spotbtn').click(function () {
                var spotName = $.trim($('#spotName').val());
                if (validateSpot()) {
                    $.ajax({
                        type: "POST",
                        url: "/tour/haveSpot",
                        data: {"spotName": spotName},
                        async: true,
                        success: function (data) {
                            if (data == "success") {
                                location.href = "spotByName";
                            }
                            if (data == "spotNotExist") {
                                $('.tip').html("客官，您查询的景点不存在");
                                $('#modal').modal('show');
                                return;
                            }
                        }
                    });
                }
            });
        }

        /**
         * 验证输入
         */
        function validateSpot() {
            var spotName = $.trim($('#spotName').val());
            if (spotName == null || spotName == '') {
                $('.tip').html("客官，请输入景点名字");
                $('#modal').modal('show');
                $('#spotName').val("");
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
                url: "/tour/spotComment",
                data: {"spotId": $('#spotid').val(), "pageNum": $('#pageNum').html(), "size": $('#size').val()},
                success: function (data) {
                    addCommentDiv(data);
                    setPage(data);
                }
            });
        }

        /**
         * 添加评论列表
         * @param data
         */
        function addCommentDiv(data) {
            var comment = "";
            var maplist = data.maplist;
            for (var i = 0; i < maplist.length; i++) {
                var newDate = new Date(maplist[i].comment.time);
                comment += "<div class='media'>" +
                        "<div class='media-left '>" +
                        "<img src='" + maplist[i].user.avatar + "' class='img-circle'>" +
                        "</div>" +
                        "<div class='media-body'>" +
                        "<h5 class='media-heading'>" + maplist[i].user.nick + "</h5>" + maplist[i].comment.content +
                        "<div class='comment-time-div'>" +
                        "<div class='comment-time'>" + newDate.toLocaleString() + "</div>" +
                        "</div>" +
                        "</div>" +
                        "</div>";
            }
            $('.comment-body').empty();
            $('.comment-body').append(comment);
        }

        /**
         * 设置分页属性
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
         */
        function pageClick() {
            $('.pager a').each(function (i) {
                $(this).off('click');
                if ($(this).parent().attr('class') != 'disabled') {
                    $(this).click(function () {
                        var pageNum = $(this).attr('value');
                        $.ajax({
                            type: "POST",
                            url: "/tour/spotComment",
                            data: {"spotId": $('#spotid').val(), "pageNum": pageNum, "size": $('#size').val()},
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
                        url: "/tour/addSpotComment",
                        data: {"spotId": $('#spotid').val(), "content": content},
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

    </script>

</head>
<body>

<%@ include file="/nav.jsp" %>
<%@ include file="/tip.jsp" %>

<input id="spotid" type="hidden" value="${json.spot.id}"/>

<div class="addr-search container">
    <div class="row">
        <div class="form-group col-lg-4">
            <input type="text" class="form-control" id="spotName" placeholder="景点" name="spotName"/>
        </div>

        <button id="spotbtn" type="button" class="btn btn-search btn-warning">
            <span class="glyphicon glyphicon-search"></span>
        </button>
    </div>
</div>

<div class="addr-wrap container">
    <div class="addr-title">
        <h1>${json.spot.spotName}</h1>
    </div>
    <div class="split"></div>
    <div class="addr-nav">
        <div class="addr-nav-general addr-nav-active">
            <span>概况</span>
        </div>
    </div>
</div>

<div class="nav-general-content container">
    <div class="addr-img">
        <div id="carousel-example-generic" class="carousel" data-ride="carousel">
            <!-- Wrapper for slides -->
            <div class="carousel-inner" role="listbox">
                <c:forEach items="${json.spotImg}" var="spotImg" varStatus="i">
                <c:if test="${i.index == 0}">
                <div class='item active'>
                    </c:if>
                    <c:if test="${i.index != 0}">
                    <div class='item'>
                        </c:if>
                        <img src='${spotImg.img}' alt=''>
                    </div>
                    </c:forEach>
                </div>
                <!-- Controls -->
                <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left"></span>
                </a>
                <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right"></span>
                </a>
            </div>
        </div>

        <div class="addr-intro">
            ${json.spot.spotIntroduce}
        </div>

        <div class="addr-help">
            <div class="help-title">用时参考</div>
            <div class="help-body">${json.spot.spendTime}</div>
            <div class="help-title">交通</div>
            <div class="help-body">${json.spot.traffic}</div>
            <div class="help-title">门票</div>
            <div class="help-body">${json.spot.ticket}</div>
            <div class="help-title">开放时间</div>
            <div class="help-body">${json.spot.openTime}</div>
        </div>

        <div class="addr-loc">
            <div class="loc-title">景点位置</div>
            <div class="loc-body">${json.spot.location}</div>
            <div class="mapAndPath">
                <div id="mapContainer" class="loc-map"></div>
                <div class="spot-container panel panel-info">
                    <div class="panel-heading">景点 - 查看游玩路线</div>
                    <div class="panel-body spot-content"></div>
                </div>
                <div class="path-container panel panel-success">
                    <div class="panel-heading">最短游玩路线</div>
                    <div class="panel-body path-content"></div>
                </div>
            </div>
        </div>

        <script type="text/javascript"
                src="http://webapi.amap.com/maps?v=1.3&key=368a175838176615ee0513371b307c44"></script>
        <script type="text/javascript">
            var coordinate = "${json.spot.coordinate}";
            var array = coordinate.substring(1, coordinate.length - 1).split(",");
            var x = array[0];
            var y = array[1];
            var map = new AMap.Map('mapContainer', {
                zoom: 14,
                mapStyle: 'normal',
                center: [x, y]
            });
            var marker = new AMap.Marker({
                position: [x, y],//marker所在的位置
                map: map//创建时直接赋予map属性
            });
            AMap.plugin(['AMap.ToolBar', 'AMap.Scale'], function () {
                map.addControl(new AMap.ToolBar());//上下左右
                map.addControl(new AMap.Scale());//定位当前位置
            });
        </script>

    </div>

    <%@ include file="/comment.jsp" %>

    <div class="footer"></div>

</body>
</html>