<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>酒店</title>
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

        .hotel-content {
            padding-top: 2%;
        }

        .hotel-content a {
            color: black;
        }

        .hotel-content-div {
            width: 100%;
            height: 300px;
            padding: 20px;
        }

        .hotel-img {
            float: left;
            width: 320px;
            height: 260px;
            overflow: hidden;
        }

        .hotel-img img {
            width: 100%;
            height: 100%;
        }

        .hotel-abstract {
            float: right;
            width: 63%;
            height: 100%;
        }

        .hotel-content-div:hover {
            background-color: #f5f5f5;
        }

        .hotel-name {
            font-size: 20px;
            font-weight: 300;
            padding-bottom: 10px;
        }

        .hotel-name a:hover {
            color: #ff9d00;
        }

        .price {
            float: right;
            color: #ff9d00;
        }

        .hotel-intro {
            color: #666;
            width: 100%;
            height: 40%;
            overflow: hidden;
        }

        .hotel-level {
            color: #ff9d00;
            width: 100%;
            height: 15%;
            overflow: hidden;
        }

        .hotel-addr {
            color: #666;
            width: 100%;
            height: 10%;
            overflow: hidden;
        }

        .hotel-phone {
            color: #666;
            width: 100%;
            height: 12%;
            overflow: hidden;
        }

        .hotel-location {
            color: #ff9d00;
            font-size: 15px;
            font-weight: 300;
        }

        .footer {
            width: 100%;
            height: 100px;
        }

    </style>

    <script>
        $(function () {

            initHeadHotel();

            ajaxFirst();

            spotBtnClick();

        });

        /**
         * 更新顶部导航栏
         */
        function initHeadHotel() {
            $('.head-nav').find('div').removeClass('head-nav-active');
            $('.head-nav').find('.head-nav-hotel').addClass('head-nav-active');
        }

        /**
         * 获取全部hotel
         * 第一次请求不带 spotname 参数
         */
        function ajaxFirst() {
            $.ajax({
                type: "POST",
                url: "/tour/hotels",
                success: function (data) {
                    addHotel(data);
                }
            });
        }

        /**
         * 添加酒店列表
         * @param data
         */
        function addHotel(data) {
            var maplist = data.maplist;
            var comment = "";
            for (var i = 0; i < maplist.length; i++) {
                var intro = maplist[i].hotel.hotelIntroduce;
                var level =  maplist[i].hotel.hotelLevel;
                var stars = "";                             //拼等级星星
                for (var j = 0; j<level; j++) {
                    stars += "<span class='glyphicon glyphicon-star'></span>";
                }
                if (intro.length > 200) {
                    intro = intro.substring(0, 200) + "...";
                }
                comment += "<div class='hotel-content-div'>" +
                                "<div class='hotel-img'><a href='/tour/hotel?id=" + maplist[i].hotel.id + "' target='_blank'> <img class='img-rounded' src='" + maplist[i].hotel.indexImg + "'/></a></div>" +
                                "<div class='hotel-abstract'>" +
                                    "<div class='hotel-name'>" +
                                        "<a href='/tour/hotel?id=" + maplist[i].hotel.id + "' target='_blank'>" + maplist[i].hotel.hotelName + "</a>" +
                                        "<div class='price'><span>¥" + maplist[i].hotel.price + "起</span></div>" +
                                    "</div>" +
                                    "<div class='hotel-level'>" + stars + "</div>" +
                                    "<div class='hotel-intro'><span>" + intro + "</span></div>" +
                                    "<div class='hotel-addr'><span>地址：" + maplist[i].hotel.location + "</span></div>" +
                                    "<div class='hotel-phone'><span>联系电话：" + maplist[i].hotel.phone + "</span></div>" +
                                    "<div class='hotel-location'><span class='glyphicon glyphicon-map-marker'></span>" + maplist[i].spot.spotName + "</div>" +
                                "</div>" +
                            "</div>";
            }
            $('.hotel-content').empty();
            $('.hotel-content').append(comment);
        }

        /**
         * 景点查询酒店按钮的点击事件
         */
        function spotBtnClick() {
            $('#spotBtn').click(function () {
                if (validateSpot()) {
                    var spotname = $.trim($('#spotname').val());
                    $.ajax({
                        type: "POST",
                        url: "/tour/hotels",
                        data: {"spotname": spotname},
                        success: function (data) {
                            travelAsync(data);
                        }
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

        /**
         * 查询酒店成功之后的回调函数
         * private
         */
        function travelAsync(data) {
            if (data.status == "spotNotExist") {
                $('.tip').html("客官，您查询的景点不存在");
                $('#modal').modal('show');
                return;
            }
            if (data.status == "hotelNotExist") {
                $('.tip').html("客官，该景点附近还没有酒店");
                $('#modal').modal('show');
                return;
            }
            addHotel(data);
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
        </div>

        <button id="spotBtn" type="button" class="btn btn-warning btn-style">
            <span class="glyphicon glyphicon-search"></span>
        </button>
    </div>
</div>

<div class="hotel-content container"></div>

<div class="footer"></div>

</body>
</html>