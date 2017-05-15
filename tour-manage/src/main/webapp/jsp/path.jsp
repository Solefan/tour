<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

    <title>路线管理</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">

    <link rel="stylesheet" type="text/css" href="../resources/css/common.css">
    <link rel="stylesheet" type="text/css" href="../resources/js/jquery-easyui-1.2.6/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="../resources/js/jquery-easyui-1.2.6/themes/icon.css">

    <script type="text/javascript" src="../resources/js/jquery-easyui-1.2.6/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="../resources/js/jquery-easyui-1.2.6/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../resources/js/jquery-easyui-1.2.6/jquery.form.min.js"></script>
    <script type="text/javascript" src="../resources/js/jquery-easyui-1.2.6/locale/easyui-lang-zh_CN.js"></script>

    <script type="text/javascript">
        $(function () {

            initAllSpot();

            radioClick();

            initDataGrid();

            $("#searchbtn").click(function() {
                $("#t_path").datagrid('load', serializeForm($("#search")));
            });

            saveBtnClick();

        });

        //初始化数据表格
        function initDataGrid() {
            $('#t_path').datagrid({

                //	title : '景点列表',
                url: '/manage/getPathList',
                idField: 'id',

                height: 500,
                striped: true,
                rownumbers: true,
                fitColumns: true,
                pagination: true,
                pageSize: 10,
                pageList: [5, 10, 15, 20],
                remoteSort: false,
                columns: [[
                    {
                        checkbox: true,
                        width: 10
                    }, {
                        field: 'fromSid',
                        title: '起始景点名称',
                        width: 50,
                        formatter: function(value, record, index) {
                            return $('#fromSid').find("option[value='" + value + "']").html();
                        }
                    }, {
                        field: 'toSid',
                        title: '目的景点名称',
                        width: 50,
                        formatter: function(value, record, index) {
                            return $('#toSid').find("option[value='" + value + "']").html();
                        }
                    }, {
                        field: 'distance',
                        title: '距离',
                        width: 50,
                        formatter : function(value, record, index) {
                            var str = '';
                            if (value == -1) {
                                str = "不可直达";
                            } else {
                                str = value;
                            }
                            return str;
                        }
                    }
                ]],
                toolbar: [
                    {
                        text: '修改距离',
                        iconCls: 'icon-edit',
                        handler: edit
                    }
                ]
            });
        }

        // 加载所有景点
        function initAllSpot() {
            $.ajax({
                type: "POST",
                url: "/manage/getAllSpot",
                async: false,
                success: function(data) {
                    var inner = "";
                    for (var i = 0; i<data.length; i++) {
                        inner += " <option value='" + data[i].id + "'>" + data[i].spotName + "</option>";
                    }
                    $('.fromSid').append(inner);
                    $('.toSid').append(inner);
                }
            });
        }

        function edit() {
            flag = 'edit';
            var arr = $("#t_path").datagrid('getSelections');
            if (arr.length != 1) {
                $.messager.show({
                    title: '提示信息',
                    msg: '只能选择一行记录进行修改！'
                });
            } else {
                $("#mydialog").dialog({
                    title: '修改距离',
                    iconCls: 'icon-edit'
                });
                $('#mydialog').dialog('open'); //打开窗口
                $('#myform').get(0).reset();   //清空表单数据
                $('#myform').form('load', {	   //调用load方法把所选中的数据load到表单中
                    id: arr[0].id,
                    fromSid: arr[0].fromSid,
                    toSid: arr[0].toSid,
                    distance: arr[0].distance
                });
                if (arr[0].distance == -1) {
                    $('#no').attr('checked', true);
                    $('.distance').hide();
                    $('#distance').val("");
                } else {
                    $('#yes').attr('checked', true);
                    $('.distance').show();
                }

            }
        }

        //验证
        function validate() {
            if ($('#yes').attr('checked')) {
                if ($('#distance').val() == "") {
                    $('#distance').focus();
                    return false;
                }
            }
            return true;
        }

        //表单的序列化
        function serializeForm(form){
            var obj = {};
            $.each(form.serializeArray(), function(index){
                if (obj[this['name']]) {
                    obj[this['name']] = obj[this['name']] + ',' + this['value'];
                } else {
                    obj[this['name']] = this['value'];
                }
            });
            return obj;
        }

        function saveBtnClick() {
            $("#saveBtn").click(function() {
                if (!validate()) {
                    $.messager.show({
                        title: '提示信息',
                        msg: '请填写直达距离',
                    });
                    return;
                }
                $.ajax({
                    type: "POST",
                    url: "/manage/editPath",
                    data: $('#myform').serialize(),
                    success: function(data) {
                        //关闭窗口
                        $("#mydialog").dialog('close');
                        //刷新datagrid
                        $("#t_path").datagrid('reload');
                        $.messager.show({
                            title: '提示信息',
                            msg: '操作成功！'
                        });
                    }
                });
            });
        }

        //是否直达选择事件
        function radioClick() {
            $('input:radio').each(function() {
                $(this).change(function() {
                    if ($(this).attr('id') == 'no') {
                        $('.distance').hide();
                    } else {
                        $('.distance').show();
                    }
                });
            });
        }


    </script>

</head>

<body>
<div id="panel" class="easyui-panel" title="查询入口" style="height:70; padding:6; overflow:hidden">

    <form id="search">
        <table style="width:70%">
            <tr>
                <td align="right">起始景点:</td>
                <td>
                    <select class="fromSid" name="fromSid" >
                        <option value="">全部</option>
                    </select>
                </td>
                <td align="right">目的景点:</td>
                <td>
                    <select class="fromSid" name="toSid" >
                        <option value="">全部</option>
                    </select>
                </td>
                <td align="right"><a id="searchbtn" class="easyui-linkbutton" iconCls="icon-search"></a></td>
            </tr>
        </table>
    </form>

</div>

<table id="t_path"></table>

<div id="mydialog" class="easyui-dialog" closed="true" modal="true" draggable="true" style="width:330px; margin: 20px 40px">

    <form id="myform" method="post" enctype="multipart/form-data">
        <input id="id" type="hidden" name="id" value="" />
        <table>
            <tr>
                <td>起始景点名称:</td>
                <td><select id="fromSid" class="fromSid" name="fromSid" style="width:130px" disabled></select></td>
            </tr>

            <tr>
                <td>目的景点名称:</td>
                <td><select id="toSid" class="toSid" name="toSid" style="width:130px" disabled></select></td>
            </tr>

            <tr>
                <td>直达:</td>
                <td>
                    <input id="yes" type="radio" name="type" value="1" />是<input id="no" type="radio" name="type" value="0" />否
                </td>
            </tr>

            <tr class="distance">
                <td>直达距离:</td>
                <td><input id="distance" type="text" name="distance" value="" style="width:130px" /></td>
            </tr>

            <tr align="center">
                <td colspan="2">
                    <a id="saveBtn" class="easyui-linkbutton" iconCls="icon-save">保存</a>
                </td>
            </tr>

        </table>
    </form>
</div>

</body>

</html>
