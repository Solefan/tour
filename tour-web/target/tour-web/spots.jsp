<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>景点</title>
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

        .spot-content {
            padding-top: 2%;
        }

        .spot-content a {
            color: black;
        }

        .spot-content-div {
            width: 100%;
            height: 220px;
            padding: 20px;
        }

        .spot-img {
            float: left;
            width: 300px;
            height: 180px;
        }

        .spot-img img {
            width: 100%;
            height: 100%;
        }

        .spot-abstract {
            float: right;
            width: 65%;
            height: 100%;
        }

        .spot-content-div:hover {
            background-color: #f5f5f5;
        }

        .spot-name {
            font-size: 20px;
            font-weight: 300;
            padding-bottom: 10px;
        }

        .spot-name a:hover {
            color: #ff9d00;
        }

        .spot-intro {
            color: #666;
            width: 100%;
            height: 69%;
            overflow: hidden;
        }

        .spot-location {
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

            initHeadAddr();

            /**
             * 简介中的字数限制
             */
            $('.spot-intro').each(function(i) {
                var content = $(this).find('a').html();
                if (content.length > 200) {
                    content = content.substring(0, 200) + "...";
                }
                $(this).find('a').html(content);
            });

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

        });

        /**
         * 更新顶部导航栏
         */
        function initHeadAddr() {
            $('.head-nav').find('div').removeClass('head-nav-active');
            $('.head-nav').find('.head-nav-addr').addClass('head-nav-active');
        }

        /**
         * 验证输入
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
    </script>

</head>
<body>

<%@ include file="/nav.jsp" %>
<%@ include file="/tip.jsp" %>

<div class="addr-search container">
    <div class="row">
        <div class="form-group col-lg-4">
            <input type="text" class="form-control" id="spotName" placeholder="出行目的地" name="spotName"/>
        </div>

        <button id="spotBtn" type="button" class="btn btn-warning btn-style">
            <span class="glyphicon glyphicon-search"></span>
        </button>
    </div>
</div>


<div class="spot-content container">

    <c:forEach items="${spotlist}" var="spot">
        <div class="spot-content-div">
            <div class="spot-img">
                <a href="/tour/spot?id=${spot.id}" target="_blank">
                    <img class="img-rounded" src="${spot.indexImg}" alt=""/>
                </a>
            </div>
            <div class="spot-abstract">
                <div class="spot-name">
                    <a href="/tour/spot?id=${spot.id}" target="_blank">${spot.spotName}</a>
                </div>
                <div class="spot-intro">
                    <a href="/tour/spot?id=${spot.id}" target="_blank">${spot.spotIntroduce}</a>
                </div>
                <div class="spot-location">
                    <span class="glyphicon glyphicon-map-marker"></span>${spot.location}
                </div>
            </div>
        </div>
    </c:forEach>

</div>

<div class="footer"></div>

</body>
</html>