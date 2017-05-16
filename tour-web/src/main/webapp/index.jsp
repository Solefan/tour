<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta charset="UTF-8">
    <title>途悠游</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <link rel="stylesheet" href="resources/css/bootstrap.min.css">

    <script src="resources/js/jquery.min.js"></script>
    <script src="resources/js/bootstrap.min.js"></script>
    <script src="resources/js/holder.min.js"></script>

    <script src="resources/js/moment.min.js" type="text/javascript"></script>

    <style>

        .item {
            height: 400px;
        }

        .item img {
            width: 100%;
            height: 100%;
        }

        .content-container {
            width: 80%;
            height: auto;
            margin: 20px auto;
        }

        .left-div {
            width: 25%;
            height: auto;
            float: left;
            padding: 1% 2%;
        }

        .addr-div {
            margin-bottom: 50px;
        }

        .a-title, .f-title {
            color: #ff9d00;
            font-size: 20px;
            font-weight: 400;
            padding-bottom: 5%;
        }

        .flight-content {
            width: 100%;
            height: 300px;
            background-color: #f5f5f5;
            display: none;
        }

        .flight-title {
            width: 100%;
            height: 20%;
            color: #999;
        }

        .flight-title div {
            float: left;
            width: 40%;
            height:100%;
            padding-top: 8%;
            text-align: center;
            font-size: 17px;
        }

        .flight-body {
            width: 100%;
            height: 80%;
            overflow: scroll;
        }

        .flight-body .panel {
            padding: 1%;
            height: 22%;
            margin-bottom: 3%;
        }

        .flight-common{
            width: 100%;
            height: 50%;
            text-align: center;
        }

        .flight-name {
            color: #ff9d00;
        }

        .flight-name div {
            width: 50%;
            height: 100%;
            text-align: center;
        }

        .flight-detail div {
            float: left;
            width: 44%;
            height: 100%;
            text-align: center;
            color: #999;
        }

        .btn-style {
            margin-top: 1%;
            background-color: #ff9d00;
            color: white;
            height: 30px;
        }

        .btn-style:hover {
            background-color: #ff8d00;
            color: white;
        }

        .travel-div {
            width: 75%;
            float: right;
            padding: 1% 2%;
        }

        .travel-title {
            color: #ff9d00;
            font-size: 20px;
            font-weight: 400;
            padding-bottom: 1%;
            padding-left: 5%;
        }

        .travel-split {
            width: 98%;
            height: 1px;
            background-color: #c9c9c9;
            float: right;
        }

        .travel-content {
            padding-top: 7%;
        }

        .travel-content a {
            color: black;
        }

        .travel-content-div {
            width: 100%;
            height: 180px;
            padding: 15px;
        }

        .travel-img {
            float: left;
            width: 250px;
            height: 150px;
        }

        .travel-img img {
            width: 100%;
            height: 100%;
        }

        .travel-abstract {
            float: right;
            width: 60%;
        }

        .travel-content-div:hover {
            background-color: #f5f5f5;
        }

        .abstract-title {
            font-size: 20px;
            font-weight: 300;
            padding-bottom: 10px;
        }

        .abstract-title a:hover {
            color: #ff9d00;
        }

        .abstract-content {
            color: #666;
            width: 100%;
            height: 63%;
            padding-bottom: 10px;
            overflow: hidden;
        }

        .abstract-bottom {
            font-size: 10px;
            font-weight: 300;
            color: #ff9d00;
        }

    </style>

    <script>
        $(function () {

            //更新导航栏
            initHeadIndex();

            //加载游记
            ajaxTravels();

            //点击换一批按钮点击事件
            refreshBtnClick();

            //查询景点按钮点击事件
            spotBtnClick();

            //查询航班按钮点击事件
            flightBtnClick();

        });

        /**
         * 更新顶部导航栏
         */
        function initHeadIndex() {
            $('.head-nav').find('div').removeClass('head-nav-active');
            $('.head-nav').find('.head-nav-index').addClass('head-nav-active');
        }

        /**
         * 首页5个游记的查询
         */
        function ajaxTravels() {
            $.ajax({
                type: "POST",
                url: "/tour/limit5",
                async: false,
                success: function(data) {
                    refreshAsync(data);
                }
            });
        }

        /**
         * 换一批按钮点击事件
         */
        function refreshBtnClick() {
            $('#refreshBtn').click(function() {
                $.ajax({
                    type: "POST",
                    url: "/tour/refresh",
                    async: true,
                    success: function(data) {
                        refreshAsync(data);
                    }
                });
            });
        }

        /**
         * 换一批异部返回数据拼装TravelContent
         * private
         * @param data
         */
        function refreshAsync(data) {
            $('.travel-content').empty();
            var inner = "";
            for (var i = 0; i<data.length; i++) {
                var title = data[i].travel.title;
                var content = data[i].travel.content;
                if (title.length > 20) {
                    title = title.substring(0, 19) + "...";
                }
                if (content.length > 100) {
                    content = content.substring(0, 100) + "...";
                }
                inner += "<div class='travel-content-div'>" +
                        "<div class='travel-img'>" +
                        "<a href='/tour/travel?id=" + data[i].travel.id + "' target='_blank'><img src='" + data[i].travel.img +"' /></a>" +
                        "</div>" +
                        "<div class='travel-abstract'>" +
                        "<div class='abstract-title'>" +
                        "<a href='/tour/travel?id=" + data[i].travel.id + "' target='_blank'>" + title + "</a>" +
                        "</div>" +
                        "<div class='abstract-content'>" +
                        "<a href='/tour/travel?id=" + data[i].travel.id + "' target='_blank'>" + content + "</a>" +
                        "</div>" +
                        "<div class='abstract-bottom'><span class='glyphicon glyphicon-map-marker'></span>" + data[i].spot.spotName + ", by " + data[i].user.nick + "</div>" +
                        "</div>" +
                        "</div>";
            }
            $('.travel-content').append(inner);
        }

        /**
         * 景点查询按钮点击事件
         */
        function spotBtnClick() {
            $('#spotBtn').click(function() {
                var spotName = $.trim($('#spotName').val());
                if (validateSpot()) {
                    $.ajax({
                        type: "POST",
                        url: "/tour/haveSpot",
                        data: {"spotName": spotName},
                        async: true,
                        success: function(data) {
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
         * 航班查询按钮点击事件
         */
        function flightBtnClick() {
            $('#flightBtn').click(function() {
                var from = $.trim($('#from').val());
                var to = $.trim($('#to').val());
                if (validateFlight()) {
                    $.ajax({
                        type: "POST",
                        url: "/tour/flight",
                        data: {"from": from, "to": to},
                        async: true,
                        success: function(data) {
                            if (data.length == 0) {
                                $('.flight-content').hide();
                                $('.tip').html("无此区间的航班");
                                $('#modal').modal('show');
                                return;
                            }
                            $('#fromshow').html(from);
                            $('#toshow').html(to);
                            addFlightBody(data);
                        }
                    });
                }
            });
        }

        /**
         * 查询景点输入验证
         * private
         * @returns {boolean}
         */
        function validateSpot () {
            var spotName = $.trim($('#spotName').val());
            if (spotName  == null || spotName == '') {
                $('.tip').html("客官，请输入景点名字");
                $('#modal').modal('show');
                $('#spotName').val("");
                return false;
            }
            return true;
        }

        /**
         * 查询航班输入验证
         * private
         * @returns {boolean}
         */
        function validateFlight () {
            var from = $.trim($('#from').val());
            var to = $.trim($('#to').val());
            if (from  == null || from == '') {
                $('.tip').html("客官，请输入出发城市");
                $('#modal').modal('show');
                $('#from').val("");
                return false;
            }
            if (to == null || to == '') {
                $('.tip').html("客官，请输入到达城市");
                $('#modal').modal('show');
                $('#to').val("");
                return false;
            }
            return true;
        }

        /**
         * 根据后台返回数据拼装FlightBody
         * private
         * @param data
         */
        function addFlightBody(data) {
            $('.flight-body').empty();
            var inner = "";
            for (var i = 0; i<data.length; i++) {
                inner += "<div class='panel'>" +
                                "<div class='flight-common flight-name'>" +
                                    "<div style='float: left'>" + data[i].name + "</div>" +
                                    "<div style='float: right'>¥" + data[i].price + "</div>" +
                                "</div>" +
                                "<div class='flight-common flight-detail'>" +
                                    "<div>" + data[i].startTime + "(" + data[i].startTerminal + ")</div>" +
                                    "<div style='width: 12%;'><span class='glyphicon glyphicon-arrow-right'></span></div>" +
                                    "<div>" + data[i].endTime + "(" + data[i].endTerminal + ")</div>" +
                                "</div>" +
                            "</div>";
            }
            $('.flight-body').append(inner);
            $('.flight-content').show();
        }

    </script>

</head>
<body>

<%@ include file="/nav.jsp" %>
<%@ include file="/tip.jsp" %>

<div class="show-slider">
    <div id="carousel" class="carousel slide" data-ride="carousel">
        <!-- Indicators -->
        <ol class="carousel-indicators">
            <li data-target="#carousel" data-slide-to="0" class="active"></li>
            <li data-target="#carousel" data-slide-to="1"></li>
            <li data-target="#carousel" data-slide-to="2"></li>
        </ol>

        <!-- Wrapper for slides -->
        <div class="carousel-inner" id="wen">
            <div class="item active">
                <img src="resources/img/01.jpeg" alt="">
            </div>
            <div class="item">
                <img src="resources/img/02.jpeg" alt="">
            </div>
            <div class="item">
                <img src="resources/img/03.jpeg" alt="">
            </div>
        </div>

        <!-- Controls -->
        <a class="left carousel-control" href="#carousel" data-slide="prev">
            <span class="glyphicon glyphicon-chevron-left"></span>
        </a>
        <a class="right carousel-control" href="#carousel" data-slide="next">
            <span class="glyphicon glyphicon-chevron-right"></span>
        </a>
    </div>
</div>

<div class="content-container">

    <div class="left-div">

        <div class="addr-div">
            <div class="a-title">景点</div>
            <div>
                <div class="row">
                    <div class="form-group col-lg-8">
                        <input type="text" class="form-control" id="spotName" placeholder="出行目的地" />
                    </div>
                    <button id="spotBtn" type="button" class="btn btn-warning btn-style col-lg-3">
                        <span class="glyphicon glyphicon-search"></span>
                    </button>
                </div>
            </div>
        </div>

        <div class="flight-div">
            <div class="f-title">机票</div>
            <div>
                <div class="form-group">
                    <input type="text" class="form-control" id="from" placeholder="出发城市"/>
                </div>
                <div class="row">
                    <div class="form-group col-lg-8">
                        <input type="text" class="form-control" id="to" placeholder="到达城市"/>
                    </div>
                    <button id="flightBtn" type="button" class="btn btn-warning btn-style col-lg-3">
                        <span class="glyphicon glyphicon-plane"></span>
                    </button>
                </div>

                <div class="flight-content panel">
                    <div class="flight-title">
                        <div id="fromshow"></div>
                        <div style="width: 20%;font-size:20px"><span class="glyphicon glyphicon-arrow-right"></span></div>
                        <div id="toshow"></div>
                    </div>
                    <div class="flight-body"></div>
                </div>

            </div>
        </div>

    </div>

    <div class="travel-div">
        <div class="travel-title col-lg-10">
            旅行游记
        </div>
        <div class="col-lg-2" style="float: right">
            <input type="button" id="refreshBtn" class="btn btn-default" value="换一批" />
        </div>

        <div class="travel-split"></div>

        <div class="travel-content"></div>
    </div>

</div>

</body>
</html>