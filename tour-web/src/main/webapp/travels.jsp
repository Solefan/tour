<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>旅行游记</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

    <link rel="stylesheet" href="resources/css/bootstrap.min.css">

    <script src="resources/js/jquery.min.js"></script>
    <script src="resources/js/bootstrap.min.js"></script>
    <script src="resources/js/holder.min.js"></script>

    <style>

        .container {
            width: 80%;
        }

        .addr-search {
            margin: 50px auto 0px;
            padding-top: 5px;
        }

        .btn-style {
            background-color: #ff9d00;
            color: white;
        }

        .btn-style:hover {
            background-color: #ff8d00;
            color: white;
        }

        .travel-content {
            padding-top: 2%;
            height: 1130px;
            background-color: #fbfbfb;
        }

        .travel-content a {
            color: black;
        }

        .travel-content-div {
            width: 100%;
            height: 220px;
            padding: 20px;
        }

        .travel-img {
            float: left;
            width: 300px;
            height: 180px;
        }

        .travel-img img {
            width: 100%;
            height: 100%;
        }

        .travel-abstract {
            float: right;
            width: 65%;
            height: 100%;
        }

        .travel-content-div:hover {
            background-color: #f5f5f5;
        }

        .travel-name {
            font-size: 20px;
            font-weight: 300;
            padding-bottom: 10px;
        }

        .travel-name a:hover {
            color: #ff9d00;
        }

        .travel-intro {
            color: #666;
            width: 100%;
            height: 70%;
            overflow: hidden;
        }

        .travel-location {
            color: #ff9d00;
            font-size: 13px;
            font-weight: 300;
        }

        .travel-split {
            width: 100%;
            height: 1px;
            background-color: #c9c9c9;
            margin-top: 2%;
        }

        .travel-page {
            width: 100%;
            height: 100px;
        }

        .travel-page a {
            cursor: pointer;
        }

        .travel-page .page-total {
            margin-top: 3%;
            float: right;
            margin-left: 1%;
        }

        .travel-page .page-current {
            margin-top: 3%;
            float: right;
            margin-left: 1%;
        }

        .travel-page .page-content {
            float: right;
            margin-left: 3%;
        }

        .footer {
            width: 100%;
            height: 50px;
        }

    </style>

    <script>
        $(function () {
            initHeadTravel();
            ajaxFirstPage();
            spotBtnClick();
        });

        /**
         * 更新顶部导航栏
         */
        function initHeadTravel() {
            $('.head-nav').find('div').removeClass('head-nav-active');
            $('.head-nav').find('.head-nav-travel').addClass('head-nav-active');
        }

        /**
         * 获取第一页travel
         * 第一次请求不带 spotname 参数
         */
        function ajaxFirstPage() {
            $.ajax({
                type: "POST",
                url: "/tour/travels",
                data: {"pageNum": $('#pageNum').html(), "size": $('#size').val()},
                success: function (data) {
                    addTravel(data);
                }
            });
        }

        /**
         * 景点查询游记按钮的点击事件
         */
        function spotBtnClick() {
            $('#spotBtn').click(function () {
                if (validateSpot()) {
                    var spotname = $.trim($('#spotname').val());
                    $.ajax({
                        type: "POST",
                        url: "/tour/travels",
                        data: {"spotname": spotname, "pageNum": 1, "size": $('#size').val()},
                        success: function (data) {
                            travelAsync(data);
                        }
                    });
                }
            });
        }

        /**
         * 查询游记成功之后的回调函数
         * private
         */
        function travelAsync(data) {
            if (data.status == "spotNotExist") {
                $('.tip').html("客官，您查询的景点不存在");
                $('#modal').modal('show');
                return;
            }
            if (data.status == "travelNotExist") {
                $('.tip').html("客官，该景点暂时还没有游记");
                $('#modal').modal('show');
                return;
            }
            var maplist = data.maplist;
            $('#querySpotName').val(maplist[0].spot.spotName);     //换页时需要携带的参数 hidden
            addTravel(data);
        }

        /**
         * 添加游记列表
         * private
         * @param data
         */
        function addTravel(data) {
            var maplist = data.maplist;
            var comment = "";
            for (var i = 0; i < maplist.length; i++) {
                var content = maplist[i].travel.content;
                if (content.length > 200) {
                    content = content.substring(0, 200) + "...";
                }
                comment += "<div class='travel-content-div'>" +
                        "<div class='travel-img'>" +
                        "<a href='/tour/travel?id=" + maplist[i].travel.id + "' target='_blank'><img class='img-rounded' src='" + maplist[i].travel.img + " ' alt=''/></a>" +
                        "</div>" +
                        "<div class='travel-abstract'>" +
                        "<div class='travel-name'>" +
                        "<a href='/tour/travel?id=" + maplist[i].travel.id + "' target='_blank'>" + maplist[i].travel.title + "</a>" +
                        "</div>" +
                        "<div class='travel-intro'>" +
                        "<a href='/tour/travel?id=" + maplist[i].travel.id + "' target='_blank'>" + content + "</a>" +
                        "</div>" +
                        "<div class='travel-location'>" +
                        "<span class='glyphicon glyphicon-map-marker'></span> " + maplist[i].spot.spotName + ", by " + maplist[i].user.nick +
                        "</div>" +
                        "</div>" +
                        "</div>";
            }
            $('.travel-content').empty();
            $('.travel-content').append(comment);
            setPage(data);
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
                            url: "/tour/travels",
                            data: {"spotname": $('#querySpotName').val(), "pageNum": pageNum, "size": $('#size').val()},
                            success: function (data) {
                                addTravel(data);
                                var speed = 200;//滑动的速度
                                $('body').animate({scrollTop: 0}, speed);
                            }
                        });
                    });
                }
            });
        }

        /**
         * 景点查询游记输入验证
         * private
         */
        function validateSpot() {
            var spotname = $.trim($('#spotname').val());
            if (spotname  == null || spotname == '') {
                $('.tip').html("客官，请输入景点名字");
                $('#modal').modal('show');
                return false;
            }
            return true;
        }

    </script>

</head>
<body>

<%@ include file="/nav.jsp" %>
<%@ include file="/tip.jsp" %>

<div class="addr-search container">
    <div class="row">
        <div class="form-group col-lg-4">
            <input type="text" class="form-control" id="spotname" placeholder="出行目的地" name="spotname"/>
            <input type="hidden" class="form-control" id="querySpotName" name="querySpotName" value=""/>
        </div>

        <button id="spotBtn" type="button" class="btn btn-warning btn-style">
            <span class="glyphicon glyphicon-search"></span>
        </button>
    </div>
</div>

<div class="travel-content container"></div>

<div class="travel-split"></div>

<div class="container">

    <input type="hidden" id="size" value="5"/>
    <div class="travel-page">
        <div class="page-content">
            <ul class="pager">
                <li class=""><a id="firstPage" href="javascript:void(0)" value="1">首页</a></li>
                <li class=""><a id="prePage" href="javascript:void(0)" value="">上一页</a></li>
                <li class=""><a id="nextPage" href="javascript:void(0)" value="">下一页</a></li>
                <li class=""><a id="lastPage" href="javascript:void(0)" value="">尾页</a></li>
            </ul>
        </div>
        <div class="page-current">
            第<span id="pageNum">1</span>页
        </div>
        <div class="page-total">
            共<span id="pages"></span>页
        </div>
    </div>

</div>

<div class="footer"></div>

</body>
</html>